import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/ResidentMmcStatusResModel.dart';

/// MMC bill ka ONLINE payment (Razorpay).
///
/// Flow:
///  1. Resident amount chunta hai (poora baaki ya kam - partial allowed)
///  2. Server par order banta hai  -> POST /api/v1/resident/mmc/pay/order
///  3. Razorpay checkout khulta hai (UPI / Card / Net Banking)
///  4. Success par server verify karta hai -> POST /api/v1/resident/mmc/pay/verify
///     (server khud Razorpay se check karke hi bill par paisa chadhata hai)
///  5. Fail / cancel -> POST /api/v1/resident/mmc/pay/failed (sirf record, bill nahi badalta)
///
/// Sheet `true` return karti hai jab payment server par record ho gaya
/// (ya processing mein hai) - screen tab MMC data refresh karti hai.

// Base URL wahi jo ApiStateNetwork (@RestApi) mein hai
const String _kApiBase = 'https://admin.ascentpms.care/api/v1';

const Color _kGold = Color(0xffB8860B);
const Color _kDark = Color(0xFF101C16);

Future<bool?> showMmcOnlinePaymentSheet(
  BuildContext context, {
  required PendingMonthItem bill,
  PayOnline? config,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => MmcOnlinePaymentSheet(bill: bill, config: config),
  );
}

enum _Stage { input, processing, success, failed }

class MmcOnlinePaymentSheet extends StatefulWidget {
  final PendingMonthItem bill;
  final PayOnline? config;

  const MmcOnlinePaymentSheet({super.key, required this.bill, this.config});

  @override
  State<MmcOnlinePaymentSheet> createState() => _MmcOnlinePaymentSheetState();
}

class _MmcOnlinePaymentSheetState extends State<MmcOnlinePaymentSheet> {
  late final Razorpay _razorpay;
  late final TextEditingController _amountCtrl;

  _Stage _stage = _Stage.input;
  String? _inputError;
  String _statusText = "";
  String? _orderId;
  bool _recorded = false; // server par payment chadh gaya (ya processing)

  // Success screen ke liye
  String _resultMessage = "";
  String? _receiptNumber;
  String? _receiptUrl;
  String? _receiptDownloadUrl;
  bool _isPartial = false;
  bool _isPending = false; // paisa kata par confirm baad mein hoga

  num get _balance => widget.bill.amount;
  num get _minAmount => widget.config?.minAmount ?? 1;
  bool get _allowPartial => widget.config?.allowPartial ?? true;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: _plain(_balance));
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountCtrl.dispose();
    super.dispose();
  }

  // Alag Dio: login token wahi (Hive), par app ka global error snackbar nahi -
  // payment ke message sheet ke andar hi dikhte hain
  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final box = Hive.isBoxOpen("associationdata")
              ? Hive.box("associationdata")
              : await Hive.openBox("associationdata");
          final token = box.get("token");
          if (token != null && token.toString().isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          handler.next(options);
        },
      ),
    );
    return dio;
  }

  // ------------------------------------------------------------------ helpers

  String _plain(num v) {
    final d = v.toDouble();
    return d == d.roundToDouble() ? d.toInt().toString() : d.toStringAsFixed(2);
  }

  String _money(num v) {
    final d = v.toDouble();
    final s = d == d.roundToDouble()
        ? d.toInt().toString()
        : d.toStringAsFixed(2);
    // 1,23,456 (Indian grouping)
    final parts = s.split('.');
    var intPart = parts[0];
    if (intPart.length > 3) {
      final last3 = intPart.substring(intPart.length - 3);
      var rest = intPart.substring(0, intPart.length - 3);
      final buf = <String>[];
      while (rest.length > 2) {
        buf.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) buf.insert(0, rest);
      intPart = '${buf.join(',')},$last3';
    }
    return '₹ $intPart${parts.length > 1 ? '.${parts[1]}' : ''}';
  }

  String _errorMessage(Object e, String fallback) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return "No internet connection. Please try again.";
      }
    }
    return fallback;
  }

  Map<String, dynamic> _asMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  // ------------------------------------------------------------------ flow

  Future<void> _startPayment() async {
    final raw = _amountCtrl.text.trim().replaceAll(',', '');
    final amount = num.tryParse(raw);

    if (amount == null || amount <= 0) {
      setState(() => _inputError = "Please enter a valid amount");
      return;
    }
    if (amount < _minAmount) {
      setState(() => _inputError = "Minimum amount is ${_money(_minAmount)}");
      return;
    }
    if (amount > _balance + 0.009) {
      setState(
        () => _inputError =
            "Amount cannot be more than the pending ${_money(_balance)}",
      );
      return;
    }
    if (!_allowPartial && (amount - _balance).abs() > 0.009) {
      setState(() => _inputError = "Please pay the full amount");
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _inputError = null;
      _stage = _Stage.processing;
      _statusText = "Starting secure payment…";
    });

    try {
      final res = await _dio.post(
        '$_kApiBase/resident/mmc/pay/order',
        data: {
          'bill_id': widget.bill.id,
          'amount': double.parse(amount.toStringAsFixed(2)),
          'source': 'app',
        },
      );
      final body = _asMap(res.data);
      if (body['status'] != true) {
        _fail(body['message']?.toString() ?? "Could not start the payment.");
        return;
      }
      final d = _asMap(body['data']);
      _orderId = d['order_id']?.toString();

      final prefill = _asMap(d['prefill']);
      final options = <String, dynamic>{
        'key': d['key_id'],
        'order_id': _orderId,
        'amount': d['amount'], // paise
        'currency': d['currency'] ?? 'INR',
        'name': d['name'] ?? 'Stayo',
        'description': d['description'] ?? 'MMC Payment',
        'prefill': {
          'name': prefill['name'] ?? '',
          'email': prefill['email'] ?? '',
          'contact': prefill['contact'] ?? '',
        },
        'theme': {'color': d['theme_color'] ?? '#B8860B'},
        'retry': {'enabled': true, 'max_count': 2},
      };

      if (!mounted) return;
      setState(() => _statusText = "Opening payment options…");
      _razorpay.open(options);
    } catch (e) {
      _fail(_errorMessage(e, "Could not start the payment. Please try again."));
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse r) async {
    if (!mounted) return;
    setState(() {
      _stage = _Stage.processing;
      _statusText = "Confirming your payment…";
    });

    final payload = {
      'razorpay_order_id': r.orderId ?? _orderId ?? '',
      'razorpay_payment_id': r.paymentId ?? '',
      'razorpay_signature': r.signature ?? '',
    };

    // Network ki dikkat par 2 baar aur koshish (server webhook se bhi update kar deta hai)
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final res = await _dio.post(
          '$_kApiBase/resident/mmc/pay/verify',
          data: payload,
        );
        final body = _asMap(res.data);
        if (body['status'] == true) {
          final d = _asMap(body['data']);
          _recorded = true;
          if (!mounted) return;
          setState(() {
            _stage = _Stage.success;
            _isPending = false;
            _resultMessage =
                body['message']?.toString() ?? "Payment received successfully.";
            _receiptNumber = d['receipt_number']?.toString();
            _receiptUrl = d['receipt_url']?.toString();
            _receiptDownloadUrl = d['receipt_download_url']?.toString();
            _isPartial = d['is_partial'] == true;
          });
          return;
        }
        // Server ne saaf mana kiya (signature / amount mismatch) - retry nahi
        _fail(body['message']?.toString() ?? "Payment verification failed.");
        return;
      } on DioException catch (e) {
        final data = _asMap(e.response?.data);
        final retry = _asMap(data['data'])['retry'] == true;
        final code = e.response?.statusCode ?? 0;
        final networkIssue = e.response == null;
        if ((retry || networkIssue || code >= 500) && attempt < 2) {
          await Future.delayed(Duration(seconds: 3 * (attempt + 1)));
          continue;
        }
        if (retry || networkIssue || code >= 500) {
          // Paisa kat chuka ho sakta hai - server / webhook baad mein bill update karega
          _recorded = true;
          if (!mounted) return;
          setState(() {
            _stage = _Stage.success;
            _isPending = true;
            _resultMessage =
                "Your payment is being processed. If money was deducted, your bill will be updated automatically in a few minutes.";
            _receiptNumber = null;
            _receiptUrl = null;
            _receiptDownloadUrl = null;
            _isPartial = false;
          });
          return;
        }
        _fail(data['message']?.toString() ?? "Payment verification failed.");
        return;
      } catch (_) {
        _fail("Payment verification failed. Please check your bill again.");
        return;
      }
    }
  }

  void _onPaymentError(PaymentFailureResponse r) {
    final cancelled = r.code == Razorpay.PAYMENT_CANCELLED;
    final msg = cancelled
        ? "Payment cancelled. No amount was charged."
        : _readableError(r.message);

    // Sirf record ke liye (bill nahi badalta)
    final orderId = _orderId;
    if (orderId != null) {
      () async {
        try {
          await _dio.post(
            '$_kApiBase/resident/mmc/pay/failed',
            data: {
              'razorpay_order_id': orderId,
              'error_description': cancelled ? 'Checkout closed' : msg,
            },
          );
        } catch (_) {}
      }();
    }

    if (cancelled) {
      if (!mounted) return;
      setState(() {
        _stage = _Stage.input;
        _inputError = msg;
      });
      return;
    }
    _fail(msg);
  }

  /// Android par Razorpay kabhi message JSON string mein bhejta hai - saaf text nikalo
  String _readableError(String? raw) {
    const fallback = "Payment failed. Please try again.";
    if (raw == null || raw.trim().isEmpty) return fallback;
    final t = raw.trim();
    if (t.startsWith('{')) {
      try {
        final j = jsonDecode(t);
        if (j is Map) {
          final err = j['error'];
          if (err is Map && err['description'] != null) {
            return err['description'].toString();
          }
          if (j['description'] != null) return j['description'].toString();
        }
      } catch (_) {}
      return fallback;
    }
    return t;
  }

  void _onExternalWallet(ExternalWalletResponse r) {
    // External wallet ka option hum on nahi karte; kabhi aaye to resident ko wapas form par lao
    if (!mounted) return;
    setState(() {
      _stage = _Stage.input;
      _inputError =
          "${r.walletName ?? 'This wallet'} is not supported here. Please choose UPI, Card or Net Banking.";
    });
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _stage = _Stage.failed;
      _resultMessage = message;
    });
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _close() => Navigator.of(context).pop(_recorded);

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return PopScope(
      canPop: _stage != _Stage.processing,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _header(),
                  SizedBox(height: 16.h),
                  if (_stage == _Stage.input) _inputView(),
                  if (_stage == _Stage.processing) _processingView(),
                  if (_stage == _Stage.success) _successView(),
                  if (_stage == _Stage.failed) _failedView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: _kGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.payments_rounded, color: _kGold, size: 22.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pay Maintenance (MMC)",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
              Text(
                widget.bill.month,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: const Color.fromRGBO(42, 41, 51, 0.65),
                ),
              ),
            ],
          ),
        ),
        if (_stage != _Stage.processing)
          IconButton(
            onPressed: _close,
            icon: Icon(Icons.close_rounded, size: 22.sp, color: _kDark),
          ),
      ],
    );
  }

  Widget _inputView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Pending amount",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: const Color.fromRGBO(42, 41, 51, 0.7),
                  ),
                ),
              ),
              Text(
                _money(_balance),
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: _kGold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          _allowPartial ? "Amount to pay" : "Amount",
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _amountCtrl,
          enabled: _allowPartial,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
          onChanged: (_) {
            if (_inputError != null) setState(() => _inputError = null);
          },
          decoration: InputDecoration(
            prefixText: "₹ ",
            prefixStyle: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
            filled: true,
            fillColor: Colors.white,
            errorText: _inputError,
            errorMaxLines: 2,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: _kGold, width: 1.4),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.08),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
        ),
        if (_allowPartial) ...[
          SizedBox(height: 8.h),
          Text(
            "You can pay the full amount or a part of it. Any remaining amount stays pending.",
            style: GoogleFonts.outfit(
              fontSize: 12.5.sp,
              color: const Color.fromRGBO(42, 41, 51, 0.6),
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => setState(() {
                _amountCtrl.text = _plain(_balance);
                _inputError = null;
              }),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Text(
                  "Pay full amount (${_money(_balance)})",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _kGold,
                    decoration: TextDecoration.underline,
                    decorationColor: _kGold,
                  ),
                ),
              ),
            ),
          ),
        ],
        SizedBox(height: 18.h),
        SizedBox(
          height: 50.h,
          child: ElevatedButton.icon(
            onPressed: _startPayment,
            icon: Icon(Icons.lock_rounded, size: 18.sp, color: Colors.white),
            label: Text(
              "Pay Securely",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined, size: 14.sp, color: Colors.grey),
            SizedBox(width: 6.w),
            Text(
              "UPI • Cards • Net Banking — secured by Razorpay",
              style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _processingView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28.h),
      child: Column(
        children: [
          SizedBox(
            width: 36.w,
            height: 36.w,
            child: const CircularProgressIndicator(
              color: _kGold,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _statusText,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Please don't close the app.",
            style: GoogleFonts.outfit(fontSize: 12.5.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _successView() {
    final hasReceipt = _receiptUrl != null && _receiptUrl!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 6.h),
        Icon(
          _isPending
              ? Icons.hourglass_top_rounded
              : (_isPartial
                    ? Icons.timelapse_rounded
                    : Icons.check_circle_rounded),
          size: 64.sp,
          color: (_isPending || _isPartial) ? _kGold : const Color(0xFF16A34A),
        ),
        SizedBox(height: 12.h),
        Text(
          _isPending
              ? "Payment Processing"
              : (_isPartial ? "Part Payment Received" : "Payment Successful"),
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _resultMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: const Color.fromRGBO(42, 41, 51, 0.75),
          ),
        ),
        if (_receiptNumber != null && _receiptNumber!.isNotEmpty) ...[
          SizedBox(height: 10.h),
          Text(
            "Receipt: $_receiptNumber",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: _kGold,
            ),
          ),
        ],
        SizedBox(height: 20.h),
        if (hasReceipt) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openUrl(_receiptUrl),
                  icon: Icon(
                    Icons.receipt_long_rounded,
                    size: 18.sp,
                    color: _kDark,
                  ),
                  label: Text(
                    "View Receipt",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: _kDark,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(46.h),
                    side: const BorderSide(color: _kDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              if (_receiptDownloadUrl != null &&
                  _receiptDownloadUrl!.isNotEmpty) ...[
                SizedBox(width: 10.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openUrl(_receiptDownloadUrl),
                    icon: Icon(
                      Icons.download_rounded,
                      size: 18.sp,
                      color: _kDark,
                    ),
                    label: Text(
                      "Download",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _kDark,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(46.h),
                      side: const BorderSide(color: _kDark),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
        ],
        SizedBox(
          height: 50.h,
          child: ElevatedButton(
            onPressed: _close,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Done",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _failedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 6.h),
        Icon(
          Icons.error_outline_rounded,
          size: 60.sp,
          color: const Color(0xFFEF4444),
        ),
        SizedBox(height: 12.h),
        Text(
          "Payment Not Completed",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          _resultMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: const Color.fromRGBO(42, 41, 51, 0.75),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => setState(() {
              _stage = _Stage.input;
              _inputError = null;
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              "Try Again",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TextButton(
          onPressed: _close,
          child: Text(
            "Close",
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: _kDark,
            ),
          ),
        ),
      ],
    );
  }
}

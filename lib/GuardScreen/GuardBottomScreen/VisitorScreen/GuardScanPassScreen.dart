import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/GuaredHistoryScreen.dart';
import 'VisitorApprovalPassScreen.dart';

class GuardScanPassScreen extends ConsumerStatefulWidget {
  const GuardScanPassScreen({super.key});

  @override
  ConsumerState<GuardScanPassScreen> createState() =>
      _GuardScanPassScreenState();
}

class _GuardScanPassScreenState extends ConsumerState<GuardScanPassScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController passCodeController = TextEditingController();
  late final MobileScannerController cameraController;
  bool isFlashOn = false;
  bool isVerifying = false;
  String _scannedCode = '';
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animController.dispose();
    passCodeController.dispose();
    super.dispose();
  }

  String _sanitizePassCode(String raw) {
    String text = raw.trim();
    if (text.contains('PASS:')) {
      text = text.split('PASS:').last.split('|').first;
    }
    return text.replaceAll('#', '').trim();
  }

  Future<void> _verifyPass(String code, [String? qrData]) async {
    final rawInput = code.trim().isNotEmpty ? code : (qrData ?? "");
    final cleanCode = _sanitizePassCode(rawInput);
    if (cleanCode.isEmpty) {
      showErrorSnackBar("Please enter or scan a valid pass code");
      return;
    }
    setState(() {
      isVerifying = true;
    });
    try {
      final auth = ref.read(authServiceProvider);
      final res = await auth.scanVisitorPassData(passCode: cleanCode);
      if (res.status == true && res.data != null) {
        final d = res.data!;
        _scannedCode = cleanCode;
        showSuccessSnackBar(res.message ?? "Pass verified.");
        _showPassDetailsModal(
          passCode: d.passCode ?? cleanCode,
          visitorName: d.visitorName ?? "Visitor",
          visitorPhone: d.visitorPhone ?? "",
          flatNumber: d.flatNumber ?? "",
          passType: d.passType ?? "Visitor Pass",
          validDate: d.validDate ?? "Today",
          status: d.status ?? "VERIFIED",
          visitorId: d.visitorId?.toString() ?? d.id?.toString(),
        );
      } else {
        showErrorSnackBar(
          res.message ?? "Invalid or expired Visitor Pass code '$cleanCode'",
        );
      }
    } catch (e) {
      // Server ka asli message (invalid / expired / already used / rejected)
      // Dio interceptor already dikha deta hai - galat generic message nahi.
    } finally {
      if (mounted) {
        setState(() {
          isVerifying = false;
        });
      }
    }
  }

  void _showPassDetailsModal({
    required String passCode,
    required String visitorName,
    required String visitorPhone,
    required String flatNumber,
    required String passType,
    required String validDate,
    required String status,
    String? visitorId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        bool isMarkingIn = false;
        bool isMarkingOut = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.r),
                  topRight: Radius.circular(22.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pass Verification",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4F5E1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16A765),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "QR Code verified successfully against pre-approved pass.",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F5EE),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE4DFD3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46.w,
                              height: 46.w,
                              decoration: BoxDecoration(
                                color: AppColors.heading,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    visitorName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    visitorPhone,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD2F3DF),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                flatNumber.toLowerCase().startsWith('flat')
                                    ? flatNumber
                                    : "Flat $flatNumber",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF16A765),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        const Divider(height: 1, color: Color(0xFFE0DDD5)),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _passMetaCol("Pass Type", passType),
                            _passMetaCol("Pass Code", passCode),
                            _passMetaCol("Valid Until", validDate),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.heading,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: isMarkingIn || isMarkingOut
                                ? null
                                : () async {
                                    final nav = Navigator.of(context);
                                    setModalState(() {
                                      isMarkingIn = true;
                                    });
                                    try {
                                      // Real scan "mark_in": backend pass ko yahin use karta hai
                                      // (one-time pass, expiry aur status check ke saath).
                                      final res = await ref
                                          .read(authServiceProvider)
                                          .scanVisitorPassData(
                                            passCode: _scannedCode.isNotEmpty
                                                ? _scannedCode
                                                : passCode,
                                            action: "mark_in",
                                          );
                                      if (res.status == true) {
                                        final inAt = res.data?.inTime;
                                        showSuccessSnackBar(
                                          res.message ??
                                              ((inAt != null && inAt.isNotEmpty)
                                                  ? "Entry confirmed! IN-Time recorded at $inAt."
                                                  : "Entry confirmed! IN-Time recorded."),
                                        );
                                        if (modalContext.mounted) {
                                          Navigator.pop(modalContext);
                                        }
                                        nav.pushReplacement(
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                Guaredhistoryscreen(),
                                          ),
                                        );
                                      } else {
                                        showErrorSnackBar(
                                          res.message ??
                                              "Could not record entry.",
                                        );
                                      }
                                    } catch (e) {
                                      // Server ka asli error Dio interceptor dikha deta hai.
                                    } finally {
                                      if (modalContext.mounted) {
                                        setModalState(() {
                                          isMarkingIn = false;
                                        });
                                      }
                                    }
                                  },
                            child: isMarkingIn
                                ? SizedBox(
                                    height: 18.h,
                                    width: 18.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Mark IN-Time (Allow Entry)",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        height: 44.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.heading),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: isMarkingIn || isMarkingOut
                              ? null
                              : () async {
                                  final nav = Navigator.of(context);
                                  setModalState(() {
                                    isMarkingOut = true;
                                  });
                                  try {
                                    final res = await ref
                                        .read(authServiceProvider)
                                        .scanVisitorPassData(
                                          passCode: _scannedCode.isNotEmpty
                                              ? _scannedCode
                                              : passCode,
                                          action: "mark_out",
                                        );
                                    if (res.status == true) {
                                      showSuccessSnackBar(
                                        res.message ??
                                            "Visitor marked OUT. Visit closed.",
                                      );
                                      if (modalContext.mounted) {
                                        Navigator.pop(modalContext);
                                      }
                                      if (nav.canPop()) {
                                        nav.pop();
                                      }
                                    } else {
                                      showErrorSnackBar(
                                        res.message ??
                                            "Could not mark visitor OUT.",
                                      );
                                    }
                                  } catch (e) {
                                    // Server ka asli error Dio interceptor dikha deta hai.
                                  } finally {
                                    if (modalContext.mounted) {
                                      setModalState(() {
                                        isMarkingOut = false;
                                      });
                                    }
                                  }
                                },
                          child: isMarkingOut
                              ? SizedBox(
                                  height: 18.h,
                                  width: 18.h,
                                  child: CircularProgressIndicator(
                                    color: AppColors.heading,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Mark OUT",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _passMetaCol(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            color: const Color(0xFF777777),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 41.w,
                  height: 41.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan Visitor Pass",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Scan QR code or enter pass code",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Scanner Viewport Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1E18),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF16A765),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Camera Active",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                try {
                                  await cameraController.switchCamera();
                                } catch (_) {}
                              },
                              icon: Icon(
                                Icons.flip_camera_ios_outlined,
                                color: Colors.white70,
                                size: 20.sp,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  await cameraController.toggleTorch();
                                  setState(() {
                                    isFlashOn = !isFlashOn;
                                  });
                                } catch (_) {}
                              },
                              icon: Icon(
                                isFlashOn
                                    ? Icons.flash_on_rounded
                                    : Icons.flash_off_rounded,
                                color: isFlashOn
                                    ? const Color(0xFFE8B900)
                                    : Colors.white70,
                                size: 22.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Real Camera QR Viewfinder
                    Container(
                      width: 250.w,
                      height: 250.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFE8B900),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Back camera live video feed
                            MobileScanner(
                              controller: cameraController,
                              onDetect: (BarcodeCapture capture) {
                                if (isVerifying) return;
                                for (final barcode in capture.barcodes) {
                                  final raw =
                                      barcode.rawValue ?? barcode.displayValue;
                                  if (raw != null && raw.trim().isNotEmpty) {
                                    _verifyPass(raw.trim(), raw.trim());
                                    break;
                                  }
                                }
                              },
                              errorBuilder: (context, error) {
                                return Container(
                                  color: Colors.black87,
                                  padding: EdgeInsets.all(12.w),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.videocam_off_outlined,
                                          color: const Color(0xFFE8B900),
                                          size: 36.sp,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          "Camera permission needed\nor camera unavailable",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFE8B900,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 4.h,
                                            ),
                                          ),
                                          onPressed: () {
                                            cameraController.start();
                                          },
                                          child: Text(
                                            "Retry",
                                            style: GoogleFonts.outfit(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // 4 Corner Brackets Overlay
                            Positioned(
                              top: 8,
                              left: 8,
                              child: _cornerBracket(isTop: true, isLeft: true),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: _cornerBracket(isTop: true, isLeft: false),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: _cornerBracket(isTop: false, isLeft: true),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: _cornerBracket(
                                isTop: false,
                                isLeft: false,
                              ),
                            ),

                            // Animated Laser Scanning Line
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Positioned(
                                  top: _animation.value * 230,
                                  left: 10,
                                  right: 10,
                                  child: Container(
                                    height: 2.5,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8B900),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFE8B900,
                                          ).withOpacity(0.8),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Verification loading overlay
                            if (isVerifying)
                              Container(
                                color: Colors.black45,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE8B900),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                    Text(
                      "Point camera at visitor's pass QR code",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Manual Code Input Option
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Or Enter Pass Code Manually",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Use 6-digit pass code shared by resident",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: passCodeController,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: 2,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "e.g. VP-84920",
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color(0xFF999999),
                                letterSpacing: 0,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              filled: true,
                              fillColor: AppColors.scaffoldBg,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: const Color(0xff101C16),
                                  width: 1.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: AppColors.heading,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.heading,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: isVerifying
                                ? null
                                : () => _verifyPass(
                                    passCodeController.text.trim(),
                                  ),
                            child: isVerifying
                                ? SizedBox(
                                    height: 18.h,
                                    width: 18.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Verify",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cornerBracket({required bool isTop, required bool isLeft}) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFFE8B900), width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFFE8B900), width: 3)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFFE8B900), width: 3)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFFE8B900), width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}

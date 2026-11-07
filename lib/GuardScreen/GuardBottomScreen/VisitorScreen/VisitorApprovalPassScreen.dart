import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/Provider/visitorPassProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/GuardHomeScreen.dart';
import 'package:property_association_or_resident/GuardScreen/Model/VisitorPassResModel.dart';

class Visitorapprovalpassscreen extends ConsumerStatefulWidget {
  final String visitorId;
  final String? visitorName;
  final String? flatNumber;
  final String? visitorPhone;
  final String? visitType;
  final String? vehicleNumber;
  final String? purpose;
  final String? initialStatus;
  final String? inTime;

  const Visitorapprovalpassscreen({
    super.key,
    required this.visitorId,
    this.visitorName,
    this.flatNumber,
    this.visitorPhone,
    this.visitType,
    this.vehicleNumber,
    this.purpose,
    this.initialStatus,
    this.inTime,
  });

  @override
  ConsumerState<Visitorapprovalpassscreen> createState() =>
      _VisitorapprovalpassscreenState();
}

class _VisitorapprovalpassscreenState
    extends ConsumerState<Visitorapprovalpassscreen> {
  late String
  currentStatus; // 'PENDING', 'APPROVED', 'REJECTED', 'NO_RESPONSE_CALL'
  int secondsRemaining = 60;
  Timer? _countdownTimer;
  String? inTime;
  String? outTime;
  bool isStatusInitializedFromApi = false;
  bool isActionLoading = false;
  bool isMarkingOut = false;

  Future<void> _makeCall(String phone) async {
    if (phone.trim().isEmpty || phone.trim() == '--') {
      showErrorSnackBar("Resident phone number is not available.");
      return;
    }
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri url = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showErrorSnackBar("Could not open dialer for $phone");
    }
  }

  Future<void> _handleVerbalApprove(bool isApprove) async {
    setState(() {
      isActionLoading = true;
    });
    try {
      final auth = ref.read(authServiceProvider);
      final res = await auth.verbalApproveVisitorData(
        id: widget.visitorId,
        action: isApprove ? 'approved' : 'rejected',
      );
      if (res.status == true) {
        showSuccessSnackBar(
          res.message ??
              (isApprove ? "Visitor verbally approved!" : "Entry rejected"),
        );
        setState(() {
          currentStatus = isApprove ? 'APPROVED' : 'REJECTED';
        });
        ref.invalidate(visitorPassProvider(widget.visitorId));
      } else {
        showErrorSnackBar(res.message ?? "Failed to update visitor status");
      }
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
      // Status yahan galat tarah se change nahi karte.
      ref.invalidate(visitorPassProvider(widget.visitorId));
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> _handleMarkOut() async {
    setState(() {
      isMarkingOut = true;
    });
    try {
      final auth = ref.read(authServiceProvider);
      final res = await auth.markOutData(widget.visitorId);
      if (res.status == true) {
        final newOutTime = res.data?.outTime ?? _formatCurrentTime();
        setState(() {
          outTime = newOutTime;
        });
        showSuccessSnackBar(
          res.message ?? "Visitor marked OUT. Record closed.",
        );
      } else {
        showErrorSnackBar(res.message ?? "Could not mark visitor OUT.");
      }
      ref.invalidate(visitorPassProvider(widget.visitorId));
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
      ref.invalidate(visitorPassProvider(widget.visitorId));
    } finally {
      if (mounted) {
        setState(() {
          isMarkingOut = false;
        });
      }
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour == 0
        ? 12
        : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  void initState() {
    super.initState();
    currentStatus = widget.initialStatus ?? 'PENDING';
    inTime = widget.inTime;
    if (currentStatus == 'PENDING') {
      _startCountdown();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    secondsRemaining = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        // Auto-poll status from API every 3 seconds while waiting for resident approval
        if (secondsRemaining % 3 == 0 && widget.visitorId.isNotEmpty) {
          ref.invalidate(visitorPassProvider(widget.visitorId));
        }
      } else {
        timer.cancel();
        setState(() {
          currentStatus = 'NO_RESPONSE_CALL';
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _navigateToGuardHome() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => const GuardBottomNavState()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vId = widget.visitorId;
    final visitorPassAsync = ref.watch(visitorPassProvider(vId));
    final VisitorPassData? passData = visitorPassAsync.value?.data;

    // Continuously sync status whenever passData is updated (via polling or refresh)
    if (passData != null) {
      final badge = passData.approvalStatusCard?.badge?.toUpperCase();
      if ((badge == 'APPROVED' || badge == 'INSIDE') &&
          currentStatus != 'APPROVED') {
        currentStatus = 'APPROVED';
        _countdownTimer?.cancel();
      } else if (badge == 'REJECTED' && currentStatus != 'REJECTED') {
        currentStatus = 'REJECTED';
        _countdownTimer?.cancel();
      }
    }

    final vName =
        passData?.visitorDetails?.name ?? widget.visitorName ?? 'Visitor';
    final vFlat =
        passData?.visitorDetails?.apartment ?? widget.flatNumber ?? '--';
    final vPhone =
        passData?.visitorDetails?.visitorMobile ??
        widget.visitorPhone ??
        '--';
    final vType =
        passData?.visitorDetails?.typeLabel ??
        widget.visitType ??
        'Visitor';
    final vVehicle =
        passData?.visitorDetails?.vehicle ??
        widget.vehicleNumber ??
        '--';
    final vPurpose =
        passData?.visitorDetails?.purpose ??
        widget.purpose ??
        '--';
    final vPhotoUrl = passData?.visitorDetails?.photoUrl;
    final vRequestedAt = passData?.visitorDetails?.requestedAt ?? '--';

    final residentName = passData?.residentApproval?.residentName ?? 'Resident';
    final residentPhone =
        passData?.residentApproval?.residentPhone ?? '';

    final passCode = passData?.visitorPassCard?.passCode ?? '--';
    final qrCodeUrl = passData?.visitorPassCard?.qrCodeUrl;
    final passBadge = passData?.visitorPassCard?.badge ?? 'VERIFIED PASS';
    final passInstruction =
        passData?.visitorPassCard?.instruction ??
        'Scan this QR code or enter this pass code to verify the visitor.';

    final effectiveInTime =
        passData?.timings?.inTime ?? inTime ?? '--';
    final effectiveOutTime = passData?.timings?.outTime ?? outTime;

    final headerTitle = passData?.header?.title ?? "Visitor Approval & Pass";
    final headerSubtitle =
        passData?.header?.subtitle ?? "View approval status and visitor pass";

    return WillPopScope(
      onWillPop: () async {
        _navigateToGuardHome();
        return false;
      },
      child: Scaffold(
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
                  onTap: _navigateToGuardHome,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        headerSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.65),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(visitorPassProvider(vId));
            await ref.read(visitorPassProvider(vId).future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (visitorPassAsync.isLoading) ...[
                  //   SizedBox(height: 4.h),
                  //   const LinearProgressIndicator(
                  //     color: AppColors.heading,
                  //     backgroundColor: Color(0xFFE0E0E0),
                  //   ),
                  // ],

                  // SizedBox(height: 16.h),

                  // Interactive Status Simulator Filter
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statusChip("Pending", "PENDING"),
                        _statusChip("Approved", "APPROVED"),
                        _statusChip("Call Flow", "NO_RESPONSE_CALL"),
                        _statusChip("Rejected", "REJECTED"),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Status Banner Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: currentStatus == 'APPROVED'
                            ? const Color(0xFF16A765)
                            : currentStatus == 'NO_RESPONSE_CALL'
                            ? const Color(0xFFE8B900)
                            : currentStatus == 'REJECTED'
                            ? const Color(0xFFD22424)
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Approval Status',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: currentStatus == 'APPROVED'
                                    ? const Color(0xFFD4F5E1)
                                    : currentStatus == 'NO_RESPONSE_CALL'
                                    ? const Color(0xFFFFF4D1)
                                    : currentStatus == 'REJECTED'
                                    ? const Color(0xFFFFE5E5)
                                    : const Color(0xFFE8F1FF),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                currentStatus == 'APPROVED'
                                    ? 'APPROVED'
                                    : currentStatus == 'NO_RESPONSE_CALL'
                                    ? 'NO RESPONSE (CALL)'
                                    : currentStatus == 'REJECTED'
                                    ? 'REJECTED'
                                    : 'WAITING ($secondsRemaining s)',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: currentStatus == 'APPROVED'
                                      ? const Color(0xFF16A765)
                                      : currentStatus == 'NO_RESPONSE_CALL'
                                      ? const Color(0xFFB8860B)
                                      : currentStatus == 'REJECTED'
                                      ? const Color(0xFFD22424)
                                      : const Color(0xFF1E5993),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        if (currentStatus == 'PENDING') ...[
                          Text(
                            passData?.approvalStatusCard?.title ??
                                'Approval Request Sent to Resident',
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            passData?.approvalStatusCard?.description ??
                                'Notification delivered to resident of Flat $vFlat. System waiting for response...',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          LinearProgressIndicator(
                            value: secondsRemaining / 60,
                            backgroundColor: const Color(0xFFEEEEEE),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFE8B900),
                            ),
                            minHeight: 6.h,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ] else if (currentStatus == 'NO_RESPONSE_CALL') ...[
                          Text(
                            'Flow 6: 1-Minute No-Response Escalation',
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFB8860B),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Resident did not respond within 1 minute. Call the resident directly${residentPhone.isEmpty ? '' : ' at $residentPhone'} for verbal approval/rejection.',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D1C16),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () => _makeCall(residentPhone),
                              icon: Icon(
                                Icons.call,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              label: Text(
                                residentPhone.isEmpty
                                    ? "Call Resident"
                                    : "Call Resident ($residentPhone)",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF16A765),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: isActionLoading
                                      ? null
                                      : () => _handleVerbalApprove(true),
                                  child: isActionLoading
                                      ? SizedBox(
                                          height: 18.h,
                                          width: 18.h,
                                          child:
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                        )
                                      : Text(
                                          "Verbal Approved",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFD22424),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: isActionLoading
                                      ? null
                                      : () => _handleVerbalApprove(false),
                                  child: Text(
                                    "Deny Entry",
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFD22424),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (currentStatus == 'REJECTED') ...[
                          Text(
                            'Resident Denied Entry',
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD22424),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Resident has rejected the entry request. Please inform the visitor and deny entry at gate.',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD22424),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: _navigateToGuardHome,
                              child: Text(
                                "Back to Gate Desk",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            passData?.approvalStatusCard?.title ??
                                'Resident Approved Visitor Entry',
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            passData?.approvalStatusCard?.description ??
                                'Visitor is approved for entry. Visitor pass is active and verified.',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Visitor Details Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Visitor Details',
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD2D5D3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child:
                                    (vPhotoUrl != null && vPhotoUrl.isNotEmpty)
                                    ? Image.network(
                                        vPhotoUrl,
                                        width: 50.w,
                                        height: 50.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.person,
                                                  size: 25.sp,
                                                  color: const Color(
                                                    0xFF07100D,
                                                  ),
                                                ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 25.sp,
                                        color: const Color(0xFF07100D),
                                      ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    vType,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF777777),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD2F3DF),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      vFlat.startsWith('Flat')
                                          ? vFlat
                                          : 'Flat $vFlat',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF20A866),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 12.h,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.2,
                          children: [
                            _infoCard(title: "Mobile", subtitle: vPhone),
                            _infoCard(title: "Vehicle", subtitle: vVehicle),
                            _infoCard(title: "Purpose", subtitle: vPurpose),
                            _infoCard(
                              title: "Requested At",
                              subtitle: vRequestedAt,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Resident Contact & Call Option
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resident Contact',
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                            Text(
                              residentName,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 11.h,
                            horizontal: 14.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFE8B900),
                              width: 1.5,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _makeCall(residentPhone),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone_in_talk_rounded,
                                  size: 22.sp,
                                  color: const Color(0xFF17201D),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  residentPhone.isEmpty
                                      ? 'Call Resident'
                                      : 'Call Resident ($residentPhone)',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF17201D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // QR Pass Box (Visible when Approved)
                  // if (currentStatus == 'APPROVED') ...[
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 24.h,
                  //     horizontal: 16.w,
                  //   ),
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.heading,
                  //     borderRadius: BorderRadius.circular(14.r),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: 12.w,
                  //           vertical: 4.h,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: const Color(0xFF16A765),
                  //           borderRadius: BorderRadius.circular(20.r),
                  //         ),
                  //         child: Text(
                  //           passBadge,
                  //           style: GoogleFonts.outfit(
                  //             fontSize: 12.sp,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white,
                  //             letterSpacing: 0.5,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(height: 14.h),
                  //       ClipRRect(
                  //         borderRadius: BorderRadius.circular(10.r),
                  //         child: (qrCodeUrl != null && qrCodeUrl.isNotEmpty)
                  //             ? Image.network(
                  //                 qrCodeUrl,
                  //                 height: 120.h,
                  //                 width: 120.w,
                  //                 fit: BoxFit.cover,
                  //                 errorBuilder: (context, error, stackTrace) {
                  //                   return Container(
                  //                     height: 120.h,
                  //                     width: 120.w,
                  //                     color: Colors.white,
                  //                     child: Icon(
                  //                       Icons.qr_code_2_rounded,
                  //                       size: 80.sp,
                  //                       color: Colors.black,
                  //                     ),
                  //                   );
                  //                 },
                  //               )
                  //             : Image.asset(
                  //                 "assets/lence_img.png",
                  //                 height: 110.h,
                  //                 width: 110.w,
                  //                 fit: BoxFit.cover,
                  //                 errorBuilder: (context, error, stackTrace) {
                  //                   return Container(
                  //                     height: 110.h,
                  //                     width: 110.w,
                  //                     color: Colors.white,
                  //                     child: Icon(
                  //                       Icons.qr_code_2_rounded,
                  //                       size: 80.sp,
                  //                       color: Colors.black,
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //       ),
                  //       SizedBox(height: 12.h),
                  //       Text(
                  //         "Pass Code: $passCode",
                  //         style: GoogleFonts.outfit(
                  //           fontSize: 17.sp,
                  //           fontWeight: FontWeight.w700,
                  //           color: Colors.white,
                  //           letterSpacing: 1.5,
                  //         ),
                  //       ),
                  //       SizedBox(height: 6.h),
                  //       Text(
                  //         passInstruction,
                  //         textAlign: TextAlign.center,
                  //         style: GoogleFonts.outfit(
                  //           fontSize: 12.sp,
                  //           color: const Color(0xFFD3D3D3),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 18.h),
                  // ],

                  // IN-TIME & OUT-TIME Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBg,
                            borderRadius: BorderRadius.circular(10.r),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xFF16B86A),
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IN-TIME',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                effectiveInTime,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBg,
                            borderRadius: BorderRadius.circular(10.r),
                            border: const Border(
                              left: BorderSide(
                                color: Color(0xffE2B509),
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OUT-TIME',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                effectiveOutTime ?? 'Inside',
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: effectiveOutTime != null
                                      ? AppColors.heading
                                      : const Color(0xFFB8860B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Action Buttons
                  if (currentStatus == 'APPROVED')
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: outTime != null
                                ? ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF16A765),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    onPressed: _navigateToGuardHome,
                                    icon: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Visit Closed (Done)',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.heading,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    onPressed: isMarkingOut
                                        ? null
                                        : _handleMarkOut,
                                    child: isMarkingOut
                                        ? SizedBox(
                                            height: 18.h,
                                            width: 18.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                          )
                                        : Text(
                                            'Mark OUT-Time',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, String statusKey) {
    final isSelected = currentStatus == statusKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentStatus = statusKey;
          if (statusKey == 'PENDING') {
            _startCountdown();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.heading : const Color(0xFFF0EFEA),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppColors.heading,
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String subtitle}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xffF3F0E8),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}

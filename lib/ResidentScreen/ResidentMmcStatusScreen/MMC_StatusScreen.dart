import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/ResidentMmcStatusResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentMmcStatusScreen/MaintenanceActivitiesScreen.dart';
import 'package:share_plus/share_plus.dart';

import 'Provider/ResidentMmcStatusProvider.dart';

class MmcStatusscreen extends ConsumerStatefulWidget {
  const MmcStatusscreen({super.key});

  @override
  ConsumerState<MmcStatusscreen> createState() => _MmcStatusscreenState();
}

class _MmcStatusscreenState extends ConsumerState<MmcStatusscreen> {
  // Helper to parse hex colors safely with a fallback
  Color _parseHexColor(
    String? hexString, {
    Color fallback = const Color(0xffB8860B),
  }) {
    if (hexString == null || hexString.isEmpty) return fallback;
    try {
      String clean = hexString.replaceAll("#", "").trim();
      if (clean.length == 6) {
        clean = "FF$clean";
      }
      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mmcState = ref.watch(residentMmcStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 20.w,
        title: mmcState.when(
          data: (data) => _buildAppBarContent(
            context,
            title: data.data.header.tag.isNotEmpty
                ? data.data.header.tag
                : "MMC Status",
            subtitle: data.data.header.subtitle.isNotEmpty
                ? data.data.header.subtitle
                : "Monthly Maintenance Charge",
          ),
          error: (_, __) => _buildAppBarContent(
            context,
            title: "MMC Status",
            subtitle: "Monthly Maintenance Charge",
          ),
          loading: () => _buildAppBarContent(
            context,
            title: "MMC Status",
            subtitle: "Monthly Maintenance Charge",
          ),
        ),
      ),
      body: mmcState.when(
        data: (data) {
          final currentStatusVal = data.data.currentMonth.currentStatus.value
              .toLowerCase();
          final isCurrentMonthPaid =
              currentStatusVal.contains("paid") &&
              !currentStatusVal.contains("unpaid");

          final pendingSummary = data.data.pendingDuesSummary;
          final hasPendingDues =
              pendingSummary != null &&
              (pendingSummary.hasPendingDues ||
                  pendingSummary.pendingMonths.isNotEmpty ||
                  pendingSummary.totalPendingMonths > 0);

          final totalOutstanding = data.data.currentMonth.totalOutstanding;

          return RefreshIndicator(
            color: const Color(0xffB8860B),
            backgroundColor: AppColors.scaffoldBg,
            onRefresh: () async {
              return ref.refresh(residentMmcStatusProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // 1. Dynamic Status Banner
                  _buildStatusBanner(
                    isCurrentMonthPaid: isCurrentMonthPaid,
                    hasPendingDues: hasPendingDues,
                    monthName: data.data.currentMonth.month.value,
                    pendingSummary: pendingSummary,
                  ),

                  SizedBox(height: 18.h),

                  // // 2. Outstanding & Arrears Summary Card (if there are dues or total_outstanding info)
                  // if (hasPendingDues || totalOutstanding != null) ...[
                  //   _buildTotalOutstandingCard(
                  //     totalOutstanding: totalOutstanding,
                  //     pendingSummary: pendingSummary,
                  //     currency: data.data.currentMonth.charge.currency,
                  //   ),
                  //   SizedBox(height: 20.h),
                  // ],

                  // 3. Current Month Card
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.data.currentMonth.sectionTitle.isNotEmpty
                              ? data.data.currentMonth.sectionTitle
                              : "Current Month",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => WorkOrderListScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 10.w,
                      //       vertical: 8.h,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: AppColors.heading),
                      //       borderRadius: BorderRadius.circular(10.r),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Service Charges",
                      //         style: GoogleFonts.outfit(
                      //           color: AppColors.heading,
                      //           fontSize: 14.sp,
                      //           fontWeight: FontWeight.w500,
                      //           letterSpacing: -0.2,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildCurrentMonthCard(
                    data: data,
                    isPaid: isCurrentMonthPaid,
                  ),

                  SizedBox(height: 18.h),

                  // // 4. Current Month Action Buttons (Receipt / Share if paid)
                  // if (isCurrentMonthPaid) ...[
                  //   _buildReceiptButtons(context, data),
                  //   SizedBox(height: 20.h),
                  // ],

                  // 5. Pending Dues & Past Months List (Dynamic from API)
                  if (hasPendingDues) ...[
                    _buildPendingDuesSection(
                      context,
                      pendingSummary: pendingSummary,
                      data: data,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Unable to load MMC Status",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => ref.refresh(residentMmcStatusProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101C16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Retry",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  // --- App Bar Title Builder ---
  Widget _buildAppBarContent(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Align(
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
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
    );
  }

  // --- Top Status Banner ---
  Widget _buildStatusBanner({
    required bool isCurrentMonthPaid,
    required bool hasPendingDues,
    required String monthName,
    PendingDuesSummary? pendingSummary,
  }) {
    Color bannerBg;
    Color bannerBorder;
    Color bannerIconColor;
    IconData bannerIcon;
    String bannerMessage;

    if (isCurrentMonthPaid && hasPendingDues) {
      bannerBg = const Color(0xFFEAB308).withOpacity(0.12);
      bannerBorder = const Color(0xFFEAB308).withOpacity(0.4);
      bannerIconColor = const Color(0xFFB8860B);
      bannerIcon = Icons.warning_amber_rounded;
      final pendingCount = pendingSummary?.totalPendingMonths ?? 1;
      final pendingAmount = pendingSummary?.totalOutstandingDisplay ?? '';
      bannerMessage =
          "Maintenance for $monthName is paid, but you have $pendingCount past pending month${pendingCount > 1 ? 's' : ''}${pendingAmount.isNotEmpty ? ' ($pendingAmount)' : ''}.";
    } else if (isCurrentMonthPaid) {
      bannerBg = const Color(0xFF24B06A).withOpacity(0.08);
      bannerBorder = const Color(0xFF24B06A).withOpacity(0.3);
      bannerIconColor = const Color(0xFF24B06A);
      bannerIcon = Icons.check_circle_outline;
      bannerMessage =
          "Your maintenance charge for $monthName is fully paid. No pending dues.";
    } else {
      bannerBg = const Color(0xFFEF4444).withOpacity(0.08);
      bannerBorder = const Color(0xFFEF4444).withOpacity(0.3);
      bannerIconColor = const Color(0xFFEF4444);
      bannerIcon = Icons.warning_amber_rounded;
      bannerMessage =
          "Maintenance charge for $monthName is due. Please pay to avoid late charges.";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: bannerBorder, width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(bannerIcon, color: bannerIconColor, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              bannerMessage,
              style: GoogleFonts.outfit(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Total Outstanding Overview Card ---
  Widget _buildTotalOutstandingCard({
    TotalOutstanding? totalOutstanding,
    PendingDuesSummary? pendingSummary,
    required String currency,
  }) {
    final outstandingDisplay =
        pendingSummary?.totalOutstandingDisplay ??
        totalOutstanding?.amountDisplay ??
        "SAR 0";

    final pendingMonthsLabel =
        totalOutstanding?.pendingMonthsLabel ??
        (pendingSummary != null
            ? "${pendingSummary.totalPendingMonths} Month Pending"
            : "0 Pending");

    final pastArrearsDisplay = totalOutstanding?.pastArrearsDisplay ?? "SAR 0";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF101C16),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffB8860B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18.sp,
                      color: const Color(0xffB8860B),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "TOTAL OUTSTANDING",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: const Color(0xffB8860B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFEF4444).withOpacity(0.4),
                  ),
                ),
                child: Text(
                  pendingMonthsLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            outstandingDisplay,
            style: GoogleFonts.outfit(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.white.withOpacity(0.12), thickness: 0.8),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Past Arrears Dues:",
                style: GoogleFonts.outfit(
                  fontSize: 13.5.sp,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                pastArrearsDisplay,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Current Month Card ---
  Widget _buildCurrentMonthCard({
    required ResidentMmcStatusResModel data,
    required bool isPaid,
  }) {
    final currentMonth = data.data.currentMonth;
    final statusBadgeColor = _parseHexColor(
      currentMonth.currentStatus.badgeColor,
      fallback: isPaid ? const Color(0xFF24B06A) : const Color(0xffB8860B),
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border.all(color: AppColors.heading, width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(184, 134, 11, 0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  size: 18.sp,
                  color: const Color(0xffB8860B),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  currentMonth.cardTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentMonth.charge.label,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff2A2933),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  currentMonth.charge.amountDisplay.isNotEmpty
                      ? currentMonth.charge.amountDisplay
                      : "${currentMonth.charge.currency} ${currentMonth.charge.amount}",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffB8860B),
                    fontSize: 24.sp,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth.currentStatus.label,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBadgeColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  currentMonth.currentStatus.value,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: statusBadgeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.8.w,
            color: const Color.fromRGBO(16, 28, 22, 0.2),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth.month.label,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                currentMonth.month.value,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(
            thickness: 0.8.w,
            color: const Color.fromRGBO(16, 28, 22, 0.2),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth.paidOn.label,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                currentMonth.paidOn.value.isNotEmpty
                    ? currentMonth.paidOn.value
                    : (isPaid ? "Recorded" : "Pending Payment"),
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isPaid ? AppColors.heading : const Color(0xFFEF4444),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Current Month Receipt Buttons ---
  Widget _buildReceiptButtons(
    BuildContext context,
    ResidentMmcStatusResModel data,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _showReceiptModal(context, data);
            },
            icon: Icon(
              Icons.receipt_long,
              size: 18.sp,
              color: const Color(0xFF101C16),
            ),
            label: Text(
              "View Receipt",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101C16),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFF101C16), width: 1.2.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              backgroundColor: AppColors.scaffoldBg,
              fixedSize: Size(double.infinity, 48.h),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              final shareText =
                  "🧾 PROPERTY MAINTENANCE PAYMENT RECEIPT\n"
                  "---------------------------------------\n"
                  "Status: PAID & VERIFIED\n"
                  "Billing Month: ${data.data.currentMonth.month.value}\n"
                  "Amount: ${data.data.currentMonth.charge.amountDisplay.isNotEmpty ? data.data.currentMonth.charge.amountDisplay : "${data.data.currentMonth.charge.currency} ${data.data.currentMonth.charge.amount}"}\n"
                  "Paid On: ${data.data.currentMonth.paidOn.value.isNotEmpty ? data.data.currentMonth.paidOn.value : 'Verified'}\n"
                  "Payment Method: Online / Bank Recorded\n"
                  "Receipt Reference: REC-${DateTime.now().year}-${data.data.currentMonth.month.value.replaceAll(' ', '')}\n"
                  "---------------------------------------\n"
                  "Verified by Property Association Management.";
              Share.share(shareText);
            },
            icon: Icon(Icons.share_rounded, size: 18.sp, color: Colors.white),
            label: Text(
              "Share Receipt",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF101C16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              fixedSize: Size(double.infinity, 48.h),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // --- Pending Dues Breakdown Section ---
  Widget _buildPendingDuesSection(
    BuildContext context, {
    required PendingDuesSummary pendingSummary,
    required ResidentMmcStatusResModel data,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pending Dues & Past Arrears",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "${pendingSummary.totalPendingMonths} Pending",
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ),
        if (pendingSummary.subtitle.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            pendingSummary.subtitle,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: const Color.fromRGBO(42, 41, 51, 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        SizedBox(height: 12.h),

        // List of Pending Months
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pendingSummary.pendingMonths.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final item = pendingSummary.pendingMonths[index];
            final badgeColor = _parseHexColor(
              item.badgeColor,
              fallback: const Color(0xFFEAB308),
            );

            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: badgeColor.withOpacity(0.5),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 20.sp,
                      color: badgeColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.month,
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.dueDate.isNotEmpty
                              ? "Due: ${item.dueDate}"
                              : "Overdue",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFFEF4444),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.amountDisplay,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffB8860B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          item.status,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // --- Main Action Buttons (Pay Maintenance & History) ---
  Widget _buildMainActionButtons(
    BuildContext context, {
    required ResidentMmcStatusResModel data,
    required bool hasPendingDues,
    required bool isCurrentMonthPaid,
  }) {
    final payNowAction = data.data.actions.payNow;
    final isPayAvailable =
        payNowAction.isAvailable ?? (hasPendingDues || !isCurrentMonthPaid);

    final payAmountDisplay =
        payNowAction.payAmountDisplay ??
        data.data.pendingDuesSummary?.totalOutstandingDisplay ??
        (data.data.currentMonth.totalOutstanding?.amountDisplay ??
            data.data.currentMonth.charge.amountDisplay);

    return Column(
      children: [
        if (isPayAvailable) ...[
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () {
                _showPaymentOptionsModal(context, data);
              },
              icon: Icon(
                Icons.payment_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
              label: Text(
                "${payNowAction.label} ($payAmountDisplay)",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF101C16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],

        // View Maintenance History Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton.icon(
            onPressed: () {
              _showHistoryModal(context, data);
            },
            icon: Icon(
              Icons.history_rounded,
              size: 20.sp,
              color: const Color(0xFF101C16),
            ),
            label: Text(
              data.data.actions.viewHistory.label.isNotEmpty
                  ? data.data.actions.viewHistory.label
                  : "View Maintenance History",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101C16),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFF101C16), width: 1.2.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              backgroundColor: AppColors.scaffoldBg,
            ),
          ),
        ),
      ],
    );
  }

  // --- Payment Modal with Bank Details ---
  void _showPaymentOptionsModal(
    BuildContext context,
    ResidentMmcStatusResModel data,
  ) {
    final payAmountDisplay =
        data.data.actions.payNow.payAmountDisplay ??
        data.data.pendingDuesSummary?.totalOutstandingDisplay ??
        data.data.currentMonth.charge.amountDisplay;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).padding.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pay Maintenance",
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101C16),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Amount Payable",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        payAmountDisplay,
                        style: GoogleFonts.outfit(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffB8860B),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Bank Transfer Details",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 10.h),
                _bankDetailRow(
                  "Account Name",
                  "Property Association Fund",
                  canCopy: true,
                ),
                _bankDetailRow(
                  "Bank Name",
                  "Al Rajhi Bank / Saudi National Bank",
                  canCopy: false,
                ),
                _bankDetailRow(
                  "IBAN / Account Number",
                  "SA0380000000608010167519",
                  canCopy: true,
                ),
                _bankDetailRow(
                  "Payment Reference",
                  "MMC-${data.data.currentMonth.month.value.replaceAll(' ', '')}",
                  canCopy: true,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showSuccessSnackBar(
                        "Please transfer via your bank app using above IBAN and reference.",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101C16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "I Have Made The Payment",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Maintenance History Modal ---
  void _showHistoryModal(BuildContext context, ResidentMmcStatusResModel data) {
    // Combine current month, pending months, and history items into a comprehensive list
    final List<Map<String, dynamic>> allCycles = [];

    // Current month
    final currentPaid =
        data.data.currentMonth.currentStatus.value.toLowerCase().contains(
          "paid",
        ) &&
        !data.data.currentMonth.currentStatus.value.toLowerCase().contains(
          "unpaid",
        );

    allCycles.add({
      "month": data.data.currentMonth.month.value,
      "amountDisplay": data.data.currentMonth.charge.amountDisplay.isNotEmpty
          ? data.data.currentMonth.charge.amountDisplay
          : "${data.data.currentMonth.charge.currency} ${data.data.currentMonth.charge.amount}",
      "status": data.data.currentMonth.currentStatus.value,
      "isPaid": currentPaid,
      "date": currentPaid
          ? (data.data.currentMonth.paidOn.value.isNotEmpty
                ? "Paid: ${data.data.currentMonth.paidOn.value}"
                : "Paid & Recorded")
          : "Due: Pending Payment",
    });

    // Pending months
    if (data.data.pendingDuesSummary != null) {
      for (final p in data.data.pendingDuesSummary!.pendingMonths) {
        allCycles.add({
          "month": p.month,
          "amountDisplay": p.amountDisplay,
          "status": p.status,
          "isPaid": false,
          "date": p.dueDate.isNotEmpty ? "Due: ${p.dueDate}" : "Overdue",
        });
      }
    }

    // Additional history items if any
    if (data.data.history != null) {
      for (final h in data.data.history!) {
        // avoid duplicate month
        if (!allCycles.any((c) => c["month"] == h.month)) {
          allCycles.add({
            "month": h.month,
            "amountDisplay": h.amountDisplay,
            "status": h.status,
            "isPaid": h.isPaid,
            "date": h.isPaid
                ? "Paid: ${h.paidDate ?? 'Recorded'}"
                : "Due: ${h.dueDate ?? 'Overdue'}",
          });
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).padding.bottom + 10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Maintenance History",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.separated(
                  itemCount: allCycles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = allCycles[index];
                    final isPaid = item["isPaid"] as bool;

                    return Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isPaid
                              ? const Color.fromRGBO(16, 28, 22, 0.15)
                              : const Color(0xFFEF4444).withOpacity(0.4),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? const Color(
                                              0xFF24B06A,
                                            ).withOpacity(0.12)
                                          : const Color(
                                              0xFFEF4444,
                                            ).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      isPaid
                                          ? Icons.check_circle_outline
                                          : Icons.warning_amber_rounded,
                                      size: 19.sp,
                                      color: isPaid
                                          ? const Color(0xFF24B06A)
                                          : const Color(0xFFEF4444),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["month"],
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.heading,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        item["date"],
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: isPaid
                                              ? Colors.grey.shade600
                                              : const Color(0xFFEF4444),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item["amountDisplay"],
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isPaid
                                          ? const Color(0xffB8860B)
                                          : const Color(0xFFEF4444),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? const Color(
                                              0xFF24B06A,
                                            ).withOpacity(0.12)
                                          : const Color(
                                              0xFFEF4444,
                                            ).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      item["status"],
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isPaid
                                            ? const Color(0xFF24B06A)
                                            : const Color(0xFFEF4444),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (isPaid) ...[
                            SizedBox(height: 8.h),
                            Divider(
                              thickness: 0.7,
                              color: const Color.fromRGBO(16, 28, 22, 0.1),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showReceiptModal(
                                      context,
                                      data,
                                      customMonth: item["month"],
                                      customAmount: item["amountDisplay"],
                                      customPaidOn: item["date"].replaceAll(
                                        "Paid: ",
                                        "",
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        size: 15.sp,
                                        color: const Color(0xffB8860B),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Receipt & Share",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffB8860B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Receipt Modal ---
  void _showReceiptModal(
    BuildContext context,
    ResidentMmcStatusResModel data, {
    String? customMonth,
    String? customAmount,
    String? customPaidOn,
  }) {
    final billingMonth = customMonth ?? data.data.currentMonth.month.value;
    final amountText =
        customAmount ??
        (data.data.currentMonth.charge.amountDisplay.isNotEmpty
            ? data.data.currentMonth.charge.amountDisplay
            : "${data.data.currentMonth.charge.currency} ${data.data.currentMonth.charge.amount}");
    final paidDateText =
        customPaidOn ??
        (data.data.currentMonth.paidOn.value.isNotEmpty
            ? data.data.currentMonth.paidOn.value
            : "Verified");

    final refCode =
        "REC-${DateTime.now().year}-${billingMonth.replaceAll(' ', '')}";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).padding.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Receipt",
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "STATUS",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF24B06A).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              "PAID & VERIFIED",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF24B06A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const Divider(thickness: 0.8, color: Colors.black12),
                      SizedBox(height: 12.h),
                      _receiptRow("Billing Month", billingMonth),
                      _receiptRow("Amount", amountText),
                      _receiptRow("Paid On", paidDateText),
                      _receiptRow("Payment Method", "Online / Bank Recorded"),
                      _receiptRow("Receipt Reference", refCode),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final shareText =
                              "🧾 PROPERTY MAINTENANCE PAYMENT RECEIPT\n"
                              "---------------------------------------\n"
                              "Status: PAID & VERIFIED\n"
                              "Billing Month: $billingMonth\n"
                              "Amount: $amountText\n"
                              "Paid On: $paidDateText\n"
                              "Payment Method: Online / Bank Recorded\n"
                              "Receipt Reference: $refCode\n"
                              "---------------------------------------\n"
                              "Verified by Property Association Management.";
                          Share.share(shareText);
                        },
                        icon: Icon(
                          Icons.share_rounded,
                          size: 18.sp,
                          color: const Color(0xFF101C16),
                        ),
                        label: Text(
                          "Share Receipt",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF101C16),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: const Color(0xFF101C16),
                            width: 1.2.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          fixedSize: Size(double.infinity, 48.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text:
                                  "🧾 Payment Receipt\nMonth: $billingMonth\nAmount: $amountText\nStatus: PAID & VERIFIED\nReference: $refCode",
                            ),
                          );
                          showSuccessSnackBar("Receipt copied to clipboard!");
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Copy Details",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF101C16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          fixedSize: Size(double.infinity, 48.h),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Close",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Bank Detail Row with Copy ---
  Widget _bankDetailRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xff101C16), width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (canCopy)
              IconButton(
                icon: Icon(
                  Icons.copy,
                  size: 16.sp,
                  color: const Color(0xFFB8860B),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  showSuccessSnackBar("$label copied to clipboard");
                },
              ),
          ],
        ),
      ),
    );
  }

  // --- Receipt Item Row ---
  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

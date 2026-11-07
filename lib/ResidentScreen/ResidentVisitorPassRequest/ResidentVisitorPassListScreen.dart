import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/residentVisitorPassResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentVisitorPassRequest/ResidentVisitorPassRequest.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentVisitorPassRequest/provider/getPassListProvider.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'service/qr_share_service.dart';

class ResidentVisitorPassListScreen extends ConsumerStatefulWidget {
  const ResidentVisitorPassListScreen({super.key});

  @override
  ConsumerState<ResidentVisitorPassListScreen> createState() =>
      _ResidentVisitorPassListScreenState();
}

class _ResidentVisitorPassListScreenState
    extends ConsumerState<ResidentVisitorPassListScreen> {
  String _selectedFilter = "ALL";

  Color _parseColor(String? colorStr, Color fallback) {
    if (colorStr == null || colorStr.isEmpty) return fallback;
    try {
      String hex = colorStr.replaceAll("#", "");
      if (hex.length == 6) hex = "FF$hex";
      return Color(int.parse("0x$hex"));
    } catch (_) {
      return fallback;
    }
  }

  void _showQrPassDialog({
    required String passCode,
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String purpose,
    String? status,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (status ?? "").toUpperCase() == "PENDING" ||
                                  (status ?? "").toUpperCase() == "WAITING"
                              ? "Visitor Gate Pass"
                              : "Pre-Approved Gate Pass",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Share this QR code with your visitor",
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
                      color:
                          (status ?? "").toUpperCase() == "PENDING" ||
                              (status ?? "").toUpperCase() == "WAITING"
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFD4F5E1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      status ?? "APPROVED",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            (status ?? "").toUpperCase() == "PENDING" ||
                                (status ?? "").toUpperCase() == "WAITING"
                            ? const Color(0xFFB8860B)
                            : const Color(0xFF16A765),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8F3),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE5E0D5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: passCode,
                        version: QrVersions.auto,
                        size: 160.w,
                        gapless: false,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.heading,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "PASS CODE: ",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            passCode,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE8B900),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Visitor Name",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          visitorName,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: const Color(0xFFE2E4E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expected Arrival",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          visitTime.isEmpty
                              ? visitDate
                              : "$visitDate · $visitTime",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: const Color(0xFFE2E4E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Purpose",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          purpose,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A765),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          QrShareService.sharePassWithQr(
                            passCode: passCode,
                            visitorName: visitorName,
                            visitDate: visitDate,
                            visitTime: visitTime,
                            purpose: purpose,
                          );
                        },
                        icon: Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        label: Text(
                          "Share Pass With Guest",
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
                    height: 46.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.heading),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        "Done",
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
  }

  void _navigateToCreatePass() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const Residentvisitorpassrequest(),
      ),
    ).then((_) {
      ref.invalidate(getPassListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getPassListProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 38.h,
                width: 38.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF101C16),
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              "Get Pass Visitor List",
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: SizedBox(
              height: 30.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.heading,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _navigateToCreatePass,
                icon: Icon(
                  Icons.add_rounded,
                  size: 17.sp,
                  color: const Color(0xFFE8B900),
                ),
                label: Text(
                  "New Pass",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        color: AppColors.heading,
        onRefresh: () async {
          ref.invalidate(getPassListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Guide Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF101C16), Color(0xFF1C2F25)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 24.sp,
                        color: const Color(0xFFE8B900),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fast Gate Entry via QR Pass",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Share QR pass with guests for instant verification by guard at the gate.",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Filter Row
              state.when(
                data: (data) {
                  final allRequests =
                      (data.data?.visitorPasses != null &&
                          data.data!.visitorPasses!.isNotEmpty)
                      ? data.data!.visitorPasses!
                      : (data.data?.recentRequests?.requests ?? <Request>[]);

                  final filteredList = allRequests.where((req) {
                    if (_selectedFilter == "ALL") return true;
                    final st = (req.status ?? "").toUpperCase();
                    if (_selectedFilter == "APPROVED") {
                      return st == "APPROVED";
                    }
                    if (_selectedFilter == "PENDING") {
                      return st == "PENDING" || st == "WAITING";
                    }
                    if (_selectedFilter == "COMPLETED") {
                      return st == "COMPLETED";
                    }
                    return true;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Passes (${filteredList.length})",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width: 8.w),
                                  _buildFilterChip("ALL", "All"),
                                  SizedBox(width: 6.w),
                                  _buildFilterChip("APPROVED", "Approved"),
                                  SizedBox(width: 6.w),
                                  _buildFilterChip("PENDING", "Pending"),
                                  SizedBox(width: 6.w),
                                  _buildFilterChip("COMPLETED", "Completed"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (filteredList.isEmpty)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 36.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBg,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: const Color(0xff101C16),
                              width: 1.w,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 48.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "No Visitor Passes Found",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Click '+ New Pass' or button below to create your first visitor QR pass.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF777777),
                                ),
                              ),
                              SizedBox(height: 14.h),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.heading,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: _navigateToCreatePass,
                                icon: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Create Pass Now",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return _buildPassItemCard(item);
                          },
                        ),
                    ],
                  );
                },
                error: (err, stack) => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 40.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Failed to load visitor passes",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.heading,
                          ),
                          onPressed: () => ref.invalidate(getPassListProvider),
                          child: Text(
                            "Retry",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.h),
                    child: const CircularProgressIndicator(
                      color: AppColors.heading,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterKey;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.heading : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.heading : const Color(0xff101C16),
            width: 1.w,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  Widget _buildPassItemCard(Request item) {
    final rawCode = item.passCode ?? item.token ?? "";
    final pCode = rawCode.replaceAll('#', '').trim();
    final vName = item.visitorName ?? item.title ?? "Visitor";
    final arr = item.arrivalTime ?? "Today";
    final purpose = item.purpose ?? item.visitorType ?? "Guest Visit";

    final statusUpper = (item.status ?? "").toUpperCase().trim();
    final bool isApproved = statusUpper == "APPROVED";
    final bool isCompleted = statusUpper == "COMPLETED";
    final bool isRejected =
        statusUpper == "REJECTED" || statusUpper == "DENIED";
    final bool isInside = statusUpper == "INSIDE" || statusUpper == "ENTERED";
    final bool isExpired = statusUpper == "EXPIRED";
    final bool isPending =
        statusUpper == "PENDING" ||
        statusUpper == "WAITING" ||
        (!isApproved &&
            !isCompleted &&
            !isRejected &&
            !isInside &&
            !isExpired);

    // Status styling based on status
    final Color statusBg;
    final Color statusColor;

    if (isApproved) {
      statusBg = const Color(0xFFD4F5E1);
      statusColor = _parseColor(item.statusColor, const Color(0xFF16A765));
    } else if (isCompleted) {
      statusBg = const Color(0xFFF3F4F6);
      statusColor = _parseColor(item.statusColor, const Color(0xFF6B7280));
    } else if (isRejected) {
      statusBg = const Color(0xFFFEE2E2);
      statusColor = _parseColor(item.statusColor, const Color(0xFFDC2626));
    } else if (isInside) {
      statusBg = const Color(0xFFE0F2FE);
      statusColor = _parseColor(item.statusColor, const Color(0xFF0284C7));
    } else {
      statusBg = const Color(0xFFFEF3C7);
      statusColor = _parseColor(item.statusColor, const Color(0xFFB8860B));
    }

    return GestureDetector(
      onTap: () {
        if (isExpired) {
          showErrorSnackBar(
            "This pass has expired. Please create a new visitor pass.",
          );
        } else if (pCode.isEmpty && (isApproved || isPending)) {
          showErrorSnackBar("Pass code is not available yet. Please refresh.");
        } else if (isApproved || isPending) {
          _showQrPassDialog(
            passCode: pCode,
            visitorName: vName,
            visitDate: arr,
            visitTime: "",
            purpose: purpose,
            status: item.status,
          );
        } else if (isCompleted) {
          showErrorSnackBar(
            "This visit has already been completed. QR pass is no longer active.",
          );
        } else if (isRejected) {
          showErrorSnackBar(
            "This visitor request was rejected. QR pass is not available.",
          );
        } else if (isInside) {
          showErrorSnackBar(
            "Visitor has already entered the campus using this pass.",
          );
        } else {
          showErrorSnackBar(
            "Pass is pending approval. QR pass will be active once approved.",
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        width: double.infinity,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFFE5E7EB)
                : isRejected
                ? const Color(0xFFFECACA)
                : isApproved
                ? const Color(0xFFBBF7D0)
                : const Color(0xFFE5DEBA),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF6B7280)
                        : isRejected
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF101C16),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_outline_rounded
                        : isRejected
                        ? Icons.cancel_outlined
                        : Icons.qr_code_2_rounded,
                    size: 25.sp,
                    color: isCompleted || isRejected
                        ? Colors.white
                        : const Color(0xFFE8B900),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.subtitle != null && item.subtitle!.isNotEmpty
                            ? item.subtitle!
                            : "${item.visitorType ?? 'Guest'} · $purpose · $arr",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    item.status ?? "PENDING",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // Pass code pill
            if (isApproved || isPending)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isApproved
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isApproved
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFFDE68A),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_rounded,
                      size: 16.sp,
                      color: isApproved
                          ? const Color(0xFF16A765)
                          : const Color(0xFFD97706),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        "Code: $pCode · Tap to View & Share QR",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isApproved
                              ? const Color(0xFF166534)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.heading,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View QR",
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 9.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else if (isCompleted)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 16.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        "Code: $pCode · Visit Completed",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Completed",
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (isRejected)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFFECACA), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: 16.sp,
                      color: const Color(0xFFDC2626),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        "Code: $pCode · Request Rejected",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Declined",
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (isInside)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.meeting_room_outlined,
                      size: 16.sp,
                      color: const Color(0xFF0284C7),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        "Code: $pCode · Visitor Inside Campus",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getPassListResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentGateApproval/provider/gateVisitorApprovalProvider.dart';

class ResidentVisitorApprovalScreen extends ConsumerStatefulWidget {
  const ResidentVisitorApprovalScreen({super.key});

  @override
  ConsumerState<ResidentVisitorApprovalScreen> createState() =>
      _ResidentVisitorApprovalScreenState();
}

class _ResidentVisitorApprovalScreenState
    extends ConsumerState<ResidentVisitorApprovalScreen> {
  int? _respondingVisitorId;
  String? _respondingAction;
  String _selectedFilter = "ALL";

  Future<void> _handleVisitorResponse({
    required int visitorId,
    required String visitorName,
    required String action, // "APPROVED" or "REJECTED"
    String? reason,
  }) async {
    setState(() {
      _respondingVisitorId = visitorId;
      _respondingAction = action;
    });

    try {
      final auth = ref.read(authServiceProvider);
      final res = await auth.respondResidentVisitorData(
        id: visitorId.toString(),
        action: action,
        remarks: reason,
      );

      if (res.status == true) {
        showSuccessSnackBar(
          res.message ??
              (action.toLowerCase() == "approved"
                  ? "Visitor $visitorName approved successfully!"
                  : "Visitor $visitorName entry denied."),
        );
      } else {
        showErrorSnackBar(
          res.message ?? "Could not update the visitor request.",
        );
      }
      ref.invalidate(gateVisitorApprovalProvider);
    } catch (e) {
      // Server ka asli error (jaise "already responded") Dio interceptor dikha deta hai.
      log("Error responding to visitor: $e");
      ref.invalidate(gateVisitorApprovalProvider);
    } finally {
      if (mounted) {
        setState(() {
          _respondingVisitorId = null;
          _respondingAction = null;
        });
      }
    }
  }

  void _showRejectDialog({
    required int visitorId,
    required String visitorName,
  }) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.scaffoldBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.block_rounded,
                  color: const Color(0xFFDC2626),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Deny Entry",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to deny entry to $visitorName?",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: reasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Reason for rejection (optional)",
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    color: const Color(0xFF999999),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Color(0xFFDC2626)),
                  ),
                  contentPadding: EdgeInsets.all(10.r),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF666666),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                final reason = reasonController.text.trim();
                Navigator.pop(context);
                _handleVisitorResponse(
                  visitorId: visitorId,
                  visitorName: visitorName,
                  action: "rejected",
                  reason: reason.isNotEmpty ? reason : null,
                );
              },
              child: Text(
                "Deny Entry",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(gateVisitorApprovalProvider);
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
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF101C16),
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visitor Approvals",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Incoming gate visitor entry requests",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
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
      body: asyncState.when(
        data: (res) {
          final allPasses = res.data?.visitorPasses ?? [];

          final filteredRequests = allPasses.where((r) {
            if (_selectedFilter == "ALL") return true;
            final st = (r.status ?? "").toUpperCase();
            if (_selectedFilter == "PENDING") {
              return st == "PENDING" || st == "WAITING";
            }
            if (_selectedFilter == "APPROVED") {
              return st == "APPROVED" || st == "INSIDE" || st == "ENTERED";
            }
            if (_selectedFilter == "COMPLETED") {
              return st == "COMPLETED";
            }
            return true;
          }).toList();

          final subtitleFlat =
              allPasses.isNotEmpty &&
                  (allPasses.first.flatNumber != null ||
                      allPasses.first.unitNumber != null)
              ? "Flat ${allPasses.first.flatNumber ?? allPasses.first.unitNumber} · Main Gate Desk"
              : "Need to speak with gate guard on duty?";

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              return ref.refresh(gateVisitorApprovalProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),

                  // Gate Desk Banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF16A34A)),
                          ),
                          child: Icon(
                            Icons.security_rounded,
                            color: const Color(0xFF16A34A),
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Security Gate Desk",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                              Text(
                                subtitleFlat,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Filter Row & Section Header
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip("ALL", "All"),
                        SizedBox(width: 5.w),
                        _filterChip("PENDING", "Pending"),
                        SizedBox(width: 5.w),
                        _filterChip("APPROVED", "Approved"),
                        SizedBox(width: 5.w),
                        _filterChip("COMPLETED", "Completed"),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Requests List
                  if (filteredRequests.isEmpty)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
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
                            Icons.verified_user_outlined,
                            size: 48.sp,
                            color: const Color(0xFF16A34A),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No Visitor Requests Found",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "When guard creates a visitor pass for your flat, it will appear here for your approval.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: filteredRequests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildVisitorRequestCard(
                          filteredRequests[index],
                        );
                      },
                    ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
        error: (err, stack) {
          log("Error loading visitor pass: $err");
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Failed to fetch visitor passes",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () =>
                        ref.invalidate(gateVisitorApprovalProvider),
                    child: Text(
                      "Retry",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
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
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.5,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.heading),
            ),
          );
        },
      ),
    );
  }

  Widget _filterChip(String filterKey, String label) {
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
          borderRadius: BorderRadius.circular(20.r),
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

  Widget _buildVisitorRequestCard(VisitorPass item) {
    final int id = item.id ?? 0;
    final String name = item.visitorName ?? "Visitor";
    final String status = (item.status ?? "PENDING").toUpperCase();
    final bool isPending = status == "PENDING" || status == "WAITING";
    final bool isApproved =
        status == "APPROVED" || status == "ENTERED" || status == "INSIDE";
    final bool isCompleted = status == "COMPLETED";
    final bool isRejected = status == "REJECTED" || status == "DENIED";

    final Color statusColor = isPending
        ? const Color(0xFFD97706)
        : isApproved
        ? const Color(0xFF16A34A)
        : isCompleted
        ? const Color(0xFF6B7280)
        : const Color(0xFFDC2626);

    final Color statusBg = isPending
        ? const Color(0xFFFEF3C7)
        : isApproved
        ? const Color(0xFFDCFCE7)
        : isCompleted
        ? const Color(0xFFF3F4F6)
        : const Color(0xFFFEE2E2);

    final bool isThisLoading = _respondingVisitorId == id;

    final String subtitleText =
        item.visitorPhone != null && item.visitorPhone!.isNotEmpty
        ? "${item.visitorPhone} • Unit ${item.unitNumber ?? item.flatNumber ?? ''}"
        : "Unit ${item.unitNumber ?? item.flatNumber ?? 'Entry'}";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPending ? const Color(0xFFF59E0B) : const Color(0xff101C16),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar + Name + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46.h,
                width: 46.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: const Color(0xFF16A34A),
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitleText,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Details Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              children: [
                _detailRow(
                  icon: Icons.category_outlined,
                  label: "Type",
                  value: item.visitorType ?? "Guest",
                ),
                Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                _detailRow(
                  icon: Icons.info_outline,
                  label: "Purpose",
                  value: item.purpose ?? "Visit",
                ),
                if (item.expectedArrival != null &&
                    item.expectedArrival!.isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.access_time_rounded,
                    label: "Expected Arrival",
                    value: item.expectedArrival!,
                  ),
                ],
                if (item.vehicleNumber != null &&
                    item.vehicleNumber!.isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.directions_car_outlined,
                    label: "Vehicle Number",
                    value: item.vehicleNumber!,
                  ),
                ],
                if (item.guardName != null && item.guardName!.isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.shield_outlined,
                    label: "Guard on Duty",
                    value: item.guardPost != null
                        ? "${item.guardName} (${item.guardPost})"
                        : item.guardName!,
                  ),
                ],
                if (item.passCode != null && item.passCode!.isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.confirmation_number_outlined,
                    label: "Pass Code",
                    value: item.passCode!,
                    isHighlight: true,
                  ),
                ],
                if (item.inTime != null &&
                    item.inTime.toString().isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.login_rounded,
                    label: "In Time",
                    value: item.inTime.toString(),
                  ),
                ],
                if (item.outTime != null &&
                    item.outTime.toString().isNotEmpty) ...[
                  Divider(color: const Color(0xFFE5E7EB), height: 12.h),
                  _detailRow(
                    icon: Icons.logout_rounded,
                    label: "Out Time",
                    value: item.outTime.toString(),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Action Buttons
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isThisLoading
                        ? null
                        : () => _showRejectDialog(
                            visitorId: id,
                            visitorName: name,
                          ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        isThisLoading &&
                            _respondingAction?.toLowerCase() == "rejected"
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFDC2626),
                            ),
                          )
                        : Text(
                            "Deny Entry",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isThisLoading
                        ? null
                        : () => _handleVisitorResponse(
                            visitorId: id,
                            visitorName: name,
                            action: "approved",
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        isThisLoading &&
                            _respondingAction?.toLowerCase() == "approved"
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "✓ Approve Entry",
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
          ] else if (isApproved) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF16A34A),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    item.inTime != null
                        ? "Approved · Entry at ${item.inTime}"
                        : "Approved · Gate Entry Permitted",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (isCompleted) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    color: const Color(0xFF6B7280),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    item.outTime != null
                        ? "Completed · Exited at ${item.outTime}"
                        : "Completed · Visit Finished",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (isRejected) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: const Color(0xFFDC2626),
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Denied · Gate Entry Blocked",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15.sp, color: const Color(0xFF6B7280)),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: isHighlight ? const Color(0xFF16A34A) : AppColors.heading,
          ),
        ),
      ],
    );
  }
}

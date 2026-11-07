import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'provider/getDefaulterDetailsProvider.dart';
import 'provider/getDefaulterListProvider.dart';
import 'provider/getOutstandingPendingProvider.dart';
import 'provider/maintenanceChargeStatusProvider.dart';
import 'provider/maintananceChargesProvider.dart';

class DefaultersDetails extends ConsumerStatefulWidget {
  final String id;
  const DefaultersDetails({super.key, required this.id});

  @override
  ConsumerState<DefaultersDetails> createState() => _DefaultersDetailsState();
}

class _DefaultersDetailsState extends ConsumerState<DefaultersDetails> {
  Color _resolveDefaulterBadgeColor({
    String? badgeColorHex,
    String? statusText,
    bool? isDefaulter,
    bool? isOverdueAbove2Months,
  }) {
    if (badgeColorHex != null && badgeColorHex.isNotEmpty) {
      try {
        final hex = badgeColorHex.replaceAll("#", "").trim();
        if (hex.length == 6) {
          return Color(int.parse("FF$hex", radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      } catch (_) {}
    }

    final upper = (statusText ?? "").toUpperCase().trim();
    if (isDefaulter == true ||
        isOverdueAbove2Months == true ||
        upper == "DEFAULTER") {
      return const Color(0xFFEF4444);
    } else if (upper == "CLEARED" || upper == "PAID") {
      return const Color(0xFF22C55E);
    } else if (upper == "REGULAR") {
      return const Color(0xFFEAB308);
    }
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final defaulterDetails = ref.watch(getDefaulterDetailsProvider(widget.id));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 20.sp,
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
                      "DEFAULTER DETAILS",
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
                      "Maintenance Charges / Defaulters",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(42, 41, 51, 0.7),
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
      bottomNavigationBar: _payBar(defaulterDetails.value?.data),
      body: defaulterDetails.when(
        data: (data) {
          final timeline = data.data?.maintenanceHistory?.timeline ?? [];
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: Image.asset(
                                "assets/unit.png",
                                width: 38.w,
                                height: 38.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 38.w,
                                    height: 38.w,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.home_work_outlined,
                                      size: 22.sp,
                                      color: Colors.black54,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data?.unitCard?.unitNumber ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  data.data?.unitCard?.propertyType ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final unitCard = data.data?.unitCard;
                              final statusBadge =
                                  unitCard?.defaulterStatus ??
                                  unitCard?.statusBadge ??
                                  "N/A";
                              final statusColor = _resolveDefaulterBadgeColor(
                                badgeColorHex: unitCard?.badgeColor,
                                statusText: statusBadge,
                                isDefaulter: unitCard?.isDefaulter,
                                isOverdueAbove2Months:
                                    unitCard?.isOverdueAbove2Months,
                              );

                              return InkWell(
                                // onTap: _isTogglingStatus ? null : _toggleStatus,
                                // child: Container(
                                //   padding: EdgeInsets.symmetric(
                                //     horizontal: 12.w,
                                //     vertical: 5.h,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: statusColor.withOpacity(0.08),
                                //     border: Border.all(
                                //       color: statusColor,
                                //       width: 1.w,
                                //     ),
                                //     borderRadius: BorderRadius.circular(20.r),
                                //   ),
                                //   child: Row(
                                //     mainAxisSize: MainAxisSize.min,
                                //     children: [
                                //       if (_isTogglingStatus)
                                //         SizedBox(
                                //           width: 12.w,
                                //           height: 12.w,
                                //           child: CircularProgressIndicator(
                                //             strokeWidth: 1.5,
                                //             color: statusColor,
                                //           ),
                                //         )
                                //       else
                                //         Icon(
                                //           Icons.swap_horiz,
                                //           size: 14.sp,
                                //           color: statusColor,
                                //         ),
                                //       SizedBox(width: 4.w),
                                //       Text(
                                //         statusBadge,
                                //         style: GoogleFonts.outfit(
                                //           fontSize: 13.sp,
                                //           fontWeight: FontWeight.w600,
                                //           color: statusColor,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.08),
                                    border: Border.all(
                                      color: statusColor,
                                      width: 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        statusBadge,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _divider(),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Owner",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  data.data?.unitCard?.propertyOwner ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Due Date",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  data.data?.unitCard?.dueDate ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),
                Text(
                  "Outstanding Amount",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      _buildOutstandingRow(
                        "Total Outstanding",
                        data
                                .data
                                ?.outstandingAmount
                                ?.formattedTotalOutstanding ??
                            "0",
                        isBold: true,
                      ),
                      const Divider(
                        color: Color.fromRGBO(16, 28, 22, 0.2),
                        height: 1,
                      ),
                      SizedBox(height: 12.h),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            data
                                .data
                                ?.outstandingAmount
                                ?.breakdownItems
                                ?.length ??
                            0,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return _buildOutstandingRow(
                            data
                                    .data
                                    ?.outstandingAmount
                                    ?.breakdownItems?[index]
                                    .title ??
                                "N/A",
                            data
                                    .data
                                    ?.outstandingAmount
                                    ?.breakdownItems?[index]
                                    .formattedAmount ??
                                "0",
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),
                Text(
                  "Payment Information",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      _buildPaymentInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label:
                            data
                                .data
                                ?.paymentInformation
                                ?.currentBillingMonth
                                ?.label ??
                            "Current Billing Month",
                        value:
                            data
                                .data
                                ?.paymentInformation
                                ?.currentBillingMonth
                                ?.monthYear ??
                            "N/A",
                        trailingText:
                            data
                                .data
                                ?.paymentInformation
                                ?.currentBillingMonth
                                ?.status ??
                            "Pending",
                      ),
                      _divider(),
                      _buildPaymentInfoItem(
                        icon: Icons.info_outline_rounded,
                        label:
                            data
                                .data
                                ?.paymentInformation
                                ?.overdueSince
                                ?.label ??
                            "Overdue Since",
                        value:
                            data.data?.paymentInformation?.overdueSince?.date ??
                            "N/A",
                        trailingText:
                            data
                                .data
                                ?.paymentInformation
                                ?.overdueSince
                                ?.daysText ??
                            "N/A",
                      ),
                      _divider(),
                      _buildPaymentInfoItem(
                        icon: Icons.warning_amber_rounded,
                        label:
                            data
                                .data
                                ?.paymentInformation
                                ?.lastRecordedPayment
                                ?.label ??
                            "Last Recorded Payment",
                        value:
                            data
                                .data
                                ?.paymentInformation
                                ?.lastRecordedPayment
                                ?.monthYear ??
                            "July 2026",
                        trailingText:
                            data
                                .data
                                ?.paymentInformation
                                ?.lastRecordedPayment
                                ?.formattedAmount ??
                            "0",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maintenance History",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      "ACTIVITY",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      if (timeline.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            "No timeline available",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        ...List.generate(timeline.length, (index) {
                          final item = timeline[index];

                          return _buildTimelineItem(
                            title: item.monthYear ?? "",
                            subtitle: item.description ?? "",
                            amount: item.formattedAmount ?? "",
                            status: item.status ?? "",
                            isFirst: index == 0,
                            isLast: index == timeline.length - 1,
                          );
                        }),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildActionButtons(data.data),
                SizedBox(height: 30.h),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("something went wrong"));
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: const Color.fromRGBO(16, 28, 22, 0.15),
    );
  }

  Widget _buildOutstandingRow(
    String label,
    String amount, {
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: isBold ? 16.sp : 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.outfit(
              fontSize: isBold ? 18.sp : 15.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: const Color(0xFFC18A00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required String trailingText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.heading, width: 1.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Icon(icon, size: 18.sp, color: AppColors.heading),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailingText,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required bool isFirst,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 242, 165, 0.8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC18A00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5.w,
                    color: const Color(0xFFC18A00).withOpacity(0.5),
                  ),
                ),
            ],
          ),

          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        amount,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == "paid"
                              ? Colors.green.withOpacity(0.12)
                              : Colors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: status.toLowerCase() == "paid"
                                ? const Color(0xFF1E7E34)
                                : const Color(0xFFD35400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSendingReminder = false;
  bool _isTogglingStatus = false;

  Future<void> _sendReminder(dynamic data) async {
    setState(() => _isSendingReminder = true);
    try {
      final res = await ref
          .read(authServiceProvider)
          .sendDefaulterReminder(id: widget.id);
      String msg = "Payment reminder sent successfully!";
      if (res is Map && res['message'] != null) {
        msg = res['message'].toString();
      }
      showSuccessSnackBar(msg);
    } catch (e) {
      showErrorSnackBar("Failed to send reminder: $e");
    } finally {
      if (mounted) setState(() => _isSendingReminder = false);
    }
  }

  Future<void> _toggleStatus() async {
    setState(() => _isTogglingStatus = true);
    try {
      final res = await ref
          .read(authServiceProvider)
          .toggleDefaulterStatus(id: widget.id);
      String msg = "Status toggled successfully!";
      if (res is Map && res['message'] != null) {
        msg = res['message'].toString();
      }
      ref.invalidate(getDefaulterDetailsProvider(widget.id));
      showSuccessSnackBar(msg);
    } catch (e) {
      // showErrorSnackBar("Failed to toggle status: $e");
    } finally {
      if (mounted) setState(() => _isTogglingStatus = false);
    }
  }

  Widget _buildActionButtons(dynamic data) {
    final statusBadge =
        data?.unitCard?.defaulterStatus ??
        data?.unitCard?.statusBadge ??
        "Defaulter";

    final isPaid = statusBadge.trim().toLowerCase() == "paid";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Management Actions",
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            // Expanded(
            //   child: SizedBox(
            //     height: 52.h,
            //     child: OutlinedButton(
            //       onPressed: _isSendingReminder
            //           ? null
            //           : () => _sendReminder(data),
            //       style: OutlinedButton.styleFrom(
            //         side: BorderSide(color: AppColors.heading, width: 1.2),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8.r),
            //         ),
            //         backgroundColor: Colors.white,
            //       ),
            //       child: _isSendingReminder
            //           ? SizedBox(
            //               width: 20.w,
            //               height: 20.w,
            //               child: const CircularProgressIndicator(
            //                 color: Color(0xFF101C16),
            //                 strokeWidth: 2,
            //               ),
            //             )
            //           : Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   Icons.notifications_active_outlined,
            //                   size: 20.sp,
            //                   color: AppColors.heading,
            //                 ),
            //                 SizedBox(width: 6.w),
            //                 Text(
            //                   "Send Reminder",
            //                   style: GoogleFonts.outfit(
            //                     fontSize: 16.sp,
            //                     fontWeight: FontWeight.w600,
            //                     color: AppColors.heading,
            //                     letterSpacing: -0.39,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: OutlinedButton(
                  onPressed: (_isSendingReminder || isPaid)
                      ? null
                      : () => _sendReminder(data),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isPaid ? Colors.grey : AppColors.heading,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    backgroundColor: isPaid
                        ? Colors.grey.shade200
                        : Colors.white,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: _isSendingReminder
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Color(0xFF101C16),
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 20.sp,
                              color: isPaid ? Colors.grey : AppColors.heading,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Send Reminder",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isPaid ? Colors.grey : AppColors.heading,
                                letterSpacing: -0.39,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => _showRecordPaymentModal(context, data),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Receive Pay",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.39,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // SizedBox(height: 12.h),
        // SizedBox(
        //   width: double.infinity,
        //   height: 48.h,
        //   child: OutlinedButton.icon(
        //     onPressed: _isTogglingStatus ? null : _toggleStatus,
        //     icon: _isTogglingStatus
        //         ? SizedBox(
        //             width: 18.w,
        //             height: 18.w,
        //             child: const CircularProgressIndicator(
        //               strokeWidth: 2,
        //               color: Color(0xFF101C16),
        //             ),
        //           )
        //         : Icon(Icons.swap_horiz, size: 20.sp, color: AppColors.heading),
        //     label: Text(
        //       "Toggle Defaulter Status ($statusBadge)",
        //       style: GoogleFonts.outfit(
        //         fontSize: 14.sp,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.heading,
        //         letterSpacing: -0.39,
        //       ),
        //     ),
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(
        //         color: Color.fromRGBO(16, 28, 22, 0.3),
        //         width: 1.2,
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8.r),
        //       ),
        //       backgroundColor: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  /// Hamesha dikhne wala "Receive Payment" button (scroll karke dhoondhna nahi padta).
  Widget? _payBar(dynamic data) {
    if (data == null) return null;
    final num balance = data.unitCard?.balanceAmount ?? 1;
    final bool settled = balance <= 0;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
        child: SizedBox(
          height: 52.h,
          child: ElevatedButton.icon(
            onPressed: settled ? null : () => _showRecordPaymentModal(context, data),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.heading,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            icon: Icon(Icons.payments_outlined, color: Colors.white, size: 20.sp),
            label: Text(
              settled
                  ? "Fully Paid"
                  : "Receive Payment (Full / Partial)",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bill / Paid / Pending ek nazar me (partial payment ke liye).
  Widget _paymentSummary(dynamic data) {
    final u = data?.unitCard;
    Widget cell(String label, String? value, Color color) => Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.black54),
          ),
          SizedBox(height: 2.h),
          Text(
            value ?? "-",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color.fromRGBO(16, 28, 22, 0.2)),
      ),
      child: Row(
        children: [
          cell("Bill", u?.formattedBillAmount, AppColors.heading),
          cell("Received", u?.formattedPaidAmount, const Color(0xFF16A765)),
          cell("Pending", u?.formattedBalanceAmount, const Color(0xFFD97706)),
        ],
      ),
    );
  }

  void _showRecordPaymentModal(BuildContext context, dynamic data) {
    String paidVia = 'UPI (Google Pay)';
    final methods = [
      'UPI (Google Pay)',
      'Cash',
      'Cheque',
      'Bank Transfer',
      'UPI (PhonePe)',
      'UPI (Paytm)',
    ];

    final now = DateTime.now();
    String paymentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final num balance =
        data?.unitCard?.balanceAmount ??
        num.tryParse(
          (data?.outstandingAmount?.formattedTotalOutstanding?.toString() ?? '')
              .replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0;
    final String rawAmount = balance > 0 ? balance.toString() : '';

    final amountController = TextEditingController(text: rawAmount);
    final notesController = TextEditingController(
      text: "Received payment via online transfer",
    );
    final dateController = TextEditingController(text: paymentDate);
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 25.h,
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
                          "Receive Maintenance Pay",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
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
                    SizedBox(height: 6.h),
                    Text(
                      "Unit: ${data?.unitCard?.unitNumber ?? ''} · Due: ${data?.outstandingAmount?.formattedTotalOutstanding ?? ''}",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Paid Via (Payment Method)",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: methods.map((m) {
                        final isSel = paidVia == m;
                        return ChoiceChip(
                          label: Text(
                            m,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: isSel
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSel ? Colors.white : Colors.black87,
                            ),
                          ),
                          selected: isSel,
                          selectedColor: const Color(0xFF101C16),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: isSel
                                  ? const Color(0xFF101C16)
                                  : Colors.black26,
                            ),
                          ),
                          onSelected: (val) {
                            if (val) setModalState(() => paidVia = m);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 14.h),
                    _paymentSummary(data),
                    SizedBox(height: 14.h),
                    Text(
                      "Amount Received",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    if (balance > 0)
                      Wrap(
                        spacing: 8.w,
                        children: [
                          ActionChip(
                            label: Text("Full ₹${balance.toStringAsFixed(0)}"),
                            onPressed: () => setModalState(
                              () => amountController.text = balance.toString(),
                            ),
                          ),
                          ActionChip(
                            label: const Text("Half"),
                            onPressed: () => setModalState(
                              () => amountController.text = (balance / 2)
                                  .toStringAsFixed(0),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          size: 22.sp,
                          color: AppColors.heading,
                        ),
                        hintText: "e.g. 4250",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Payment Date (yyyy-MM-dd)",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          final formattedDate =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                          setModalState(() {
                            paymentDate = formattedDate;
                            dateController.text = formattedDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 22.sp,
                          color: AppColors.heading,
                        ),
                        hintText: "Select payment date",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Payment Notes",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g. Received payment via online transfer",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF101C16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                final amt = amountController.text.trim();
                                final parsed = num.tryParse(amt);
                                if (parsed == null || parsed <= 0) {
                                  showErrorSnackBar(
                                    "Please enter a valid received amount",
                                  );
                                  return;
                                }
                                if (balance > 0 && parsed > balance) {
                                  showErrorSnackBar(
                                    "Amount cannot be more than the pending ₹${balance.toStringAsFixed(0)}",
                                  );
                                  return;
                                }
                                setModalState(() => isSubmitting = true);
                                try {
                                  final res = await ref
                                      .read(authServiceProvider)
                                      .receiveDefaulterPay(
                                        id: widget.id,
                                        amount: amt,
                                        paidVia: paidVia,
                                        paymentDate: dateController.text.trim(),
                                        notes: notesController.text.trim(),
                                      );
                                  ref.invalidate(
                                    getDefaulterDetailsProvider(widget.id),
                                  );
                                  // Baaki screens ki lists bhi refresh (paid / partial / pending turant dikhe)
                                  ref.invalidate(getDefaulterListProvider);
                                  ref.invalidate(getOutstandingPendingProvider);
                                  ref.invalidate(maintenanceChargeStatusProvider);
                                  ref.invalidate(maintenanceChargesProvider);
                                  String msg =
                                      "Payment received and recorded successfully";
                                  if (res is Map && res['message'] != null) {
                                    msg = res['message'].toString();
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    showSuccessSnackBar(msg);
                                  }
                                } catch (e) {
                                  setModalState(() => isSubmitting = false);
                                  showErrorSnackBar(
                                    "Failed to record payment: $e",
                                  );
                                }
                              },
                        child: isSubmitting
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                (balance > 0 &&
                                        (num.tryParse(amountController.text) ??
                                                0) <
                                            balance)
                                    ? "Record Partial Payment"
                                    : "Submit Payment Record",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
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
      },
    );
  }
}

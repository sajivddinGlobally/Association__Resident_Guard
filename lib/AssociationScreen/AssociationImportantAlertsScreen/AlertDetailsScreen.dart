import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getAlertModel.dart';

class AlertDetailsScreen extends StatefulWidget {
  final Alert alert;

  const AlertDetailsScreen({super.key, required this.alert});

  @override
  State<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  bool isAcknowledged = false;

  Color _hexToColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.isEmpty) return defaultColor;
    try {
      final hex = hexString.replaceAll('#', '').trim();
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return defaultColor;
  }

  IconData _getIconData(String? iconType) {
    switch (iconType?.toLowerCase()) {
      case 'wrench':
      case 'plumbing':
      case 'tools':
        return Icons.build_outlined;
      case 'alert_triangle':
      case 'warning':
      case 'complaint':
        return Icons.warning_amber_rounded;
      case 'clock':
      case 'time':
      case 'pending':
        return Icons.access_time_rounded;
      case 'check':
      case 'done':
        return Icons.check_circle_outline;
      case 'security':
      case 'shield':
        return Icons.shield_outlined;
      case 'water':
        return Icons.water_drop_outlined;
      case 'power':
      case 'electricity':
        return Icons.bolt_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  void _copyAlertDetails() {
    final alert = widget.alert;
    final text =
        '''
ALERT: ${alert.title ?? 'Alert'}
Category: ${alert.category ?? 'General'}
Reported: ${alert.timeAgo ?? 'Recent'}
Location: ${alert.locationInfo ?? 'General Area'}
Details: ${alert.subtitle ?? 'No additional details provided.'}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.heading,
        content: Text(
          "Alert details copied to clipboard",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alert = widget.alert;
    final isUrgent =
        (alert.isUrgent ?? false) || alert.cardType == "urgent_hero";
    final iconData = _getIconData(alert.iconType);
    final iconBgColor = _hexToColor(
      alert.iconBg,
      isUrgent ? const Color(0xffB8860B) : const Color(0xFFFFF8D9),
    );
    final iconColor = _hexToColor(
      alert.iconColor,
      isUrgent ? Colors.white : const Color(0xFFD99B00),
    );

    final badgeData = alert.badge;
    final badgeText =
        alert.badgeText ??
        badgeData?.text ??
        (isUrgent ? "URGENT ALERT" : "NOTICE");

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
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
                    "Alert Details",
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
                    alert.category?.toUpperCase() ?? "ASSOCIATION ALERT",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   onTap: _copyAlertDetails,
            //   child: Container(
            //     padding: EdgeInsets.all(10.w),
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: const Color.fromRGBO(16, 28, 22, 0.3),
            //       ),
            //       borderRadius: BorderRadius.circular(6.r),
            //     ),
            //     child: Icon(
            //       Icons.share_outlined,
            //       color: AppColors.heading,
            //       size: 20.sp,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Status Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: isUrgent
                    ? const Color(0xff0C1C16)
                    : AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xff101C16),
                  width: 1.2.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: isUrgent
                              ? const Color(0xffB8860B)
                              : const Color.fromRGBO(184, 134, 11, 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: isUrgent
                              ? null
                              : Border.all(
                                  color: const Color(0xffB8860B),
                                  width: 1.w,
                                ),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: isUrgent
                                ? Colors.white
                                : const Color(0xffB8860B),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 15.sp,
                            color: isUrgent
                                ? Colors.white70
                                : const Color(0xff777777),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            alert.timeAgo ?? "Just now",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: isUrgent
                                  ? Colors.white70
                                  : const Color(0xff777777),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(iconData, color: iconColor, size: 22.sp),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title ?? "Alert Notice",
                              style: GoogleFonts.outfit(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w700,
                                color: isUrgent
                                    ? Colors.white
                                    : AppColors.heading,
                                letterSpacing: -0.3,
                                height: 1.25,
                              ),
                            ),
                            if (alert.id != null && alert.id!.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                "ID: ${alert.id}",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isUrgent
                                      ? Colors.white60
                                      : const Color(0xff888888),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Description / Briefing Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xff101C16), width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 19.sp,
                        color: AppColors.heading,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Alert Briefing",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    alert.subtitle != null && alert.subtitle!.isNotEmpty
                        ? alert.subtitle!
                        : "No detailed briefing has been provided for this alert. Please monitor association updates and maintenance logs for ongoing status.",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff333333),
                      height: 1.45,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Location & Target Information Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xff101C16), width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 19.sp,
                        color: AppColors.heading,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Affected Location",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(16, 28, 22, 0.05),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.apartment_rounded,
                          size: 20.sp,
                          color: AppColors.heading,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            alert.locationInfo != null &&
                                    alert.locationInfo!.isNotEmpty
                                ? alert.locationInfo!
                                : "Entire Property / Main Premises",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Impact & Status Details Grid
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xff101C16), width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alert Information",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _infoRow(
                    "Priority Level",
                    isUrgent ? "High / Urgent" : "Normal / Standard",
                    valueColor: isUrgent
                        ? const Color(0xffDC2626)
                        : const Color(0xff16A34A),
                  ),
                  Divider(
                    height: 18.h,
                    color: const Color.fromRGBO(16, 28, 22, 0.1),
                  ),
                  _infoRow(
                    "Category",
                    (alert.category ?? "General").toUpperCase(),
                  ),
                  Divider(
                    height: 18.h,
                    color: const Color.fromRGBO(16, 28, 22, 0.1),
                  ),
                  _infoRow("Broadcast Status", "Active to All Residents"),
                  Divider(
                    height: 18.h,
                    color: const Color.fromRGBO(16, 28, 22, 0.1),
                  ),
                  _infoRow("Reported Time", alert.timeAgo ?? "Recent"),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Action Buttons
            // SizedBox(
            //   width: double.infinity,
            //   height: 48.h,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: isAcknowledged
            //           ? const Color(0xff16A34A)
            //           : AppColors.heading,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.r),
            //       ),
            //       elevation: 0,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         isAcknowledged = !isAcknowledged;
            //       });
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           backgroundColor: AppColors.heading,
            //           content: Text(
            //             isAcknowledged
            //                 ? "Alert marked as Acknowledged"
            //                 : "Alert marked as Unacknowledged",
            //             style: GoogleFonts.outfit(
            //               color: Colors.white,
            //               fontSize: 14.sp,
            //             ),
            //           ),
            //           duration: const Duration(seconds: 2),
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       isAcknowledged
            //           ? Icons.check_circle_outline
            //           : Icons.done_all_rounded,
            //       color: Colors.white,
            //       size: 18.sp,
            //     ),
            //     label: Text(
            //       isAcknowledged ? "Alert Acknowledged" : "Acknowledge Alert",
            //       style: GoogleFonts.outfit(
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white,
            //         letterSpacing: -0.2,
            //       ),
            //     ),
            //   ),
            // ),

            // SizedBox(height: 12.h),

            // SizedBox(
            //   width: double.infinity,
            //   height: 48.h,
            //   child: OutlinedButton.icon(
            //     style: OutlinedButton.styleFrom(
            //       backgroundColor: AppColors.scaffoldBg,
            //       side: BorderSide(color: AppColors.heading, width: 1.2.w),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.r),
            //       ),
            //     ),
            //     onPressed: () {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           backgroundColor: AppColors.heading,
            //           content: Text(
            //             "Broadcast reminder sent to relevant residents",
            //             style: GoogleFonts.outfit(
            //               color: Colors.white,
            //               fontSize: 14.sp,
            //             ),
            //           ),
            //           duration: const Duration(seconds: 2),
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.campaign_outlined,
            //       color: AppColors.heading,
            //       size: 20.sp,
            //     ),
            //     label: Text(
            //       "Broadcast to Residents",
            //       style: GoogleFonts.outfit(
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.w600,
            //         color: AppColors.heading,
            //         letterSpacing: -0.2,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff666666),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.heading,
          ),
        ),
      ],
    );
  }
}

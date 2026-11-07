import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationImportantAlertsScreen/AlertDetailsScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationImportantAlertsScreen/provider/getAlertsProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getAlertModel.dart';

class Importantalertsscreen extends ConsumerStatefulWidget {
  const Importantalertsscreen({super.key});

  @override
  ConsumerState<Importantalertsscreen> createState() =>
      _ImportantalertsscreenState();
}

class _ImportantalertsscreenState extends ConsumerState<Importantalertsscreen> {
  int selectedFilter = 0;

  final List<String> filters = [
    "All Alerts",
    "Urgent",
    "Maintenance",
    "Service",
  ];

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
      default:
        return Icons.notifications_none_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAlertState = ref.watch(
      getAlertsProvider(filters[selectedFilter].toLowerCase()),
    );
    final header = getAlertState.valueOrNull?.data?.header;

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
                      header?.title ?? "Important Alerts",
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
                      header?.subtitle ??
                          "Residential/Commercial management team Management",
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
      body: getAlertState.when(
        data: (data) {
          final alertOverview = data.data?.alertOverview;
          final alertsSection = data.data?.alertsSection;
          final alerts = data.data?.alerts ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                getAlertsProvider(filters[selectedFilter].toLowerCase()),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    // Alert Overview Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFCEF),
                        border: Border.all(
                          color: const Color(0xff111111),
                          width: 1.3,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Alert Overview",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffB8860B),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  alertOverview?.badge ?? "Alert Overview",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alertOverview?.title ??
                                          "Important Alerts",
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      alertOverview?.description ??
                                          "Attention required across the Residential/Commercial management team",
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
                            ],
                          ),
                          SizedBox(height: 14.h),
                          const Divider(
                            color: Color.fromRGBO(16, 28, 22, 0.2),
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              _alertItem(
                                alertOverview?.metrics?.urgent?.count ?? "0",
                                alertOverview?.metrics?.urgent?.label ??
                                    "Urgent",
                                isHighlighted:
                                    alertOverview
                                        ?.metrics
                                        ?.urgent
                                        ?.isHighlighted ??
                                    true,
                              ),
                              _alertItem(
                                alertOverview?.metrics?.unread?.count ?? "0",
                                alertOverview?.metrics?.unread?.label ??
                                    "Unread",
                                isHighlighted:
                                    alertOverview
                                        ?.metrics
                                        ?.unread
                                        ?.isHighlighted ??
                                    true,
                              ),
                              _alertItem(
                                alertOverview?.metrics?.general?.count ?? "0",
                                alertOverview?.metrics?.general?.label ??
                                    "General",
                                isHighlighted:
                                    alertOverview
                                        ?.metrics
                                        ?.general
                                        ?.isHighlighted ??
                                    false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    // Alerts Section Title & Quick Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          alertsSection?.title ?? "Alerts",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          alertsSection?.quickAction?.label ?? "MARK ALL READ",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(filters.length, (index) {
                          final isSelected = selectedFilter == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF0C1B15)
                                      : const Color(0xFFFFFCEB),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  filters[index],
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Alerts List
                    if (alerts.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Center(
                          child: Text(
                            "No alerts found",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff777777),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          final alert = alerts[index];
                          if (alert.cardType == "urgent_hero" ||
                              (alert.isUrgent ?? false)) {
                            return _buildUrgentHeroCard(alert);
                          } else {
                            return _buildStandardCard(alert);
                          }
                        },
                      ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _alertItem(String number, String title, {bool isHighlighted = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: isHighlighted
                  ? const Color(0xff101C16)
                  : const Color(0xff292832),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentHeroCard(Alert alert) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AlertDetailsScreen(alert: alert),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(18.w),
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xff0C1C16),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(184, 134, 11, 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.circle,
                    size: 7.sp,
                    color: const Color(0xffB8860B),
                  ),
                ),
                SizedBox(width: 7.w),
                Text(
                  alert.badgeText ?? "URGENT ALERT",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Text(
                  alert.timeAgo ?? "",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              alert.title ?? "",
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
            if (alert.subtitle != null && alert.subtitle!.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                alert.subtitle!,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffD0D8D4),
                  letterSpacing: -0.2,
                ),
              ),
            ],
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    alert.locationInfo ?? "",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (alert.actionLink?.label != null &&
                    alert.actionLink!.label!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffB8860B),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      alert.actionLink!.label!,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardCard(Alert alert) {
    final iconBgColor = _hexToColor(alert.iconBg, const Color(0xFFFFF8D9));
    final iconColor = _hexToColor(alert.iconColor, const Color(0xFFD99B00));
    final iconData = _getIconData(alert.iconType);

    final badgeData = alert.badge;
    final isOutline = (badgeData?.type?.toLowerCase() == 'outline');
    final badgeBorderColor = _hexToColor(
      badgeData?.borderColor,
      const Color(0xff1E5993),
    );
    final badgeBgColor = _hexToColor(
      badgeData?.bgColor,
      const Color(0xFFE0F2FE),
    );
    final badgeTextColor = _hexToColor(
      badgeData?.textColor,
      isOutline ? const Color(0xFF1261A0) : const Color(0xFF101C16),
    );

    final actionLabel = (alert.actionLink?.label ?? "VIEW DETAILS")
        .replaceAll('→', '')
        .trim();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AlertDetailsScreen(alert: alert),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF0),
          border: Border.all(color: const Color(0xFF101C16), width: 1.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(iconData, color: iconColor, size: 20.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (alert.subtitle != null &&
                          alert.subtitle!.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          alert.subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.75),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  alert.timeAgo ?? "",
                  maxLines: 1,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color.fromRGBO(16, 28, 22, 0.15),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (badgeData?.text != null && badgeData!.text!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isOutline ? Colors.transparent : badgeBgColor,
                      border: isOutline
                          ? Border.all(color: badgeBorderColor, width: 1)
                          : null,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      badgeData.text!,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: badgeTextColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  actionLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(
                  Icons.arrow_forward,
                  size: 16.sp,
                  color: const Color(0xFF101C16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/GetNotificaionListModel.dart'
    as notif_model
    show Notification;

import 'provider/getNotificationProvider.dart';
import 'provider/markNotificationReadProvider.dart';

class Notification extends ConsumerStatefulWidget {
  const Notification({super.key});

  @override
  ConsumerState<Notification> createState() => _NotificationState();
}

class _NotificationState extends ConsumerState<Notification> {
  int selectedFilter = 0;
  final Set<String> _readRequestedIds = {};

  final List<String> defaultFilters = [
    "All",
    "Maintenance",
    "Inspections",
    "Complaints",
    "Services",
  ];

  IconData _getNotificationIcon(String? iconType) {
    switch (iconType?.toLowerCase()) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'check':
        return Icons.check;
      case 'alert':
        return Icons.notifications_active_outlined;
      case 'document':
        return Icons.description_outlined;
      case 'inspection':
        return Icons.fact_check_outlined;
      case 'service':
        return Icons.build_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Future<void> markNotificationsRead(
    List<notif_model.Notification> notifications,
  ) async {
    final unreadIds = notifications
        .where((item) => item.isRead != true && item.id != null)
        .map((item) => item.id.toString())
        .where((id) => !_readRequestedIds.contains(id))
        .toSet()
        .toList();

    if (unreadIds.isEmpty) return;
    _readRequestedIds.addAll(unreadIds);

    try {
      await ref.read(markMultipleNotificationsReadProvider(unreadIds).future);
    } catch (e) {
      debugPrint("Mark notifications read error: $e");
    }
  }

  void _onNotificationTap(notif_model.Notification item) async {
    final idStr = item.id?.toString();
    if (idStr != null &&
        item.isRead != true &&
        !_readRequestedIds.contains(idStr)) {
      _readRequestedIds.add(idStr);
      try {
        await ref
            .read(authServiceProvider)
            .markMultipleNotificationsRead(ids: [idStr]);
      } catch (e) {
        log("Error marking notification $idStr as read: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final getNotificaionState = ref.watch(
      getNotificaionListProvider(defaultFilters[selectedFilter]),
    );

    final apiData = getNotificaionState.valueOrNull?.data;
    final header = apiData?.header;
    final filters = (apiData?.filters != null && apiData!.filters!.isNotEmpty)
        ? apiData.filters!
        : defaultFilters;

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header?.title ?? "Notifications",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    header?.subtitle ?? "Stay updated with your property",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filters.length, (index) {
                  final bool isSelected = selectedFilter == index;

                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          vertical: 7.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff101C16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          filters[index],
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: getNotificaionState.when(
                data: (data) {
                  final resData = data.data;
                  final sections = resData?.sections ?? [];
                  final allNotifications = resData?.notifications ?? [];
                  final List<notif_model.Notification> allItems = [
                    ...allNotifications,
                    for (final sec in sections) ...?sec.items,
                  ];

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      markNotificationsRead(allItems);
                    }
                  });

                  if (sections.isNotEmpty) {
                    final validSections = <Widget>[];

                    for (final section in sections) {
                      final items = section.items ?? [];

                      if (items.isEmpty) continue;

                      validSections.add(
                        Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: Row(
                            children: [
                              Text(
                                section.title ?? "Recent",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const Spacer(),
                              if (section.badge != null &&
                                  section.badge!.isNotEmpty)
                                Text(
                                  section.badge!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );

                      for (final item in items) {
                        validSections.add(_buildNotificationCard(item));
                      }

                      validSections.add(SizedBox(height: 10.h));
                    }

                    if (validSections.isEmpty) {
                      return Center(
                        child: Text(
                          "No notifications found",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.heading,
                      onRefresh: () async {
                        ref.invalidate(getNotificaionListProvider);
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: validSections,
                      ),
                    );
                  }

                  if (allNotifications.isEmpty) {
                    return Center(
                      child: Text(
                        "No notifications found",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.heading,
                    onRefresh: () async {
                      ref.invalidate(getNotificaionListProvider);
                    },
                    child: ListView.builder(
                      itemCount: allNotifications.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(allNotifications[index]);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 40.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Failed to load notifications",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(getNotificaionListProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.heading,
                          ),
                          child: Text(
                            "Retry",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.heading),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseBadgeColor(
    String? color, {
    Color defaultColor = const Color(0xFFEF4444),
  }) {
    if (color == null || color.isEmpty) {
      return defaultColor;
    }
    try {
      final hex = color.replaceAll("#", "").trim();
      if (hex.length == 6) {
        return Color(int.parse("FF$hex", radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return defaultColor;
    } catch (_) {
      return defaultColor;
    }
  }

  Widget _buildNotificationCard(notif_model.Notification item) {
    final bool isOverdue = item.isOverdue == true ||
        (item.redTag != null && item.redTag!.trim().isNotEmpty);

    final Color overdueColor = _parseBadgeColor(
      item.tagColor ?? item.badgeColor,
      defaultColor: const Color(0xFFEF4444),
    );

    final String headingBadgeText = (item.headingReminderTag != null &&
            item.headingReminderTag!.trim().isNotEmpty)
        ? item.headingReminderTag!.trim()
        : (item.redTag != null && item.redTag!.trim().isNotEmpty)
            ? item.redTag!.trim()
            : "OVERDUE REMINDER";

    return GestureDetector(
      onTap: () => _onNotificationTap(item),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isOverdue ? overdueColor.withOpacity(0.04) : Colors.transparent,
          border: Border.all(
            color: isOverdue
                ? overdueColor.withOpacity(0.5)
                : const Color(0xff101010),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isOverdue)
                Container(
                  width: 5.w,
                  decoration: BoxDecoration(
                    color: overdueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7.r),
                      bottomLeft: Radius.circular(7.r),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 46.w,
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: isOverdue
                              ? overdueColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                            color: isOverdue
                                ? overdueColor
                                : const Color(0xff101010),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Icon(
                            _getNotificationIcon(item.iconType),
                            color: isOverdue ? overdueColor : AppColors.heading,
                            size: 22.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 6.w,
                                    runSpacing: 4.h,
                                    children: [
                                      Text(
                                        item.title ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      if (isOverdue)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 7.w,
                                            vertical: 2.5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: overdueColor,
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            headingBadgeText.toUpperCase(),
                                            style: GoogleFonts.outfit(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  item.time ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromRGBO(42, 41, 51, 0.75),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              item.message ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 0.75),
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isOverdue
                                    ? overdueColor.withOpacity(0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isOverdue
                                      ? overdueColor
                                      : const Color(0xff101010),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                isOverdue
                                    ? (item.redTag ?? item.tag ?? "Overdue Reminder")
                                    : (item.tag ?? "General"),
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isOverdue
                                      ? overdueColor
                                      : const Color(0xff101010),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

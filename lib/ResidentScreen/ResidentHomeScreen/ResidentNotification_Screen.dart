import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationNotification/provider/markNotificationReadProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/GetNotificaionListModel.dart'
    as notif_model;
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/provider/residentDashboardProvider.dart';

import '../../AssociationScreen/AssociationNotification/provider/getNotificationProvider.dart';

class ResidentnotificationScreen extends ConsumerStatefulWidget {
  const ResidentnotificationScreen({super.key});

  @override
  ConsumerState<ResidentnotificationScreen> createState() =>
      _ResidentnotificationScreenState();
}

class _ResidentnotificationScreenState
    extends ConsumerState<ResidentnotificationScreen> {
  int selectedFilter = 0;

  final List<String> defaultFilters = [
    "All",
    "Issues",
    "Maintenance",
    "Association",
    "Important",
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

  final Set<String> _readRequestedIds = {};

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
      ref.invalidate(residentDashboardProvider);
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
        ref.invalidate(getNotificaionListProvider);
        ref.invalidate(residentDashboardProvider);
        if (mounted) setState(() {});
      } catch (e) {
        debugPrint("Error marking notification $idStr as read: $e");
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  final resData = getNotificaionState.valueOrNull?.data;
                  final sections = resData?.sections ?? [];
                  final allNotifications = resData?.notifications ?? [];
                  final List<notif_model.Notification> allItems = [
                    ...allNotifications,
                    for (final sec in sections) ...?sec.items,
                  ];
                  final unread = allItems
                      .where((n) => n.isRead != true && n.id != null)
                      .map((n) => n.id.toString())
                      .where((id) => !_readRequestedIds.contains(id))
                      .toSet()
                      .toList();
                  if (unread.isNotEmpty) {
                    _readRequestedIds.addAll(unread);
                    await ref
                        .read(authServiceProvider)
                        .markMultipleNotificationsRead(ids: unread);
                    ref.invalidate(getNotificaionListProvider);
                    ref.invalidate(residentDashboardProvider);
                    if (mounted) {
                      showSuccessSnackBar("All notifications marked as read");
                      setState(() {});
                    }
                  } else {
                    if (mounted) {
                      showSuccessSnackBar("All notifications are already read");
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.done_all_rounded,
                        size: 16.sp,
                        color: AppColors.heading,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Mark all",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(defaultFilters.length, (index) {
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
                          defaultFilters[index],
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
                                  fontWeight: FontWeight.w600,
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
                                    fontSize: 13.sp,
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
                            fontSize: 16.sp,
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
                          fontSize: 16.sp,
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
                            fontSize: 17.sp,
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
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
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

  Widget _buildNotificationCard(notif_model.Notification item) {
    final bool isUnread =
        (item.isRead != true) &&
        !_readRequestedIds.contains(item.id?.toString());

    return GestureDetector(
      onTap: () => _onNotificationTap(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFFBF8E6) : Colors.transparent,
          border: Border.all(
            color: isUnread ? const Color(0xff101010) : const Color(0xFFE5DEBA),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                color: isUnread ? const Color(0xFF101C16) : Colors.transparent,
                border: Border.all(color: const Color(0xff101010), width: 1.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: Icon(
                  _getNotificationIcon(item.iconType),
                  color: isUnread ? Colors.white : AppColors.heading,
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
                      if (isUnread) ...[
                        Container(
                          width: 7.w,
                          height: 7.w,
                          margin: EdgeInsets.only(right: 6.w, top: 5.h),
                          decoration: const BoxDecoration(
                            color: Color(0xffD5A52C),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          item.title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.time ?? "",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.75),
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
                      border: Border.all(color: const Color(0xff101010)),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Text(
                      item.tag ?? "General",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff101010),
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
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/residentAnnouncementResModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentAnnouncementScreen/provider/residentAnnouncementProvider.dart';
import 'ResidentAnnouncementDetailScreen.dart';

class ResidentAnnouncementScreen extends ConsumerStatefulWidget {
  const ResidentAnnouncementScreen({super.key});

  @override
  ConsumerState<ResidentAnnouncementScreen> createState() =>
      _ResidentAnnouncementScreenState();
}

class _ResidentAnnouncementScreenState
    extends ConsumerState<ResidentAnnouncementScreen> {
  // Tabs: ALL, RESIDENT
  String _selectedTab = "ALL";

  List<ResidentAnnouncementItem> _filterAnnouncements(
    List<ResidentAnnouncementItem> allItems,
  ) {
    if (_selectedTab == "ALL") {
      return allItems;
    }
    return allItems.where((item) {
      final aud = (item.targetAudience ?? "").toUpperCase();
      return aud.contains("RESIDENT") || aud.contains("RESIDENTS");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(residentAnnouncementProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          automaticallyImplyLeading: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    alignment: Alignment.center,
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
                        "Announcements",
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
                        "Association notices and updates",
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
      ),
      body: announcementsAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 30.w,
                height: 30.h,
                child: const CircularProgressIndicator(
                  color: Color(0xFF101C16),
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Loading announcements...",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color(0xFF6F7672),
                ),
              ),
            ],
          ),
        ),
        error: (err, stack) => RefreshIndicator(
          color: const Color(0xFF101C16),
          onRefresh: () async {
            ref.invalidate(residentAnnouncementProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    size: 44.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Unable to load announcements",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    err.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: const Color(0xFF6F7672),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101C16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    onPressed: () {
                      ref.invalidate(residentAnnouncementProvider);
                    },
                    icon: Icon(Icons.refresh, color: Colors.white, size: 16.sp),
                    label: Text(
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
          ),
        ),
        data: (responseModel) {
          final allItems = responseModel.data ?? [];
          final list = _filterAnnouncements(allItems);

          return RefreshIndicator(
            color: const Color(0xFF101C16),
            onRefresh: () async {
              ref.invalidate(residentAnnouncementProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // // Tabs: All vs Resident
                  // Row(
                  //   children: [
                  //     _tabItem(
                  //       key: "ALL",
                  //       label: "All Notices",
                  //       icon: Icons.groups_outlined,
                  //     ),
                  //     SizedBox(width: 12.w),
                  //     _tabItem(
                  //       key: "RESIDENT",
                  //       label: "Resident Specific",
                  //       icon: Icons.home_outlined,
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 18.h),

                  // Announcement List
                  if (list.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      margin: EdgeInsets.only(bottom: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C16),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.campaign_rounded,
                            color: const Color(0xFFE8B900),
                            size: 30.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${list.length} notice${list.length == 1 ? "" : "s"} from your association",
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Latest first. Tap a notice to read it fully.",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (list.isEmpty)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 30.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color.fromRGBO(16, 28, 22, 0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 40.sp,
                            color: const Color(0xFF6F7672),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "No Announcements",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Your association has not posted any notice yet. New notices will also appear in Notifications.",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF6F7672),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return _buildNoticeCard(item);
                      },
                    ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tabItem({
    required String key,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedTab == key;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = key;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF101C16) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF101C16)
                  : const Color.fromRGBO(16, 28, 22, 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17.sp,
                color: isSelected
                    ? const Color(0xFFE8B900)
                    : const Color(0xFF101C16),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF101C16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Type ke hisaab se rang + icon
  ({Color color, IconData icon, String label}) _typeStyle(String? type) {
    switch ((type ?? "").toLowerCase()) {
      case "maintenance":
        return (
          color: const Color(0xFFE08A00),
          icon: Icons.build_circle_outlined,
          label: "Maintenance",
        );
      case "emergency":
        return (
          color: const Color(0xFFD93025),
          icon: Icons.warning_amber_rounded,
          label: "Emergency",
        );
      case "meeting":
        return (
          color: const Color(0xFF1C64F2),
          icon: Icons.groups_outlined,
          label: "Meeting",
        );
      case "event":
        return (
          color: const Color(0xFF7C3AED),
          icon: Icons.celebration_outlined,
          label: "Event",
        );
      case "notice":
        return (
          color: const Color(0xFF0E7490),
          icon: Icons.push_pin_outlined,
          label: "Notice",
        );
      default:
        return (
          color: const Color(0xFFB8860B),
          icon: Icons.campaign_outlined,
          label: "Announcement",
        );
    }
  }

  Widget _chip(String text, Color color, {bool solid = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: solid ? color : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: solid ? Colors.white : color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildNoticeCard(ResidentAnnouncementItem item) {
    final style = _typeStyle(item.type);
    final priority = (item.priority ?? "normal").toLowerCase();
    final isUrgent = priority == "urgent" || priority == "high";
    final accent = isUrgent && (item.type ?? "").toLowerCase() != "emergency"
        ? const Color(0xFFD93025)
        : style.color;
    final date = item.createdAtFormatted ?? item.dateHuman ?? "";
    final by = item.createdBy?.name;
    final hasAttachment = (item.attachmentUrl ?? "").toString().isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: accent.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ResidentAnnouncementDetailScreen(announcement: item),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rangeen header: type + priority + date
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.08),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(14.r),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                      child: Icon(style.icon, color: accent, size: 20.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _chip(style.label.toUpperCase(), accent),
                          if (isUrgent)
                            _chip(
                              priority.toUpperCase(),
                              const Color(0xFFD93025),
                              solid: true,
                            ),
                          if (item.pinned == true)
                            _chip("PINNED", const Color(0xFF101C16)),
                        ],
                      ),
                    ),
                    if (date.isNotEmpty)
                      Text(
                        date,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6F7672),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.message ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(42, 41, 51, 0.82),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        if (by != null && by.isNotEmpty) ...[
                          Icon(
                            Icons.person_outline_rounded,
                            size: 16.sp,
                            color: const Color(0xFF6F7672),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              by,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color(0xFF6F7672),
                              ),
                            ),
                          ),
                        ],
                        if (hasAttachment) ...[
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.attach_file_rounded,
                            size: 16.sp,
                            color: const Color(0xFF6F7672),
                          ),
                          Text(
                            "Attachment",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF6F7672),
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          "Read more",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: accent,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13.sp,
                          color: accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

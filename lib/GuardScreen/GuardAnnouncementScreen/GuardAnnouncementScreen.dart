import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/announcementModel.dart';
import 'GuardAnnouncementDetailScreen.dart';

class GuardAnnouncementScreen extends StatefulWidget {
  const GuardAnnouncementScreen({super.key});

  @override
  State<GuardAnnouncementScreen> createState() =>
      _GuardAnnouncementScreenState();
}

class _GuardAnnouncementScreenState extends State<GuardAnnouncementScreen> {
  // Tabs: ALL, GUARD
  String _selectedTab = "ALL";

  late List<AnnouncementItem> _allAnnouncements;

  @override
  void initState() {
    super.initState();
    _allAnnouncements = DummyAnnouncementData.getGuardAnnouncements();
  }

  List<AnnouncementItem> get _filteredList {
    return _allAnnouncements.where((item) {
      if (_selectedTab == "ALL") return true;
      final aud = (item.targetAudience ?? "").toUpperCase();
      return aud == "GUARDS" || aud == "GUARD";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

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
                        "Guard Notices",
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
                        "Association directives and orders",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs: All vs Guard
            Row(
              children: [
                _tabItem(
                  key: "ALL",
                  label: "All Notices",
                  icon: Icons.groups_outlined,
                ),
                SizedBox(width: 12.w),
                _tabItem(
                  key: "GUARD",
                  label: "Guard Specific",
                  icon: Icons.shield_outlined,
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // Announcement List
            if (list.isEmpty)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30.h),
                padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
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
                      Icons.shield_outlined,
                      size: 40.sp,
                      color: const Color(0xFF6F7672),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "No Guard Directives",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
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

  Widget _buildNoticeCard(AnnouncementItem item) {
    final isAll = (item.targetAudience ?? "").toUpperCase() == "ALL";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFF101C16),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    GuardAnnouncementDetailScreen(announcement: item),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Audience Tag & Date
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C16),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAll
                                ? Icons.groups_outlined
                                : Icons.shield_outlined,
                            size: 11.sp,
                            color: const Color(0xFFE8B900),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            isAll ? "All Society" : "Guard Order",
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.postedDate ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6F7672),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // Title
                Text(
                  item.title ?? "",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 6.h),

                // Description
                Text(
                  item.shortDescription ?? item.content ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                    height: 1.35,
                  ),
                ),

                SizedBox(height: 10.h),

                // View Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "View Details",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: AppColors.heading,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

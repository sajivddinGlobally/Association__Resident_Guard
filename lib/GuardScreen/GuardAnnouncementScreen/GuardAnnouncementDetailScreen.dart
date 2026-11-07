import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/announcementModel.dart';

class GuardAnnouncementDetailScreen extends StatefulWidget {
  final AnnouncementItem announcement;

  const GuardAnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  State<GuardAnnouncementDetailScreen> createState() =>
      _GuardAnnouncementDetailScreenState();
}

class _GuardAnnouncementDetailScreenState
    extends State<GuardAnnouncementDetailScreen> {
  void _copyAnnouncement() {
    final item = widget.announcement;
    final text = '''
🛡️ ASSOCIATION DIRECTIVE (FOR GUARD)
Title: ${item.title ?? ''}
Audience: ${item.targetAudience ?? 'Guard'}
Date: ${item.postedDate ?? ''}

Instructions / Details:
${item.content ?? item.shortDescription ?? ''}

Issued by: ${item.postedBy ?? 'Society Association'}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.heading,
        content: Text(
          "Directive copied to clipboard",
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
    final item = widget.announcement;
    final isAll = (item.targetAudience ?? "").toUpperCase() == "ALL";

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                        "Guard Notice Details",
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
                        "Official order from Association",
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
                GestureDetector(
                  onTap: _copyAnnouncement,
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
                      Icons.share_outlined,
                      color: const Color(0xff101C16),
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Announcement Container (No white, transparent with heading border)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.heading,
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Audience Badge & Date
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
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
                              size: 13.sp,
                              color: const Color(0xFFE8B900),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              isAll ? "All Society" : "Guard Order",
                              style: GoogleFonts.outfit(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13.sp,
                            color: const Color(0xFF6F7672),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.postedDate ?? "Recent",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6F7672),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Title
                  Text(
                    item.title ?? "Guard Notice",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 12.h),
                  const Divider(color: Color(0xFFC6C6C6), height: 1),
                  SizedBox(height: 12.h),

                  // Description Body
                  Text(
                    item.content ?? item.shortDescription ?? "",
                    style: GoogleFonts.outfit(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF101C16),
                      height: 1.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Issued By Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color.fromRGBO(16, 28, 22, 0.3),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.heading,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_balance_outlined,
                        size: 20.sp,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Issued By",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6F7672),
                          ),
                        ),
                        Text(
                          item.postedBy ?? "Society Association",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

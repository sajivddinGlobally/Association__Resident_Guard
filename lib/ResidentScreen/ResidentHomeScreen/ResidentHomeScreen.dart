import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/RaiseComplaintScreen/RaiseComplaint.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentServiceRequest/ResidentServiceRequestScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentFrequentVisitors/ResidentFrequentVisitorsScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentAIPropertyAssistantScreen/Resident_Ai_PropertyAssistant.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentAssociationCalendarScreen/Resident_Calendar_Screen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentApartmentScreen/ApartmentScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentProfileScreen/ResidentProfileScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentRequestScreen/ResidentRequestScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentComplaintScreen/CommunityContactsScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentEmergencyContactScreen/Emergency_ContactScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentNotification_Screen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentGateApproval/ResidentGateApprovalScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentGateApproval/ResidentVisitorApprovalScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentMmcStatusScreen/MMC_StatusScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentVisitorPassRequest/ResidentVisitorPassListScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentAnnouncementScreen/ResidentAnnouncementScreen.dart';
import 'package:svg_flutter/svg.dart';

import '../ResidentMmcStatusScreen/MaintenanceActivitiesScreen.dart';
import 'provider/residentDashboardProvider.dart';

class ResidentBottomNavBar extends StatefulWidget {
  const ResidentBottomNavBar({super.key});

  @override
  State<ResidentBottomNavBar> createState() => _ResidentBottomNavBarState();
}

class _ResidentBottomNavBarState extends State<ResidentBottomNavBar> {
  int selectedBottomIndex = 0;

  List<Widget> get pages => [
    Residenthomescreen(
      onReqeustTap: () {
        setState(() {
          selectedBottomIndex = 2;
        });
      },
      onProfileTap: () {
        setState(() {
          selectedBottomIndex = 3;
        });
      },
    ),
    Apartmentscreen(isShowBackButton: false),
    Residentrequestscreen(),
    Residentprofilescreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedBottomIndex != 0) {
          setState(() {
            selectedBottomIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: pages[selectedBottomIndex],
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
              color: Color(0xFFFFFCEB),
              border: Border(
                top: BorderSide(color: const Color(0xFF17221D), width: 1.w),
              ),
            ),
            child: Row(
              children: [
                _bottomItem(
                  index: 0,
                  // image: "assets/bottam_img.png",
                  image: "assets/SvgImage/homeicon.svg",
                  title: "Home",
                ),

                _bottomItem(
                  index: 1,
                  // image: "assets/bottom_img2.png",
                  image: "assets/SvgImage/bottom_img2.svg",
                  title: "Apartment",
                ),

                _bottomItem(
                  index: 2,
                  // image: "assets/bottom_img3.png",
                  image: "assets/SvgImage/bottam_img.svg",
                  title: "Requests",
                ),

                _bottomItem(
                  index: 3,
                  // image: "assets/bottom_img5.png",
                  image: "assets/SvgImage/profileicon.svg",
                  title: "Account",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required int index,
    required String image,
    required String title,
  }) {
    final bool isSelected = selectedBottomIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedBottomIndex = index;
          });
        },
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  image,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? const Color(0xff101C16)
                        : const Color(0xFF6F7672),
                    BlendMode.srcIn,
                  ),
                  width: 30.w,
                  height: 30.h,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Color(0xFF17221D)
                      : const Color(0xffA0A5A2),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Residenthomescreen extends ConsumerStatefulWidget {
  final VoidCallback onReqeustTap;
  final VoidCallback onProfileTap;
  const Residenthomescreen({
    super.key,
    required this.onReqeustTap,
    required this.onProfileTap,
  });

  @override
  ConsumerState<Residenthomescreen> createState() => _ResidenthomescreenState();
}

class _ResidenthomescreenState extends ConsumerState<Residenthomescreen> {
  @override
  Widget build(BuildContext context) {
    final dashBoardData = ref.watch(residentDashboardProvider);
    var box = Hive.box("associationdata");
    final headers = dashBoardData.valueOrNull?.data?.header;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        titleSpacing: 20.w,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Good Morning",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(16, 28, 22, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    "Hello, ${box.get("name") ?? ''} 👋",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ResidentnotificationScreen(),
                        ),
                      ).then((value) {
                        ref.invalidate(residentDashboardProvider);
                      });
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Color(0xffE8E5DC)),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 21.sp,
                        color: Color(0xff0D241B),
                      ),
                    ),
                  ),
                  if (headers?.unreadNotificationsCount != 0)
                    Positioned(
                      right: 0.w,
                      top: -2.h,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Color(0xffD5A52C),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: widget.onProfileTap,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Color(0xffE8E5DC)),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 21.sp,
                    color: Color(0xff0D241B),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
        ],
      ),
      body: dashBoardData.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      width: double.infinity,
                      height: 252.h,
                      child: Stack(
                        children: [
                          Image.network(
                            // "assets/ResidentHome.png",
                            data.data?.myResidence?.image ?? "",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 252.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30.r),
                                    bottomRight: Radius.circular(30.r),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff101C16).withOpacity(0.0),
                                      Color(0xff101C16).withOpacity(0.4),
                                      Color(0xff101C16).withOpacity(0.9),
                                      Color(0xff101C16),
                                    ],
                                    stops: const [0.0, 0.4, 0.75, 1.0],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.broken_image, size: 20.w),
                                ),
                              );
                            },
                          ),

                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.75),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            left: 23.w,
                            bottom: 71.h,
                            child: Text(
                              data.data?.myResidence?.tag ?? "My Residence",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffB8860B),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 23.w,
                            bottom: 49.h,
                            child: Text(
                              data.data?.myResidence?.complexName ??
                                  "Green Valley",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 45.h,
                            right: 22.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(184, 134, 11, 0.3),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                data.data?.myResidence?.unitBadge ??
                                    "Not Assigned",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xffB8860B),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 23.w,
                            bottom: 29.h,
                            child: Text(
                              data.data?.myResidence?.subtitle ??
                                  "Your registered apartment",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Quick Actions",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _serviceCard(
                          title:
                              data.data?.quickActions?.raiseComplaint?.title ??
                              "Raise Complaint",
                          subtitle:
                              data
                                  .data
                                  ?.quickActions
                                  ?.raiseComplaint
                                  ?.subtitle ??
                              "Report an issue and receive a token",
                          icon: Icons.warning_amber_rounded,
                          isSelected: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Raisecomplaint(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: _serviceCard(
                          title: "My Request",
                          // data.data?.quickActions?.myRequests?.title ??
                          // "My Requests",
                          subtitle: "Track your request",
                          // data.data?.quickActions?.myRequests?.subtitle ??
                          // "Track your complaints",
                          icon: Icons.chat_bubble_outline,
                          isSelected: false,
                          onTap: widget.onReqeustTap,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _serviceCard(
                          title: "Request Service",
                          subtitle: "Book a society service",
                          icon: Icons.build_circle_outlined,
                          isSelected: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ResidentServiceRequestScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: _serviceCard(
                          title: "Frequent Visitors",
                          subtitle: "People registered for your flat",
                          icon: Icons.groups_outlined,
                          isSelected: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ResidentFrequentVisitorsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const ResidentGateApprovalScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.heading.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8B900).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.security_rounded,
                              color: const Color(0xFFB8860B),
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Parcel & Delivery Approvals",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD22424),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Parcels",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Approve deliveries & leave at gate options",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: AppColors.heading,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  // Visitor Request Approvals (Calls /api/v1/resident/visitor-passes)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const ResidentVisitorApprovalScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.heading.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.badge_outlined,
                              color: const Color(0xFF16A34A),
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Visitor Request Approvals",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF16A34A),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Visitor Pass",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Gate passes & visitor entry requests created by guard",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: AppColors.heading,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Pre-Approve Visitor / Create Visitor Pass (Process 2: QR Pass)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const ResidentVisitorPassListScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.heading.withOpacity(0.2),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: Color(0xFFDBEAFE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              color: const Color(0xFF2563EB),
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      // "Pre-Approve Visitor",
                                      "Gate Pass Visitor List",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2563EB),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Text(
                                        "QR Pass",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Create guest pass & get QR code to share with visitor",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: AppColors.heading,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                  Text(
                    "Community",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => MmcStatusscreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9D6A5),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: const Color(0xFFB8860B),
                              size: 18.sp,
                            ),
                          ),

                          SizedBox(width: 15.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data?.community?.mmcStatus?.title ??
                                      "MMC Status",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  data.data?.community?.mmcStatus?.subtitle ??
                                      "Monthly maintenance charges",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 10.w,
                          //     vertical: 4.h,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFFE9D6A5),
                          //     borderRadius: BorderRadius.circular(20.r),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       data.data?.community?.mmcStatus?.badge ??
                          //           "Paid",
                          //       style: GoogleFonts.outfit(
                          //         fontSize: 16.sp,
                          //         color: const Color(0xFFB8860B),
                          //         letterSpacing: -0.2,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => WorkOrderListScreen(),
                        ),
                      );
                    },
                    child: associationCard(
                      title: "Service Charges Status",
                      subtitle: "Service Charges",
                      icon: Icons.currency_rupee,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ResidentCalendarScreen(),
                        ),
                      );
                    },
                    child: associationCard(
                      title:
                          data.data?.community?.associationCalendar?.title ??
                          "Association Calendar",
                      subtitle:
                          data.data?.community?.associationCalendar?.subtitle ??
                          "Upcoming community events",
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ResidentnotificationScreen(),
                        ),
                      );
                    },
                    child: associationCard(
                      title:
                          data.data?.community?.notifications?.title ??
                          "Notifications",
                      subtitle:
                          data.data?.community?.notifications?.subtitle ??
                          "Association announcements",
                      icon: Icons.notifications_none_outlined,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const ResidentAnnouncementScreen(),
                        ),
                      );
                    },
                    child: associationCard(
                      title: "Association Announcements",
                      subtitle: "Important notices, circulars & updates",
                      icon: Icons.campaign_outlined,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Support",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      Communitycontactsscreen(),
                                ),
                              );
                            },
                            child: supportCard(
                              title:
                                  data.data?.support?.caretakerSupport?.title ??
                                  "Support",
                              subtitle:
                                  data
                                      .data
                                      ?.support
                                      ?.caretakerSupport
                                      ?.subtitle ??
                                  "Caretaker & Association Representative",
                              icon: Icons.headset_mic_outlined,
                            ),
                          ),
                        ),

                        SizedBox(width: 28.w),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      EmergencyContactscreen(),
                                ),
                              );
                            },
                            child: supportCard(
                              title:
                                  data.data?.support?.emergencyContact?.title ??
                                  "Emergency Contact",
                              subtitle:
                                  data
                                      .data
                                      ?.support
                                      ?.emergencyContact
                                      ?.subtitle ??
                                  "Call for immediate assistance",
                              icon: Icons.phone_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Assistant",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ResidentAiPropertyassistant(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 17.w,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(184, 134, 11, 0.9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF101C16),
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Container(
                                width: 39.w,
                                height: 39.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF101C16),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/SvgImage/vector.svg",
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 6.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Stayo Assistant",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF101C16),
                                          height: 1.1,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFAE8130),
                                        borderRadius: BorderRadius.circular(
                                          3.r,
                                        ),
                                      ),
                                      child: Text(
                                        "AI",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF101C16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  data
                                          .data
                                          ?.assistant
                                          ?.propertyAssistant
                                          ?.subtitle ??
                                      "Ask me anything about your property",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF101C16),
                                    height: 1.1,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Arrow Circle
                          Container(
                            width: 41.w,
                            height: 41.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF101C16),
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward,
                                size: 18.sp,
                                color: const Color(0xFF101C16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const ResidentVisitorPassListScreen(),
                        ),
                      );
                    },
                    child: visitorPassCard(
                      title:
                          data.data?.assistant?.visitorPass?.title ??
                          "Visitor Pass Request",
                      subtitle:
                          data.data?.assistant?.visitorPass?.subtitle ??
                          "Create a visitor access request",
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return const Center(child: Text("Something went wrong"));
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _serviceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.heading : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.heading : const Color(0xFFD9D5C9),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF5F0DF)
                        : const Color(0xFFF0EAD4),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 18.sp,
                      color: const Color(0xFFB8860B),
                    ),
                  ),
                ),

                Icon(
                  Icons.arrow_forward,
                  size: 20.sp,
                  color: const Color(0xFFB8860B),
                ),
              ],
            ),
            SizedBox(height: 7.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF101C16),
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF666666),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget associationCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF999999), width: 1.3),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9D6A5),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(icon, size: 18.sp, color: const Color(0xFFB8860B)),
          ),

          SizedBox(width: 15.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Icon(
            Icons.chevron_right,
            size: 22.sp,
            color: const Color(0xFF101C16),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget supportCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D5C9), width: 1.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: const Color(0xffEEE6D2),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(icon, size: 18.sp, color: const Color(0xFFB8860B)),
          ),

          SizedBox(height: 5.h),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget visitorPassCard({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1D17),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.person_add_alt_1_outlined,
              size: 24.sp,
              color: const Color(0xFFB8860B),
            ),
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_right,
              size: 16.sp,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }
}

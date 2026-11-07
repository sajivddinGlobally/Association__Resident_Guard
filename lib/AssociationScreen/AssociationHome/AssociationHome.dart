import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' hide Notification;
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAIProperty/AIPropertyAssistantScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationCalender/AssociationCalender.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationDocument/AssociationDocument.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationHome/AssociationComplexInfo.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationImportantAlertsScreen/ImportantAlertsScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationNotification/Notificaion.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProfile/AssociationProfile.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/AssociationProperty.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationVisitorLog/AssociationVisitorLogScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/AssociationServiceManagement.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/ServiiceRequest.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/Complaint.dart';
import 'package:property_association_or_resident/AssociationScreen/Mantenance&Service/PendingMantenaceService.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/DefaulterList.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/MantenanceCharges.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/serviceCharges.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../MantenanceCharges/MantenanceChargeStatus.dart';
import 'Provider/commiteDashboardProvider.dart';
import '../../Core/data/model/ResponseModel/commiteDashboardModel.dart';

class AssociationBottomNavBar extends StatefulWidget {
  const AssociationBottomNavBar({super.key});

  @override
  State<AssociationBottomNavBar> createState() =>
      _AssociationBottomNavBarState();
}

class _AssociationBottomNavBarState extends State<AssociationBottomNavBar> {
  int selectedBottomIndex = 0;

  List<Widget> get pages => [
    AssociationHome(
      onDocumentTap: () {
        setState(() {
          selectedBottomIndex = 3;
        });
      },
      onProfileTap: () {
        setState(() {
          selectedBottomIndex = 4;
        });
      },
    ),
    AssociationProperty(),
    ServiiceRequest(),
    AssociationDocument(),
    AssociationProfile(),
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
                  image: "assets/SvgImage/propertyicon.svg",
                  title: "Property",
                ),

                _bottomItem(
                  index: 2,
                  // image: "assets/bottom_img3.png",
                  image: "assets/SvgImage/serviceicon.svg",
                  title: "Services",
                ),

                _bottomItem(
                  index: 3,
                  // image: "assets/bottom_img4.png",
                  image: "assets/SvgImage/documenticon.svg",
                  title: "Documents",
                ),

                _bottomItem(
                  index: 4,
                  // image: "assets/bottom_img5.png",
                  image: "assets/SvgImage/profileicon.svg",
                  title: "Profile",
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
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF101C16)
                      : const Color(0xFF6F7672),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssociationHome extends ConsumerStatefulWidget {
  final VoidCallback onDocumentTap;
  final VoidCallback onProfileTap;
  const AssociationHome({
    super.key,
    required this.onDocumentTap,
    required this.onProfileTap,
  });

  @override
  ConsumerState<AssociationHome> createState() => _AssociationHomeState();
}

class _AssociationHomeState extends ConsumerState<AssociationHome> {
  @override
  Widget build(BuildContext context) {
    final getCommitteeDashboarState = ref.watch(commiteDashboardProvider);
    final header = getCommitteeDashboarState.valueOrNull?.data?.header;
    var box = Hive.box('associationdata');
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        toolbarHeight: 72.h,
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(16, 28, 22, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    "Hello, ${box.get('name') ?? ''} 👋",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    box.get('role') == "association_head"
                        ? "Association Head"
                        : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffD5A52C),
                      letterSpacing: -0.2,
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
                          builder: (context) => Notification(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
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
                  if ((header?.unreadNotifications ?? 0) > 0)
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
      body: getCommitteeDashboarState.when(
        data: (data) {
          final dataObj = data.data;
          final complex = dataObj?.complex;
          final widgets = dataObj?.widgets;
          final amcPlan = dataObj?.amcPlan;
          final propertyAssistant = dataObj?.propertyAssistant;
          final complexOverview = dataObj?.complexOverview;
          final servicePerformance = dataObj?.servicePerformance;
          final latestInspection = dataObj?.latestInspection;
          final maintenanceCharges = dataObj?.maintenanceChargesMonthly;
          final importantAlerts = dataObj?.importantAlerts;

          final totalUnits =
              complexOverview?.totalUnits ??
              complex?.totalUnits ??
              complex?.occupancyOverview?.totalProperties ??
              0;
          final occupied =
              complexOverview?.occupiedUnits ??
              complex?.occupiedUnits ??
              complex?.occupancyOverview?.occupied ??
              0;
          final occupancyRatio = complexOverview?.occupancyProgress != null
              ? (complexOverview!.occupancyProgress! / 100.0).clamp(0.0, 1.0)
              : (totalUnits > 0
                    ? (occupied / totalUnits).clamp(0.0, 1.0)
                    : 0.0);
          final occupancyPercent =
              complexOverview?.occupancyPercentage ??
              "${(occupancyRatio * 100).round()}%";

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(commiteDashboardProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: _buildPropertyCard(complex),
                  ),
                  SizedBox(height: 15.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(left: 18.w),
                      child: Row(
                        children: [
                          _quickAction(
                            icon: Icons.calendar_month_outlined,
                            title: "Association",
                            subtitle: "Calendar",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Associationcalender(),
                                ),
                              );
                            },
                          ),
                          _quickAction(
                            icon: Icons.chat_bubble_outline,
                            title: "Open",
                            subtitle: "Complaints",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Complaint(),
                                ),
                              );
                            },
                          ),
                          // _quickAction(
                          //   icon: Icons.currency_rupee,
                          //   // title: "Maintenance",
                          //   // subtitle: "Charges",
                          //   title: "Service",
                          //   subtitle: "Charges",
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       CupertinoPageRoute(
                          //         builder: (context) => MantenanceCharges(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          _quickAction(
                            icon: Icons.currency_rupee,
                            title: "Service",
                            subtitle: "Charges",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Servicecharges(),
                                ),
                              );
                            },
                          ),
                          _quickAction(
                            icon: Icons.build_outlined,
                            title: " MMC   ",
                            subtitle: "",
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   CupertinoPageRoute(
                              //     builder: (context) =>
                              //         PendingMantenaceService(),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      MantenanceChargeStatus(),
                                ),
                              );
                            },
                          ),
                          _quickAction(
                            icon: Icons.badge_outlined,
                            title: "Visitor",
                            subtitle: "Log",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const AssociationVisitorLogScreen(),
                                ),
                              );
                            },
                          ),
                          _quickAction(
                            icon: Icons.description_outlined,
                            title: "Documents",
                            subtitle: "",
                            onTap: widget.onDocumentTap,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                amcPlan?.title ?? "Annual Maintenance Contract",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  height: 1.1,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                amcPlan?.planName ?? "AMC Plan",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  height: 1.1,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 95.w,
                          height: 31.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF17221D),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            amcPlan?.status ?? "ACTIVE",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF101C16),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AiPropertyAssistantScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                            fontSize: 17.sp,
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
                                          horizontal: 4.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFAE8130),
                                          borderRadius: BorderRadius.circular(
                                            3.r,
                                          ),
                                        ),
                                        child: Text(
                                          propertyAssistant?.badge ?? "AI",
                                          style: GoogleFonts.outfit(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF101C16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    propertyAssistant?.subtitle ??
                                        "Ask me anything about your property",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                        16,
                                        28,
                                        22,
                                        0.8,
                                      ),
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
                  ),

                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Text(
                          "Complex Overview",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            height: 1,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Spacer(),

                        Text(
                          complexOverview?.statusLabel ?? "Live Status",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(16, 28, 22, 0.75),
                            height: 1,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.w),
                          width: 5.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (complexOverview?.isLive ?? true)
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E2118),
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12.w,
                              right: 12.w,
                              top: 12.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Properties / Units",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.sp,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.85,
                                          ),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        "$totalUnits",
                                        style: GoogleFonts.outfit(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Occupancy",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.85,
                                          ),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        occupancyPercent.endsWith("%")
                                            ? occupancyPercent
                                            : "$occupancyPercent%",
                                        style: GoogleFonts.outfit(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff4D9B51),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        child: LinearProgressIndicator(
                                          value: occupancyRatio,
                                          minHeight: 6.h,
                                          backgroundColor: const Color(
                                            0xFF19382D,
                                          ),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Color(0xffD5A52C)),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        complexOverview?.occupancyText ??
                                            "$occupied / $totalUnits Units",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          color: const Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            0.75,
                                          ),
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 6.w),

                                Image.asset(
                                  "assets/associationImage/appartment.png",
                                  height: 80.h,
                                  width: 80.w,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.15),
                            indent: 10,
                            endIndent: 10,
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _bottomOverviewStat(
                                  icon: Icons.report_problem_outlined,
                                  title: "Open Complaints",
                                  value:
                                      "${complexOverview?.stats?.openComplaints ?? widgets?.openComplaints ?? 0}"
                                          .padLeft(2, ''),
                                  color: Colors.red,
                                ),
                                Container(
                                  width: 1.w,
                                  height: 30.h,
                                  color: Colors.white.withOpacity(0.15),
                                ),

                                _bottomOverviewStat(
                                  icon: Icons.build_outlined,
                                  title: "Pending Maintenance",
                                  value:
                                      "${complexOverview?.stats?.pendingMaintenance ?? widgets?.pendingMaintenance ?? 0}"
                                          .padLeft(2, ''),
                                  color: Colors.yellow,
                                ),

                                Container(
                                  width: 1.w,
                                  height: 30.h,
                                  color: Colors.white.withOpacity(0.15),
                                ),
                                _bottomOverviewStat(
                                  icon: Icons.apartment_outlined,
                                  title: "Active Services",
                                  value:
                                      "${complexOverview?.stats?.activeServices ?? widgets?.activeServices ?? 0}"
                                          .padLeft(2, ''),
                                  color: Colors.green,
                                ),
                                Container(
                                  width: 1.w,
                                  height: 30.h,
                                  color: Colors.white.withOpacity(0.15),
                                ),

                                _bottomOverviewStat(
                                  icon: Icons.shield_outlined,
                                  title: "Overdue Units",
                                  value:
                                      "${complexOverview?.stats?.outstandingUnits ?? widgets?.defaulters?.count ?? 0}"
                                          .padLeft(2, ''),
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildServicePerformance(
                    servicePerformance,
                    latestInspection,
                    widgets,
                  ),

                  SizedBox(height: 12.h),

                  _buildMaintenanceCharges(
                    maintenanceCharges,
                    complex,
                    widgets,
                  ),

                  SizedBox(height: 12.h),

                  _buildImportantAlerts(importantAlerts, widgets),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          if (error is DioException && error.response?.statusCode == 401) {
            return const SizedBox.shrink();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Something went wrong",
                  style: GoogleFonts.outfit(color: AppColors.heading),
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => ref.refresh(commiteDashboardProvider),
                  child: Text("Retry"),
                ),
              ],
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _buildPropertyCard(Complex? complex) {
    final totalUnits =
        complex?.totalUnits ?? complex?.occupancyOverview?.totalProperties ?? 0;
    final occupied =
        complex?.occupiedUnits ?? complex?.occupancyOverview?.occupied ?? 0;
    final occupancyPercent = complex?.occupancyPercentage != null
        ? complex!.occupancyPercentage!
        : (totalUnits > 0
              ? "${((occupied / totalUnits) * 100).round()}%"
              : "0%");

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Color(0xFF0F171F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AssociationComplexInfo(),
                ),
              );
            },
            child: Stack(
              children: [
                (complex?.image != null && complex!.image!.isNotEmpty)
                    ? Image.network(
                        complex.image!,
                        height: 220.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              "assets/associationImage/pro.png",
                              height: 220.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      )
                    : Image.asset(
                        "assets/associationImage/pro.png",
                        height: 220.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                Positioned.fill(
                  child: Container(
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
                  left: 12.w,
                  top: 10.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff0D241B).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Color(0xff4D9B51),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          (complex?.status ?? "ACTIVE").toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12.w,
                  top: 48.h,
                  right: 120.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complex?.name ?? "N/A",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 11.sp,
                            color: Color(0xffD5A52C),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              complex?.address ?? "N/A",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(
                                  255,
                                  255,
                                  255,
                                  0.85,
                                ),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 12.w,
                  top: 70.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "View Complex",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 11.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Color(0xFF0F171F),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _propertyStat(
                          icon: Icons.apartment_outlined,
                          title: "Total Units",
                          value: "$totalUnits",
                        ),

                        _verticalDivider(),

                        _propertyStat(
                          icon: Icons.people_outline,
                          title: "Occupied",
                          value: "$occupied",
                          subValue: occupancyPercent.startsWith("(")
                              ? occupancyPercent
                              : "($occupancyPercent)",
                        ),

                        _verticalDivider(),

                        _propertyStat(
                          icon: Icons.shield_outlined,
                          title: "Status",
                          value: complex?.status ?? "Active",
                          valueColor: Color(0xff4D9B51),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _propertyStat({
    required IconData icon,
    required String title,
    required String value,
    String? subValue,
    Color? valueColor,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Center(
              child: Icon(icon, size: 18.sp, color: const Color(0xffD5A52C)),
            ),
          ),

          SizedBox(width: 6.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  color: const Color.fromRGBO(255, 255, 255, 0.75),
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: valueColor ?? Colors.white,
                    ),
                  ),

                  if (subValue != null)
                    Text(
                      " $subValue",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 28.h,
      width: 1,
      color: Colors.white24,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.r),
              border: Border.all(color: Color(0xffE8E5DC)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 19.sp, color: Color(0xffD5A52C)),
                SizedBox(height: 3.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff0D241B),
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff0D241B),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null && badge.isNotEmpty)
            Positioned(
              right: 12.w,
              top: 4.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: const Color(0xffD5A52C),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.outfit(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomOverviewStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 10.5.sp,
                      color: const Color.fromRGBO(255, 255, 255, 0.85),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                      height: 1.15,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
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

  String _formatInspectionDate(DateTime? date) {
    if (date == null) return "N/A";
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  Widget _buildServicePerformance(
    ServicePerformance? servicePerf,
    DataLatestInspection? latestInspection,
    Widgets? widgets,
  ) {
    final propertyScore =
        servicePerf?.scoreValue?.toDouble() ??
        widgets?.propertyScore?.toDouble() ??
        0.0;
    final normalizedScore = propertyScore > 10
        ? propertyScore / 10
        : propertyScore;
    final progressValue = (normalizedScore / 10).clamp(0.0, 1.0);
    final rawScore = servicePerf?.score;
    final scoreStr = rawScore != null && rawScore.isNotEmpty
        ? (rawScore.replaceAll('%', '').trim().contains('/')
              ? rawScore.replaceAll('%', '').trim()
              : "${rawScore.replaceAll('%', '').trim()}/10")
        : (normalizedScore > 0
              ? (normalizedScore % 1 == 0
                    ? "${normalizedScore.toInt()}/10"
                    : "${normalizedScore.toStringAsFixed(1)}/10")
              : "0/10");
    final performanceStatus =
        servicePerf?.rating ??
        (normalizedScore >= 8.0
            ? "Good"
            : (normalizedScore >= 5.0 ? "Average" : "Needs Attention"));
    final performanceColor =
        (performanceStatus.toLowerCase() == "good" || normalizedScore >= 8.0)
        ? Colors.green
        : (normalizedScore >= 5.0 ? Colors.orange : Colors.red);
    final perfTitle = servicePerf?.title ?? "Service Performance";
    final perfLabel = servicePerf?.label ?? "Overall Service\nPerformance";
    final perfMessage = servicePerf?.message ?? "Overall Service Performance";

    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          const AssociationServiceManagement(),
                    ),
                  ).then((value) {
                    ref.invalidate(commiteDashboardProvider);
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: const Color(0xffE8E5DC),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              perfTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Details",
                                maxLines: 1,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF9B7627),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.chevron_right,
                                size: 12.sp,
                                color: const Color(0xFF9B7627),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Performance
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70.w,
                            height: 70.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  height: 60.w,
                                  child: CircularProgressIndicator(
                                    value: progressValue,
                                    strokeWidth: 5.w,
                                    backgroundColor: const Color(0xffE8E4D8),
                                    color: Color(0xffD5A52C),
                                  ),
                                ),
                                Text(
                                  scoreStr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff0D241B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 6.w),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  perfLabel,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.sp,
                                    color: const Color(0xff0D241B),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                Text(
                                  performanceStatus,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: performanceColor,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 15.sp,
                              ),
                            ),
                          ),

                          SizedBox(width: 5.w),

                          Flexible(
                            child: Text(
                              perfMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                color: const Color(0xff0D241B),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 8.w),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   CupertinoPageRoute(
                  //     builder: (context) => const InspectionreportScreen(),
                  //   ),
                  // ).then((value) {
                  //   ref.invalidate(commiteDashboardProvider);
                  // });
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: const Color(0xffE8E5DC),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              latestInspection?.title ?? "Latest Inspection",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Text(
                          //       "View Details",
                          //       maxLines: 1,
                          //       style: GoogleFonts.outfit(
                          //         fontSize: 11.sp,
                          //         color: const Color(0xFF9B7627),
                          //         letterSpacing: -0.3,
                          //       ),
                          //     ),
                          //     SizedBox(width: 2.w),
                          //     Icon(
                          //       Icons.chevron_right,
                          //       size: 12.sp,
                          //       color: const Color(0xFF9B7627),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 4.w,
                          top: 3.h,
                          bottom: 3.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: const Color(0xFFF9F2E4),
                          border: Border.all(
                            color: const Color(0xffE8E5DC),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    latestInspection?.status ?? "Completed",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    latestInspection?.description ??
                                        "Most recent property inspection",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11.sp,
                                      color: const Color(0xff777777),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _inspectionItem(
                              icon: Icons.calendar_today_outlined,
                              title: "Date",
                              value:
                                  latestInspection?.date ??
                                  _formatInspectionDate(
                                    widgets?.latestInspection?.date,
                                  ),
                            ),
                            Container(
                              width: 1.w,
                              margin: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 2.w,
                              ),
                              color: const Color(0xffE8E5DC),
                            ),
                            Builder(
                              builder: (context) {
                                final inspScore = latestInspection?.score
                                    ?.toString();
                                return _inspectionItem(
                                  icon: Icons.score_outlined,
                                  title: "Score",
                                  value: inspScore != null
                                      ? (inspScore.contains('/')
                                            ? inspScore
                                            : "${inspScore.replaceAll('%', '').trim()}/10")
                                      : (widgets?.latestInspection?.score !=
                                                null
                                            ? "${widgets!.latestInspection!.score}/10"
                                            : "N/A"),
                                );
                              },
                            ),
                            Container(
                              width: 1.w,
                              margin: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 2.w,
                              ),
                              color: const Color(0xffE8E5DC),
                            ),
                            _inspectionItem(
                              icon: Icons.verified_outlined,
                              title: "Status",
                              value: latestInspection?.status ?? "Completed",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inspectionItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF9F2E4),
              ),
              child: Center(
                child: Icon(icon, size: 14.sp, color: const Color(0xFF9B7627)),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                color: const Color(0xff777777),
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff0D241B),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceCharges(
    MaintenanceChargesMonthly? chargesMonthly,
    Complex? complex,
    Widgets? widgets,
  ) {
    final title = chargesMonthly?.title ?? "Maintenance Charges (Monthly)";
    final rawStatus =
        chargesMonthly?.statusBadge ?? chargesMonthly?.statusBadge ?? "Active";
    final status = rawStatus.toLowerCase() == "tracking" ? "Active" : rawStatus;
    final totalUnits =
        complex?.totalUnits ?? complex?.occupancyOverview?.totalProperties ?? 0;
    final defaultersCount =
        chargesMonthly?.defaulters ?? widgets?.defaulters?.count ?? 0;
    final paidUnits =
        chargesMonthly?.paidUnits ??
        (totalUnits - defaultersCount).clamp(0, totalUnits);
    final unpaidUnits = chargesMonthly?.unpaidUnits ?? defaultersCount;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: _sectionContainer(
        title: title,
        action: "View Details",
        onTap: () {
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(builder: (context) => MantenanceCharges()),
          // );
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => Servicecharges()),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffD5A52C)),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.currency_rupee,
                  size: 16.sp,
                  color: Color(0xffD5A52C),
                ),
              ),
              SizedBox(width: 10.w),
              _chargeStat(title: "Status", value: status),

              _chargeStat(
                title: "Paid Units",
                value: "$paidUnits",
                valueColor: Color(0xff4D9B51),
              ),

              _chargeStat(
                title: "Unpaid Units",
                value: "$unpaidUnits",
                valueColor: Color(0xffD94A42),
              ),

              _chargeStat(
                title: "Defaulters",
                value: "$defaultersCount",
                valueColor: Color(0xffD94A42),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chargeStat({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              color: Color(0xff777777),
              fontWeight: FontWeight.w400,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Color(0xff0D241B),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMPORTANT ALERTS
  // ============================================================

  Widget _buildImportantAlerts(List<ImportantAlert>? alerts, Widgets? widgets) {
    if (alerts != null && alerts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: _sectionContainer(
          title: "Important Alerts",
          action: "View All",
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Importantalertsscreen(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: alerts.map((alert) {
                  IconData icon;
                  Color color;

                  if (alert.severity == "danger" || alert.severity == "error") {
                    color = const Color(0xffD94A42);
                  } else {
                    color = const Color(0xffD5A52C);
                  }

                  final type = (alert.type ?? "").toLowerCase();
                  final titleLower = (alert.title ?? "").toLowerCase();
                  final actionRoute = (alert.actionRoute ?? "").toLowerCase();

                  if (type.contains("complaint") ||
                      titleLower.contains("complaint")) {
                    icon = Icons.report_problem_outlined;
                    color = const Color(0xffD94A42);
                  } else if (type.contains("maintenance") ||
                      titleLower.contains("maintenance")) {
                    icon = Icons.build_outlined;
                  } else if (type.contains("charge") ||
                      type.contains("defaulter") ||
                      titleLower.contains("charge") ||
                      titleLower.contains("outstanding") ||
                      titleLower.contains("unit")) {
                    icon = Icons.currency_rupee;
                  } else {
                    icon = Icons.info_outline;
                  }

                  String displayCount = alert.count != null
                      ? "${alert.count}"
                      : "";
                  String displayTitle = alert.title ?? "";
                  if (displayCount.isNotEmpty &&
                      displayTitle.startsWith("$displayCount ")) {
                    displayTitle = displayTitle.substring(
                      displayCount.length + 1,
                    );
                  }

                  VoidCallback onAlertTap;
                  if (type.contains("complaint") ||
                      actionRoute.contains("complaint") ||
                      titleLower.contains("complaint")) {
                    onAlertTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const Complaint(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    };
                  } else if (type.contains("maintenance") ||
                      actionRoute.contains("maintenance") ||
                      titleLower.contains("maintenance")) {
                    onAlertTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => Servicecharges(),
                          // const PendingMantenaceService(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    };
                  } else if (type.contains("charge") ||
                      type.contains("defaulter") ||
                      actionRoute.contains("charge") ||
                      actionRoute.contains("defaulter") ||
                      titleLower.contains("charge") ||
                      titleLower.contains("outstanding") ||
                      titleLower.contains("payment") ||
                      titleLower.contains("unit")) {
                    onAlertTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const DefaulterList(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    };
                  } else {
                    onAlertTap = () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const Importantalertsscreen(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    };
                  }

                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: SizedBox(
                      width: 200.w,
                      child: _alertItem(
                        icon: icon,
                        count: displayCount,
                        title: displayTitle,
                        description: alert.subtitle ?? "",
                        color: color,
                        onTap: onAlertTap,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }

    final openComplaints = widgets?.openComplaints ?? 0;
    final pendingMaintenance = widgets?.pendingMaintenance ?? 0;
    final defaultersCount = widgets?.defaulters?.count ?? 0;
    final totalOutstanding = widgets?.defaulters?.totalOutstanding ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: _sectionContainer(
        title: "Important Alerts",
        action: "View All",
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const Importantalertsscreen(),
            ),
          ).then((value) {
            ref.invalidate(commiteDashboardProvider);
          });
        },
        child: Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 200.w,
                  child: _alertItem(
                    icon: Icons.report_problem_outlined,
                    count: "$openComplaints",
                    title: "complaints require attention",
                    description: "Review and take necessary action",
                    color: const Color(0xffD94A42),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const Complaint(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 200.w,
                  child: _alertItem(
                    icon: Icons.build_outlined,
                    count: "$pendingMaintenance",
                    title: "maintenance items pending",
                    description: "Pending maintenance requires approval",
                    color: const Color(0xffD5A52C),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const PendingMantenaceService(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  width: 200.w,
                  child: _alertItem(
                    icon: Icons.currency_rupee,
                    count: "$defaultersCount",
                    title: "units have outstanding charges",
                    description: totalOutstanding > 0
                        ? "Total: ₹$totalOutstanding"
                        : "Follow up for payment collection",
                    color: const Color(0xffD5A52C),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const DefaulterList(),
                        ),
                      ).then((value) {
                        ref.invalidate(commiteDashboardProvider);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertItem({
    required IconData icon,
    required String count,
    required String title,
    required String description,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: const Color(0xffE8E5DC), width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Center(
                    child: Icon(icon, size: 17.sp, color: color),
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (count.isNotEmpty)
                          TextSpan(
                            text: "$count ",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff0D241B),
                            ),
                          ),
                        TextSpan(
                          text: title,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff0D241B),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 13.sp,
                  color: const Color(0xff0D241B),
                ),
              ],
            ),

            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: const Color(0xff777777),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionContainer({
    required String title,
    required String action,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(9.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xffE8E5DC), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9B7627),
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (action.isNotEmpty)
                      Icon(
                        Icons.chevron_right,
                        size: 13.sp,
                        color: Color(0xFF9B7627),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          child,
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/GuaredHistoryScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardParcelScreen/GuardParcelRegisterScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/GuardScanPassScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/GuardVisitorScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/Provider/guardDashBoardProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardVichelScreen/GuardVehicleScreen.dart';
import 'package:svg_flutter/svg.dart';

import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/FrequentVisitorsScreen.dart';
import '../GuardBottomScreen/GuardProfileScreen/guardProfileScreen.dart';
import '../GuardNotificationScreen/GuardNotificationScreen.dart';
import '../GuardAnnouncementScreen/GuardAnnouncementScreen.dart';

class GuardBottomNavState extends StatefulWidget {
  const GuardBottomNavState({super.key});

  @override
  State<GuardBottomNavState> createState() => _GuardBottomNavStateState();
}

class _GuardBottomNavStateState extends State<GuardBottomNavState> {
  int selectedBottomIndex = 0;
  List<Widget> get pages => [
    Guardhomescreen(
      onVisitorTap: () {
        setState(() {
          selectedBottomIndex = 1;
        });
      },
      onParcelTap: () {
        setState(() {
          selectedBottomIndex = 2;
        });
      },
      onProfileTap: () {
        setState(() {
          selectedBottomIndex = 4;
        });
      },
    ),
    Guardvisitorscreen(),
    Guardparcelregisterscreen(),
    Guaredhistoryscreen(),
    GuardProfileScreen(),
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
                  title: "Visitor",
                ),

                _bottomItem(
                  index: 2,
                  // image: "assets/bottom_img3.png",
                  image: "assets/SvgImage/serviceicon.svg",
                  title: "Parcel",
                ),

                _bottomItem(
                  index: 3,
                  // image: "assets/bottom_img4.png",
                  image: "assets/SvgImage/documenticon.svg",
                  title: "History",
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

class Guardhomescreen extends ConsumerStatefulWidget {
  final VoidCallback onVisitorTap;
  final VoidCallback onParcelTap;
  final VoidCallback onProfileTap;
  const Guardhomescreen({
    super.key,
    required this.onVisitorTap,
    required this.onParcelTap,
    required this.onProfileTap,
  });

  @override
  ConsumerState<Guardhomescreen> createState() => _GuardhomescreenState();
}

class _GuardhomescreenState extends ConsumerState<Guardhomescreen> {
  bool _isTogglingShift = false;

  @override
  Widget build(BuildContext context) {
    final guardDashboard = ref.watch(guardDashboardProvider);
    final todaysactivity = guardDashboard.valueOrNull?.data?.todaysActivity;
    final header = guardDashboard.valueOrNull?.data?.header;
    var box = Hive.box("associationdata");
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
                    "Hello, ${box.get("name") ?? ''}  👋",
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
              InkWell(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.scaffoldBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: const Color(0xFFD22424),
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Emergency SOS",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              color: const Color(0xFFD22424),
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        "Broadcast an emergency security alert to committee & residents from gate?",
                        style: GoogleFonts.outfit(fontSize: 14.sp),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD22424),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            "TRIGGER SOS",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      final res = await ref
                          .read(authServiceProvider)
                          .sendGuardSosData(reason: "Emergency Gate Alert");
                      if (res.status == true) {
                        showSuccessSnackBar(
                          res.message ?? "Emergency SOS alert sent.",
                        );
                      } else {
                        showErrorSnackBar(
                          res.message ?? "Could not send SOS alert.",
                        );
                      }
                    } catch (e) {
                      // Server ka asli error Dio interceptor dikha deta hai.
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD22424),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 15.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "SOS",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const GuardNotificationScreen(),
                        ),
                      ).then((value) {
                        ref.invalidate(guardDashboardProvider);
                      });
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xffE8E5DC)),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 21.sp,
                        color: const Color(0xff0D241B),
                      ),
                    ),
                  ),
                  if (header?.hasNotifications == true)
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
      body: guardDashboard.when(
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  child: SizedBox(
                    height: 252.h,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.network(
                          // "assets/ResidentHome.png",
                          data.data?.shiftCard?.backgroundImage ?? "",
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
                          left: 20.w,
                          bottom: 65.h,
                          right: 20.w,
                          child: Builder(
                            builder: (context) {
                              final isOnDuty =
                                  data.data?.shiftCard?.isOnDuty ?? true;
                              return Row(
                                children: [
                                  Container(
                                    height: 20.w,
                                    width: 20.w,
                                    decoration: BoxDecoration(
                                      color: isOnDuty
                                          ? const Color.fromRGBO(
                                              17,
                                              197,
                                              80,
                                              0.2,
                                            )
                                          : const Color.fromRGBO(
                                              210,
                                              36,
                                              36,
                                              0.2,
                                            ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Container(
                                        height: 14.w,
                                        width: 14.w,
                                        decoration: BoxDecoration(
                                          color: isOnDuty
                                              ? const Color(0xff11C550)
                                              : const Color(0xFFD22424),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 8.w),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.data?.shiftCard?.shiftName ?? "",
                                          style: GoogleFonts.outfit(
                                            fontSize: 18.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          data.data?.shiftCard?.timings ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 8.w),

                                  InkWell(
                                    onTap: _isTogglingShift
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isTogglingShift = true;
                                            });
                                            try {
                                              final res = await ref
                                                  .read(authServiceProvider)
                                                  .toggleGuardShiftData();
                                              if (res.status == true) {
                                                showSuccessSnackBar(
                                                  res.message ??
                                                      "Shift status updated.",
                                                );
                                              } else {
                                                showErrorSnackBar(
                                                  res.message ??
                                                      "Could not update shift status.",
                                                );
                                              }
                                              ref.invalidate(
                                                guardDashboardProvider,
                                              );
                                            } catch (e) {
                                              // Server ka asli error Dio interceptor dikha deta hai.
                                            } finally {
                                              if (mounted) {
                                                setState(() {
                                                  _isTogglingShift = false;
                                                });
                                              }
                                            }
                                          },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 17.w,
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          50.r,
                                        ),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: _isTogglingShift
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 14.w,
                                                  height: 14.w,
                                                  child:
                                                      const CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            AppColors.heading,
                                                      ),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  "Updating...",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 14.sp,
                                                    color: AppColors.heading,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.sync,
                                                  size: 14.sp,
                                                  color: AppColors.heading,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  data
                                                          .data
                                                          ?.shiftCard
                                                          ?.statusLabel ??
                                                      "Toggle Shift",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 14.sp,
                                                    color: AppColors.heading,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Quick Actions",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              color: AppColors.heading,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Live",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              color: AppColors.heading,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: [
                          _infoCard(
                            icon: Icons.person_outline,
                            title: "Register Visitor",
                            subtitle:
                                "Add visitor photo, flat details & request approval",
                            onTap: () {
                              widget.onVisitorTap();
                            },
                          ),
                          _infoCard(
                            icon: Icons.inventory_2_outlined,
                            title: "Register Parcel",
                            subtitle:
                                "Capture parcel details & request approval",
                            onTap: () {
                              widget.onParcelTap();
                            },
                          ),
                          _infoCard(
                            icon: Icons.qr_code_scanner_rounded,
                            title: "Scan Visitor Pass",
                            subtitle: "Scan QR code or visitor pass code",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const GuardScanPassScreen(),
                                ),
                              );
                            },
                          ),
                          _infoCard(
                            icon: Icons.directions_car_outlined,
                            title: "Vehicle Search",
                            subtitle: "Search vehicle number & owner details  ",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Guardvehiclescreen(),
                                ),
                              );
                            },
                          ),
                          _infoCard(
                            icon: Icons.repeat_rounded,
                            title: "Frequent Visitors",
                            subtitle:
                                "1-Tap entry for maids, milkman & daily staff",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const Frequentvisitorsscreen(),
                                ),
                              );
                            },
                          ),
                          _infoCard(
                            icon: Icons.campaign_outlined,
                            title: "Notice Board",
                            subtitle:
                                "Gate standing orders, shift SOPs & notices",
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const GuardAnnouncementScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            "Today's Activity",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              color: AppColors.heading,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Live",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              color: AppColors.heading,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: todaysactivity?.items?.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = todaysactivity!.items![index];

                            return Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: _approvalItem(
                                title: item.title ?? "",
                                subtitle: item.subtitle ?? "",
                                status: item.badge ?? "",
                                statusColor: item.badge == "APPROVED"
                                    ? const Color(0xff24B06A)
                                    : item.badge == "PENDING"
                                    ? const Color(0xFFE2B509)
                                    : item.badge == "VERIFIED"
                                    ? const Color(0xFF1E5993)
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 17.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1C16),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.data?.vehicleSearchWidget?.title ?? "",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              data.data?.vehicleSearchWidget?.description ?? "",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Container(
                              height: 38.h,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 12.w, right: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBg,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xffE8E5DC),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                Guardvehiclescreen(),
                                          ),
                                        );
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "",
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.h,
                                        ),
                                      ),
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28.h,
                                    width: 68.w,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                Guardvehiclescreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFE8B900,
                                        ),
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Search",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 35.h),
                    ],
                  ),
                ),
              ],
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

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    double iconSize = 20,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 15.w,
          right: 12.w,
          top: 10.h,
          bottom: 10.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.heading),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: iconSize.sp, color: AppColors.heading),

            SizedBox(height: 8.h),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(41, 42, 51, 0.6),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _approvalItem({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon Box
        Container(
          height: 40.w,
          width: 40.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF222222), width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.person,
            size: 18.sp,
            color: const Color(0xFF222222),
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF171717),
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
                  color: const Color(0xFF666666),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            status,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart' hide Notification;
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/AddResidentScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/GuardScreen/addGuardScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAuditReport/AssociationReport.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAuditReport/inspectionReportScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAnnouncement/AssociationAnnouncementListScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationNotification/Notificaion.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProfile/AssociationChangePassword.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProfile/AssociationEditProfile.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProfile/Provider/getProfileProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/AssociationLogin.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:svg_flutter/svg.dart';

import '../../Core/AuthService/AuthServiceProvider.dart';
import '../../Core/Utils/showMessage.dart';
import '../AssociationCalender/AssociationCalender.dart';

class AssociationProfile extends ConsumerStatefulWidget {
  const AssociationProfile({super.key});

  @override
  ConsumerState<AssociationProfile> createState() => _AssociationProfileState();
}

class _AssociationProfileState extends ConsumerState<AssociationProfile> {
  @override
  Widget build(BuildContext context) {
    final getProfileState = ref.watch(getProfileProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Profile",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Manage your personal information",
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
          ],
        ),
      ),
      body: getProfileState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFF101C16),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey.shade100,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              data.data?.avatarUrl ?? "",
                              width: 76.r,
                              height: 76.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 76.r,
                                  height: 76.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF101C16),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 36.sp,
                                    color: AppColors.heading,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          data.data?.name ?? "MD Sajiv",
                          style: GoogleFonts.outfit(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          data.data?.email ?? "sajiv@gmail.com",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 0.75),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: const Color(0xFF000000),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            data.data?.role == "association_head"
                                ? "Association Head"
                                : "Resident",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000000),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Personal Information",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Full Name",
                          value: data.data?.name ?? "Md Sajiv",
                        ),
                        _documentRow(
                          title: "Email Address",
                          value: data.data?.email ?? "sajiv@gmail.com",
                        ),
                        _documentRow(
                          title: "Phone Number",
                          value: data.data?.phone ?? "+91 98XXXXXX42",
                        ),
                        _documentRow(
                          title: "Account Type",
                          value: data.data?.role == "association_head"
                              ? "Association Head"
                              : "Resident",
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1.2,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/SvgImage/proAparment.svg",
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Association",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                                  ),
                                ),
                                Text(
                                  data.data?.activeComplex?.name ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101C16),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        const Divider(color: Color(0xFFC6C6C6)),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Role
                            Expanded(
                              child: _associationInfoItem(
                                title: "Role",
                                value: data.data?.role == "association_head"
                                    ? "Association Head"
                                    : "Resident",
                              ),
                            ),

                            // Total Units
                            Expanded(
                              child: _associationInfoItem(
                                title: "Total Units",
                                value:
                                    data.data?.activeComplex?.totalUnits
                                        .toString() ??
                                    "0",
                              ),
                            ),
                            // Blocks
                            Expanded(
                              child: _associationInfoItem(
                                title: "Blocks",
                                value:
                                    data.data?.activeComplex?.totalBlocks
                                        .toString() ??
                                    "0",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Account Settings",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h),
                        _accountSettingTab(
                          image: "assets/SvgImage/editicon.svg",
                          name: "Edit Profile",
                          title: "Update your personal information",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AssociationEditProfile(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/icons8-lock.svg",
                          name: "Security & Password",
                          title: "Manage password and account security",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    AssociationChangePassword(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/audit.svg",
                          name: "Audit Reports",
                          title: "Audit Reports history",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AssociationReport(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/audit.svg",
                          name: "Inspection Reports",
                          title: "Inspection Reports history",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => InspectionReportScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/add.svg",
                          name: "Add Resident ",
                          title: "All Resident add/List",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Addresidentscreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          // image: "assets/SvgImage/history.svg",
                          image: "assets/SvgImage/add.svg",
                          name: "Add Guard",
                          title: "All  Guard Add/List",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AddGuardScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/history.svg",
                          name: "Add Event/Meeting",
                          title: "Association Calendar · Green Valley",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Associationcalender(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/notifi.svg",
                          name: "Announcements",
                          title: "View broadcast notices & create announcements",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const AssociationAnnouncementListScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/notifi.svg",
                          name: "Notifications",
                          title: "Manage property notification preferences",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Notification(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Logout Account",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Something went wrong"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    bool showBottomBorder = true,
  }) {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: showBottomBorder
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                      )
                    : null,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: showBottomBorder
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                    )
                  : null,
            ),
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
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
    );
  }

  Widget _accountSettingTab({
    required String image,
    required String name,
    required String title,
    required VoidCallback callback,
  }) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: const Color(0xFF000000), width: 1.2),
              ),
              child: Center(child: SvgPicture.asset(image)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 0.75),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF2A2933),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _associationInfoItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(0, 0, 0, 0.6),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              contentPadding: EdgeInsets.all(24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 36.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Logout",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Are you sure you want to log out from this account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: Color.fromRGBO(41, 42, 51, 0.6),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: AppColors.heading),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.outfit(
                              color: AppColors.heading,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final service = ref.read(
                                      authServiceProvider,
                                    );
                                    final respos = await service.logout();
                                    if (context.mounted) {
                                      var box = Hive.box("associationdata");
                                      await box.delete("token");
                                      await box.delete("role");
                                      showSuccessSnackBar(
                                        respos.message ??
                                            "Successfully logged out",
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              AssociationLogin(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      var box = Hive.box("associationdata");
                                      await box.delete("token");
                                      await box.delete("role");
                                      showSuccessSnackBar(
                                        "Successfully logged out",
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              AssociationLogin(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "Logout",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

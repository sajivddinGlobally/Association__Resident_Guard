import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/AssociationLogin.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardProfileScreen/provider/getGuardProfileProvider.dart';
import 'GuardChangePasswordScreen.dart';
import 'GuardEditProfileScreen.dart';

class GuardProfileScreen extends ConsumerStatefulWidget {
  const GuardProfileScreen({super.key});

  @override
  ConsumerState<GuardProfileScreen> createState() => _GuardProfileScreenState();
}

class _GuardProfileScreenState extends ConsumerState<GuardProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final guardProfileState = ref.watch(getGuardProfileProvider);

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
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guard Account",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Manage your guard duty & profile",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: guardProfileState.when(
        data: (data) {
          final statusleble = data.data?.isOnDuty == true
              ? "ON DUTY"
              : "OFF DUTY";
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.heading,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                data.data?.avatarUrl ?? "",
                                width: 58.w,
                                height: 58.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 58.w,
                                    height: 58.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Icon(
                                      Icons.security,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data?.name ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "Security Personnel · ${data.data?.guardPost ?? ""}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const GuardEditProfileScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF514719),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "•  Guard Access Active (${data.data?.shiftName ?? ""})",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFB8860B),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Current Shift & Duty",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF101C16),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Gate Duty Assignment",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1F4DE),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                statusleble,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF16B866),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _dutyItem(
                                "Shift Timing",
                                data.data?.shiftTimings ?? "",
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _dutyItem(
                                "Shift Type",
                                data.data?.shiftName ?? "",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _dutyItem(
                                "Gate / Post",
                                data.data?.guardPost ?? "",
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _dutyItem(
                                "Role Assigned",
                                data.data?.role ?? "",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Security ",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff888888)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        menuItem(
                          icon: Icons.person_outline,
                          title: "Edit Profile",
                          subtitle: "Update guard name and photo",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const GuardEditProfileScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1, color: Color(0xff555555)),
                        menuItem(
                          icon: Icons.lock_outline,
                          title: "Security & Password",
                          subtitle: "Update guard account password",
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const GuardChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  signOutCard(
                    onTap: () async {
                      _showLogoutDialog(context);
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Error loading guard profile"));
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              height: 38.w,
              width: 38.w,
              decoration: BoxDecoration(
                color: const Color(0xffEBD9A8),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, color: const Color(0xffB8860B), size: 22.sp),
            ),
            SizedBox(width: 12.w),
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
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color(0xff777777),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: const Color(0xFF101C16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dutyItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7C9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget signOutCard({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffCCB4B4), width: 1.5.w),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Row(
          children: [
            Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(210, 36, 36, 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.logout,
                size: 20.sp,
                color: const Color(0xffD22424),
              ),
            ),
            SizedBox(width: 15.w),
            Text(
              "Sign Out",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xffD91F1F),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
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
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.54,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Are you sure you want to log out from guard portal?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: const Color.fromRGBO(41, 42, 51, 0.6),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 26.h),
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
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: const BorderSide(color: AppColors.heading),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
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
                                    await service.logout();
                                    if (context.mounted) {
                                      var box = Hive.box("associationdata");
                                      await box.delete("token");
                                      await box.delete("role");
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const AssociationLogin(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      var box = Hive.box("associationdata");
                                      await box.delete("token");
                                      showSuccessSnackBar(
                                        "Successfully logged out",
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const AssociationLogin(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.w,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
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

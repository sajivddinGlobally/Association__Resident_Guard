import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationHome/AssociationHome.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/register_screen.dart';
import 'package:property_association_or_resident/AssociationScreen/ForgotPassword/AssociationForgotPassword.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/GuardHomeScreen.dart';

import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentHomeScreen.dart';

class AssociationLogin extends ConsumerStatefulWidget {
  const AssociationLogin({super.key});

  @override
  ConsumerState<AssociationLogin> createState() => _AssociationLoginState();
}

class _AssociationLoginState extends ConsumerState<AssociationLogin> {
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;
  int? selectIndex; // 0: Association Head, 1: Resident/
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 150.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/circuler_img.png",
                      width: 146.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/circuler_img.png",
                      width: 177.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ClipOval(
                child: Image.asset(
                  // "assets/new logo.png",
                  "assets/updatelogo.jpeg",
                  width: 110.w,
                  height: 110.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Center(
            //   child: SvgPicture.asset(
            //     "assets/SvgImage/Logo Pro.svg",
            //     width: 150.w,
            //     height: 150.w,
            //   ),
            // ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WELCOME BACK",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 22.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Sign in to manage and monitor your property.",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff26332D),
                      fontSize: 15.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRoleButton(
                          title: "Association Head",
                          backgroundColor: selectIndex == 0
                              ? const Color(0xFF101C16)
                              : Colors.transparent,
                          borderColor: const Color(0xFF101C16),
                          textColor: selectIndex == 0
                              ? Colors.white
                              : const Color(0xFF101C16),
                          onTap: () {
                            setState(() {
                              selectIndex = 0;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildRoleButton(
                          title: "Resident",
                          backgroundColor: selectIndex == 1
                              ? const Color(0xFF101C16)
                              : Colors.transparent,
                          borderColor: const Color(0xFF101C16),
                          textColor: selectIndex == 1
                              ? Colors.white
                              : const Color(0xFF101C16),
                          onTap: () {
                            setState(() {
                              selectIndex = 1;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _buildRoleButton(
                          title: "Guard",
                          backgroundColor: selectIndex == 2
                              ? const Color(0xFF101C16)
                              : Colors.transparent,
                          borderColor: const Color(0xFF101C16),
                          textColor: selectIndex == 2
                              ? Colors.white
                              : const Color(0xFF101C16),
                          onTap: () {
                            setState(() {
                              selectIndex = 2;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "EMAIL OR MOBILE NUMBER",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 15.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 12.w, right: 8.w),
                        child: Icon(
                          Icons.mail_outline,
                          color: const Color(0xff101C16),
                          size: 24.sp,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48.w,
                        minHeight: 52.h,
                      ),
                      hintText: "Enter Email or mobile number",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(16, 28, 22, 0.6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: AppColors.heading,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(16, 28, 22, 0.6),
                          width: 1.2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 15.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 12.w, right: 8.w),
                        child: Icon(
                          Icons.lock_outline,
                          color: const Color(0xff101C16),
                          size: 22.sp,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48.w,
                        minHeight: 52.h,
                      ),
                      hintText: "Enter your Password",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(16, 28, 22, 0.6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: AppColors.heading,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(16, 28, 22, 0.6),
                          width: 1.2,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minHeight: 52.h,
                        maxHeight: 52.h,
                        minWidth: 46.w,
                        maxWidth: 46.w,
                      ),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: 46.w,
                          minHeight: 52.h,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.heading,
                          size: 20.sp,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: Checkbox(
                                value: rememberMe,
                                activeColor: AppColors.heading,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                side: const BorderSide(
                                  color: AppColors.heading,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Remember me",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    AssociationForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  SizedBox(
                    height: 52.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      onPressed: isLoading
                          ? null
                          : () async {
                              if (selectIndex == null) {
                                showErrorSnackBar("Please select role");
                                return;
                              }
                              if (emailController.text.trim().isEmpty) {
                                return;
                              }
                              if (passwordController.text.trim().isEmpty) {
                                return;
                              }
                              // if (rememberMe == false) {
                              //   showErrorSnackBar("Please checked Remember Me");
                              //   return;
                              // }

                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final service = ref.read(authServiceProvider);
                                final selectedRole = selectIndex == 0
                                    ? "association_head"
                                    : selectIndex == 1
                                    ? "apartment_resident"
                                    : "security";
                                final response = await service.login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  role: selectedRole,
                                );
                                if (response.status == true) {
                                  var box = Hive.box("associationdata");
                                  await box.put("token", response.data!.token);
                                  await box.put("id", response.data!.user!.id);
                                  await box.put(
                                    "name",
                                    response.data!.user!.name,
                                  );
                                  await box.put(
                                    "phone",
                                    response.data!.user!.phone,
                                  );
                                  final userRole =
                                      (response.data?.user?.role != null &&
                                          response.data!.user!.role!
                                              .toString()
                                              .trim()
                                              .isNotEmpty)
                                      ? response.data!.user!.role
                                      : selectedRole;
                                  await box.put("role", userRole);
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => selectIndex == 0
                                            ? const AssociationBottomNavBar()
                                            : selectIndex == 1
                                            ? const ResidentBottomNavBar()
                                            : const GuardBottomNavState(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                }
                              } catch (e) {
                                log(e.toString());
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Login",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: const Color(0xffFFFFFF),
                                letterSpacing: -0.24,
                              ),
                            ),
                    ),
                  ),

                  // SizedBox(
                  //   height: 52.h,
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.heading,
                  //       elevation: 2,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.r),
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //           builder: (context) => GuardBottomNavState(),
                  //         ),
                  //       );
                  //     },

                  //     child: Text(
                  //       "Login",
                  //       style: GoogleFonts.outfit(
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 15.sp,
                  //         color: Color(0xffFFFFFF),
                  //         letterSpacing: -0.24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000),
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 80.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "SECURE PRIVATE PROPERTY MANAGEMENT",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(16, 28, 22, 0.5),
                        letterSpacing: 2.16,
                      ),
                    ),
                  ),
                  SizedBox(height: 33.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String title,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

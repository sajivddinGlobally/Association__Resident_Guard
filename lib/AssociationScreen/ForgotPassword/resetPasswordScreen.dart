import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/AssociationLogin.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import '../../Core/AuthService/AuthServiceProvider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  bool isLoading = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              height: 170.h,
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
            // Center(
            //   child: ClipOval(
            //     child: Image.asset(
            //       // "assets/property_img.png",
            //       "assets/logo.png",
            //       width: 75.w,
            //       height: 75.w,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
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
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RESET PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 22.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Create a new password for your account.",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff26332D),
                      fontSize: 15.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    "NEW PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      fontSize: 16.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: newPasswordController,
                    cursorColor: AppColors.heading,
                    cursorHeight: 20.h,
                    cursorWidth: 1.5.w,
                    obscureText: !isNewPasswordVisible,
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
                      hintText: "Enter your new Password",
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
                            isNewPasswordVisible = !isNewPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isNewPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.heading,
                          size: 22.sp,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "CONFIRM NEW PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      fontSize: 16.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: confirmPasswordController,
                    cursorColor: AppColors.heading,
                    cursorHeight: 20.h,
                    cursorWidth: 1.5.w,
                    obscureText: !isConfirmPasswordVisible,
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
                      hintText: "Confirm your new Password",
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
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.heading,
                          size: 22.sp,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),

                  SizedBox(height: 36.h),
                  SizedBox(
                    height: 52.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),

                      onPressed: isLoading
                          ? null
                          : () async {
                              final newPassword = newPasswordController.text
                                  .trim();
                              final confirmPassword = confirmPasswordController
                                  .text
                                  .trim();

                              if (newPassword.isEmpty) {
                                return;
                              }
                              if (confirmPassword.isEmpty) {
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                showErrorSnackBar("Passwords do not match");
                                return;
                              }

                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final service = ref.read(authServiceProvider);
                                final response = await service.resetPassword(
                                  newPassword: newPassword,
                                  confirmPassword: confirmPassword,
                                  email: widget.email,
                                );
                                if (response.status == true) {
                                  showSuccessSnackBar(
                                    response.message ??
                                        "Password reset successfully",
                                  );
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
                          ? Center(
                              child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  color: AppColors.heading,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            )
                          : Text(
                              "Reset Password",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 17.sp,
                                color: const Color(0xffFFFFFF),
                                letterSpacing: -0.2,
                              ),
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
}

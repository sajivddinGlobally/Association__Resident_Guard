import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:svg_flutter/svg.dart';

import '../../Core/AuthService/AuthServiceProvider.dart';

class AssociationChangePassword extends ConsumerStatefulWidget {
  const AssociationChangePassword({super.key});

  @override
  ConsumerState<AssociationChangePassword> createState() =>
      _AssociationChangePasswordState();
}

class _AssociationChangePasswordState
    extends ConsumerState<AssociationChangePassword> {
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 44.w,
                  height: 44.h,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Security & Password",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Manage your account security",
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.heading, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/SvgImage/icons8-lock.svg",
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Security & Password",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Manage password and account security",
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
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Secure",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
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
              SizedBox(height: 24.h),
              Text(
                "Change Password",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Color(0xFF000000), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextfield(
                      controller: currentPassController,
                      label: "Current Password",
                      hintText: "Current Password",
                      isPasswordVisible: isCurrentPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isCurrentPasswordVisible = !isCurrentPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextfield(
                      controller: newPassController,
                      label: "New Password",
                      hintText: "Enter New Password",
                      isPasswordVisible: isNewPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextfield(
                      controller: confirmPassController,
                      label: "Confirm New Password",
                      hintText: "Confirm New Password",
                      isPasswordVisible: isConfirmPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () async {
                    if (newPassController.text != confirmPassController.text) {
                      showErrorSnackBar('Passwords do not match');
                      return;
                    }
                    if (newPassController.text.isEmpty ||
                        confirmPassController.text.isEmpty ||
                        currentPassController.text.isEmpty) {
                      showErrorSnackBar('Please fill all the fields');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final service = ref.read(authServiceProvider);
                      final response = await service.changePassword(
                        currentPassword: currentPassController.text,
                        newPassword: newPassController.text,
                        confirmNewPassword: confirmPassController.text,
                      );
                      if (context.mounted) {
                        showSuccessSnackBar('Password changed successfully');
                        if (response.status == true) {
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      log(e.toString());
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          "Update Password",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffFFFFFF),
                            fontSize: 17.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextfield({
    required String label,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityChanged,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff101C16),
            letterSpacing: -0.2,
          ),
          controller: controller,
          cursorColor: AppColors.heading,
          cursorHeight: 20.h,
          cursorWidth: 1.5.w,
          obscureText: !isPasswordVisible,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
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
              constraints: BoxConstraints(minWidth: 46.w, minHeight: 52.h),
              onPressed: onVisibilityChanged,
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
      ],
    );
  }
}

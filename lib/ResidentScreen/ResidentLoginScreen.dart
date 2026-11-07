import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentHomeScreen.dart';

class Residentloginscreen extends StatefulWidget {
  const Residentloginscreen({super.key});

  @override
  State<Residentloginscreen> createState() => _ResidentloginscreenState();
}

class _ResidentloginscreenState extends State<Residentloginscreen> {
  bool isPasswordVisible = false;
  bool rememberMe = false;
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
            Center(
              child: ClipOval(
                child: Image.asset(
                  // "assets/property_img.png",
                  "assets/logo.png",
                  width: 75.w,
                  height: 75.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 70.h),
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
                      fontSize: 17.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "EMAIL OR MOBILE NUMBER",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 17.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                        letterSpacing: -0.2,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,

                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Icon(
                            Icons.mail_outline,
                            color: const Color(0xff26332D),
                            size: 21.sp,
                          ),
                        ),

                        prefixIconConstraints: BoxConstraints(
                          minWidth: 41.w, // 10 left + 21 icon + 10 right
                          minHeight: 44.h,
                        ),

                        hintText: "Enter Email or mobile number",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(color: AppColors.heading),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      fontSize: 17.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                        letterSpacing: -0.2,
                      ),
                      obscureText: !isPasswordVisible,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Icon(
                            Icons.lock_outline,
                            color: const Color(0xff26332D),
                            size: 18.sp,
                          ),
                        ),

                        prefixIconConstraints: BoxConstraints(
                          minWidth: 38.w, // 10 left + 18 icon + 10 gap
                          minHeight: 44.h,
                        ),

                        hintText: "Enter your Password",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(color: AppColors.heading),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                          ),
                        ),

                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 40.w,
                            minHeight: 44.h,
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
                            size: 16.sp,
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 12.w,
                              height: 12.h,
                              child: Checkbox(
                                value: rememberMe,
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
                                  width: 1.2,
                                ),
                              ),
                            ),

                            SizedBox(width: 10.w),

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
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) =>
                            //         AssociationForgotPasswordPage(),
                            //   ),
                            // );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    height: 48.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ResidentBottomNavBar(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: const Color(0xffFFFFFF),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // SizedBox(height: 30.h),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //         margin: EdgeInsets.only(left: 38.w),
                  //         height: 2.h,
                  //         color: const Color(0xffB8BCB8),
                  //       ),
                  //     ),

                  //     SizedBox(width: 17.w),

                  //     Text(
                  //       "OR",
                  //       style: GoogleFonts.outfit(
                  //         fontSize: 19.sp,
                  //         fontWeight: FontWeight.w500,
                  //         color: const Color(0xff101C16),
                  //       ),
                  //     ),

                  //     SizedBox(width: 17.w),

                  //     Expanded(
                  //       child: Container(
                  //         margin: EdgeInsets.only(right: 38.w),
                  //         height: 2.h,
                  //         color: const Color(0xffB8BCB8),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 30.h),
                  // Container(
                  //   height: 41.h,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8.r),
                  //     border: Border.all(color: AppColors.heading),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       "LOGIN WITH OTP",
                  //       style: GoogleFonts.outfit(
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 15.sp,
                  //         color: AppColors.heading,
                  //         letterSpacing: -0.24,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 80.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "SECURE PRIVATE PROPERTY MANAGEMENT",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
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
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/AssociationLogin.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/provider/getAssignedProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentLoginScreen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool associationAgreeTerms = false;
  bool ownerAgreeTerms = false;
  bool isOwnerPasswordVisible = false;
  bool isOwnerConfirmPasswordVisible = false;
  int selectIndex = 0;
  bool isLoading = false;
  String? complexId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController associationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController apartmentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    associationController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUnassignedData = ref.watch(getAssignedProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ClipOval(
                    //   child: Image.asset(
                    //     // "assets/property_img.png",
                    //     "assets/logo.png",
                    //     width: 75.w,
                    //     height: 75.w,
                    //     fit: BoxFit.cover,
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
                    SizedBox(height: 12.h),
                    Text(
                      "Create Account",
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.39,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    selectIndex == 0
                        ? SizedBox(
                            width: 380.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              "REGISTER YOUR ASSOCIATION PROFILE TO MANAGE PROPERTIES, SERVICES, INSPECTIONS AND MAINTENANCE ACTIVITIES.",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(42, 41, 51, 0.75),
                                letterSpacing: -0.2,
                              ),
                            ),
                          )
                        : Text(
                            "REGISTER AS A RESIDENT",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(42, 41, 51, 0.75),
                              letterSpacing: -0.2,
                            ),
                          ),
                  ],
                ),
              ),
              // SizedBox(height: 20.h),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20.w),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: _buildButton(
              //           title: "Association Head",
              //           backgroundColor: selectIndex == 0
              //               ? Color(0xFF101C16)
              //               : Colors.transparent,
              //           borderColor: const Color(0xFF101C16),
              //           textColor: selectIndex == 0
              //               ? Colors.white
              //               : Color(0xFF101C16),
              //           onTap: () {
              //             setState(() {
              //               selectIndex = 0;
              //             });
              //           },
              //         ),
              //       ),
              //       SizedBox(width: 20.w),
              //       Expanded(
              //         child: _buildButton(
              //           title: "Resident",
              //           backgroundColor: selectIndex == 1
              //               ? Color(0xFF101C16)
              //               : Colors.transparent,
              //           borderColor: const Color(0xFF101C16),
              //           textColor: selectIndex == 1
              //               ? Colors.white
              //               : Color(0xFF101C16),
              //           onTap: () {
              //             setState(() {
              //               selectIndex = 1;
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20.w),
              selectIndex == 0
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 13.w,
                        vertical: 13.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(
                            number: "01",
                            title: "PROPERTY INFORMATION",
                          ),
                          SizedBox(height: 15.w),
                          fieldLabel("FULL NAME"),
                          customTextField(
                            controller: nameController,
                            hintText: "Enter Your Full Name",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your full name";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          fieldLabel("MOBILE NUMBER"),
                          customTextField(
                            controller: mobileController,
                            hintText: "+91-00000-00000",
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your mobile number";
                              }
                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return "Please enter a valid 10-digit mobile number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),

                          fieldLabel("EMAIL ADDRESS"),
                          customTextField(
                            controller: emailController,
                            hintText: "Enter Email address",
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email address";
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          sectionHeader(
                            number: "02",
                            title:
                                "Residential/Commercial management team Information",
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF000000),
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                child: Icon(
                                  Icons.home_outlined,
                                  size: 14.sp,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                              SizedBox(width: 9.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Residential/Commercial management team Details",
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    Text(
                                      "Enter the residential Residential/Commercial management team information",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          42,
                                          41,
                                          51,
                                          0.75,
                                        ),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          fieldLabel(
                            "RESIDENTIAL/COMMERCIAL MANAGEMENT TEAM / COMPLEX NAME",
                          ),
                          getUnassignedData.when(
                            data: (data) {
                              return DropdownButtonFormField<String>(
                                value: complexId,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select an apartment / flat";
                                  }
                                  return null;
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: const Color(0xFF000000),
                                  size: 20.sp,
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff101C16),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Select Complex Name',
                                  hintStyle: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                                    letterSpacing: -0.3,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                items: data.data?.map((data) {
                                  return DropdownMenuItem<String>(
                                    value: data.id.toString(),
                                    child: Text(
                                      data.name ?? '',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    complexId = value;
                                  });
                                },
                              );
                            },
                            error: (e, s) {
                              log("error $e");
                              return Center(
                                child: Text("Something went wrong"),
                              );
                            },
                            loading: () {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.heading,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          fieldLabel("LOCATION"),
                          customTextField(
                            controller: locationController,
                            hintText: "City / State",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your location";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),
                          sectionHeader(
                            number: "03",
                            title: "ASSOCIATION INFORMATION",
                          ),
                          SizedBox(height: 13.h),
                          fieldLabel("PASSWORD"),
                          customTextField(
                            controller: passwordController,
                            hintText: "Create a strong password",
                            obscureText: !isPasswordVisible,
                            showVisibilityIcon: true,
                            onVisibilityTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 13.h),
                          fieldLabel("CONFIRM PASSWORD"),
                          customTextField(
                            controller: confirmPasswordController,
                            hintText: "Re-enter your password",
                            obscureText: !isConfirmPasswordVisible,
                            showVisibilityIcon: true,
                            onVisibilityTap: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your confirm password";
                              }
                              if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 19.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 25.w,
                                height: 25.w,
                                color: Colors.white,
                                child: Checkbox(
                                  value: associationAgreeTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      associationAgreeTerms = value ?? false;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(
                                    color: Color(0xFF000000),
                                    width: 1,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      color: Color.fromRGBO(42, 41, 51, 0.7),
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      const TextSpan(text: "I agree to the "),
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2A2933),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            " and acknowledge the\nassociation management platform policies.",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.w),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      if (ownerAgreeTerms) {
                                        showErrorSnackBar(
                                          "Please agree to the terms and conditions",
                                        );
                                        return;
                                      }
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        final service = ref.read(
                                          authServiceProvider,
                                        );
                                        final response = await service.register(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phone: mobileController.text.trim(),
                                          password: passwordController.text
                                              .trim(),
                                          confirmPassword:
                                              confirmPasswordController.text
                                                  .trim(),
                                          complexId: complexId!,
                                          role: 'association_head',
                                          address: locationController.text
                                              .trim(),
                                        );
                                        if (response.status == true) {
                                          showSuccessSnackBar(
                                            response.message ?? "Sucess",
                                          );
                                          if (context.mounted) {
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF101C16),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: isLoading
                                  ? Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.5,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "CREATE ACCOUNT  →",
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF101C16),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ACCOUNT INFORMATION",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          fieldLabel("FULL NAME"),
                          customTextField(
                            controller: nameController,
                            hintText: "Enter Your Full Name",
                          ),

                          SizedBox(height: 10.h),

                          fieldLabel("EMAIL ADDRESS"),
                          customTextField(
                            controller: emailController,
                            hintText: "Enter Your Email Address",
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 10.h),

                          fieldLabel("MOBILE NUMBER"),
                          customTextField(
                            controller: mobileController,
                            hintText: "Enter Your Mobile Number",
                            keyboardType: TextInputType.phone,
                          ),

                          SizedBox(height: 10.h),

                          fieldLabel("PASSWORD"),
                          customTextField(
                            controller: passwordController,
                            hintText: "Current Password",
                            obscureText: !isPasswordVisible,
                            showVisibilityIcon: true,
                            onVisibilityTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),

                          SizedBox(height: 10.h),

                          fieldLabel("CONFIRM PASSWORD"),
                          customTextField(
                            controller: confirmPasswordController,
                            hintText: "Confirm Your Password",
                            obscureText: !isConfirmPasswordVisible,
                            showVisibilityIcon: true,
                            onVisibilityTap: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),

                          SizedBox(height: 16.h),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 27.w,
                                height: 27.w,
                                child: Checkbox(
                                  value: associationAgreeTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      associationAgreeTerms = value ?? false;
                                    });
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: const BorderSide(
                                    color: Color(0xFF101C16),
                                    width: 1,
                                  ),
                                ),
                              ),

                              SizedBox(width: 8.w),

                              Expanded(
                                child: Text(
                                  "I agree to the Terms & Conditions and Privacy Policy.",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF101C16),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15.h),

                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => Residentloginscreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF101C16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                "Create Account",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  if (selectIndex == 0) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AssociationLogin(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Residentloginscreen(),
                      ),
                    );
                  }
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account?  ",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.8),
                          ),
                        ),
                        TextSpan(
                          text: "Login",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
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
      ),
    );
  }

  Widget sectionHeader({required String number, required String title}) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF000000), width: 1.2.w),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            number,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
              letterSpacing: -0.2,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.heading,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onVisibilityTap,
    bool showVisibilityIcon = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.outfit(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 0.55),
          letterSpacing: -0.2,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        suffixIcon: showVisibilityIcon
            ? InkWell(
                onTap: onVisibilityTap,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22.sp,
                  color: const Color(0xFF000000),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          minHeight: 52.h,
          maxHeight: 52.h,
          minWidth: 46.w,
          maxWidth: 46.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: const Color.fromRGBO(16, 28, 22, 0.6),
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: AppColors.heading, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
      ),
    );
  }
}

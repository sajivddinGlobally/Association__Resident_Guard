import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/GuardScreen/provider/GetGuardShiftsProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

class AddGuardScreen extends ConsumerStatefulWidget {
  const AddGuardScreen({super.key});

  @override
  ConsumerState<AddGuardScreen> createState() => _AddGuardScreenState();
}

class _AddGuardScreenState extends ConsumerState<AddGuardScreen> {
  final _formKeyGuard = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController guardPostController = TextEditingController();
  final TextEditingController shiftIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedShiftId;
  bool isPasswordVisible = false;
  bool agreeTerms = false;
  bool isLoading = false;
  File? avatarFile;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    guardPostController.dispose();
    shiftIdController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(16, 28, 22, 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Select Guard Avatar",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, ImageSource.camera),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(16, 28, 22, 0.4),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 28.sp,
                                color: AppColors.heading,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Camera",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.pop(context, ImageSource.gallery),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(16, 28, 22, 0.4),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 28.sp,
                                color: AppColors.heading,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Gallery",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          avatarFile = File(picked.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final guardShiftState = ref.watch(getGuardShifirProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          automaticallyImplyLeading: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    alignment: Alignment.center,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Guard",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "All Guard Information",
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
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKeyGuard,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                Container(
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
                        "GUARD INFORMATION",
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

                      // 1. Name
                      fieldLabel("FULL NAME"),
                      customTextField(
                        controller: nameController,
                        hintText: "Enter Guard Full Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter guard full name";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      // 2. Phone
                      fieldLabel("PHONE NUMBER"),
                      customTextField(
                        controller: phoneController,
                        hintText: "Enter Guard Phone Number",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter phone number";
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                            return "Please enter a valid 10-digit phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),

                      // 6. Email
                      fieldLabel("EMAIL ADDRESS"),
                      customTextField(
                        controller: emailController,
                        hintText: "Enter Guard Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter email address";
                          }
                          if (!RegExp(
                            r'^[^@]+@[^@]+\.[^@]+',
                          ).hasMatch(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      // 3. Password
                      fieldLabel("PASSWORD"),
                      customTextField(
                        controller: passwordController,
                        hintText: "Enter Password",
                        obscureText: !isPasswordVisible,
                        showVisibilityIcon: true,
                        onVisibilityTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      // 4. Guard Post
                      fieldLabel("GUARD POST"),
                      customTextField(
                        controller: guardPostController,
                        hintText: "Enter Guard Post (e.g. Main Gate 1)",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter guard post";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      // 5. Shift ID Dropdown
                      fieldLabel("SELECT SHIFT"),
                      guardShiftState.when(
                        data: (data) {
                          return DropdownButtonFormField<String>(
                            initialValue: selectedShiftId,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a shift";
                              }
                              return null;
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF000000),
                              size: 22.sp,
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
                              hintText: 'Select Shift',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 0.55),
                                letterSpacing: -0.2,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
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
                                borderSide: BorderSide(
                                  color: AppColors.heading,
                                  width: 1.5.w,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.w,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.5.w,
                                ),
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return (data.shifts ?? []).map((shift) {
                                final title =
                                    shift.timings != null &&
                                        shift.timings!.isNotEmpty
                                    ? "${shift.name ?? ''} (${shift.timings})"
                                    : (shift.name ?? '');
                                return Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                );
                              }).toList();
                            },
                            items: (data.shifts ?? []).map((shift) {
                              final title =
                                  shift.timings != null &&
                                      shift.timings!.isNotEmpty
                                  ? "${shift.name ?? ''} (${shift.timings})"
                                  : (shift.name ?? '');
                              return DropdownMenuItem<String>(
                                value: shift.id.toString(),
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedShiftId = value;
                                shiftIdController.text = value ?? '';
                              });
                            },
                          );
                        },
                        error: (e, s) {
                          log("Shift fetch error: $e");
                          return Center(
                            child: Text(
                              "Failed to load shifts",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                        loading: () {
                          return Center(
                            child: SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: CircularProgressIndicator(
                                color: AppColors.heading,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      // 7. Avatar (File)
                      fieldLabel("AVATAR (PROFILE PHOTO)"),
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color.fromRGBO(16, 28, 22, 0.6),
                              width: 1.2.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: avatarFile != null
                              ? Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.r),
                                      child: Image.file(
                                        avatarFile!,
                                        width: 48.w,
                                        height: 48.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            avatarFile!.path
                                                .split(
                                                  Platform.isWindows
                                                      ? '\\'
                                                      : '/',
                                                )
                                                .last,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.outfit(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff101C16),
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            "Tap to change photo",
                                            style: GoogleFonts.outfit(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffB8860B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 20.sp,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          avatarFile = null;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      width: 42.w,
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          16,
                                          28,
                                          22,
                                          0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        size: 22.sp,
                                        color: const Color(0xff101C16),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Choose Avatar / File",
                                            style: GoogleFonts.outfit(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.55,
                                              ),
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            "JPG, PNG, WEBP supported",
                                            style: GoogleFonts.outfit(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromRGBO(
                                                42,
                                                41,
                                                51,
                                                0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                            16,
                                            28,
                                            22,
                                            0.4,
                                          ),
                                          width: 1.w,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Browse",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff101C16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 27.w,
                            height: 27.w,
                            child: Checkbox(
                              value: agreeTerms,
                              onChanged: (value) {
                                setState(() {
                                  agreeTerms = value ?? false;
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

                      SizedBox(height: 18.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!_formKeyGuard.currentState!.validate()) {
                                    return;
                                  }
                                  if (!agreeTerms) {
                                    showErrorSnackBar(
                                      "Please agree to the terms and conditions",
                                    );
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  try {
                                    final fileAvtar = avatarFile != null
                                        ? await MultipartFile.fromFile(
                                            avatarFile!.path,
                                            filename: avatarFile!.path
                                                .split('/')
                                                .last,
                                          )
                                        : null;
                                    final service = ref.read(
                                      authServiceProvider,
                                    );
                                    final res = await service.addGuardData(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      password: passwordController.text.trim(),
                                      guardPost: guardPostController.text
                                          .trim(),
                                      shiftId: shiftIdController.text.trim(),
                                      email: emailController.text.trim(),
                                      image: fileAvtar,
                                    );
                                    if (res.status == true) {
                                      showSuccessSnackBar(res.message!);
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      showErrorSnackBar(res.message!);
                                    }
                                  } catch (e, st) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    log(e.toString());
                                    log(st.toString());
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF101C16),
                            elevation: 0,
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
                                  "Add Guard",
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
                SizedBox(height: 24.h),
              ],
            ),
          ),
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
        fontSize: 18.sp,
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
}

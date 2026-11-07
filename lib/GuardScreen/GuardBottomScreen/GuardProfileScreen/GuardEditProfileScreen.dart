import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardProfileScreen/provider/getGuardProfileProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/Provider/guardDashBoardProvider.dart';

class GuardEditProfileScreen extends ConsumerStatefulWidget {
  const GuardEditProfileScreen({super.key});

  @override
  ConsumerState<GuardEditProfileScreen> createState() =>
      _GuardEditProfileScreenState();
}

class _GuardEditProfileScreenState
    extends ConsumerState<GuardEditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  File? selectedImage;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  bool _isNameInitialized = false;

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  void _showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      showErrorSnackBar("Name cannot be empty");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var box = Hive.box("associationdata");
      final currentPhone = box.get("phone")?.toString() ?? "";

      final service = ref.read(authServiceProvider);
      final response = await service.editProfile(
        name: name,
        phone: currentPhone,
        image: selectedImage != null
            ? await MultipartFile.fromFile(selectedImage!.path)
            : null,
      );

      if (response.status == true) {
        box.put("name", name);
        showSuccessSnackBar(response.message ?? "Profile updated successfully");
        ref.invalidate(getGuardProfileProvider);
        ref.invalidate(guardDashboardProvider);
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        showErrorSnackBar(response.message ?? "Failed to update profile");
      }
    } catch (e) {
      showErrorSnackBar("Error: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("associationdata");
    final guardProfileState = ref.watch(getGuardProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
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
                    width: 41.w,
                    height: 41.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(16, 28, 22, 0.3),
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: const Color(0xff101C16),
                      size: 16.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Profile",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Account Setting",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.65),
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
      body: guardProfileState.when(
        data: (profileData) {
          final profile = profileData.data;
          if (!_isNameInitialized && profile?.name != null) {
            nameController.text = profile!.name!;
            _isNameInitialized = true;
          }

          final statusBadgeText =
              "• Guard Access Active (${profile?.shiftName ?? ''})";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // Top Profile Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.heading,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: _showImagePicker,
                                  child: ClipOval(
                                    child: selectedImage != null
                                        ? Image.file(
                                            selectedImage!,
                                            width: 58.w,
                                            height: 58.w,
                                            fit: BoxFit.cover,
                                          )
                                        : (profile?.avatarUrl != null &&
                                              profile!.avatarUrl!.isNotEmpty)
                                        ? Image.network(
                                            profile.avatarUrl!,
                                            width: 58.w,
                                            height: 58.w,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                                      width: 58.w,
                                                      height: 58.w,
                                                      color: Colors.grey,
                                                      child: Icon(
                                                        Icons.security,
                                                        color: Colors.white,
                                                        size: 30.sp,
                                                      ),
                                                    ),
                                          )
                                        : Container(
                                            width: 58.w,
                                            height: 58.w,
                                            color: Colors.grey,
                                            child: Icon(
                                              Icons.security,
                                              color: Colors.white,
                                              size: 30.sp,
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showImagePicker,
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: const BoxDecoration(
                                        color: Color(0xffB8860B),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nameController.text.isNotEmpty
                                        ? nameController.text
                                        : (profile?.name ?? "N/A"),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Security Personnel · ${profile?.guardPost ?? ''}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF514719),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            statusBadgeText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
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
                    "Personal Information",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff888888)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        // Full Name (Editable)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            nameFocusNode.requestFocus();
                            nameController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: nameController.text.length),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 38.w,
                                  width: 38.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEBD9A8),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: const Color(0xffB8860B),
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Full Name",
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff777777),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      TextFormField(
                                        controller: nameController,
                                        focusNode: nameFocusNode,
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          hintText: "Enter Full Name",
                                          hintStyle: GoogleFonts.outfit(
                                            fontSize: 16.sp,
                                            color: const Color(0xffAAAAAA),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    nameFocusNode.requestFocus();
                                    nameController.selection =
                                        TextSelection.fromPosition(
                                          TextPosition(
                                            offset: nameController.text.length,
                                          ),
                                        );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      size: 20.sp,
                                      color: const Color(0xffB8860B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xff555555)),
                        // Designation / Role (Read-Only)
                        _readOnlyItem(
                          icon: Icons.phone,
                          title: "Phone Number",
                          subtitle: box.get("phone") ?? "xxxxxxxxxx",
                        ),
                        const Divider(height: 1, color: Color(0xff555555)),
                        // Designation / Role (Read-Only)
                        _readOnlyItem(
                          icon: Icons.shield_outlined,
                          title: "Designation & Role",
                          subtitle:
                              "${profile?.role ?? 'Security Personnel'} · ${profile?.guardPost ?? 'Gate Duty'}",
                        ),
                        const Divider(height: 1, color: Color(0xff555555)),
                        // Complex / Property (Read-Only)
                        _readOnlyItem(
                          icon: Icons.location_city_outlined,
                          title: "Assigned Property",
                          subtitle:
                              profile?.complexName ?? "Main Gate Premises",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Duty Assignment",
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
                                color: profile?.isOnDuty == true
                                    ? const Color(0xFFD1F4DE)
                                    : const Color(0xFFFDE8E8),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                profile?.isOnDuty == true
                                    ? "ON DUTY"
                                    : "OFF DUTY",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: profile?.isOnDuty == true
                                      ? const Color(0xFF16B866)
                                      : const Color(0xFFE02424),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _infoBlock(
                                "Shift Timing",
                                profile?.shiftTimings ?? "N/A",
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _infoBlock(
                                "Shift Type",
                                profile?.shiftName ?? "N/A",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _infoBlock(
                                "Gate / Post",
                                profile?.guardPost ?? "Gate 1",
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _infoBlock(
                                "Role Assigned",
                                profile?.role ?? "Security",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101C16),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: isLoading ? null : _saveChanges,
                      child: isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Save Changes",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Error loading profile data",
                style: GoogleFonts.outfit(fontSize: 16.sp),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(getGuardProfileProvider);
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.heading),
        ),
      ),
    );
  }

  Widget _readOnlyItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 38.w,
            width: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xffEBD9A8),
              borderRadius: BorderRadius.circular(5.r),
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
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff777777),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff101C16),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, size: 18.sp, color: const Color(0xffAAAAAA)),
        ],
      ),
    );
  }

  Widget _infoBlock(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7C9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }
}

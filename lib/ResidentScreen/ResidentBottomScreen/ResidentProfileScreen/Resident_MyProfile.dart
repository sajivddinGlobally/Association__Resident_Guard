import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentProfileScreen/provider/getResidentProfileProvider.dart';

class ResidentMyprofile extends ConsumerStatefulWidget {
  const ResidentMyprofile({super.key});

  @override
  ConsumerState<ResidentMyprofile> createState() => _ResidentMyprofileState();
}

class _ResidentMyprofileState extends ConsumerState<ResidentMyprofile> {
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

  Future<void> _saveChanges(String? currentPhone) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      showErrorSnackBar("Name cannot be empty");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final service = ref.read(authServiceProvider);
      final response = await service.editProfile(
        name: name,
        phone: currentPhone ?? "",
        image: selectedImage != null
            ? await MultipartFile.fromFile(selectedImage!.path)
            : null,
      );

      if (response.status == true) {
        showSuccessSnackBar(response.message ?? "Profile updated successfully");
        ref.invalidate(getResidentProfileProvider);
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
    final profileState = ref.watch(getResidentProfileProvider);

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
                        "My Profile",
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
                // SizedBox(width: 10.w),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 10.w,
                //     vertical: 6.h,
                //   ),
                //   decoration: BoxDecoration(
                //     color: const Color.fromRGBO(184, 134, 11, 0.3),
                //     borderRadius: BorderRadius.circular(50.r),
                //   ),
                //   child: Text(
                //     "Show Event",
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //     style: GoogleFonts.outfit(
                //       fontWeight: FontWeight.w500,
                //       color: const Color(0xffB8860B),
                //       fontSize: 16.sp,
                //       letterSpacing: -0.2,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: profileState.when(
        data: (profileData) {
          final profile = profileData.data;
          if (!_isNameInitialized && profile?.name != null) {
            nameController.text = profile!.name!;
            _isNameInitialized = true;
          }

          final access = profile?.currentAccess;
          final apartment =
              access?.apartment ??
              access?.unitNumber ??
              profile?.apartment ??
              profile?.unitNumber ??
              "N/A";
          final building = access?.building ?? profile?.building ?? "N/A";
          final property =
              access?.property ??
              access?.community ??
              profile?.community ??
              "N/A";
          final role =
              access?.role ??
              profile?.roleDisplay ??
              profile?.role ??
              "Resident";
          final statusBadgeText =
              profile?.statusBadge ?? "•  Resident Access Active";

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
                                                    Image.asset(
                                                      "assets/profile (2).png",
                                                      width: 58.w,
                                                      height: 58.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                          )
                                        : Image.asset(
                                            "assets/profile (2).png",
                                            width: 58.w,
                                            height: 58.w,
                                            fit: BoxFit.cover,
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
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
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
                                      ),
                                      SizedBox(width: 8.w),
                                      _buildOccupancyBadge(
                                        profile?.myResidence?.residentType,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    profile?.subtitle ??
                                        "Resident · Apartment $apartment",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
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
                  SizedBox(height: 16.h),
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
                              horizontal: 22.w,
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
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Full Name",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
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
                                          fontSize: 18.sp,
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
                                            fontSize: 17.sp,
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

                        Divider(height: 1, color: const Color(0xff555555)),

                        // Email Address (Read-Only)
                        menuItem(
                          icon: Icons.home_outlined,
                          title: "Email Address",
                          subtitle: profile?.email ?? "N/A",
                          isReadOnly: true,
                        ),

                        Divider(height: 1, color: const Color(0xff555555)),

                        // Phone Number (Read-Only)
                        menuItem(
                          icon: Icons.phone_outlined,
                          title: "Phone Number",
                          subtitle: profile?.phone ?? "N/A",
                          isReadOnly: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Current Access",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  residentAccess(
                    status: access?.status ?? access?.accountStatus ?? "ACTIVE",
                    apartment: apartment,
                    building: building,
                    property: property.toString(),
                    role: role,
                  ),
                  SizedBox(height: 25.h),
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101C16),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () => _saveChanges(profile?.phone),
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
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.2,
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
        error: (error, stackTrace) => Center(
          child: Text(
            "Failed to load profile",
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              color: AppColors.heading,
            ),
          ),
        ),
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 15.h),
      child: InkWell(
        onTap: onTap,
        child: Row(
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
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff777777),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isReadOnly)
              Icon(
                Icons.lock_outline,
                size: 18.sp,
                color: const Color(0xff999999),
              )
            else
              Icon(
                Icons.chevron_right,
                size: 27.sp,
                color: const Color(0xff101C16),
              ),
          ],
        ),
      ),
    );
  }

  Widget residentAccess({
    required String status,
    required String apartment,
    required String building,
    required String property,
    required String role,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF101C16), width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Resident Access",
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D4A0),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB8860B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Row(
            children: [
              Expanded(child: _accessItem("Apartment", apartment)),
              SizedBox(width: 20.w),
              Expanded(child: _accessItem("Building", building)),
            ],
          ),
          SizedBox(height: 11.h),
          Row(
            children: [
              Expanded(child: _accessItem("Property", property)),
              SizedBox(width: 20.w),
              Expanded(child: _accessItem("Role", role)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accessItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7C9),
        borderRadius: BorderRadius.circular(14.r),
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
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 19.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyBadge(String? type) {
    if (type == null || type.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final isTenant = type.toLowerCase() == "tenant";
    final isOwner = type.toLowerCase() == "owner";
    if (!isTenant && !isOwner) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isOwner ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isOwner ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isOwner ? "👑" : "📄", style: TextStyle(fontSize: 15.sp)),
          SizedBox(width: 4.w),
          Text(
            isOwner ? "Owner" : "Tenant",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isOwner
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}

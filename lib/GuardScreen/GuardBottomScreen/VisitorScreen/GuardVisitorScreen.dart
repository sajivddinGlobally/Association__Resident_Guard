import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/GuardScanPassScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/Provider/getFlatApartmentProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/VisitorApprovalPassScreen.dart';
import 'package:property_association_or_resident/GuardScreen/Model/getFlatApartmentModel.dart';

class Guardvisitorscreen extends ConsumerStatefulWidget {
  const Guardvisitorscreen({super.key});

  @override
  ConsumerState<Guardvisitorscreen> createState() => _GuardvisitorscreenState();
}

class _GuardvisitorscreenState extends ConsumerState<Guardvisitorscreen> {
  final TextEditingController visitorNameController = TextEditingController();
  final TextEditingController visitorPhoneController = TextEditingController();
  final TextEditingController flatNumberController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  bool isFrequentVisitor = false;
  String? frequentRole = "Maid";
  bool isVisitorLoading = false;

  String? selectedVisitType;
  File? visitorPhoto;
  Datum? selectedFlat;
  final FocusNode flatFocusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  late String entryTime;

  @override
  void initState() {
    super.initState();
    entryTime = _formatCurrentTime();
    flatNumberController.addListener(() {
      if (selectedFlat != null &&
          flatNumberController.text.trim().toLowerCase() !=
              (selectedFlat!.flatNumber ??
                      selectedFlat!.propertyNameNumber ??
                      '')
                  .toLowerCase()) {
        setState(() {
          selectedFlat = null;
        });
      }
    });
  }

  @override
  void dispose() {
    visitorNameController.dispose();
    visitorPhoneController.dispose();
    flatNumberController.dispose();
    vehicleNumberController.dispose();
    purposeController.dispose();
    flatFocusNode.dispose();
    super.dispose();
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour == 0
        ? 12
        : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  Future<void> pickVisitorPhoto() async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Photo",
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),

                SizedBox(height: 8.h),

                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.heading,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Camera",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.heading,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Gallery",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        visitorPhoto = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final getFlatApartmentState = ref.watch(getFlatApartmentProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 72.h,
        titleSpacing: 20.w,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register Visitor",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    "Create visitor entry & request resident approval",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 18.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const GuardScanPassScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.heading,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 17.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Scan Pass",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Visitor Photo",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),

                        Text(
                          "Required",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: pickVisitorPhoto,
                          child: Container(
                            height: 74.h,
                            width: 108.w,
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: visitorPhoto != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(17.r),
                                    child: Image.file(
                                      visitorPhoto!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        size: 25.sp,
                                        color: Colors.black,
                                      ),

                                      SizedBox(height: 4.h),

                                      Text(
                                        "Capture Photo",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Take visitor photo",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              Text(
                                "Capture a clear photo of the visitor before creating the entry.",
                                style: GoogleFonts.outfit(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              SizedBox(height: 6.h),
                              SizedBox(
                                height: 36.h,
                                width: 139.w,
                                child: ElevatedButton(
                                  onPressed: pickVisitorPhoto,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.heading,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                  ),
                                  child: Text(
                                    "+ Capture / Upload",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visitor Information",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Visitor Name *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _textField(
                      controller: visitorNameController,
                      hintText: "Enter Visitor Full Name",
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Visitor Mobile Number *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _textField(
                      controller: visitorPhoneController,
                      hintText: "Enter Visitor Mobile Number ",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Visit Type',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBg,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: const Color(0xff92929A),
                                    width: 1,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedVisitType,
                                    isExpanded: true,

                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 11.w,
                                      ),
                                      child: Text(
                                        'Select Type',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          color: const Color(0xff888891),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),

                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 22,
                                        color: Color(0xff77777F),
                                      ),
                                    ),

                                    items:
                                        [
                                          'Personal',
                                          'Business',
                                          'Delivery',
                                          'Maintenance',
                                          'Other',
                                        ].map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 11.w,
                                              ),
                                              child: Text(
                                                type,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 14.sp,
                                                  color: const Color(
                                                    0xff222222,
                                                  ),
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),

                                    onChanged: (value) {
                                      setState(() {
                                        selectedVisitType = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vehicle',
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              SizedBox(
                                height: 46.h,
                                child: _textField(
                                  controller: vehicleNumberController,
                                  hintText: "Optional",
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Purpose of Visit",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: purposeController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        color: AppColors.heading,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Briefly mention purpose of visit",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: const Color(0xff888891),
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.2,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 11.w,
                          vertical: 10.h,
                        ),

                        filled: true,
                        fillColor: AppColors.scaffoldBg,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color: Color(0xff92929A),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color: AppColors.heading,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Frequent Visitor",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Text(
                              "Mark as regular staff (Maid, Driver, etc.)",
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                color: const Color(0xFF666666),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.8.h,
                          child: Switch(
                            value: isFrequentVisitor,
                            activeThumbColor: AppColors.heading,
                            onChanged: (val) {
                              setState(() {
                                isFrequentVisitor = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (isFrequentVisitor) ...[
                      SizedBox(height: 10.h),
                      Text(
                        "Frequent Role",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xff92929A)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: frequentRole,
                            isExpanded: true,
                            items:
                                [
                                  'Maid',
                                  'Driver',
                                  'Cook',
                                  'Milkman',
                                  'Plumber',
                                  'Electrician',
                                  'Other Staff',
                                ].map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(
                                      role,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                frequentRole = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Apartment Details",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (getFlatApartmentState.isLoading)
                          SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.heading,
                            ),
                          )
                        else if (getFlatApartmentState.hasValue)
                          Text(
                            "${(getFlatApartmentState.value?.data ?? getFlatApartmentState.value?.properties ?? []).length} Flats",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      "Flat / Apartment *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 7.h),

                    // RawAutocomplete for Flat / Apartment with dynamic suggestions
                    RawAutocomplete<Datum>(
                      textEditingController: flatNumberController,
                      focusNode: flatFocusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final allFlats =
                            getFlatApartmentState.value?.data ??
                            getFlatApartmentState.value?.properties ??
                            [];
                        if (textEditingValue.text.isEmpty) {
                          return allFlats;
                        }
                        final q = textEditingValue.text.trim().toLowerCase();
                        return allFlats.where((flat) {
                          final fNo =
                              (flat.flatNumber ?? flat.propertyNameNumber ?? '')
                                  .toLowerCase();
                          final res = (flat.residentName ?? '').toLowerCase();
                          final ph = (flat.residentPhone ?? '').toLowerCase();
                          final loc = (flat.location ?? '').toLowerCase();
                          final st =
                              (flat.status ?? flat.statusBadge ?? '')
                                  .toLowerCase();
                          return fNo.contains(q) ||
                              res.contains(q) ||
                              ph.contains(q) ||
                              loc.contains(q) ||
                              st.contains(q);
                        });
                      },
                      displayStringForOption: (Datum option) =>
                          option.flatNumber ?? option.propertyNameNumber ?? '',
                      fieldViewBuilder:
                          (
                            BuildContext context,
                            TextEditingController controller,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextField(
                              key: _autocompleteKey,
                              controller: controller,
                              focusNode: focusNode,
                              onSubmitted: (_) => onFieldSubmitted(),
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                color: AppColors.heading,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Enter flat no. or resident name...",
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  color: const Color(0xff888891),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.2,
                                ),
                                prefixIcon: Icon(
                                  Icons.apartment_rounded,
                                  size: 20.sp,
                                  color: controller.text.isNotEmpty
                                      ? AppColors.heading
                                      : const Color(0xff888891),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.text.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          controller.clear();
                                          setState(() {
                                            selectedFlat = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            size: 20.sp,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Container(
                                        height: 32.h,
                                        width: 32.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                          color: const Color(0xFFF3F4F6),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.search,
                                            color: AppColors.heading,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                filled: true,
                                fillColor: AppColors.scaffoldBg,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                    color: controller.text.isNotEmpty
                                        ? AppColors.heading
                                        : const Color(0xff92929A),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: AppColors.heading,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder:
                          (
                            BuildContext context,
                            AutocompleteOnSelected<Datum> onSelected,
                            Iterable<Datum> options,
                          ) {
                            final renderBox =
                                _autocompleteKey.currentContext
                                        ?.findRenderObject()
                                    as RenderBox?;
                            final fieldWidth =
                                renderBox?.size.width ??
                                (MediaQuery.of(context).size.width - 72.w);

                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 6.0,
                                shadowColor: Colors.black26,
                                borderRadius: BorderRadius.circular(12.r),
                                color: Colors.white,
                                child: Container(
                                  width: fieldWidth,
                                  constraints: BoxConstraints(maxHeight: 260.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: options.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 14.w,
                                          ),
                                          child: Text(
                                            "No matching flat or resident found",
                                            style: GoogleFonts.outfit(
                                              fontSize: 13.sp,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                height: 1,
                                                color: Color(0xFFF3F4F6),
                                              ),
                                          itemBuilder: (BuildContext context, int index) {
                                            final Datum flat = options
                                                .elementAt(index);
                                            final flatNumber =
                                                flat.flatNumber ??
                                                flat.propertyNameNumber ??
                                                'Flat';
                                            final residentName =
                                                (flat.residentName != null &&
                                                    flat.residentName!
                                                        .trim()
                                                        .isNotEmpty)
                                                ? flat.residentName!
                                                : 'Vacant / Unassigned';
                                            final isSelected =
                                                selectedFlat?.id != null
                                                ? selectedFlat?.id == flat.id
                                                : flatNumberController.text ==
                                                      flatNumber;

                                            return InkWell(
                                              onTap: () {
                                                onSelected(flat);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h,
                                                ),
                                                color: isSelected
                                                    ? const Color(0xFFF0FDF4)
                                                    : Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 36.w,
                                                      height: 36.w,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? const Color(
                                                                0xFFDCFCE7,
                                                              )
                                                            : const Color(
                                                                0xFFF3F4F6,
                                                              ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.r,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .apartment_rounded,
                                                          size: 18.sp,
                                                          color: isSelected
                                                              ? const Color(
                                                                  0xFF16A34A,
                                                                )
                                                              : AppColors
                                                                    .heading,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                flatNumber,
                                                                style: GoogleFonts.outfit(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .heading,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          1.h,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: flat
                                                                      .badgeBgColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4.r,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: flat
                                                                        .badgeBorderColor,
                                                                    width: 0.8,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  flat.displayStatusBadge,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        9.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: flat
                                                                        .badgeTextColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2.h),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                flat.isVacant
                                                                    ? Icons
                                                                        .person_off_outlined
                                                                    : Icons
                                                                        .person_outline_rounded,
                                                                size: 12.sp,
                                                                color: flat.isVacant
                                                                    ? const Color(
                                                                        0xFF9CA3AF,
                                                                      )
                                                                    : const Color(
                                                                        0xFF6B7280,
                                                                      ),
                                                              ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  residentName,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: flat.isVacant
                                                                        ? const Color(
                                                                            0xFF6B7280,
                                                                          )
                                                                        : const Color(
                                                                            0xFF374151,
                                                                          ),
                                                                    fontStyle: flat.isVacant
                                                                        ? FontStyle
                                                                            .italic
                                                                        : FontStyle
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (flat.residentPhone !=
                                                                      null &&
                                                                  flat
                                                                      .residentPhone!
                                                                      .isNotEmpty) ...[
                                                                SizedBox(
                                                                  width: 6.w,
                                                                ),
                                                                Text(
                                                                  flat.residentPhone!,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        11.sp,
                                                                    color: const Color(
                                                                      0xFF9CA3AF,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: const Color(
                                                          0xFF16A34A,
                                                        ),
                                                        size: 18.sp,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                            );
                          },
                      onSelected: (Datum selection) {
                        setState(() {
                          selectedFlat = selection;
                          flatNumberController.text =
                              selection.flatNumber ??
                              selection.propertyNameNumber ??
                              '';
                        });
                        flatFocusNode.unfocus();
                      },
                    ),

                    // Rich Resident Card Preview when a flat is selected
                    if (selectedFlat != null) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedFlat!.isVacant
                                            ? Icons.person_off_outlined
                                            : Icons.person_outline_rounded,
                                        size: 16.sp,
                                        color: AppColors.heading,
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          selectedFlat!.residentName ??
                                              "Vacant / Unassigned",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                            fontStyle: selectedFlat!.isVacant
                                                ? FontStyle.italic
                                                : FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedFlat!.badgeBgColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: selectedFlat!.badgeBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6.w,
                                        height: 6.w,
                                        decoration: BoxDecoration(
                                          color: selectedFlat!.badgeColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        selectedFlat!.displayStatusBadge,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: selectedFlat!.badgeTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            if (selectedFlat!.residentPhone != null &&
                                selectedFlat!.residentPhone!.isNotEmpty) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Mobile: ${selectedFlat!.residentPhone}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            if (selectedFlat!.location != null &&
                                selectedFlat!.location!.isNotEmpty) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "Location: ${selectedFlat!.location}",
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (selectedFlat!.isVacant) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "This unit is currently vacant / unassigned.",
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ] else if (flatNumberController.text.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14.sp,
                            color: const Color(0xFF6B7280),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Manual flat number. Tap to pick from list.",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE2E2E2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entry Information',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(16, 28, 22, 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 20.sp,
                            color: Colors.black,
                          ),

                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'In-Time',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    height: 1.15,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                Text(
                                  'Recorded when the resident approves',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF656565),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            isFrequentVisitor ? entryTime : "--",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isVisitorLoading
                      ? null
                      : () async {
                          final vName = visitorNameController.text.trim();
                          final vPhone = visitorPhoneController.text.trim();
                          final vFlat = flatNumberController.text.trim();

                          if (vName.isEmpty) {
                            showErrorSnackBar("Please enter visitor full name");
                            return;
                          }
                          if (vPhone.isEmpty) {
                            showErrorSnackBar(
                              "Please enter visitor mobile number",
                            );
                            return;
                          }
                          if (vFlat.isEmpty) {
                            showErrorSnackBar(
                              "Please enter flat / apartment number",
                            );
                            return;
                          }

                          final vType = (selectedVisitType ?? "guest")
                              .toLowerCase();
                          final vVehicle = vehicleNumberController.text.trim();
                          final vPurpose = purposeController.text.trim();

                          setState(() {
                            isVisitorLoading = true;
                          });

                          try {
                            final authService = ref.read(authServiceProvider);
                            final response = await authService.addVisitorData(
                              visitorName: vName,
                              visitorPhone: vPhone,
                              flatNumber: vFlat,
                              visitType: vType,
                              vehicleNumber: vVehicle,
                              purpose: vPurpose.isEmpty ? "Visit" : vPurpose,
                              visitorPhoto: visitorPhoto,
                              isFrequent: isFrequentVisitor ? "1" : "0",
                              frequentRole: isFrequentVisitor
                                  ? (frequentRole ?? "Maid")
                                  : "",
                            );

                            String? returnedVisitorId;
                            try {
                              if (response.status == true) {
                                returnedVisitorId = response
                                    .data!
                                    .visitorDetails!
                                    .id
                                    .toString();
                              }
                            } catch (_) {}

                            if (response.status != true ||
                                returnedVisitorId == null ||
                                returnedVisitorId.isEmpty ||
                                returnedVisitorId == "null") {
                              showErrorSnackBar(
                                response.message ??
                                    "Could not register the visitor. Please try again.",
                              );
                              return;
                            }

                            showSuccessSnackBar(
                              isFrequentVisitor
                                  ? "Frequent visitor registered & entry recorded."
                                  : "Visitor registered & approval request sent.",
                            );

                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      Visitorapprovalpassscreen(
                                        visitorId: returnedVisitorId!,
                                        visitorName: vName,
                                        visitorPhone: vPhone,
                                        flatNumber: vFlat,
                                        visitType: selectedVisitType ?? "Guest",
                                        vehicleNumber: vVehicle,
                                        purpose: vPurpose,
                                        initialStatus: isFrequentVisitor
                                            ? "APPROVED"
                                            : "PENDING",
                                      ),
                                ),
                              );
                            }
                          } catch (e) {
                            // showErrorSnackBar(e.toString());
                            log(e.toString());
                          } finally {
                            if (mounted) {
                              setState(() {
                                isVisitorLoading = false;
                              });
                            }
                          }
                        },
                  child: isVisitorLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Send Approval Request',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
              // SizedBox(height: 10.h),
              // SizedBox(
              //   width: double.infinity,
              //   height: 44.h,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.scaffoldBg,
              //       side: BorderSide(color: AppColors.heading, width: 1.w),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8.r),
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: Text(
              //       'Cancel',
              //       style: GoogleFonts.outfit(
              //         fontSize: 16.sp,
              //         fontWeight: FontWeight.w500,
              //         color: AppColors.heading,
              //         letterSpacing: -0.2,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.outfit(
        fontSize: 20.sp,
        color: AppColors.heading,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 14.sp,
          color: const Color(0xff888891),
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 11.w,
          vertical: maxLines > 1 ? 12.h : 0,
        ),
        filled: true,
        fillColor: AppColors.scaffoldBg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xff92929A), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.heading, width: 1.2),
        ),
      ),
    );
  }
}

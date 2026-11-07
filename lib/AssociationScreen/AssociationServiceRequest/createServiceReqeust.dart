import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestProvider.dart';
import '../../Core/AuthService/AuthServiceProvider.dart';
import '../../Core/Constant/appColor.dart';
import '../../Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/Provider/getPropeertyUnitListProvider.dart';

class CreateServiceRequest extends ConsumerStatefulWidget {
  const CreateServiceRequest({super.key});

  @override
  ConsumerState<CreateServiceRequest> createState() =>
      _CreateServiceRequestState();
}

class _CreateServiceRequestState extends ConsumerState<CreateServiceRequest> {
  int selectedPriority = 1;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  bool isLoading = false;

  final List<String> priorities = ["Low", "Medium", "High"];
  int selectedIndex = -1;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedPropertyId;

  final List<String> categories = [
    "Cleaning",
    "Painting",
    "Carpentry",
    "Pest Control",
    "Appliance Service",
    "Electrical Addon",
    "Other",
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {
      "id": "cleaning",
      "label": "cleaning",
      "types": [
        "Full Apartment Deep Cleaning",
        "Kitchen & Chimney Deep Cleaning",
        "Bathroom Sanitization & Descaling",
        "Carpet & Sofa Shampooing",
        "Balcony & Window Glass Washing",
        "Move-in / Move-out Cleaning",
        "Post-Renovation Cleaning",
        "Other Cleaning Service",
      ],
    },
    {
      "id": "painting",
      "label": "painting",
      "types": [
        "Full Apartment Interior Painting",
        "Feature / Accent Wall Painting",
        "Minor Touch-up & Patch Painting",
        "Door & Window Wood Polishing",
        "Balcony Waterproof Coating",
        "Other Painting Service",
      ],
    },
    {
      "id": "carpentry",
      "label": "carpentry",
      "types": [
        "Modular Kitchen Hinge & Drawer Repair",
        "Custom Wardrobe / Shelf Installation",
        "Door Lock & Handle Installation",
        "Furniture Assembly & Dismantling",
        "Curtain Rod & Blind Installation",
        "Other Carpentry Service",
      ],
    },
    {
      "id": "pest_control",
      "label": "pest_control",
      "types": [
        "General Pest Control (Cockroaches & Ants)",
        "Termite Prevention Treatment",
        "Bed Bug Specialized Treatment",
        "Rodent & Rat Control",
        "Mosquito & Fly Fogging",
        "Bird Netting Installation",
        "Other Pest Control",
      ],
    },
    {
      "id": "appliance_service",
      "label": "appliance_service",
      "types": [
        "AC Servicing / Gas Charging",
        "AC Installation / Uninstallation",
        "Washing Machine Installation",
        "RO Water Purifier Servicing",
        "Geyser / Water Heater Installation",
        "TV Wall Mount Setup",
        "Other Appliance Service",
      ],
    },
    {
      "id": "electrical_addon",
      "label": "electrical_addon",
      "types": [
        "New Light Point / Chandelier Installation",
        "Inverter & UPS Setup / Battery Replacement",
        "Smart Home Device & Sensor Installation",
        "Additional Power Socket Installation",
        "Decorative LED Strip Setup",
        "Other Electrical Addition",
      ],
    },
    {
      "id": "other_services",
      "label": "other_services",
      "types": [
        "Handyman General Assistance",
        "Packing & Moving Support",
        "Plant & Balcony Garden Setup",
        "Custom Property Service",
      ],
    },
  ];
  String? selectedCategory;
  String? selectedService;
  final TextEditingController customServiceController = TextEditingController();
  List<String> customServices = [];
  List<String> get availableServices {
    if (selectedCategory == null) {
      return [];
    }
    final normalized = selectedCategory!.toLowerCase().replaceAll(' ', '_');
    final category = serviceCategories.firstWhere(
      (item) => (item["id"] as String).toLowerCase() == normalized,
      orElse: () => {"types": <String>[]},
    );
    final List<String> types = List<String>.from(category["types"] ?? []);
    return [...types, ...customServices];
  }

  String formatCategory(String value) {
    if (value.isEmpty) return value;
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }

  File? selectedFile;
  String? selectedFileName;
  String? selectedFileType;
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffA5A69F),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Add Attachment",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 18.h),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 0.8.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: const Color(0xff101C16),
                      size: 21.sp,
                    ),
                  ),
                  title: Text(
                    "Upload Image",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                  subtitle: Text(
                    "JPG, JPEG or PNG",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color(0xff777777),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 5.h),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument();
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 0.8.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: const Color(0xff101C16),
                      size: 21.sp,
                    ),
                  ),
                  title: Text(
                    "Upload Document",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                  subtitle: Text(
                    "PDF, DOC or DOCX",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color(0xff777777),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final File file = File(image.path);
      final int fileSize = await file.length();
      const int maxSize = 10 * 1024 * 1024;
      if (fileSize > maxSize) {
        showErrorSnackBar("Image size must be less than 10 MB.");
        return;
      }
      setState(() {
        selectedFile = file;
        selectedFileName = image.name;
        selectedFileType = "image";
      });
    } catch (e) {
      showErrorSnackBar("Unable to select image.");
    }
  }

  Future<void> _pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "doc", "docx"],
      );
      if (result == null) {
        return;
      }
      final PlatformFile fileData = result.files.single;
      if (fileData.path == null) {
        showErrorSnackBar("Unable to select document.");
        return;
      }
      final File file = File(fileData.path!);
      final int fileSize = await file.length();
      const int maxSize = 10 * 1024 * 1024;
      if (fileSize > maxSize) {
        showErrorSnackBar("Document size must be less than 10 MB.");
        return;
      }
      setState(() {
        selectedFile = file;
        selectedFileName = fileData.name;
        selectedFileType = "document";
      });
    } catch (e) {
      showErrorSnackBar("Unable to select document.");
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(committeeUnitsListProvider);
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
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Service Request",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "REQUEST A PROPERTY SERVICE",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
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
              SizedBox(height: 30.h),
              Text(
                "Service Information",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                "Property / Unit",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              unitsAsync.when(
                data: (unitData) {
                  final units = unitData.data?.flattenedUnits ?? [];
                  final seenIds = <int>{};
                  final uniqueUnits = units
                      .where((u) => u.id != null && seenIds.add(u.id!))
                      .toList();

                  final bool isValidSelection = selectedPropertyId == null ||
                      uniqueUnits.any((u) => u.id == selectedPropertyId);
                  final currentVal = isValidSelection ? selectedPropertyId : null;

                  return Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: const Color(0xFF101C16),
                        width: 1.w,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: currentVal,
                        isExpanded: true,
                        hint: Text(
                          "Society Common Area / All Units",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(153, 42, 41, 51),
                            letterSpacing: -0.3,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: const Color.fromARGB(153, 42, 41, 51),
                        ),
                        dropdownColor: Colors.white,
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(
                              "Society Common Area / All Units",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101C16),
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          ...uniqueUnits.map((u) {
                            String label = u.unitNumber ?? u.badge ?? "Unit ${u.id}";
                            if (u.block != null && u.block!.isNotEmpty) {
                              label += " · ${u.block}";
                            }
                            if (u.propertyOwner != null &&
                                u.propertyOwner!.isNotEmpty &&
                                u.propertyOwner != "Unassigned") {
                              label += " (${u.propertyOwner})";
                            }
                            return DropdownMenuItem<int?>(
                              value: u.id,
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF101C16),
                                  letterSpacing: -0.3,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedPropertyId = val;
                          });
                        },
                      ),
                    ),
                  );
                },
                loading: () => Container(
                  height: 48.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Loading property units...",
                        style: GoogleFonts.outfit(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                error: (_, __) => Container(
                  height: 48.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Society Common Area / All Units",
                    style: GoogleFonts.outfit(fontSize: 14.sp),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Text(
                "Service Category *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 16.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedCategory == null
                    ? null
                    : formatCategory(selectedCategory!),
                hint: "Select Service Category",
                items: serviceCategories
                    .map((item) => formatCategory(item["id"] as String))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    final match = serviceCategories.firstWhere(
                      (item) => formatCategory(item["id"] as String) == value,
                      orElse: () => {},
                    );
                    selectedCategory =
                        match["id"] ??
                        value?.toLowerCase().replaceAll(' ', '_');

                    // Category change hone par purani service reset
                    selectedService = null;
                  });
                },
              ),
              SizedBox(height: 16.h),
              Text(
                "Select Service *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedService,
                hint: selectedCategory == null
                    ? "Select category first"
                    : "Select Service",
                items: availableServices,
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                    titleController.text = value ?? "";
                  });
                },
              ),

              SizedBox(height: 16.h),
              Text(
                "Service Request Title *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 55.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff101C16), width: 1),
                ),
                child: Center(
                  child: TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: titleController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "e.g. Bathroom tap repair",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff8B8D8B),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // Exact vertical center
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Service Details *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff101C16), width: 1),
                ),
                child: TextField(
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                  controller: descriptionController,
                  minLines: 5,
                  maxLines: 7,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Describe your service request...",
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff8B8D8B),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Preferred Schedule",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        height: 41.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFDF2),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? "dd-mm-yyyy"
                                    : "${selectedDate!.day.toString().padLeft(2, '0')}-"
                                          "${selectedDate!.month.toString().padLeft(2, '0')}-"
                                          "${selectedDate!.year}",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: selectedDate == null
                                      ? const Color(0xff8B8D8B)
                                      : const Color(0xff292832),
                                ),
                              ),
                            ),

                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20.sp,
                              color: const Color(0xff292832),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Container(
                        height: 41.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFDF2),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedTime == null
                                    ? "10:10AM"
                                    : selectedTime!.format(context),
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: selectedTime == null
                                      ? const Color(0xff8B8D8B)
                                      : const Color(0xff292832),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20.sp,
                              color: const Color(0xff292832),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "Priority",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 18.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildPriority(),
              SizedBox(height: 30.h),
              Text(
                "Attach Supporting Document / Image",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  _showAttachmentOptions();
                },
                child: DottedBorder(
                  color: const Color(0xff101C16),
                  strokeWidth: 1,
                  dashPattern: const [2, 2],
                  radius: Radius.circular(10.r),
                  child: Container(
                    height: 104.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: selectedFile == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35.w,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF101C16),
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                child: Icon(
                                  Icons.file_upload_outlined,
                                  size: 18.sp,
                                  color: const Color(0xff101C16),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add Attachment",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF101C16),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "JPG, PNG or PDF · Max 10 MB",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(153, 42, 41, 51),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                      width: 0.8.w,
                                    ),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.r),
                                    child:
                                        selectedFileType == "image" &&
                                            selectedFile != null
                                        ? Image.file(
                                            selectedFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.description_outlined,
                                            size: 20.sp,
                                            color: const Color(0xff101C16),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    selectedFileName ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFile = null;
                                      selectedFileName = null;
                                      selectedFileType = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 19.sp,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildInfoBox(),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 49.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null) {
                      showErrorSnackBar("Please select a service category");
                      return;
                    }
                    // if (selectedIndex == -1) {
                    //   showErrorSnackBar("Please select a service type");
                    //   return;
                    // }
                    if (selectedService == null) {
                      showErrorSnackBar("Please select a service");
                      return;
                    }
                    if (titleController.text.trim().isEmpty) {
                      showErrorSnackBar("Please enter a service title");
                      return;
                    }
                    if (descriptionController.text.trim().isEmpty) {
                      showErrorSnackBar("Please enter service details");
                      return;
                    }
                    if (selectedDate == null) {
                      showErrorSnackBar("Please select a preferred date");
                      return;
                    }
                    if (selectedTime == null) {
                      showErrorSnackBar("Please select a preferred time");
                      return;
                    }

                    String formattedDate =
                        "${selectedDate!.year}-"
                        "${selectedDate!.month.toString().padLeft(2, '0')}-"
                        "${selectedDate!.day.toString().padLeft(2, '0')}";
                    String formattedTime = selectedTime!.format(context);

                    MultipartFile? attachment;
                    if (selectedFile != null) {
                      attachment = await MultipartFile.fromFile(
                        selectedFile!.path,
                        filename: selectedFileName,
                      );
                    }

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final int? resolvedPropertyId =
                          (selectedPropertyId != null && selectedPropertyId != 0)
                              ? selectedPropertyId
                              : null;

                      final service = ref.read(authServiceProvider);
                      await service.createServiceTicket(
                        serviceCategory: selectedCategory!,
                        serviceType: selectedService!,
                        title: titleController.text.trim(),
                        details: descriptionController.text.trim(),
                        preferredDate: formattedDate,
                        preferredTime: formattedTime,
                        priority: priorities[selectedPriority],
                        attachment: attachment,
                        type: "service_request",
                        propertyId: resolvedPropertyId,
                      );
                      ref.invalidate(getServiceRequestProvider);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      String msg = "Failed to submit request.";
                      if (e is DioException && e.response?.data is Map) {
                        msg = e.response?.data["message"] ?? msg;
                      }
                      showErrorSnackBar(msg);
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101C16),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.scaffoldBg,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Submit",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 16, 28, 22),
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: const Color(0xFF101C16), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: const Color(0xff555555),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              "After submission, a unique service request ID will be generated. "
              "You can use it to track your service request status and resolution progress.",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2A2933),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFF101C16), width: 1.w),
      ),
      padding: EdgeInsets.only(left: 15.w, right: 25.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(153, 42, 41, 51),
              letterSpacing: -0.3,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20.sp,
            color: Color.fromARGB(153, 42, 41, 51),
          ),
          dropdownColor: Colors.white,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriority() {
    return Row(
      children: List.generate(priorities.length, (index) {
        final bool isSelected = selectedPriority == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index != priorities.length - 1 ? 7.w : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPriority = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 38.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color.fromARGB(102, 174, 129, 48)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFAE8130)
                        : Color.fromARGB(153, 42, 41, 51),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  priorities[index],
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Color(0xFF2A2933)
                        : Color.fromARGB(153, 42, 41, 51),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

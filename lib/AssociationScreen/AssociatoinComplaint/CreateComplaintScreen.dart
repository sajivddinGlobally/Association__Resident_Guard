import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/Provider/getPropeertyUnitListProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/Provider/getComplaintProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

class CreateComplaintScreen extends ConsumerStatefulWidget {
  const CreateComplaintScreen({super.key});

  @override
  ConsumerState<CreateComplaintScreen> createState() =>
      _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends ConsumerState<CreateComplaintScreen> {
  bool isLoading = false;

  final List<String> categories = [
    "Plumbing",
    "Electrical",
    "Civil",
    "House Keeping",
    "Other",
  ];

  final List<Map<String, dynamic>> complaintCategories = [
    {
      "id": "plumbing",
      "label": "plumbing",
      "types": [
        "Tap & Faucet Leakage / Breakdown",
        "Pipe Leakage / Drainage Blockage",
        "Toilet & Flush Tank Mechanism Failure",
        "Water Heater / Geyser Malfunction",
        "Low Water Pressure / Shower Issue",
        "Sink & Basin Drainage Blockage",
        "Water Tank / Motor Breakdown",
        "Other Plumbing Breakdown",
      ],
    },
    {
      "id": "electrical",
      "label": "electrical",
      "types": [
        "Circuit Breaker / MCB Frequent Tripping",
        "Power Outage / Phase Fault",
        "Wiring Burning Smell / Short Circuit Risk",
        "Switch, Socket & Plug Sparks / Broken",
        "Ceiling Fan / Exhaust Fan Breakdown",
        "Light Fixture / Bulb Malfunction",
        "Inverter & Backup Failure",
        "Other Electrical Fault",
      ],
    },
    {
      "id": "civil",
      "label": "civil",
      "types": [
        "Wall Cracks & Structural Fissures",
        "Ceiling Seepage & Water Leakage",
        "Floor Tile Cracking / Sinking",
        "Balcony & Window Seepage",
        "Plaster Peeling & External Cracks",
        "Other Structural / Civil Issue",
      ],
    },
    {
      "id": "house_keeping",
      "label": "house_keeping",
      "types": [
        "Floor Deep Cleaning & Stain Removal",
        "Corridor & Common Area Cleaning",
        "Garbage Disposal & Waste Clearance",
        "Bathroom & Washroom Sanitization",
        "Window & Glass Pane Cleaning",
        "Balcony & Terrace Cleaning",
        "Pest Control & Disinfection",
        "Other House Keeping Issue",
      ],
    },
    {
      "id": "other",
      "label": "other",
      "types": [
        "AC Cooling Breakdown / Water Leakage",
        "Door & Window Jammed / Broken",
        "Tile, Grouting & Marble Repair",
        "Severe Pest Infestation",
        "Lift / Elevator Malfunction",
        "Carpentry & Furniture Repair",
        "Other Maintenance Breakdown",
      ],
    },
  ];

  String? selectedCategory;
  String? selectedSubject;
  int? selectedPropertyId;
  String? selectedPropertyLabel;

  final TextEditingController customServiceController = TextEditingController();
  List<String> customServices = [];

  List<String> get availableComplaints {
    if (selectedCategory == null) {
      return [];
    }
    final normalized = selectedCategory!.toLowerCase().replaceAll(' ', '_');
    final category = complaintCategories.firstWhere(
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

  int selectedPriority = 1;

  final List<String> priorities = ["Low", "Medium", "High"];

  final TextEditingController descriptionController = TextEditingController();
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
    customServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(committeeUnitsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
                  width: 41.w,
                  height: 41.h,
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
              SizedBox(width: 9.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CREATE COMPLAINT",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "RAISE A PROPERTY QUERY",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
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
              SizedBox(height: 16.h),
              Text(
                "Complaint Information",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 16.h),

              // Property / Unit (Optional)
              _buildLabel("Property / Unit"),
              SizedBox(height: 10.h),
              unitsAsync.when(
                data: (unitData) {
                  final units = unitData.data?.flattenedUnits ?? [];
                  final seenIds = <int>{};
                  final uniqueUnits = units
                      .where((u) => u.id != null && seenIds.add(u.id!))
                      .toList();
                      
                  final bool isValidSelection =
                      selectedPropertyId == null ||
                      uniqueUnits.any((u) => u.id == selectedPropertyId);
                  final currentVal = isValidSelection
                      ? selectedPropertyId
                      : null;

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
                            String label =
                                u.unitNumber ?? u.badge ?? "Unit ${u.id}";
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

              SizedBox(height: 10.h),
              _buildLabel("Complaint Category *"),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedCategory == null
                    ? null
                    : formatCategory(selectedCategory!),
                hint: "Select Complain Category",
                items: complaintCategories
                    .map((item) => formatCategory(item["id"] as String))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    final match = complaintCategories.firstWhere(
                      (item) => formatCategory(item["id"] as String) == value,
                      orElse: () => {},
                    );
                    selectedCategory =
                        match["id"] ??
                        value?.toLowerCase().replaceAll(' ', '_');
                    // Category change hone par purani service reset
                    selectedSubject = null;
                  });
                },
              ),
              SizedBox(height: 10.h),
              _buildLabel("Complaint Subject *"),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedSubject,
                hint: selectedCategory == null
                    ? "Select Complain category first"
                    : "Select Complain Subject",
                items: availableComplaints,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
              ),
              SizedBox(height: 10.h),
              _buildLabel("Description *"),
              SizedBox(height: 7.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFF101C16),
                    width: 1.w,
                  ),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  textAlignVertical: TextAlignVertical.top,
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.w),
                    hintText: "Describe your complaint or query in detail...",
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(153, 41, 41, 51),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Priority",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
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
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                        153,
                                        42,
                                        41,
                                        51,
                                      ),
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
                                      fontSize: 12.sp,
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
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 49.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null) {
                      showErrorSnackBar("Please select a complaint category");
                      return;
                    }

                    if (selectedSubject == null) {
                      showErrorSnackBar("Please select a complaint subject");
                      return;
                    }
                    if (descriptionController.text.trim().isEmpty) {
                      showErrorSnackBar("Please enter complaint details");
                      return;
                    }

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
                          (selectedPropertyId != null &&
                              selectedPropertyId != 0)
                          ? selectedPropertyId
                          : null;

                      final service = ref.read(authServiceProvider);
                      await service.createServiceTicket(
                        serviceCategory: selectedCategory!,
                        title: selectedSubject!,
                        details: descriptionController.text.trim(),
                        priority: priorities[selectedPriority],
                        attachment: attachment,
                        type: "complaint",
                        preferredDate: null,
                        preferredTime: null,
                        serviceType: null,
                        propertyId: resolvedPropertyId,
                      );
                      ref.invalidate(getComplaintProvider);
                      if (mounted) {
                        _showSuccessDialog(priorities[selectedPriority]);
                      }
                    } catch (e) {
                      String msg = "Failed to submit Complaint.";
                      if (e is DioException && e.response?.data is Map) {
                        msg = e.response?.data["message"] ?? msg;
                      }
                      showErrorSnackBar(msg);
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
                            child: const CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Submit Complaint",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF101C16),
        letterSpacing: -0.3,
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
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Color _getPriorityColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF2E7D32); // Low = Green
      case 1:
        return const Color(0xFFE65100); // Medium = Amber / Orange
      case 2:
        return const Color(0xFFD32F2F); // High = Red
      default:
        return const Color(0xFF101C16);
    }
  }

  Color _getPriorityBg(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFE8F5E9);
      case 1:
        return const Color(0xFFFFF3E0);
      case 2:
        return const Color(0xFFFFEBEE);
      default:
        return Colors.transparent;
    }
  }

  Widget _buildPriority() {
    return Row(
      children: List.generate(priorities.length, (index) {
        final bool isSelected = selectedPriority == index;
        final Color color = _getPriorityColor(index);
        final Color bg = _getPriorityBg(index);
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
                  color: isSelected ? bg : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? color
                        : const Color.fromARGB(153, 42, 41, 51),
                    width: isSelected ? 1.5.w : 1.w,
                  ),
                ),
                child: Text(
                  priorities[index],
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? color
                        : const Color.fromARGB(153, 42, 41, 51),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showSuccessDialog(String priority) {
    final Color priorityColor = priority.toLowerCase().contains("high")
        ? const Color(0xFFD32F2F)
        : priority.toLowerCase().contains("medium")
        ? const Color(0xFFE65100)
        : const Color(0xFF2E7D32);
    final Color priorityBg = priority.toLowerCase().contains("high")
        ? const Color(0xFFFFEBEE)
        : priority.toLowerCase().contains("medium")
        ? const Color(0xFFFFF3E0)
        : const Color(0xFFE8F5E9);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: const Color(0xFF101C16), width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 24.h,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2E7D32),
                    width: 1.5.w,
                  ),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF2E7D32),
                  size: 36.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Complaint Registered!",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Your query has been submitted successfully to the management team.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(178, 42, 41, 51),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(25, 16, 28, 22),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFF101C16),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Priority Status:",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: priorityBg,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: priorityColor, width: 1.w),
                      ),
                      child: Text(
                        "$priority Priority",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: priorityColor,
                        ),
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
                    backgroundColor: const Color(0xFF101C16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "View Complaints",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(25, 16, 28, 22),
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
              "After submission, a unique complaint ID will be generated. "
              "You can use it to track the complaint status and resolution progress.",
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
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
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Core/AuthService/AuthServiceProvider.dart';
import 'ResidentVisitorPassListScreen.dart';
import 'provider/getPassListProvider.dart';
import 'provider/getVisitorPassListProvider.dart';
import 'service/qr_share_service.dart';

class Residentvisitorpassrequest extends ConsumerStatefulWidget {
  const Residentvisitorpassrequest({super.key});

  @override
  ConsumerState<Residentvisitorpassrequest> createState() =>
      _ResidentvisitorpassrequestState();
}

class _ResidentvisitorpassrequestState
    extends ConsumerState<Residentvisitorpassrequest> {
  final visitorNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  int? selected; // 0 = Guest, 1 = Service, 2 = Delivery
  bool isFrequentVisitor = false;
  String frequentRole = "Maid";
  final List<String> frequentRoles = const [
    "Maid",
    "Driver",
    "Cook",
    "Tutor",
    "Other",
  ];
  DateTime? selectedDate;
  TimeOfDay? selectedTime1;
  bool isVisitorLoading = false;

  String get dateText {
    if (selectedDate == null) {
      return "DD / MM / YYYY";
    }

    return "${selectedDate!.day.toString().padLeft(2, '0')} / "
        "${selectedDate!.month.toString().padLeft(2, '0')} / "
        "${selectedDate!.year}";
  }

  // Time Format
  String get timeText1 {
    if (selectedTime1 == null) {
      return "00:00";
    }

    return selectedTime1!.format(context);
  }

  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // Time Picker
  Future<void> selectTime1() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime1 ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime1 = time;
      });
    }
  }

  String? selectedPurpose;
  final List<String> purposeList = [
    "Personal / Family Visit",
    "Delivery (Food / Parcel)",
    "Home Maintenance / Repair",
    "Housekeeping / Cleaning",
    "Cab / Taxi Pickup",
    "Official / Business",
    "Other",
  ];

  void _showQrPassDialog({
    required String passCode,
    required String visitorName,
    required String visitDate,
    required String visitTime,
    required String purpose,
    String? status,
    VoidCallback? onDone,
  }) {
    bool hasCompleted = false;
    void triggerDone() {
      if (!hasCompleted) {
        hasCompleted = true;
        if (onDone != null) onDone();
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pre-Approved Gate Pass",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Share this QR code with your visitor",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4F5E1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      status ?? "APPROVED",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A765),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8F3),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE5E0D5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: passCode,
                        version: QrVersions.auto,
                        size: 160.w,
                        gapless: false,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.heading,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "PASS CODE: ",
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            passCode,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE8B900),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Visitor Name",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          visitorName,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: const Color(0xFFE2E4E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expected Arrival",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          visitTime.isEmpty
                              ? visitDate
                              : "$visitDate · $visitTime",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: const Color(0xFFE2E4E2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Purpose",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        Text(
                          purpose,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A765),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          QrShareService.sharePassWithQr(
                            passCode: passCode,
                            visitorName: visitorName,
                            visitDate: visitDate,
                            visitTime: visitTime,
                            purpose: purpose,
                          );
                        },
                        icon: Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        label: Text(
                          "Share Pass With Guest",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 46.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.heading),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        triggerDone();
                      },
                      child: Text(
                        "Done",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((_) {
      triggerDone();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getVisitorListProvider);
    final headers = state.valueOrNull?.data?.heroCard;
    final isLoading = state.isLoading;
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
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visitor Pass Request",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Request entry access for your visitor",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
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
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              isLoading
                  ? Container(
                      width: double.infinity,
                      height: 150.h,
                      decoration: BoxDecoration(
                        color: AppColors.heading,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.scaffoldBg,
                          strokeWidth: 1.w,
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.heading,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF514719),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Color(0xffB8860B),
                              size: 16.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            headers?.title ?? "Request a Visitor Pass",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            headers?.subtitle ??
                                "Create a visitor request for access to your registered apartment.",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 10.h),
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
                              headers?.registeredApartment?.text ??
                                  "Apartment not assigned",
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
                "Visitor Details",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(17.w),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff101C16)),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visitor Name",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: visitorNameController,
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        hintText: "Enter Visitor Name",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(42, 41, 51, 0.6),
                          letterSpacing: -0.2,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.r),
                          borderSide: const BorderSide(
                            color: Color(0xff101C16),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.r),
                          borderSide: const BorderSide(
                            color: Color(0xff101C16),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      "Mobile Number",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: mobileNumberController,
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Mobile Number",
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(42, 41, 51, 0.6),
                          letterSpacing: -0.2,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.r),
                          borderSide: const BorderSide(
                            color: Color(0xff101C16),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.r),
                          borderSide: const BorderSide(
                            color: Color(0xff101C16),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Visitor Type",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = 0;
                              });
                            },
                            child: visitorType("Guest", selected == 0),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = 1;
                              });
                            },
                            child: visitorType("Service", selected == 1),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = 2;
                                selectedPurpose = "Delivery (Food / Parcel)";
                              });
                            },
                            child: visitorType("Delivery", selected == 2),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Frequent visitor (maid, driver, cook...)",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Switch(
                          value: isFrequentVisitor,
                          onChanged: (val) {
                            setState(() {
                              isFrequentVisitor = val;
                            });
                          },
                        ),
                      ],
                    ),
                    if (isFrequentVisitor) ...[
                      Text(
                        "Frequent visitors are allowed in automatically every time. Entry is recorded for each visit.",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        children: frequentRoles.map((role) {
                          return ChoiceChip(
                            label: Text(role),
                            selected: frequentRole == role,
                            onSelected: (_) {
                              setState(() {
                                frequentRole = role;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Visitor Details",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(17.w),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff101C16)),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildField(
                            title: "Visit Date",
                            value: dateText,
                            icon: Icons.calendar_month_outlined,
                            onTap: selectDate,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: buildField(
                            title: "Visit Time",
                            value: timeText1,
                            icon: Icons.access_time_outlined,
                            onTap: selectTime1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Purpose of Visit",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.r),
                        border: Border.all(
                          color: Color(0xff101C16),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPurpose,
                          isExpanded: true,
                          hint: Text(
                            "Select purpose",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF666666),
                              letterSpacing: -0.2,
                            ),
                          ),
                          isDense: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xFF101C16),
                            size: 22.sp,
                          ),
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff101C16),
                            letterSpacing: -0.2,
                          ),
                          items: purposeList.map((String purpose) {
                            return DropdownMenuItem<String>(
                              value: purpose,
                              child: Text(
                                purpose,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPurpose = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () async {
                  if (visitorNameController.text.isEmpty) {
                    showErrorSnackBar("Please enter visitor name");
                    return;
                  }
                  if (mobileNumberController.text.isEmpty) {
                    showErrorSnackBar("Please enter mobile number");
                    return;
                  }
                  if (selected == null) {
                    showErrorSnackBar("Please select visitor type");
                    return;
                  }
                  if (dateText.isEmpty) {
                    showErrorSnackBar("Please select visit date");
                    return;
                  }
                  if (timeText1.isEmpty) {
                    showErrorSnackBar("Please select visit time");
                    return;
                  }
                  if (selectedPurpose == null) {
                    showErrorSnackBar("Please select purpose of visit");
                    return;
                  }
                  setState(() {
                    isVisitorLoading = true;
                  });
                  try {
                    final service = ref.read(authServiceProvider);
                    final res = await service.createVisitorPassRequest(
                      visitorName: visitorNameController.text,
                      mobileNumber: mobileNumberController.text,
                      visitorType: selected == 0
                          ? "guest"
                          : (selected == 1 ? "service" : "delivery"),
                      visitDate: dateText,
                      visitTime: timeText1,
                      purposeOfVisit: selectedPurpose!,
                      isFrequent: isFrequentVisitor,
                      frequentRole: isFrequentVisitor ? frequentRole : null,
                    );
                    if (res.status == true) {
                      final rawPassCode =
                          res.data?.rawPass?.passCode ??
                          res.data?.token ??
                          "";
                      final generatedPassCode = rawPassCode
                          .replaceAll('#', '')
                          .trim();
                      final vName =
                          res.data?.visitorName ?? visitorNameController.text;
                      final vDate = dateText;
                      final vTime = timeText1;
                      final vPurpose = selectedPurpose!;
                      visitorNameController.clear();
                      mobileNumberController.clear();
                      setState(() {
                        selected = null;
                        selectedDate = null;
                        selectedTime1 = null;
                        selectedPurpose = null;
                        isFrequentVisitor = false;
                        frequentRole = "Maid";
                      });
                      ref.invalidate(getPassListProvider);
                      // ref.invalidate(getVisitorListProvider);
                      showSuccessSnackBar(
                        res.message ?? "Pass created successfully",
                      );
                      // _showQrPassDialog(
                      //   passCode: generatedPassCode,
                      //   visitorName: vName,
                      //   visitDate: vDate,
                      //   visitTime: vTime,
                      //   purpose: vPurpose,
                      //   status: res.data?.status ?? "APPROVED",
                      //   onDone: () {
                      //     if (Navigator.canPop(context)) {
                      //       Navigator.pop(context);
                      //     } else {
                      //       Navigator.pushReplacement(
                      //         context,
                      //         CupertinoPageRoute(
                      //           builder: (context) =>
                      //               const ResidentVisitorPassListScreen(),
                      //         ),
                      //       );
                      //     }
                      //   },
                      // );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ResidentVisitorPassListScreen(),
                        ),
                      );
                    } else {
                      showErrorSnackBar(res.message ?? "Failed to create pass");
                    }
                  } catch (e) {
                    log(e.toString());
                  } finally {
                    if (mounted) {
                      setState(() {
                        isVisitorLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45.h),
                  backgroundColor: const Color(0xff0D1C16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                child: isVisitorLoading
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
                        "Submit Visitor Request",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: -0.2,
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

  Widget visitorType(String title, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xff0D1C16) : Colors.transparent,
        border: Border.all(color: const Color(0xff101C16)),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xff4A4510)
                  : const Color(0xffE8D39F),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.person_outline,
              color: const Color(0xffC49400),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              color: selected ? Colors.white : const Color(0xff101C16),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isHint = value == "DD / MM / YYYY" || value == "00:00";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          onTap: onTap,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isHint ? const Color(0xFF666666) : const Color(0xFF101C16),
            letterSpacing: -0.2,
          ),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: Icon(icon, size: 19.sp, color: const Color(0xFF777777)),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            hintText: "DD / MM / YYYY",
            hintStyle: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: const BorderSide(color: Color(0xFF777777), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.r),
              borderSide: const BorderSide(color: Colors.black, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}

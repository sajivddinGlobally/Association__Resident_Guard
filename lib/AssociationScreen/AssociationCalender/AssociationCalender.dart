import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

class Associationcalender extends ConsumerStatefulWidget {
  const Associationcalender({super.key});

  @override
  ConsumerState<Associationcalender> createState() =>
      _AssociationcalenderState();
}

class _AssociationcalenderState extends ConsumerState<Associationcalender> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController organizedByController = TextEditingController(
    text: "Residential/Commercial management team Committee",
  );

  int selectedEventType = 0;
  final List<String> eventTypes = ["meeting", "maintenance", "community"];

  int selectedSummary = 0;
  final List<String> eventForList = ["residents", "committee", "all"];

  DateTime? selectedDate;
  TimeOfDay? selectedTime1;
  TimeOfDay? selectedTime2;
  TimeOfDay? selectedTime3;

  bool isLoading = false;

  @override
  void dispose() {
    eventNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    organizedByController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
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

  Future<void> selectTime2() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime2 ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime2 = time;
      });
    }
  }

  Future<void> selectTime3() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime3 ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime3 = time;
      });
    }
  }

  // Date Format
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

  String get timeText2 {
    if (selectedTime2 == null) {
      return "00:00";
    }

    return selectedTime2!.format(context);
  }

  String get timeText3 {
    if (selectedTime3 == null) {
      return "00:00";
    }

    return selectedTime3!.format(context);
  }

  Future<void> _publishEvent() async {
    final eventName = eventNameController.text.trim();
    final location = locationController.text.trim();
    final description = descriptionController.text.trim();
    final organizedBy = organizedByController.text.trim().isNotEmpty
        ? organizedByController.text.trim()
        : "Residential/Commercial management team Committee";

    if (eventName.isEmpty) {
      showErrorSnackBar("Please enter event name");
      return;
    }

    if (location.isEmpty) {
      showErrorSnackBar("Please enter event location");
      return;
    }

    if (selectedDate == null) {
      showErrorSnackBar("Please select event date");
      return;
    }

    if (selectedTime1 == null) {
      showErrorSnackBar("Please select start time");
      return;
    }

    if (selectedTime2 == null) {
      showErrorSnackBar("Please select end time");
      return;
    }

    final formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final formattedVisitTime =
        "${selectedTime1!.hour.toString().padLeft(2, '0')}:${selectedTime1!.minute.toString().padLeft(2, '0')}";
    final formattedEndTime =
        "${selectedTime2!.hour.toString().padLeft(2, '0')}:${selectedTime2!.minute.toString().padLeft(2, '0')}";
    final eventType = eventTypes[selectedEventType];
    final eventFor = eventForList[selectedSummary];

    setState(() {
      isLoading = true;
    });

    try {
      final service = ref.read(authServiceProvider);
      await service.addAssociationCalendar(
        eventName: eventName,
        eventType: eventType,
        visitDate: formattedDate,
        visitTime: formattedVisitTime,
        endTime: formattedEndTime,
        organizedBy: organizedBy,
        eventFor: eventFor,
        description: description,
        location: location,
      );

      if (mounted) {
        showSuccessSnackBar("Event published successfully!");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(e.toString());
      }
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
                    "Add Event / Meeting",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Association Calendar · Green Valley",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
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
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 17.h),
                decoration: BoxDecoration(
                  color: AppColors.heading,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Community Schedule",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: const Color(0xffB8860B),
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Text(
                      "Plan a New Event",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        color: Colors.white,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Text(
                      "Add meeting and community activity details for residents and association members.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.white,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                "• 1  Event Details",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEA),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF66645D), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event / Meeting Name *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: eventNameController,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter Event / Meeting Name",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        prefixIcon: Icon(
                          Icons.article_outlined,
                          size: 22.sp,
                          color: AppColors.heading,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 44.w,
                          minHeight: 52.h,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 14.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      "Event Type *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _eventButton(
                          icon: Icons.person_outline,
                          title: "Meeting",
                          index: 0,
                        ),
                        SizedBox(width: 6.w),
                        _eventButton(
                          icon: Icons.person_outline,
                          title: "Maintenance",
                          index: 1,
                        ),
                        SizedBox(width: 6.w),
                        _eventButton(
                          icon: Icons.people_outline,
                          title: "Community",
                          index: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: 13.h),
                    Text(
                      "Location *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: locationController,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter Location (e.g. Main Clubhouse)",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          size: 22.sp,
                          color: AppColors.heading,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 44.w,
                          minHeight: 52.h,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 14.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "• 2 Date & Time",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEA),
                  border: Border.all(
                    color: const Color(0xFF66645D),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildField(
                            title: "Event Date",
                            value: dateText,
                            icon: Icons.calendar_month_outlined,
                            onTap: selectDate,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: buildField(
                            title: "Start Time",
                            value: timeText1,
                            icon: Icons.access_time_outlined,
                            onTap: selectTime1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildField(
                            title: "End Time",
                            value: timeText2,
                            icon: Icons.access_time_outlined,
                            onTap: selectTime2,
                          ),
                        ),
                        // SizedBox(width: 15.w),
                        // Expanded(
                        //   child: buildField(
                        //     title: "Visit Time",
                        //     value: timeText3,
                        //     icon: Icons.access_time_outlined,
                        //     onTap: selectTime3,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "• 3 Organizer & Audience",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Organized By",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFCEF),
                        border: Border.all(
                          color: const Color(0xff777777),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 25.sp,
                            color: const Color(0xff777777),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ORGANIZER",
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  organizedByController.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff101C16),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Event For *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _buildSummaryCards(),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "• 4 Description & Agenda",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff777777),
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description / Meeting Agenda",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: descriptionController,
                      maxLines: 8,
                      minLines: 8,
                      textAlignVertical: TextAlignVertical.top,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Add the purpose, agenda or important information about this event...",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        hintMaxLines: 2,
                        filled: true,
                        fillColor: const Color(0xffFFFCEF),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 52.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: isLoading ? null : _publishEvent,
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Publish Event",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.heading, width: 1.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: 0.2,
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

  Widget _eventButton({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final bool isSelected = selectedEventType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEventType = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0DFA8) : const Color(0xFFFFFCEF),
          border: Border.all(
            color: isSelected ? AppColors.heading : const Color(0xff777777),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: Colors.black),
            SizedBox(width: 3.w),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
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
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
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
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: isHint
                ? const Color.fromRGBO(16, 28, 22, 0.6)
                : AppColors.heading,
            letterSpacing: -0.2,
          ),
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: Icon(icon, size: 22.sp, color: AppColors.heading),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            hintText: "DD / MM / YYYY",
            hintStyle: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(16, 28, 22, 0.6),
              letterSpacing: -0.2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 28, 22, 0.6),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.heading, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _summaryCard(index: 0, title: "Residents")),
        SizedBox(width: 10.w),
        Expanded(child: _summaryCard(index: 1, title: "Committee")),
        SizedBox(width: 10.w),
        Expanded(child: _summaryCard(index: 2, title: "All")),
      ],
    );
  }

  Widget _summaryCard({required int index, required String title}) {
    final bool isSelected = selectedSummary == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSummary = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.heading : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.heading : const Color(0xff6A6A6A),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xff6A6A6A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

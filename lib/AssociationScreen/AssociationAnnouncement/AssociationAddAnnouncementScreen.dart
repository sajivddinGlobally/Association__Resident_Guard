import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

class AssociationAddAnnouncementScreen extends ConsumerStatefulWidget {
  const AssociationAddAnnouncementScreen({super.key});

  @override
  ConsumerState<AssociationAddAnnouncementScreen> createState() =>
      _AssociationAddAnnouncementScreenState();
}

class _AssociationAddAnnouncementScreenState
    extends ConsumerState<AssociationAddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers for Title and Message
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  // ===========================================================================
  // COMMENTED OUT FIELDS / STATE (UI me sirf Title aur Message show karna hai)
  // In fields ki default values API payload me pass ki gayi hain.
  // ===========================================================================
  /*
  String _selectedAudience = "residents"; // Options: "residents", "all", "guards"
  String _selectedType = "maintenance"; // Options: "maintenance", "security", "general", "event"
  String _selectedPriority = "high"; // Options: "high", "normal", "low", "urgent"
  bool _isPinned = true;
  */

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // API Call method to publish announcement
  Future<void> _publishAnnouncement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(authServiceProvider);

      // Calling the Add Announcement API:
      // POST: https://realestate.gwsstaging.com/api/v1/committee/announcements
      final response = await service.addAnnouncement(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        // -------------------------------------------------------------
        // Payload extra fields (As requested in payload):
        // "type": "maintenance"
        // "priority": "high"
        // "target_audience": "residents"
        // "pinned": true
        // -------------------------------------------------------------
        type: "maintenance",
        priority: "high",
        targetAudience: "residents",
        pinned: true,
      );

      if (response.status == true) {
        showSuccessSnackBar(
          response.message ?? "Announcement published successfully!",
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        showErrorSnackBar(response.message ?? "Failed to publish announcement");
      }
    } catch (e) {
      log("Error while publishing announcement: $e");
      // Note: Error message is automatically handled by Dio Interceptor,
      // but showing a fallback message if not handled.
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        "Add Announcement",
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
                        "Create and publish a new society announcement",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================================
                // [COMMENTED OUT] TARGET AUDIENCE SELECTOR
                // Requirement: Sirf Title aur Message UI me show karna hai, baaki commented.
                // =====================================================================
                /*
                _fieldLabel("TARGET AUDIENCE"),
                Row(
                  children: [
                    _audienceTabItem(
                      key: "residents",
                      label: "Residents",
                      icon: Icons.home_outlined,
                    ),
                    SizedBox(width: 10.w),
                    _audienceTabItem(
                      key: "all",
                      label: "All Members",
                      icon: Icons.groups_outlined,
                    ),
                    SizedBox(width: 10.w),
                    _audienceTabItem(
                      key: "guards",
                      label: "Guards",
                      icon: Icons.shield_outlined,
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                */

                // =====================================================================
                // [COMMENTED OUT] ANNOUNCEMENT TYPE SELECTOR
                // =====================================================================
                /*
                _fieldLabel("ANNOUNCEMENT TYPE"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedType,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: const [
                        DropdownMenuItem(value: "maintenance", child: Text("Maintenance")),
                        DropdownMenuItem(value: "security", child: Text("Security")),
                        DropdownMenuItem(value: "general", child: Text("General Notice")),
                        DropdownMenuItem(value: "event", child: Text("Event")),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedType = val);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                */

                // =====================================================================
                // [COMMENTED OUT] PRIORITY & PINNED OPTIONS
                // =====================================================================
                /*
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel("PRIORITY"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color.fromRGBO(16, 28, 22, 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPriority,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: "high", child: Text("High")),
                                  DropdownMenuItem(value: "normal", child: Text("Normal")),
                                  DropdownMenuItem(value: "low", child: Text("Low")),
                                  DropdownMenuItem(value: "urgent", child: Text("Urgent")),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedPriority = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel("PIN TO TOP"),
                          Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color.fromRGBO(16, 28, 22, 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pin Notice", style: GoogleFonts.outfit(fontSize: 14.sp)),
                                Switch(
                                  value: _isPinned,
                                  onChanged: (val) => setState(() => _isPinned = val),
                                  activeColor: const Color(0xFF101C16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                */
                SizedBox(height: 6.h),

                // =====================================================================
                // 1. ANNOUNCEMENT TITLE (VISIBLE IN UI)
                // =====================================================================
                _fieldLabel("ANNOUNCEMENT TITLE"),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter announcement title";
                    }
                    if (value.trim().length < 3) {
                      return "Title must be at least 3 characters long";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff101C16),
                    letterSpacing: -0.2,
                  ),
                  decoration: _inputDecoration(
                    hintText: "e.g. Water Supply Maintenance Notice",
                    prefixIcon: Icons.title_rounded,
                  ),
                ),

                SizedBox(height: 20.h),

                // =====================================================================
                // 2. ANNOUNCEMENT MESSAGE (VISIBLE IN UI)
                // =====================================================================
                _fieldLabel("ANNOUNCEMENT MESSAGE"),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  minLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter announcement message";
                    }
                    if (value.trim().length < 5) {
                      return "Message must be at least 5 characters long";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff101C16),
                    letterSpacing: -0.2,
                    height: 1.45,
                  ),
                  decoration: _inputDecoration(
                    hintText:
                        "e.g. Overhead water tank cleaning scheduled this Sunday between 10:00 AM to 02:00 PM.",
                    prefixIcon: Icons.message_outlined,
                    alignLabelWithHint: true,
                  ),
                ),

                SizedBox(height: 36.h),

                // =====================================================================
                // SUBMIT BUTTON (PUBLISH ANNOUNCEMENT)
                // =====================================================================
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101C16),
                      disabledBackgroundColor: const Color(
                        0xFF101C16,
                      ).withValues(alpha: 0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _isLoading ? null : _publishAnnouncement,
                    child: _isLoading
                        ? SizedBox(
                            width: 22.w,
                            height: 22.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.campaign_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Publish Announcement",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
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

  // ===========================================================================
  // COMMENTED OUT HELPER WIDGETS
  // ===========================================================================
  /*
  Widget _audienceTabItem({
    required String key,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedAudience == key;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAudience = key;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF101C16) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF101C16)
                  : const Color.fromRGBO(16, 28, 22, 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17.sp,
                color: isSelected
                    ? const Color(0xFFE8B900)
                    : const Color(0xFF101C16),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF101C16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */

  Widget _fieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff101C16),
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: const Color.fromRGBO(42, 41, 51, 0.55),
        letterSpacing: -0.2,
      ),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(
                left: 12.w,
                right: 8.w,
                bottom: alignLabelWithHint ? 55.h : 0,
              ),
              child: Icon(
                prefixIcon,
                size: 20.sp,
                color: const Color(0xff101C16).withValues(alpha: 0.7),
              ),
            )
          : null,
      prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
      filled: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: Color.fromRGBO(16, 28, 22, 0.3),
          width: 1.2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: Color.fromRGBO(16, 28, 22, 0.3),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xff101C16), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
      ),
    );
  }
}

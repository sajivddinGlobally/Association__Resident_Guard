import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/Provider/frequentVisitorsProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/frequentVisitorsResModel.dart';

class Frequentvisitorsscreen extends ConsumerStatefulWidget {
  const Frequentvisitorsscreen({super.key});

  @override
  ConsumerState<Frequentvisitorsscreen> createState() =>
      _FrequentvisitorsscreenState();
}

class _FrequentvisitorsscreenState
    extends ConsumerState<Frequentvisitorsscreen> {
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  bool isQuickEntryLoading = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _showQuickEntryBottomSheet(
    BuildContext context, {
    required String name,
    required String flat,
    required String id,
    String? role,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Entry (1-Tap IN)',
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Confirm entry for this registered frequent visitor without repeat approval.',
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Column(
                      children: [
                        _quickEntryRow(title: 'Visitor', value: name),
                        _quickEntryDivider(),
                        _quickEntryRow(title: 'Apartment', value: flat),
                        _quickEntryDivider(),
                        _quickEntryRow(
                          title: 'Role',
                          value: role ?? 'Frequent Staff',
                        ),
                        _quickEntryDivider(),
                        _quickEntryRow(
                          title: 'Access',
                          value: 'Frequent Visitor (Auto-Approved)',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: isQuickEntryLoading
                          ? null
                          : () async {
                              setSheetState(() {
                                isQuickEntryLoading = true;
                              });
                              try {
                                final auth = ref.read(authServiceProvider);
                                final res = await auth
                                    .quickEntryFrequentVisitorData(id);
                                if (res.status == true) {
                                  showSuccessSnackBar(
                                    res.message ??
                                        "Quick entry recorded for $name.",
                                  );
                                  ref.invalidate(frequentVisitorsProvider);
                                  if (mounted) {
                                    Navigator.pop(bottomSheetContext);
                                  }
                                } else {
                                  showErrorSnackBar(
                                    res.message ??
                                        "Could not record entry for $name.",
                                  );
                                }
                              } catch (e) {
                                // Server ka asli error Dio interceptor dikha deta hai.
                              } finally {
                                if (mounted) {
                                  setSheetState(() {
                                    isQuickEntryLoading = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D1C16),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: isQuickEntryLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Confirm IN-Time',
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMarkOutBottomSheet(
    BuildContext context, {
    required String name,
    required String flat,
    required String id,
    String? role,
    String? inTime,
  }) {
    bool isMarkOutLoading = false;
    final now = DateTime.now();
    final hour = now.hour == 0
        ? 12
        : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    final currentOutTime = "$hour:$minute $period";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mark Out-Time (Exit)',
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "CURRENTLY IN",
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0369A1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Record gate exit time for this frequent visitor.',
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Column(
                      children: [
                        _quickEntryRow(title: 'Visitor', value: name),
                        _quickEntryDivider(),
                        _quickEntryRow(title: 'Apartment', value: flat),
                        _quickEntryDivider(),
                        _quickEntryRow(
                          title: 'Role',
                          value: role ?? 'Frequent Staff',
                        ),
                        if (inTime != null && inTime.isNotEmpty) ...[
                          _quickEntryDivider(),
                          _quickEntryRow(title: 'In-Time', value: inTime),
                        ],
                        _quickEntryDivider(),
                        _quickEntryRow(
                          title: 'Out-Time',
                          value: currentOutTime,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: isMarkOutLoading
                          ? null
                          : () async {
                              setSheetState(() {
                                isMarkOutLoading = true;
                              });
                              try {
                                final auth = ref.read(authServiceProvider);
                                final res = await auth.markOutData(id);
                                if (res.status == true) {
                                  showSuccessSnackBar(
                                    res.message ??
                                        "Out-time recorded for $name.",
                                  );
                                  ref.invalidate(frequentVisitorsProvider);
                                  if (mounted) {
                                    Navigator.pop(bottomSheetContext);
                                  }
                                } else {
                                  showErrorSnackBar(
                                    res.message ??
                                        "Could not record out-time for $name.",
                                  );
                                }
                              } catch (e) {
                                // Server ka asli error Dio interceptor dikha deta hai.
                                ref.invalidate(frequentVisitorsProvider);
                              } finally {
                                if (mounted) {
                                  setSheetState(() {
                                    isMarkOutLoading = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: isMarkOutLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Confirm OUT-Time',
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showQuickDetailsBottomSheet(
    BuildContext context, {
    required String name,
    required String flat,
    String? role,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Visitor Details',
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'This visitor is registered as a frequent visitor.',
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                  letterSpacing: -0.2,
                ),
              ),

              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0E9),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Column(
                  children: [
                    _quickEntryRow(title: 'Visitor', value: name),

                    _quickEntryDivider(),

                    _quickEntryRow(title: 'Apartment', value: '$flat'),

                    _quickEntryDivider(),

                    _quickEntryRow(title: 'Role', value: role ?? 'Daily Staff'),

                    _quickEntryDivider(),

                    _quickEntryRow(title: 'Access', value: 'Frequent Visitor'),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1C16),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
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

  @override
  Widget build(BuildContext context) {
    final frequentAsync = ref.watch(frequentVisitorsProvider);

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
                    "Frequent Visitors",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Quick entry for registered visitors",
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Container(
                height: 52.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: const Color.fromRGBO(16, 28, 22, 0.6),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 24.sp, color: AppColors.heading),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.trim();
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search visitor or flat number",
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(16, 28, 22, 0.6),
                            letterSpacing: -0.2,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              frequentAsync.when(
                data: (data) {
                  final visitors = data.data?.visitors ?? [];

                  final filteredVisitors = visitors.where((item) {
                    final query = searchQuery.toLowerCase();

                    final name = item.name?.toLowerCase() ?? '';
                    final apartment = item.apartment?.toLowerCase() ?? '';
                    final roleType = item.roleType?.toLowerCase() ?? '';

                    return name.contains(query) ||
                        apartment.contains(query) ||
                        roleType.contains(query);
                  }).toList();

                  if (filteredVisitors.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 40.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search_off_rounded,
                              size: 30.r,
                              color: AppColors.heading,
                            ),
                          ),

                          SizedBox(height: 14.h),

                          Text(
                            searchQuery.isEmpty
                                ? 'No Registered Visitors'
                                : 'No Visitors Found',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Text(
                            searchQuery.isEmpty
                                ? 'There are no registered visitors at the moment.'
                                : 'No visitor matches your search.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(42, 41, 51, 0.65),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              value: data.data!.metrics!
                                  .firstWhere((e) => e.label == 'Registered')
                                  .count
                                  .toString()
                                  .padLeft(2, '0'),
                              title: 'Registered',
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _statCard(
                              value: data.data!.metrics!
                                  .firstWhere(
                                    (e) => e.label == "Today's Visits",
                                  )
                                  .count
                                  .toString()
                                  .padLeft(2, '0'),
                              title: "Today's Visits",
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _statCard(
                              value: data.data!.metrics!
                                  .firstWhere((e) => e.label == 'Currently In')
                                  .count
                                  .toString()
                                  .padLeft(2, '0'),
                              title: 'Currently In',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Text(
                            "Registered Visitors",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Sorted by frequent use",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      ListView.builder(
                        itemCount: filteredVisitors.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = filteredVisitors[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xff101C16),
                                width: 1.w,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child:
                                          (item.avatarUrl != null &&
                                              item.avatarUrl!.isNotEmpty &&
                                              item.avatarUrl!.startsWith(
                                                'http',
                                              ))
                                          ? Image.network(
                                              item.avatarUrl!,
                                              height: 60.h,
                                              width: 60.w,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                    height: 60.h,
                                                    width: 60.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 28.r,
                                                      ),
                                                    ),
                                                  ),
                                            )
                                          : Container(
                                              height: 60.h,
                                              width: 60.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 28.r,
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: 9.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name ?? "N/A",
                                            style: GoogleFonts.outfit(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.heading,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "${item.roleType} · ${item.apartment}",
                                            style: GoogleFonts.outfit(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromRGBO(
                                                42,
                                                41,
                                                51,
                                                0.65,
                                              ),
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                226,
                                                181,
                                                9,
                                                0.3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            child: Text(
                                              // "FREQUENT",
                                              item.badges?.tag ?? "N/A",
                                              style: GoogleFonts.outfit(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xffE2B509),
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Builder(
                                      builder: (context) {
                                        final bool isInside =
                                            item.isInside == true ||
                                            (item.primaryAction != null &&
                                                item.primaryAction!
                                                    .toLowerCase()
                                                    .contains('out'));
                                        final badgeStatus =
                                            item.badges?.status ??
                                            (isInside
                                                ? "INSIDE"
                                                : "REGISTERED");
                                        final Color badgeStatusColor = isInside
                                            ? const Color(0xFF0284C7)
                                            : const Color(0xff24B06A);
                                        final Color badgeStatusBg = isInside
                                            ? const Color(0xFFE0F2FE)
                                            : const Color.fromRGBO(
                                                17,
                                                197,
                                                80,
                                                0.2,
                                              );

                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: badgeStatusBg,
                                            borderRadius: BorderRadius.circular(
                                              50.r,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              badgeStatus,
                                              style: GoogleFonts.outfit(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                color: badgeStatusColor,
                                                letterSpacing: -0.3,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Builder(
                                  builder: (context) {
                                    final bool isInside =
                                        item.isInside == true ||
                                        (item.primaryAction != null &&
                                            item.primaryAction!
                                                .toLowerCase()
                                                .contains('out'));

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: _visitInfoCard(
                                            title: isInside
                                                ? 'In-Time'
                                                : 'Last Visit',
                                            value: isInside
                                                ? (item.inTime ??
                                                      item.lastVisit ??
                                                      '--')
                                                : (item.lastVisit ?? '--'),
                                          ),
                                        ),
                                        SizedBox(width: 22.w),
                                        Expanded(
                                          child: _visitInfoCard(
                                            title: 'Access',
                                            value: isInside
                                                ? 'Currently Inside'
                                                : 'Auto-Approved',
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Builder(
                                  builder: (context) {
                                    final bool isInside =
                                        item.isInside == true ||
                                        (item.primaryAction != null &&
                                            item.primaryAction!
                                                .toLowerCase()
                                                .contains('out'));
                                    final String actionLabel =
                                        item.primaryAction ??
                                        (isInside
                                            ? 'Mark Out-Time'
                                            : '✓ Quick Entry');

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 37.h,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (isInside) {
                                                  _showMarkOutBottomSheet(
                                                    context,
                                                    name: item.name ?? "N/A",
                                                    flat:
                                                        item.apartment ?? "N/A",
                                                    id: item.id.toString(),
                                                    role:
                                                        item.roleType ?? "N/A",
                                                    inTime: item.inTime,
                                                  );
                                                } else {
                                                  _showQuickEntryBottomSheet(
                                                    context,
                                                    name: item.name ?? "N/A",
                                                    flat:
                                                        item.apartment ?? "N/A",
                                                    id: item.id.toString(),
                                                    role:
                                                        item.roleType ?? "N/A",
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isInside
                                                    ? const Color(0xFFD97706)
                                                    : const Color(0xFF0D1C16),
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                actionLabel,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 22.w),
                                        Expanded(
                                          child: SizedBox(
                                            height: 37.h,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                _showQuickDetailsBottomSheet(
                                                  context,
                                                  name: item.name ?? "N/A",
                                                  flat: item.apartment ?? "N/A",
                                                  role: item.roleType ?? "N/A",
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: const Color(
                                                  0xFF0D1C16,
                                                ),
                                                elevation: 0,
                                                side: const BorderSide(
                                                  color: Color(0xFF0D1C16),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        6.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'View Details',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.heading,
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
                error: (err, stacktrace) {
                  log(err.toString());
                  log(stacktrace.toString());
                  return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: Center(
                      child: Text(
                        "Something went wrong",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  );
                },
                loading: () {
                  return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.heading,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({required String value, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xff101C16), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1,
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _visitInfoCard({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0E9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD8D6D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickEntryRow({required String title, required String value}) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                letterSpacing: -0.2,
              ),
            ),

            const Spacer(),

            Text(
              value,
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
    );
  }

  Widget _quickEntryDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 13.w),
      color: const Color(0xFFE0DDD5),
    );
  }
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/ComplaintDetails.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/CreateComplaintScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/Provider/getComplaintProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class Complaint extends ConsumerStatefulWidget {
  const Complaint({super.key});

  @override
  ConsumerState<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends ConsumerState<Complaint> {
  final TextEditingController searchController = TextEditingController();
  int selectedFilter = 0;
  String searchQuery = "";

  final List<String> filters = [
    "All",
    "High Priority",
    "Under Review",
    "In Progress",
  ];

  final List<String> selectedFilterStatus = [
    "all",
    "high_priority",
    "under_review",
    "in_progress",
  ];

  String _statusToApiValue(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';
      case 'under review':
      case 'review':
      case 'under_review':
        return 'Under Review';
      case 'assigned':
        return 'Assigned';
      case 'in progress':
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return status.toLowerCase().replaceAll(' ', '_');
    }
  }

  @override
  Widget build(BuildContext context) {
    final getComplaintState = ref.watch(
      getComplaintProvider((
        status: selectedFilterStatus[selectedFilter],
        search: searchQuery,
      )),
    );
    final complaintState =
        getComplaintState.valueOrNull?.data.complaintOverview;
    final totalCount =
        getComplaintState.valueOrNull?.data.summary.totalCount ?? 0;
    final summary = getComplaintState.valueOrNull?.data.summary;
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Open Complaints",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Review and monitor complaints across the complex",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xff101C16), width: 1),
              ),
              child: getComplaintState.isLoading
                  ? SizedBox(
                      height: 100.h,
                      width: double.infinity,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.heading,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1.w,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "!",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    complaintState?.title ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    complaintState?.subtitle ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        0.75,
                                      ),
                                      letterSpacing: -0.2,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  summary?.totalCount.toString() ?? "0",
                                  style: GoogleFonts.outfit(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  "Total Complaint",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        Container(
                          width: double.infinity,
                          height: 1.h,
                          color: const Color(0xFFC6C6C6),
                        ),

                        SizedBox(height: 16.h),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _documentStat(
                                value:
                                    complaintState?.totalOpen.toString() ?? "",
                                title: "Open Complaints",
                              ),
                            ),

                            Expanded(
                              child: _documentStat(
                                value:
                                    complaintState?.highPriority.toString() ??
                                    "",
                                title: "Under Review",
                              ),
                            ),

                            Expanded(
                              child: _documentStat(
                                value:
                                    complaintState?.inProgress.toString() ?? "",
                                title: "In Progress",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 52.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              padding: EdgeInsets.only(left: 16.w, right: 10.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xff101C16), width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 26.sp,
                    color: const Color(0xff101C16),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                        letterSpacing: -0.2,
                      ),
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.trim();
                        });
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Search service or provider...",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8B8D8B),
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filters.length, (index) {
                  final bool isSelected = selectedFilter == index;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xff101C16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          filters[index],
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Open Complaints",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    "$totalCount ACTIVE",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
            getComplaintState.when(
              data: (data) {
                final allComplaints = data.data.complaints;
                final complaints = allComplaints.where((item) {
                  if (item.type != null && item.type!.isNotEmpty) {
                    return item.type!.toLowerCase() == 'complaint';
                  }
                  if (item.ticketNumber.toUpperCase().startsWith('SR')) {
                    return false;
                  }
                  return true;
                }).toList();
                if (complaints.isEmpty) {
                  return Center(child: Text("No complaints found"));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final item = complaints[index];
                    return ServiceCard(
                      icon: Icons.warning_amber_rounded,
                      title: item.title,
                      subtitle: item.unitSubtitle,
                      areaType: item.areaType,
                      areaTypeLabel: item.areaTypeLabel,
                      isEmergency: item.isEmergency,
                      priority: item.priority,
                      providerLabel: 'CATEGORY',
                      providerName: item.category,
                      scheduleLabel: 'SUBMITTED BY',
                      schedule: item.submittedBy,
                      issueLabel: 'ASSIGNED TO',
                      issues: item.assignedTo,
                      lastServiceLabel: 'DATE',
                      lastService: item.date,
                      status: _statusToApiValue(item.status),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                ComplaintDetails(id: item.id.toString()),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                log(stackTrace.toString());
                log(error.toString());
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  alignment: Alignment.center,
                  child: Text(
                    "Something went wrong",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: AppColors.heading,
                    ),
                  ),
                );
              },
              loading: () {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.heading),
                  ),
                );
              },
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50.h,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final res = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreateComplaintScreen(),
              ),
            );
            if (res == true) {
              ref.invalidate(getComplaintProvider);
            }
          },
          backgroundColor: const Color(0xFF101C16),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          icon: Icon(Icons.add, size: 20.sp),
          label: Text(
            "Post Complaint",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _documentStat({required String value, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
            height: 1.1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(42, 41, 51, 0.8),
            letterSpacing: -0.2,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? areaType;
  final String? areaTypeLabel;
  final bool? isEmergency;
  final String? priority;
  final String providerLabel;
  final String providerName;
  final String scheduleLabel;
  final String schedule;
  final String issueLabel;
  final String issues;
  final String lastServiceLabel;
  final String lastService;
  final VoidCallback onTap;
  final String status;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.areaType,
    this.areaTypeLabel,
    this.isEmergency,
    this.priority,
    required this.providerLabel,
    required this.providerName,
    required this.scheduleLabel,
    required this.schedule,
    required this.issueLabel,
    required this.issues,
    required this.lastServiceLabel,
    required this.lastService,
    required this.onTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Color(0xFF000000), width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: Color(0xFF000000), width: 1.w),
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: const Color(0xFF000000),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          height: 1.1,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 0.75),
                          height: 1.1,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if ((areaType != null && areaType!.isNotEmpty) ||
                          (areaTypeLabel != null &&
                              areaTypeLabel!.isNotEmpty)) ...[
                        SizedBox(height: 6.h),
                        Builder(
                          builder: (context) {
                            final rawType = (areaType ?? '').toLowerCase();
                            final rawLabel = (areaTypeLabel ?? '')
                                .toLowerCase();
                            final bool isCommon =
                                rawType.contains('common') ||
                                rawLabel.contains('common') ||
                                rawType == 'common_area';

                            final String label =
                                areaTypeLabel != null &&
                                    areaTypeLabel!.isNotEmpty
                                ? areaTypeLabel!
                                : (isCommon ? "Common Area" : "Inside Unit");

                            final Color bg = isCommon
                                ? const Color(0xFFF9F3EA)
                                : const Color(0xFFEFF3F6);
                            final Color border = isCommon
                                ? const Color(0xFFB8860B)
                                : const Color(0xFF90A4AE);
                            final Color textColor = isCommon
                                ? const Color(0xFF8C6400)
                                : const Color(0xFF37474F);

                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(color: border, width: 0.9),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCommon
                                        ? Icons.domain_rounded
                                        : Icons.home_rounded,
                                    size: 13.sp,
                                    color: textColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    label,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    final p = (priority ?? "HIGH").toUpperCase();
                    Color badgeBg;
                    Color badgeText;
                    Color badgeBorder;

                    if (p.contains("HIGH") ||
                        p.contains("URGENT") ||
                        p.contains("EMERGENCY")) {
                      badgeBg = const Color(0xFFFFEBEE);
                      badgeText = const Color(0xFFD32F2F);
                      badgeBorder = const Color(0xFFEF9A9A);
                    } else if (p.contains("MEDIUM") || p.contains("MED")) {
                      badgeBg = const Color(0xFFFFF3E0);
                      badgeText = const Color(0xFFE65100);
                      badgeBorder = const Color(0xFFFFB74D);
                    } else if (p.contains("LOW")) {
                      badgeBg = const Color(0xFFE8F5E9);
                      badgeText = const Color(0xFF2E7D32);
                      badgeBorder = const Color(0xFFA5D6A7);
                    } else {
                      badgeBg = const Color(0xFFF5F5F5);
                      badgeText = const Color(0xFF333333);
                      badgeBorder = const Color(0xFFD9D9D0);
                    }
                    
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: badgeBorder, width: 1.w),
                      ),
                      child: Text(
                        p,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: badgeText,
                          letterSpacing: -0.2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoItem(label: providerLabel, value: providerName),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _infoItem(label: scheduleLabel, value: schedule),
                ),
              ],
            ),
            SizedBox(height: 17.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoItem(label: issueLabel, value: issues),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _infoItem(label: lastServiceLabel, value: lastService),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Icon(Icons.circle, size: 8.sp, color: Color(0xFF1E5993)),
                SizedBox(width: 4.w),
                Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E5993),
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Text(
                        "View Details",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(184, 134, 11, 0.9),
                          height: 1.1,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 15.sp,
                        color: Color.fromRGBO(184, 134, 11, 0.9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(42, 41, 51, 0.75),
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/AssociationServiceManageDetails.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementResModel.dart';

import 'provider/getServiceManagementProvider.dart';

class AssociationServiceManagement extends ConsumerStatefulWidget {
  const AssociationServiceManagement({super.key});

  @override
  ConsumerState<AssociationServiceManagement> createState() =>
      _AssociationServiceManagementState();
}

class _AssociationServiceManagementState
    extends ConsumerState<AssociationServiceManagement> {
  final searchConatroller = TextEditingController();
  int selectedFilter = 0;
  String selectedFilterKey = "all";
  String searchQuery = "";
  List<FilterChip> cachedChips = [];
  final List<String> filters = [
    "All Services · 06",
    "Housekeeping · 02",
    "Security · 02",
    "Equipment · 02",
  ];

  @override
  Widget build(BuildContext context) {
    final getServiceManagementState = ref.watch(
      getServiceManagementProvider((
        status: selectedFilterKey,
        search: searchQuery,
      )),
    );

    final apiFilterChips =
        getServiceManagementState.valueOrNull?.data.filterChips;
    if (apiFilterChips != null && apiFilterChips.isNotEmpty) {
      cachedChips = apiFilterChips;
    }

    final footer = getServiceManagementState.valueOrNull?.data.footerNote;

    final complexOverview =
        getServiceManagementState.valueOrNull?.data.complexServiceOverview;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service Management",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Association Operations",
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
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF000000), width: 1.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: getServiceManagementState.isLoading
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
                          children: [
                            Expanded(
                              child: Text(
                                "COMPLEX SERVICE OVERVIEW",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6.h,
                                  width: 6.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF12A65A),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  complexOverview?.badge ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF24B06A),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),
                        Text(
                          complexOverview?.title ?? "",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Text(
                          complexOverview?.description ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.75),
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 13.h),
                        Divider(
                          height: 1,
                          thickness: 0.8,
                          color: Color.fromRGBO(16, 28, 22, 0.5),
                        ),
                        SizedBox(height: 13.h),
                        Row(
                          children: [
                            Expanded(
                              child: _serviceStat(
                                label:
                                    complexOverview
                                        ?.metrics
                                        .activeServices
                                        .title ??
                                    "",
                                value:
                                    complexOverview
                                        ?.metrics
                                        .activeServices
                                        .count ??
                                    "",
                                status:
                                    complexOverview
                                        ?.metrics
                                        .activeServices
                                        .label ??
                                    "",
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label:
                                    complexOverview?.metrics.providers.title ??
                                    "",
                                value:
                                    complexOverview?.metrics.providers.count ??
                                    "",
                                status:
                                    complexOverview?.metrics.providers.label ??
                                    "",
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label:
                                    complexOverview
                                        ?.metrics
                                        .performance
                                        .title ??
                                    "",
                                value:
                                    complexOverview
                                        ?.metrics
                                        .performance
                                        .count ??
                                    "",
                                status:
                                    complexOverview
                                        ?.metrics
                                        .performance
                                        .label ??
                                    "",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 19.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
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
                      controller: searchConatroller,
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
                        hintText: "Search service or provider...",
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
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cachedChips.isNotEmpty
                    ? List.generate(cachedChips.length, (index) {
                        final chip = cachedChips[index];
                        final bool isSelected =
                            selectedFilterKey.toLowerCase() ==
                            chip.key.toLowerCase();
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilterKey = chip.key;
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
                                    ? const Color(0xFFB8860B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40.r),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xff101C16),
                                  width: 1.w,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                chip.label,
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
                      })
                    : List.generate(filters.length, (index) {
                        final bool isSelected = selectedFilter == index;
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilter = index;
                                if (index == 0) {
                                  selectedFilterKey = "all";
                                } else if (index == 1) {
                                  selectedFilterKey = "housekeeping";
                                } else if (index == 2) {
                                  selectedFilterKey = "security";
                                } else if (index == 3) {
                                  selectedFilterKey = "equipment";
                                }
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
                                    ? const Color(0xFFB8860B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40.r),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : const Color(0xff101C16),
                                  width: 1.w,
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
            getServiceManagementState.when(
              data: (data) {
                final management = data.data.servicesList;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: management.length,
                  itemBuilder: (context, index) {
                    final item = management[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: ServiceCard(
                        icon: Icons.cleaning_services_outlined,
                        title: item.title,
                        subtitle: item.subtitle,
                        status: item.statusBadge,
                        providerLabel: 'Assigned Provider',
                        providerName: item.assignedProvider,
                        scheduleLabel: 'Service Schedule',
                        schedule: item.serviceSchedule,
                        issueLabel: 'Reported Issues',
                        issues: item.reportedIssues,
                        lastServiceLabel: 'Last Service',
                        lastService: item.lastService,
                        performance: item.servicePerformance.formatted,
                        personlabel: item.assignedPerson.label,
                        image: item.assignedPerson.avatar,
                        id: item.id.toString(),
                        percentage: item.servicePerformance.percentage
                            .toString(),
                        isSecurity: false,
                      ),
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
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Color.fromRGBO(184, 134, 11, 0.9)),
              ),
              child: Text(
                footer ?? "",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(184, 134, 11, 0.9),
                  letterSpacing: -0.1,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _serviceStat({
    required String label,
    required String value,
    required String status,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(42, 41, 51, 0.75),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB8860B),
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

  final String providerLabel;
  final String providerName;

  final String scheduleLabel;
  final String schedule;

  final String issueLabel;
  final String issues;

  final String lastServiceLabel;
  final String lastService;

  final String performance;
  final bool isSecurity;
  final String status;
  final String personlabel;
  final String image;
  final String id;
  final String percentage;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.providerLabel,
    required this.providerName,
    required this.scheduleLabel,
    required this.schedule,
    required this.issueLabel,
    required this.issues,
    required this.lastServiceLabel,
    required this.lastService,
    required this.performance,
    required this.isSecurity,
    required this.status,
    required this.personlabel,
    required this.image,
    required this.id,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Color(0xFF000000), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 242, 165, 0.6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(icon, size: 18.sp, color: const Color(0xFFB8860B)),
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
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // ACTIVE
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34.r),
                  border: Border.all(
                    color: const Color(0xFF24B06A),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF24B06A),
                    letterSpacing: -0.2,
                  ),
                ),
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
                child: _InfoItem(label: providerLabel, value: providerName),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: _InfoItem(label: scheduleLabel, value: schedule),
              ),
            ],
          ),
          SizedBox(height: 17.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _InfoItem(label: issueLabel, value: issues),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: _InfoItem(label: lastServiceLabel, value: lastService),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          SizedBox(height: 10.h),
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF000000), width: 1.w),
                ),
                child: ClipOval(
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 18.sp,
                        color: Colors.black87,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personlabel,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75),
                        height: 1.1,
                        letterSpacing: -0.1,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      providerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AssociationServiceManageDetails(id: id),
                    ),
                  );
                },
                child: Container(
                  height: 30.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 242, 165, 0.3),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Center(
                    child: Text(
                      'View Details →',
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Service Performance',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Text(
                performance,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              children: [
                Container(
                  height: 3.h,
                  width: double.infinity,
                  color: const Color(0xFF919191),
                ),
                FractionallySizedBox(
                  widthFactor: double.tryParse(percentage) != null
                      ? ((double.parse(percentage) > 10
                                ? double.parse(percentage) / 100
                                : double.parse(percentage) / 10))
                            .clamp(0.0, 1.0)
                      : 0,
                  child: Container(height: 3.h, color: const Color(0xFF195B3A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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

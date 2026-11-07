import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/ServiceRequestDetails.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import 'createServiceReqeust.dart';

class ServiiceRequest extends ConsumerStatefulWidget {
  const ServiiceRequest({super.key});

  @override
  ConsumerState<ServiiceRequest> createState() => _ServiiceRequestState();
}

class _ServiiceRequestState extends ConsumerState<ServiiceRequest> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  int selectedFilter = 0;

  final List<String> filters = ["All", "Pending", "In Progress", "Resolved"];

  final List<Map<String, dynamic>> complaints = const [
    {
      "title": "Water Leakage",
      "flat": "Flat B-302",
      "issue": "Bathroom pipe",
      "requestId": "SR-1024",
      "name": "Ahmed Khan",
      "status": "Pending",
      "date": "24 Aug",
      "icon": Icons.add_circle_outline,
    },
    {
      "title": "Water Leakage",
      "flat": "Flat B-302",
      "issue": "Bathroom pipe",
      "requestId": "SR-1024",
      "name": "Ahmed Khan",
      "status": "In Progress",
      "date": "24 Aug",
      "icon": Icons.waterfall_chart_outlined,
    },
    {
      "title": "Water Leakage",
      "flat": "Flat B-302",
      "issue": "Bathroom pipe",
      "requestId": "SR-1024",
      "name": "Ahmed Khan",
      "status": "High",
      "date": "24 Aug",
      "icon": Icons.home_work_outlined,
    },
    {
      "title": "Water Leakage",
      "flat": "Flat B-302",
      "issue": "Bathroom pipe",
      "requestId": "SR-1024",
      "name": "Ahmed Khan",
      "status": "Resolved",
      "date": "24 Aug",
      "icon": Icons.check,
    },
    {
      "title": "Water Leakage",
      "flat": "Flat B-302",
      "issue": "Bathroom pipe",
      "requestId": "SR-1024",
      "name": "Ahmed Khan",
      "status": "Pending",
      "date": "24 Aug",
      "icon": Icons.trending_up,
    },
  ];
  @override
  Widget build(BuildContext context) {
    final String? selectedStatus = selectedFilter == 0
        ? null
        : selectedFilter == 1
        ? "pending"
        : selectedFilter == 2
        ? "in_progress"
        : "resolved";

    final serviceState = ref.watch(
      getServiceRequestProvider((status: selectedStatus, search: searchQuery)),
    );
    final requestSummer = serviceState.valueOrNull?.data?.requestSummary;
    final startCard = serviceState.valueOrNull?.data?.statCards;
    final allRequest = serviceState.valueOrNull?.data?.summary;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Requests",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Residential/Commercial management team",
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateServiceRequest(),
                  ),
                );
              },
              child: Container(
                width: 50.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff101C16),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: "ACTIVE REQUESTS",
                      value: startCard?.activeRequests?.value ?? "0",
                      subtitle: "Requests requiring attention",
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: _summaryCard(
                      title: "RESOLVED",
                      value: startCard?.resolved?.value ?? "0",
                      subtitle: "This month",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "All Requests",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Text(
                    "${allRequest?.totalCount ?? 0} TOTAL",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
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
            SizedBox(height: 20.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: List.generate(filters.length, (index) {
                  final isSelected = selectedFilter == index;
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0C1B15)
                              : const Color(0xFFFFFCEB),
                          border: Border.all(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          filters[index],
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
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
            serviceState.when(
              data: (data) {
                final allRequests = data.data?.requests ?? [];
                final requests = allRequests.where((item) {
                  if (item.type != null && item.type!.isNotEmpty) {
                    return item.type!.toLowerCase() == 'service_request';
                  }
                  if (item.ticketNumber != null &&
                      item.ticketNumber!.toUpperCase().startsWith('CMP')) {
                    return false;
                  }
                  return true;
                }).toList();
                if (requests.isEmpty) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    alignment: Alignment.center,
                    child: Text(
                      "No service requests found",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ),
                  );
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: requests.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFC6C6C6),
                      );
                    },
                    itemBuilder: (context, index) {
                      final item = requests[index];

                      const figmaIcons = [
                        Icons.add_circle_outline,
                        Icons.waterfall_chart_outlined,
                        Icons.home_work_outlined,
                        Icons.check,
                        Icons.trending_up,
                      ];
                      final icon = figmaIcons[index % figmaIcons.length];

                      final statusDisplay =
                          (item.isHighPriority == true ||
                              item.priority?.toLowerCase() == "high")
                          ? "High"
                          : (item.statusLabel != null &&
                                item.statusLabel!.isNotEmpty)
                          ? item.statusLabel!
                          : (item.status != null && item.status!.isNotEmpty)
                          ? (item.status!.toLowerCase() == "submitted" ||
                                    item.status!.toLowerCase() == "assigned"
                                ? "Pending"
                                : item.status!.replaceAll('_', ' '))
                          : "Pending";

                      final line2 =
                          (item.flatNumber != null &&
                              item.flatNumber!.isNotEmpty)
                          ? "${item.flatNumber}${item.category != null && item.category!.isNotEmpty ? ' · ${item.category}' : ''}"
                          : (item.subtitle ?? "");

                      final line3 =
                          (item.ticketNumber != null &&
                              item.ticketNumber!.isNotEmpty &&
                              item.residentName != null &&
                              item.residentName!.isNotEmpty)
                          ? "${item.ticketNumber} · ${item.residentName}"
                          : (item.ticketNumber ?? item.residentName ?? "");

                      return Padding(
                        padding: EdgeInsets.only(
                          top: 14.h,
                          bottom: 14.h,
                          left: 11.w,
                          right: 11.w,
                        ),
                        child: ComplaintItem(
                          title: item.title ?? "",
                          subTite: line2,
                          number: line3,
                          date: item.date ?? "",
                          status: statusDisplay,
                          icon: icon,
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ServiceRequestDetails(
                                  id: item.id.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Request Summary",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      title: "PENDING",
                      value: requestSummer?.pending?.value ?? "0",
                      subtitle: "Awaiting action",
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: _summaryCard(
                      title: "IN PROGRESS",
                      value: requestSummer?.inProgress?.value ?? "0",
                      subtitle: "Currently assigned",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: -0.2,
              height: 1.1,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(41, 41, 51, 0.8),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ComplaintItem extends StatelessWidget {
  final String title;
  final String subTite;
  final String? description;
  final String number;
  final String date;
  final String status;
  final IconData? icon;
  final VoidCallback onTap;

  const ComplaintItem({
    super.key,
    required this.title,
    required this.subTite,
    this.description,
    required this.number,
    required this.date,
    required this.status,
    this.icon,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    final s = status.trim().toLowerCase().replaceAll('_', ' ');
    if (s.contains("high") || s.contains("urgent")) {
      return const Color(0xFFF7B5A5);
    } else if (s.contains("pending") ||
        s.contains("submit") ||
        s.contains("assign") ||
        s.contains("await")) {
      return const Color(0xFFFFF6D5);
    } else if (s.contains("progress")) {
      return const Color(0xFFB8D0DC);
    } else if (s.contains("resolved") ||
        s.contains("complete") ||
        s.contains("close")) {
      return const Color(0xFFC5C3BD);
    }
    return const Color(0xFFEDEDED);
  }

  Color _getStatusTextColor(String status) {
    final s = status.trim().toLowerCase().replaceAll('_', ' ');
    if (s.contains("high") || s.contains("urgent")) {
      return const Color(0xFFD82F19);
    } else if (s.contains("pending") ||
        s.contains("submit") ||
        s.contains("assign") ||
        s.contains("await")) {
      return const Color(0xFFC08A00);
    } else if (s.contains("progress")) {
      return const Color(0xFF17618A);
    } else if (s.contains("resolved") ||
        s.contains("complete") ||
        s.contains("close")) {
      return const Color(0xFF282B3A);
    }
    return Colors.black;
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return status;
    final formatted = status.replaceAll('_', ' ');
    return formatted
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 242, 165, 0.6),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              icon ?? Icons.add_circle_outline,
              size: 20.sp,
              color: const Color(0xFFB8860B),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subTite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    color: const Color.fromRGBO(0, 0, 0, 0.75),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  number,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                    color: const Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  _formatStatus(status),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusTextColor(status),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                date,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000000),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(width: 7.w),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE3E3E3),
              ),
              child: Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: const Color(0xFF2A2933),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

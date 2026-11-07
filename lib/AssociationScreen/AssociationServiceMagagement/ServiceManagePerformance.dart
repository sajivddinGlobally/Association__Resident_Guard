import 'dart:developer';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementPerformanceResModel.dart';

import 'Provider/serviceManagementPerformanceProvider.dart';

class ServiceManagePerformance extends ConsumerStatefulWidget {
  final String id;
  const ServiceManagePerformance({super.key, required this.id});

  @override
  ConsumerState<ServiceManagePerformance> createState() =>
      _ServiceManagePerformanceState();
}

class _ServiceManagePerformanceState
    extends ConsumerState<ServiceManagePerformance> {
  @override
  Widget build(BuildContext context) {
    final servicePerformanceState = ref.watch(
      serviceManagementPerformanceProvider(widget.id),
    );
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Details",
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
                      "Service Performance",
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
      body: servicePerformanceState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "PERFORMANCE OVERVIEW",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFB8860B),
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                data.data.performanceOverview.badge,
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB8860B),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB8860B),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.trending_up,
                                color: Colors.black,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data.performanceOverview.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      height: 1.1,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data.data.performanceOverview.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.75,
                                      ),
                                      height: 1.15,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          height: 1.h,
                          width: double.infinity,
                          color: Color(0xFF000000),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Overall Performance",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.75,
                                      ),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data
                                        .data
                                        .performanceOverview
                                        .overallPerformance,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFB8860B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF403F3F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  data.data.performanceOverview.statusRating,
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
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Performance Metrics",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Column(
                      children: [
                        _performanceMetric(
                          title: "Service Quality",
                          percentage:
                              int.tryParse(
                                data
                                    .data
                                    .performanceMetrics
                                    .serviceQuality
                                    .score
                                    .replaceAll('%', ''),
                              ) ??
                              0,
                          description:
                              data.data.performanceMetrics.serviceQuality.label,
                          status: data
                              .data
                              .performanceMetrics
                              .serviceQuality
                              .rating,
                          progressColor: const Color(0xFFC58B00),
                        ),
                        SizedBox(height: 16.h),
                        _performanceMetric(
                          title: "Completion Rate",
                          percentage:
                              int.tryParse(
                                data
                                    .data
                                    .performanceMetrics
                                    .completionRate
                                    .score
                                    .replaceAll('%', ''),
                              ) ??
                              0,
                          description:
                              data.data.performanceMetrics.completionRate.label,
                          status: data
                              .data
                              .performanceMetrics
                              .completionRate
                              .rating,
                          progressColor: const Color(0xFF25B36B),
                        ),
                        SizedBox(height: 16.h),
                        _performanceMetric(
                          title: "Response Performance",
                          percentage:
                              int.tryParse(
                                data
                                    .data
                                    .performanceMetrics
                                    .responsePerformance
                                    .score
                                    .replaceAll('%', ''),
                              ) ??
                              0,
                          description: data
                              .data
                              .performanceMetrics
                              .responsePerformance
                              .label,
                          status: data
                              .data
                              .performanceMetrics
                              .responsePerformance
                              .rating,
                          progressColor: const Color(0xFF087B9F),
                        ),
                        SizedBox(height: 16.h),
                        _performanceMetric(
                          title: "Issue Resolution",
                          percentage:
                              int.tryParse(
                                data
                                    .data
                                    .performanceMetrics
                                    .issueResolution
                                    .score
                                    .replaceAll('%', ''),
                              ) ??
                              0,
                          description: data
                              .data
                              .performanceMetrics
                              .issueResolution
                              .label,
                          status: data
                              .data
                              .performanceMetrics
                              .issueResolution
                              .rating,
                          progressColor: const Color(0xFF087B9F),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Service Snapshot",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 11.h,
                    childAspectRatio: 1.8.h,
                    children: [
                      _statCard(
                        icon: Icons.check,
                        title: "Completed",
                        value: data.data.serviceSnapshot.completed.count
                            .toString(),
                        subtitle: data.data.serviceSnapshot.completed.label,
                      ),
                      _statCard(
                        icon: Icons.access_time,
                        title: "Avg Response",
                        value: data.data.serviceSnapshot.avgResponse.count,
                        subtitle: data.data.serviceSnapshot.avgResponse.label,
                      ),

                      _statCard(
                        icon: Icons.shield_outlined,
                        title: "Resolved",
                        value: data.data.serviceSnapshot.resolved.count,
                        subtitle: data.data.serviceSnapshot.resolved.label,
                      ),

                      _statCard(
                        icon: Icons.star_border,
                        title: "Rating",
                        value: data.data.serviceSnapshot.rating.count,
                        subtitle: data.data.serviceSnapshot.rating.label,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Performance Trend",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _performanceTrendCard(data.data.performanceTrend),
                  SizedBox(height: 20.h),
                  Text(
                    "Recent Service Issues",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFCEB),
                      borderRadius: BorderRadius.circular(11.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.data.recentServiceIssues.issues.length,
                      itemBuilder: (context, index) {
                        final item =
                            data.data.recentServiceIssues.issues[index];

                        return Column(
                          children: [
                            _issueItem(
                              icon: Icons.check,
                              title: item.issueTitle,
                              date: item.reportedDate,
                              status: item.statusBadge,
                              statusColor: AppColors.heading,
                            ),

                            if (index !=
                                data.data.recentServiceIssues.issues.length - 1)
                              _divider(),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 21.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101C16),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Performance Summary",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Text(
                              data.data.performanceSummary.monthBadge,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 9.h),
                        Text(
                          data.data.performanceSummary.summaryText,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 11.h),
                        Container(
                          width: double.infinity,
                          height: 1.h,
                          color: const Color(0xFF6D746F),
                        ),
                        SizedBox(height: 9.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _summaryItem(
                                title: "Overall Status",
                                value:
                                    data.data.performanceSummary.overallStatus,
                              ),
                            ),
                            Expanded(
                              child: _summaryItem(
                                title: "Trend",
                                value: data.data.performanceSummary.trend,
                              ),
                            ),
                            Expanded(
                              child: _summaryItem(
                                title: "Review",
                                value: data.data.performanceSummary.nextReview,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 21.h),
                ],
              ),
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
    );
  }

  Widget _performanceMetric({
    required String title,
    required int percentage,
    required String description,
    required String status,
    required Color progressColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  height: 1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Text(
              "$percentage%",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                height: 1,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 5.h,
            backgroundColor: const Color(0xff8B8B8B),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        SizedBox(height: 5.h),
        Row(
          children: [
            Expanded(
              child: Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                  height: 1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Text(
              status,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                height: 1,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 14.w, right: 10.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 242, 165, 0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(icon, size: 16.sp, color: const Color(0xFFC58B00)),
            ),
          ),
          const Spacer(),
          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              height: 1,
              letterSpacing: -0.1,
            ),
          ),
          SizedBox(height: 4.h),
          // Value
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              height: 1,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              height: 1,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _issueItem({
    required IconData icon,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.w),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Center(
              child: Icon(icon, size: 18.sp, color: Colors.black),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                SizedBox(height: 3.h),
                Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: statusColor, width: 1.w),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              status,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: statusColor,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            height: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      color: const Color(0xFFB5B5B5),
    );
  }

  Widget _performanceTrendCard(PerformanceTrend trend) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trend.title.isNotEmpty ? trend.title : "Monthly Performance",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              if (trend.trendValues.isNotEmpty)
                Text(
                  "${trend.trendValues.last}%",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB8860B),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          // --- FlChart Package Implementation ---
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: _buildFlChart(trend),
          ),
          SizedBox(height: 10.h),
          if (trend.months.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: trend.months.map((month) {
                return Text(
                  month,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFlChart(PerformanceTrend trend) {
    if (trend.trendValues.isEmpty) return const SizedBox.shrink();

    final int minVal = trend.trendValues.reduce(math.min);
    final int maxVal = trend.trendValues.reduce(math.max);
    final double minY = (minVal - 2).toDouble();
    final double maxY = (maxVal + 2).toDouble();
    final double range = maxY > minY ? (maxY - minY) : 1.0;

    final spots = List.generate(
      trend.trendValues.length,
      (index) => FlSpot(index.toDouble(), trend.trendValues[index].toDouble()),
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range / 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: const Color(0xFF8B8B8B).withValues(alpha: 0.35),
            strokeWidth: 1.0,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (trend.trendValues.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: const Color(0xFFB8860B),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                if (index == barData.spots.length - 1) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: const Color(0xFFB8860B),
                    strokeWidth: 2.5,
                    strokeColor: Colors.white,
                  );
                }
                return FlDotCirclePainter(
                  radius: 2.5,
                  color: const Color(0xFFB8860B),
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFB8860B).withValues(alpha: 0.20),
                  const Color(0xFFB8860B).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => const Color(0xFF101C16),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()}%',
                  GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

/*
// Previous CustomPainter implementation:
class _PerformanceChartPainter extends CustomPainter {
  final List<int> values;

  _PerformanceChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw 4 horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF8B8B8B).withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final double lineSpacing = size.height / 3.0;
    for (int i = 0; i < 4; i++) {
      final double y = i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.isEmpty) return;

    // 2. Compute scale
    final int minVal = values.reduce(math.min);
    final int maxVal = values.reduce(math.max);
    final double minY = (minVal - 2).toDouble();
    final double maxY = (maxVal + 2).toDouble();
    final double range = maxY > minY ? (maxY - minY) : 1.0;

    final List<Offset> points = [];
    final int n = values.length;

    for (int i = 0; i < n; i++) {
      final double x = n > 1 ? (size.width / (n - 1)) * i : size.width / 2;
      final double normalizedY = (values[i] - minY) / range;
      final double y =
          size.height - (normalizedY * size.height).clamp(0.0, size.height);
      points.add(Offset(x, y));
    }

    // 3. Draw gradient fill area under the line
    if (points.length > 1) {
      final Path fillPath = Path();
      fillPath.moveTo(points.first.dx, size.height);
      for (final p in points) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFB8860B).withValues(alpha: 0.20),
            const Color(0xFFB8860B).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    // 4. Draw line connecting points
    final linePaint = Paint()
      ..color = const Color(0xFFB8860B)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // 5. Draw point dots on intermediate points
    final dotPaint = Paint()
      ..color = const Color(0xFFB8860B)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawCircle(points[i], 2.5, dotPaint);
    }

    // 6. Highlight the last point (indicator circle with white core)
    final lastPoint = points.last;
    final outerRingPaint = Paint()
      ..color = const Color(0xFFB8860B)
      ..style = PaintingStyle.fill;
    final innerCenterPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(lastPoint, 5.0, outerRingPaint);
    canvas.drawCircle(lastPoint, 2.5, innerCenterPaint);
  }

  @override
  bool shouldRepaint(covariant _PerformanceChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
*/

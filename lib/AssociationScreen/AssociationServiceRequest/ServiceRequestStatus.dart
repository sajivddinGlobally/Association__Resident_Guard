import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import 'Provider/getServiceRequestStatusProvider.dart';

class ServiceRequestStatus extends ConsumerStatefulWidget {
  final String id;
  const ServiceRequestStatus({super.key, required this.id});

  @override
  ConsumerState<ServiceRequestStatus> createState() =>
      _ServiceRequestStatusState();
}

class _ServiceRequestStatusState extends ConsumerState<ServiceRequestStatus> {
  final List<Map<String, dynamic>> timeline = const [
    {
      'title': 'Request Raised',
      'description': 'Service request was submitted by the resident.',
      'date': '24 Aug 2026',
      'completed': true,
    },
    {
      'title': 'Request Reviewed',
      'description':
          'Association reviewed the request and approved it for service action.',
      'date': '24 Aug 2026',
      'completed': true,
    },
    {
      'title': 'Service Assigned',
      'description': 'Request assigned to the plumbing service provider.',
      'date': '24 Aug 2026',
      'completed': true,
    },
    {
      'title': 'Request Resolved',
      'description':
          'This step will be updated once the service work is completed.',
      'date': '',
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final getServiceRequestStatusState = ref.watch(
      getServiceRequestStatusProvider(widget.id),
    );
    final headers = getServiceRequestStatusState.valueOrNull?.data?.header;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
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
                    "Ticket Status Tracking",
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
                    headers?.subtitle ?? "Service Request · SR-1024",
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
      body: getServiceRequestStatusState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
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
                                data.data?.ticketBanner?.tag ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
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
                                data.data?.ticketBanner?.status ?? "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
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
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 242, 165, 0.3),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Icon(
                                Icons.trending_up,
                                color: const Color(0xFFB8860B),
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data?.ticketBanner?.title ?? "N/A",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data.data?.ticketBanner?.subtitle ?? "N/A",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          height: 1.h,
                          width: double.infinity,
                          color: const Color(0xFFC6C6C6),
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
                                    "Raised On",
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
                                    data.data?.ticketBanner?.raisedDate ??
                                        "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Updated",
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
                                    data.data?.ticketBanner?.lastUpdate ??
                                        "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Priority",
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
                                    data.data?.ticketBanner?.priority ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Ticket Progress",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(36, 176, 106, 0.12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: const Color(0xFF24B06A),
                                  size: 18.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TICKET PROGRESS",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.75,
                                      ),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    // "Service Work In Progress",
                                    data.data?.ticketProgress?.headline ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFF24B06A),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                data.data?.ticketProgress?.statusBadge ?? "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 5.h,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E0E0),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor:
                                    (double.tryParse(
                                          data
                                                  .data
                                                  ?.ticketProgress
                                                  ?.progressPercentage
                                                  .toString() ??
                                              "0",
                                        ) ??
                                        0) /
                                    100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB8860B),
                                    borderRadius: BorderRadius.circular(3.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (data.data?.ticketProgress?.steps != null)
                          Row(
                            children: List.generate(
                              data.data!.ticketProgress!.steps!.length,
                              (index) {
                                final step =
                                    data.data!.ticketProgress!.steps![index];

                                return _statusLabel(
                                  title: step,
                                  alignment: index == 0
                                      ? Alignment.centerLeft
                                      : index ==
                                            data
                                                    .data!
                                                    .ticketProgress!
                                                    .steps!
                                                    .length -
                                                1
                                      ? Alignment.centerRight
                                      : Alignment.center,
                                  isActive:
                                      index <=
                                      data.data!.ticketProgress!.steps!.indexOf(
                                        data
                                                .data!
                                                .ticketProgress!
                                                .currentStep ??
                                            "N/A",
                                      ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Lifecycle Stages",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Column(
                      children: List.generate(
                        data.data?.lifecycleStages?.length ?? 0,
                        (index) {
                          final item = data.data!.lifecycleStages![index];
                          return _TimelineItem(
                            title: item.title ?? "N/A",
                            description: item.description ?? "N/A",
                            date: item.date ?? "Pending",
                            completed: item.isCompleted ?? false,
                            isLast:
                                index ==
                                (data.data!.lifecycleStages!.length - 1),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 242, 165, 0.3),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.push_pin,
                              color: const Color(0xFFC38A00),
                              size: 18.sp,
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
                                data
                                        .data
                                        ?.assignedServiceProvider
                                        ?.providerName ??
                                    "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                data.data?.assignedServiceProvider?.subtitle ??
                                    "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF1E5993),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            data.data?.assignedServiceProvider?.status ?? "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E5993),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Error loading service request details',
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(42, 41, 51, 0.75),
              ),
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _statusLabel({
    required final String title,
    required final Alignment alignment,
    bool isActive = false,
  }) {
    return Expanded(
      child: Align(
        alignment: alignment,
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            color: isActive
                ? const Color(0xFF24B06A)
                : const Color.fromRGBO(42, 41, 51, 0.7),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final bool completed;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed
                      ? const Color(0xFFF1DFAC)
                      : const Color(0xFFF0E1B6),
                ),
                child: Center(
                  child: completed
                      ? Icon(
                          Icons.check,
                          size: 18.sp,
                          color: const Color(0xFF111111),
                        )
                      : Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFC38A00),
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.w,
                    color: const Color.fromRGBO(16, 28, 22, 0.35),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, bottom: isLast ? 0 : 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                    ),
                  ),
                  if (date.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      date,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFC38A00),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

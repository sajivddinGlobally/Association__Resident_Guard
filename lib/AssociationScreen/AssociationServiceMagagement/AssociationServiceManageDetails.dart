import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/ServiceManagePerformance.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/ServiceManageProviderDetails.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import 'Provider/serviceManagementDetailsProvider.dart';

class AssociationServiceManageDetails extends ConsumerStatefulWidget {
  final String id;
  const AssociationServiceManageDetails({super.key, required this.id});

  @override
  ConsumerState<AssociationServiceManageDetails> createState() =>
      _AssociationServiceManageDetailsState();
}

class _AssociationServiceManageDetailsState
    extends ConsumerState<AssociationServiceManageDetails> {
  @override
  Widget build(BuildContext context) {
    final serviceDetailsState = ref.watch(
      serviceManagementDetailsProvider(widget.id),
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
                      "Service Management",
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
      body: serviceDetailsState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 17.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.data.header.complexName,
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
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34.r),
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Color(0xFF000000),
                                    size: 10.sp,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    data.data.heroCard.badgeStatus,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF000000),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                color: Color(0xFFB8860B),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(
                                Icons.cleaning_services_outlined,
                                size: 18.sp,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data.heroCard.title,
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
                                  SizedBox(height: 4.h),
                                  Text(
                                    data.data.heroCard.subtitle,
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
                        SizedBox(height: 17.h),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromRGBO(16, 28, 22, 0.5),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: _serviceStat(
                                label: "Schedule",
                                value: data.data.heroCard.metrics.schedule,
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label: "Service Since",
                                value: data.data.heroCard.metrics.serviceSince,
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label: "Issues",
                                value: data.data.heroCard.metrics.issues,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Service Information",
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
                      horizontal: 14.w,
                      vertical: 18.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 4,
                      children: [
                        _infoItem(
                          label: "Service Type",
                          value: data.data.serviceInformation.serviceType,
                        ),

                        _infoItem(
                          label: "Current Status",
                          value: data.data.serviceInformation.currentStatus,
                        ),

                        _infoItem(
                          label: "Service Schedule",
                          value: data.data.serviceInformation.serviceSchedule,
                        ),

                        _infoItem(
                          label: "Service Time",
                          value: data.data.serviceInformation.serviceTime,
                        ),

                        _infoItem(
                          label: "Last Service",
                          value: data.data.serviceInformation.lastService,
                        ),

                        _infoItem(
                          label: "Next Review",
                          value: data.data.serviceInformation.nextReview,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Assigned Person / Vendor",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ServiceManageProviderDetails(id: widget.id),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                data.data.assignedVendor.avatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 20.sp,
                                    color: Colors.black87,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data.assignedVendor.providerLabel,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                    height: 1,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  data.data.assignedVendor.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  data.data.assignedVendor.roleDescription,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                    height: 1.2,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF2A2933),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Scope of Work",
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
                      horizontal: 12.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Column(
                      children: List.generate(
                        data.data.scopeOfWork.checklistItems.length,
                        (index) {
                          final item =
                              data.data.scopeOfWork.checklistItems[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index ==
                                      data
                                              .data
                                              .scopeOfWork
                                              .checklistItems
                                              .length -
                                          1
                                  ? 0
                                  : 16.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: item.isCompleted
                                        ? const Color(0xFFB8860B)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: const Color(0xFF101C16),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: item.isCompleted
                                      ? Center(
                                          child: Icon(
                                            Icons.check,
                                            color: const Color(0xFF000000),
                                            size: 18.sp,
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    item.task,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                      height: 1.1,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(height: 20.h),
                  // Text(
                  //   "Reported Issues",
                  //   style: GoogleFonts.outfit(
                  //     fontSize: 18.sp,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.heading,
                  //     letterSpacing: -0.2,
                  //   ),
                  // ),
                  // SizedBox(height: 10.h),
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 10.w,
                  //     vertical: 10.h,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(10.r),
                  //     border: Border.all(color: Color(0xFFB8860B), width: 1.w),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         width: 35.w,
                  //         height: 34.h,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10.r),
                  //           color: Color.fromRGBO(184, 134, 11, 0.9),
                  //         ),
                  //         child: Center(
                  //           child: Text(
                  //             data.data.reportedIssues.badge,
                  //             style: GoogleFonts.outfit(
                  //               fontSize: 13.sp,
                  //               fontWeight: FontWeight.w600,
                  //               color: Color(0xFFFFFFFF),
                  //               height: 1,
                  //               letterSpacing: -0.1,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(width: 12.w),
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               data.data.reportedIssues.title,
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: GoogleFonts.outfit(
                  //                 fontSize: 16.sp,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: AppColors.heading,
                  //                 height: 1.1,
                  //                 letterSpacing: -0.1,
                  //               ),
                  //             ),
                  //             SizedBox(height: 3.h),
                  //             Text(
                  //               data.data.reportedIssues.subtitle,
                  //               maxLines: 2,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: GoogleFonts.outfit(
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: const Color.fromRGBO(42, 41, 51, 0.75),
                  //                 letterSpacing: -0.1,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(width: 10.w),
                  //       Icon(
                  //         Icons.arrow_forward_ios,
                  //         color: Color(0xFF2A2933),
                  //         size: 16.sp,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 16.h),
                  Text(
                    "Service Performance",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ServiceManagePerformance(id: widget.id),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C16),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.data.servicePerformance.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.1,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Based on service monitoring",
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data.data.servicePerformance.formatted,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.1,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: LinearProgressIndicator(
                              value:
                                  (data.data.servicePerformance.score > 10
                                          ? data.data.servicePerformance.score /
                                                100
                                          : data.data.servicePerformance.score /
                                                10)
                                      .clamp(0.0, 1.0),
                              minHeight: 4.h,
                              backgroundColor: const Color(0xFF919191),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF00BB5E),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Current Performance",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Text(
                                data.data.servicePerformance.currentPerformance,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
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

  Widget _serviceStat({required String label, required String value}) {
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
            color: const Color.fromRGBO(42, 41, 51, 0.75),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _infoItem({required final String label, required final String value}) {
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
            color: const Color.fromRGBO(42, 41, 51, 0.75),
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
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

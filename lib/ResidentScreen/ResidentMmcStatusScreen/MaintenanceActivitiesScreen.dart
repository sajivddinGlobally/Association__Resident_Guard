import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentMmcStatusScreen/provider/residentMaintenanceProvider.dart';

class WorkOrderListScreen extends ConsumerStatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  ConsumerState<WorkOrderListScreen> createState() =>
      _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends ConsumerState<WorkOrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final maintaince = ref.watch(residentMaintenaanceProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.heading, width: 1.w),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.heading,
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
                    "Work Orders",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Maintenance & repair records",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: maintaince.when(
        data: (data) {
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    itemCount: data.data?.activities?.length ?? 0,
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      final item = data.data?.activities?[index];
                      return Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff101C16).withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Icon + Order No + Status Pill
                            Row(
                              children: [
                                Container(
                                  width: 38.w,
                                  height: 38.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.heading,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      item?.assignedSupervisor?.avatar ?? "",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.phone_android,
                                              color: const Color(0xFFFFFCEB),
                                              size: 20.sp,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.workOrderNo ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.heading,
                                        ),
                                      ),
                                      Text(
                                        item?.title ?? "",
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE9D6A5),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: const Color(0xFFE9D6A5),
                                      width: 0.8.w,
                                    ),
                                  ),
                                  child: Text(
                                    item?.statusRaw ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),
                            const Divider(
                              color: Color.fromRGBO(16, 28, 22, 0.12),
                              height: 1,
                            ),
                            SizedBox(height: 10.h),

                            // Property Unit & Category Chips
                            Row(
                              children: [
                                Icon(
                                  Icons.home_work_outlined,
                                  size: 15.sp,
                                  color: AppColors.heading.withOpacity(0.7),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    "${item?.propertyUnit}  ${item?.complexName}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.heading.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    item?.category ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                // Work type badge
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.build_rounded,
                                      size: 11.sp,
                                      color: AppColors.heading,
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      item?.workType ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.heading,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xff101C16,
                                ).withOpacity(0.04),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: AppColors.heading,
                                    child: Text(
                                      item?.assignedSupervisor?.name?[0] ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.scaffoldBg,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item?.assignedSupervisor?.name ?? "",
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                          ),
                                        ),
                                        Text(
                                          item?.assignedSupervisor?.role ?? "",
                                          style: GoogleFonts.outfit(
                                            fontSize: 10.5.sp,
                                            color: const Color.fromRGBO(
                                              42,
                                              41,
                                              51,
                                              0.65,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Cost
                                  Text(
                                    item?.formattedCost ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10.h),

                            // Bottom Info Row: Target Date & Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 13.sp,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.65,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Target: ${item?.targetDate}",
                                      style: GoogleFonts.outfit(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          42,
                                          41,
                                          51,
                                          0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return const Center(child: Text("Something went wrong"));
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }
}

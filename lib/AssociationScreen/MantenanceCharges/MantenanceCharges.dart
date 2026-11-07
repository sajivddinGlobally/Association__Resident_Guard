import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/DefaulterList.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/MantenanceChargeStatus.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/outStandingPending.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import 'provider/maintananceChargesProvider.dart';

class MantenanceCharges extends ConsumerStatefulWidget {
  const MantenanceCharges({super.key});

  @override
  ConsumerState<MantenanceCharges> createState() => _MantenanceChargesState();
}

class _MantenanceChargesState extends ConsumerState<MantenanceCharges> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maintenanceChargesProvider);
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
                      "SERVICES CHARGES",
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
                      "Residential/Commercial management Team Management",
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
      body: state.when(
        data: (data) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MONTHLY CHARGES OVERVIEW",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            data.data?.monthlyChargesOverview?.badge ?? "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF24B06A),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 242, 165, 0.55),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.business_center_outlined,
                              size: 20.sp,
                              color: const Color(0xFF9D8422),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data?.monthlyChargesOverview?.title ??
                                      "Maintenance Charges",
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
                                  data
                                          .data
                                          ?.monthlyChargesOverview
                                          ?.description ??
                                      "N/A",
                                  maxLines: 2,
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
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _divider(),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryItem(
                            "Total Due",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.totalDue
                                    ?.formatted ??
                                "₹0",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.totalDue
                                    ?.label ??
                                "August 2026",
                            const Color(0xFFC18A00),
                          ),
                          _buildSummaryItem(
                            "Collected",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.collected
                                    ?.formatted ??
                                "₹0",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.collected
                                    ?.label ??
                                "August 2026",
                            const Color(0xFF24B06A),
                          ),
                          _buildSummaryItem(
                            "Outstanding",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.outstanding
                                    ?.formatted ??
                                "₹0",
                            data
                                    .data
                                    ?.monthlyChargesOverview
                                    ?.metrics
                                    ?.outstanding
                                    ?.label ??
                                "August 2026",
                            const Color(0xFFC18A00),
                          ),
                          SizedBox(width: 80.w),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),
                Text(
                  "Charge Overview",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 14.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.data?.chargeOverview?.cards == null ||
                        data.data!.chargeOverview!.cards!.isEmpty)
                      Center(
                        child: Text(
                          "No charge overview available",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.data?.chargeOverview?.cards?.length ?? 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 1.35,
                      ),
                      itemBuilder: (context, index) {
                        final item = data.data?.chargeOverview?.cards?[index];

                        return _buildGridCard(
                          _getChargeIcon(item?.key),
                          item?.title ?? "N/A",
                          item?.count?.toString() ?? "0",
                          item?.subtitle ?? "",
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Text(
                  "Collection Progress",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 12.h),
                // Progress Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 18.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff101C16),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.data?.collectionProgress?.label ?? "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            data.data?.collectionProgress?.percentageText ??
                                "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        height: 6.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor:
                              (data.data?.collectionProgress?.percentage ?? 0)
                                  .toDouble()
                                  .clamp(0.0, 100.0) /
                              100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF24B06A), // Green progress
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Collected - ${data.data?.collectionProgress?.collectedText ?? "N/A"}",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            "Total Due - ${data.data?.collectionProgress?.totalDueText ?? "N/A"}",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                Text(
                  "Complaint Information",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "View maintenance payment status and outstanding dues",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      // _buildListItem(
                      //   icon: Icons.check,
                      //   title: "Maintenance Charge Status",
                      //   subtitle:
                      //       "View paid, pending and overdue charge status",
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //         builder: (context) => MantenanceChargeStatus(),
                      //       ),
                      //     );
                      //   },
                      // ),
                      // _divider(),
                      _buildListItem(
                        icon: Icons.warning_amber_rounded,
                        title: "Defaulters List",
                        subtitle: "View units with overdue maintenance charges",
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => DefaulterList(),
                            ),
                          );
                        },
                      ),
                      _divider(),
                      _buildListItem(
                        icon: Icons.error_outline_rounded,
                        title: "Outstanding / Pending Amount",
                        subtitle: "Review pending amounts and unit-wise dues",
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => OutstandingPending(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: const Color.fromRGBO(16, 28, 22, 0.15),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    String subValue,
    Color subValueColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subValue,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: subValueColor,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  IconData _getChargeIcon(String? key) {
    switch (key) {
      case "paid_units":
        return Icons.check;

      case "pending_units":
        return Icons.access_time_outlined;

      case "overdue_units":
        return Icons.warning_amber_rounded;

      case "outstanding_amount":
        return Icons.attach_money_outlined;

      default:
        return Icons.receipt_long_outlined;
    }
  }

  Widget _buildGridCard(
    IconData icon,
    String title,
    String value,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.heading, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 242, 165, 0.4),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 18.sp, color: const Color(0xFFC18A00)),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.heading, width: 1.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 20.sp, color: AppColors.heading),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
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
            Icon(Icons.chevron_right, size: 22.sp, color: AppColors.heading),
          ],
        ),
      ),
    );
  }
}

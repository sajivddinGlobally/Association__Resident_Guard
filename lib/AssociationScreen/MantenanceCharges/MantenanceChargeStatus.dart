import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/DefaultersDetails.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/provider/maintenanceChargeStatusProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import 'DefaulterList.dart';
import 'outStandingPending.dart';

class MantenanceChargeStatus extends ConsumerStatefulWidget {
  const MantenanceChargeStatus({super.key});

  @override
  ConsumerState<MantenanceChargeStatus> createState() =>
      _MantenanceChargeStatusState();
}

class _MantenanceChargeStatusState
    extends ConsumerState<MantenanceChargeStatus> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Units', 'Paid', 'Pending', 'Overdue'];

  @override
  Widget build(BuildContext context) {
    final selectFilter = _filters[_selectedFilterIndex].toLowerCase();
    final state = ref.watch(maintenanceChargeStatusProvider(selectFilter));
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
                      // "Maintenance Charge Status",
                      "Monthliy Service Charges",
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
          final records = data.data?.unitWiseStatus?.records ?? [];
          Color _resolveBadgeColor({
            String? badgeColorHex,
            String? statusText,
            bool? isDefaulter,
            bool? isOverdueAbove2Months,
          }) {
            if (badgeColorHex != null && badgeColorHex.isNotEmpty) {
              try {
                final hex = badgeColorHex.replaceAll("#", "").trim();
                if (hex.length == 6) {
                  return Color(int.parse("FF$hex", radix: 16));
                } else if (hex.length == 8) {
                  return Color(int.parse(hex, radix: 16));
                }
              } catch (_) {}
            }

            final upper = (statusText ?? "").toUpperCase().trim();
            if (isDefaulter == true ||
                isOverdueAbove2Months == true ||
                upper == "DEFAULTER") {
              return const Color(0xFFEF4444);
            } else if (upper == "CLEARED" || upper == "PAID") {
              return const Color(0xFF22C55E);
            } else if (upper == "REGULAR") {
              return const Color(0xFFEAB308);
            }
            return Colors.grey;
          }

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
                            data.data?.monthlyCollection?.title ??
                                "MONTHLY COLLECTION",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            data.data?.monthlyCollection?.badge ??
                                "AUGUST 2026",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF24B06A),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Collected",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
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
                                  "₹ ${data.data?.monthlyCollection?.totalCollected ?? 0}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  data.data?.monthlyCollection?.description ??
                                      " N/A",
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
                            "Total Units",
                            data.data?.monthlyCollection?.summary?.totalUnits
                                    .toString() ??
                                "0",
                            "registered",
                            const Color(0xFFC18A00),
                          ),
                          _buildSummaryItem(
                            "Paid",
                            data.data?.monthlyCollection?.summary?.paidUnits
                                    .toString() ??
                                "0",
                            "units",
                            const Color(0xFF24B06A),
                          ),
                          _buildSummaryItem(
                            "Pending",
                            data.data?.monthlyCollection?.summary?.pendingUnits
                                    .toString() ??
                                "0",
                            "units",
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
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCard(
                        Icons.check,
                        "Paid Amount",
                        data.data?.chargeOverview?.paidAmount ?? "0",
                        data.data?.chargeOverview?.paidUnitsLabel ??
                            "0 units recorded",
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: _buildGridCard(
                        Icons.access_time_outlined,
                        "Pending Amount",
                        data.data?.chargeOverview?.pendingAmount ?? "0",
                        data.data?.chargeOverview?.pendingUnitsLabel ??
                            "0 units pending",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildGridCard(
                        Icons.warning_amber_rounded,
                        "Overdue",
                        data.data?.chargeOverview?.overdueAmount ?? "0",
                        data.data?.chargeOverview?.overdueUnitsLabel ??
                            "0 units overdue",
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: _buildGridCard(
                        Icons.attach_money_outlined,
                        "Collection Rate",
                        data.data?.chargeOverview?.collectionRate ?? "0",
                        data.data?.chargeOverview?.collectionRateLabel ??
                            "0 units collected",
                      ),
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
                            "Monthly Collection",
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
                  // "Payment Status",
                  "MMC Dues",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 16.h),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10.r),
                //     border: Border.all(color: AppColors.heading, width: 1.2),
                //   ),
                //   child: Column(
                //     children: [
                //       _buildListItem(
                //         icon: Icons.check,
                //         title:
                //             data.data?.paymentStatusBreakdown?.paid?.title ??
                //             "N/A",
                //         subtitle:
                //             data.data?.paymentStatusBreakdown?.paid?.subtitle ??
                //             "Maintenance charge recorded",
                //         value:
                //             data.data?.paymentStatusBreakdown?.paid?.count
                //                 .toString() ??
                //             "0",
                //         onTap: () {},
                //       ),
                //       _divider(),
                //       _buildListItem(
                //         icon: Icons.warning_amber_rounded,
                //         title:
                //             data.data?.paymentStatusBreakdown?.pending?.title ??
                //             "N/A",
                //         subtitle:
                //             data
                //                 .data
                //                 ?.paymentStatusBreakdown
                //                 ?.pending
                //                 ?.subtitle ??
                //             "Maintenance charge recorded",
                //         value:
                //             data.data?.paymentStatusBreakdown?.pending?.count
                //                 .toString() ??
                //             "0",
                //         onTap: () {},
                //       ),
                //       _divider(),
                //       _buildListItem(
                //         icon: Icons.error_outline_rounded,
                //         title:
                //             data.data?.paymentStatusBreakdown?.overdue?.title ??
                //             "N/A",
                //         subtitle:
                //             data
                //                 .data
                //                 ?.paymentStatusBreakdown
                //                 ?.overdue
                //                 ?.subtitle ??
                //             "Maintenance charge recorded",
                //         value:
                //             data.data?.paymentStatusBreakdown?.overdue?.count
                //                 .toString() ??
                //             "0",
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: Column(
                    children: [
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

                SizedBox(height: 22.h),
                Text(
                  "Unit-wise Status",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 14.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _filters.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: _buildFilterPill(index, _filters[index]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                  ),
                  child: records.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Center(
                            child: Text(
                              "No units found",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: records.length,
                          separatorBuilder: (context, index) => _divider(),
                          itemBuilder: (context, index) {
                            final item = records[index];

                            final statusText =
                                item.defaulterStatus ?? item.status ?? "N/A";
                            final statusColor = _resolveBadgeColor(
                              badgeColorHex: item.badgeColor,
                              statusText: statusText,
                              isDefaulter: item.isDefaulter,
                              isOverdueAbove2Months: item.isOverdueAbove2Months,
                            );

                            return _buildUnitItem(
                              imagePath: "assets/unit.png",
                              title: item.unitNumber ?? "N/A",
                              subtitle: item.subtitle ?? "N/A",
                              amount: item.formattedAmount ?? "₹ 0",
                              statusText: statusText.toUpperCase(),
                              statusColor: statusColor,
                              id: item.id.toString(),
                            );
                          },
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

  // Widget _buildListItem({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required String value,
  //   required VoidCallback onTap,
  // }) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
  //     child: InkWell(
  //       onTap: onTap,
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 40.w,
  //             height: 40.w,
  //             decoration: BoxDecoration(
  //               border: Border.all(color: AppColors.heading, width: 1.2),
  //               borderRadius: BorderRadius.circular(8.r),
  //             ),
  //             child: Icon(icon, size: 20.sp, color: AppColors.heading),
  //           ),
  //           SizedBox(width: 14.w),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   title,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: GoogleFonts.outfit(
  //                     fontSize: 17.sp,
  //                     fontWeight: FontWeight.w600,
  //                     color: AppColors.heading,
  //                     letterSpacing: -0.2,
  //                   ),
  //                 ),
  //                 SizedBox(height: 2.h),
  //                 Text(
  //                   subtitle,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: GoogleFonts.outfit(
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w500,
  //                     color: const Color.fromRGBO(42, 41, 51, 0.75),
  //                     letterSpacing: -0.2,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Text(
  //                 value,
  //                 style: GoogleFonts.outfit(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w700,
  //                   color: AppColors.heading,
  //                 ),
  //               ),
  //               Text(
  //                 "Units",
  //                 style: GoogleFonts.outfit(
  //                   fontSize: 12.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: const Color.fromRGBO(42, 41, 51, 0.7),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterPill(int index, String label) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff101C16) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xff101C16) : Colors.black,
            width: 1.w,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildUnitItem({
    required String imagePath,
    required String title,
    required String subtitle,
    required String amount,
    required String statusText,
    required Color statusColor,
    required String id,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => DefaultersDetails(id: id)),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Image.asset(
                  imagePath,
                  width: 32.w,
                  height: 32.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32.w,
                      height: 32.w,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 20.sp,
                        color: Colors.black54,
                      ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  statusText,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

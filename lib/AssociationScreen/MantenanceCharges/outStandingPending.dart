import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/DefaultersDetails.dart';

import 'provider/getOutstandingPendingProvider.dart';

class OutstandingPending extends ConsumerStatefulWidget {
  const OutstandingPending({super.key});

  @override
  ConsumerState<OutstandingPending> createState() => _OutstandingPendingState();
}

class _OutstandingPendingState extends ConsumerState<OutstandingPending> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All Pending',
    'Highest Amount',
    'Current Month',
  ];
  String searchQuery = "";
  final searchController = TextEditingController();

  final List<String> _filterValues = ['all', 'highest_amount', 'current_month'];
  @override
  Widget build(BuildContext context) {
    final selectFilter = _filterValues[_selectedFilterIndex];

    final outstandingPending = ref.watch(
      getOutstandingPendingProvider((
        filter: selectFilter,
        search: searchQuery,
      )),
    );
    final data = outstandingPending.value?.data;
    final isLoading = outstandingPending.isLoading;
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
                  Text(
                    "OUTSTANDING / PENDING",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Maintenance Charges",
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
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            isLoading
                ? Container(
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.heading,
                        strokeWidth: 1.3.w,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 13.h,
                      horizontal: 14.w,
                    ),
                    decoration: BoxDecoration(
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
                              data?.pendingAmountOverview?.cardTitle ??
                                  "PENDING AMOUNT OVERVIEW",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                                letterSpacing: -0.1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                data?.pendingAmountOverview?.badge ?? "Overdue",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: Image.asset(
                            data?.pendingAmountOverview?.image ??
                                "assets/unit.png",
                            width: 36.w,
                            height: 36.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 36.w,
                                height: 36.w,
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
                        SizedBox(height: 10.h),
                        Text(
                          data?.pendingAmountOverview?.unitNumber ??
                              "Flat B-302",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          data?.pendingAmountOverview?.subtitle ??
                              "Property Unit · Residential",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 0.75),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        _divider(),
                        SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Owner",
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
                                  SizedBox(height: 2.h),
                                  Text(
                                    data
                                            ?.pendingAmountOverview
                                            ?.propertyOwner ??
                                        "Ahmed Khan",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
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
                                    "Due Date",
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
                                  SizedBox(height: 2.h),
                                  Text(
                                    data?.pendingAmountOverview?.dueDate ??
                                        "05 Aug 2026",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
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

            SizedBox(height: 16.h),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    data?.kpiCards?.currentMonth?.title ?? "Current Month",
                    data?.kpiCards?.currentMonth?.amount ?? "0",
                    data?.kpiCards?.currentMonth?.subtitle ?? "loading...",
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _buildStatCard(
                    data?.kpiCards?.totalPending?.title ?? "Current Month",
                    data?.kpiCards?.totalPending?.amount ?? "0",
                    data?.kpiCards?.totalPending?.subtitle ?? "loading...",
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pending by Unit",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  "${data?.pendingByUnitHeader?.countBadge ?? 0} units",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Search Bar
            Container(
              height: 52.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
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
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      controller: searchController,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search service or provider..",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Filter Pills
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
            outstandingPending.when(
              data: (data) {
                Color _resolveDefaulterBadgeColor({
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
                  return const Color(0xFFEF4444);
                }

                final percentage =
                    data.data?.totalOutstandingCard?.percentage ?? 0;

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.black, width: 1.w),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.data?.totalOutstandingCard?.title ??
                                    "TOTAL OUTSTANDING",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              Text(
                                data.data?.totalOutstandingCard?.amount ?? "0",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFC18A00),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            height: 4.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (percentage / 100).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC18A00),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data
                                        .data
                                        ?.totalOutstandingCard
                                        ?.collectedText ??
                                    "₹8.42L collected",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                data.data?.totalOutstandingCard?.totalDueText ??
                                    "₹10.60L TOTAL DUE",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.black, width: 1.w),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.data?.pendingUnits?.items?.length ?? 0,
                        itemBuilder: (context, index) {
                          final defaulter =
                              data.data?.pendingUnits?.items?[index];
                          return Column(
                            children: [
                              _buildDefaulterItem(
                                imagePath:
                                    defaulter?.image ?? "assets/unit.png",
                                title: defaulter?.unitNumber ?? "Unit N/A",
                                subtitle: defaulter?.subtitle ?? "N/A",
                                amount: defaulter?.formattedAmount ?? "0",
                                status: defaulter?.defaulterStatus ??
                                    defaulter?.statusBadge ??
                                    "",
                                statusColor: _resolveDefaulterBadgeColor(
                                  badgeColorHex: defaulter?.badgeColor ??
                                      defaulter?.statusColor?.toString(),
                                  statusText: defaulter?.defaulterStatus ??
                                      defaulter?.statusBadge,
                                  isDefaulter: defaulter?.isDefaulter,
                                  isOverdueAbove2Months:
                                      defaulter?.isOverdueAbove2Months,
                                ),
                                id: defaulter?.id.toString() ?? "",
                              ),
                              if (index !=
                                  (data.data?.pendingUnits?.items?.length ??
                                          0) -
                                      1)
                                _divider(),
                              // _buildDefaulterItem(
                              //   imagePath: "assets/unit.png",
                              //   title: "Flat C-405",
                              //   subtitle: "Due since 10 Aug 2026 · 18 days overdue",
                              //   amount: "₹7,500",
                              // ),
                              // _divider(),
                              // _buildDefaulterItem(
                              //   imagePath: "assets/unit.png",
                              //   title: "Flat A-308",
                              //   subtitle: "Due since 12 Aug 2026 · 16 days overdue",
                              //   amount: "₹15,000",
                              // ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    "Error: $error",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                );
              },
              loading: () => SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.8,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.heading),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.h,
      thickness: 0.8.w,
      color: const Color.fromRGBO(42, 41, 51, 0.4),
    );
  }

  Widget _buildStatCard(String title, String amount, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
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
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(int index, String label) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaulterItem({
    required String imagePath,
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required Color statusColor,
    required String id,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => DefaultersDetails(id: id)),
          );
        },
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
                  width: 30.w,
                  height: 30.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 30.w,
                      height: 30.w,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 18.sp,
                        color: Colors.black54,
                      ),
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 0.75),
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
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            Icon(Icons.chevron_right, size: 22.sp, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

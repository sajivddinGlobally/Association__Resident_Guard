import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/DefaultersDetails.dart';
import 'package:property_association_or_resident/AssociationScreen/MantenanceCharges/provider/getDefaulterListProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class DefaulterList extends ConsumerStatefulWidget {
  const DefaulterList({super.key});

  @override
  ConsumerState<DefaulterList> createState() => _DefaulterListState();
}

class _DefaulterListState extends ConsumerState<DefaulterList> {
  int _selectedFilterIndex = 0;
  String searchQuery = "";
  final searchController = TextEditingController();
  final List<String> _filters = ['All Units', 'Highest Due', 'Longest Overdue'];
  final List<String> _filterValues = ['all', 'highest_due', 'longest_overdue'];

  @override
  Widget build(BuildContext context) {
    final selectFilter = _filterValues[_selectedFilterIndex];

    final defaulterState = ref.watch(
      getDefaulterListProvider((filter: selectFilter, search: searchQuery)),
    );
    final overMaintenance =
        defaulterState.valueOrNull?.data?.overdueMaintenanceOverview;

    final hightest = defaulterState.valueOrNull?.data?.kpiSummary;
    final unitCount = defaulterState.valueOrNull?.data;
    final isLoading = defaulterState.isLoading;
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
                    "DEFAULTERS LIST",
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
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.heading,
                        strokeWidth: 1.5.w,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 15.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              overMaintenance?.title ?? "OVERDUE MAINTENANCE",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                                letterSpacing: -0.1,
                              ),
                            ),
                            Text(
                              overMaintenance?.badge ?? "AUGUST 2026",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF24B06A),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 242, 165, 0.4),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Icon(
                                Icons.warning_amber_rounded,
                                size: 19.sp,
                                color: const Color(0xFFC18A00),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    overMaintenance?.sectionTitle ??
                                        "Defaulters",
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
                                    overMaintenance?.sectionSubtitle ??
                                        "Units with overdue maintenance charges",
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
                            Expanded(
                              child: _buildSummaryItem(
                                "Defaulter Units",
                                overMaintenance
                                        ?.metrics
                                        ?.defaulterUnits
                                        ?.count ??
                                    "0",
                                "Need attention",
                                const Color(0xFFC18A00),
                              ),
                            ),
                            Expanded(
                              child: _buildSummaryItem(
                                "Total Outstanding",
                                overMaintenance
                                        ?.metrics
                                        ?.totalOutstanding
                                        ?.formatted ??
                                    "0",
                                "Overdue amount",
                                const Color(0xFFC18A00),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Highest Outstanding",
                    hightest?.highestOutstanding?.formatted ?? "0",
                    hightest?.highestOutstanding?.unit ?? "loading...",
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _buildStatCard(
                    "Average Outstanding",
                    hightest?.averageOverduePerDay?.formatted ?? "0",
                    hightest?.averageOverduePerDay?.subtitle ?? "loading...",
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Defaulters",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  unitCount?.defaulters?.countLabel ?? "0",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                  ),
                ),
              ],
            ),
            SizedBox(height: 11.h),
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
                  Icon(
                    Icons.search,
                    size: 24.sp,
                    color: AppColors.heading,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
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
            SizedBox(height: 20.h),
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
            SizedBox(height: 20.h),
            defaulterState.when(
              data: (data) {
                final records = data.data?.defaulters?.records ?? [];
                // Empty state
                if (records.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 35.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 65.w,
                          height: 65.w,
                          decoration: BoxDecoration(
                            color: AppColors.heading.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: 35.sp,
                            color: AppColors.heading,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        Text(
                          "No Defaulters Found",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          "There are no outstanding dues for the selected filter.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      final statusText = record.defaulterStatus ??
                          record.statusBadge ??
                          record.status ??
                          "N/A";
                      final statusColor = _resolveDefaulterBadgeColor(
                        badgeColorHex: record.badgeColor,
                        statusText: statusText,
                        isDefaulter: record.isDefaulter,
                        isOverdueAbove2Months: record.isOverdueAbove2Months,
                      );
                      return Column(
                        children: [
                          _buildDefaulterItem(
                            imagePath: "assets/unit.png",
                            title: record.unitNumber ?? "NA",
                            subtitle: record.subtitle ?? "N/A",
                            amount: record.formattedAmount ?? "0",
                            status: statusText,
                            statusColor: statusColor,
                            id: record.id.toString(),
                          ),
                          if (index != records.length - 1) _divider(),
                        ],
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Center(child: Text("Someting went wrong")),
                );
              },
              loading: () => SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.7,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.heading),
                ),
              ),
            ),

            SizedBox(height: 30.h),
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
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subValue,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: subValueColor,
            letterSpacing: -0.2,
          ),
        ),
      ],
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

  Widget _buildDefaulterItem({
    required String imagePath,
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    Color? statusColor,
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
                    color: statusColor ?? const Color(0xFFEF4444),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/serviceWorkOrdersResModel.dart';

import '../Mantenance&Service/MantenanceServiceDetails.dart';
import 'provider/serviceWorkOrdersProvider.dart';

class Servicecharges extends ConsumerStatefulWidget {
  const Servicecharges({super.key});

  @override
  ConsumerState<Servicecharges> createState() => _ServicechargesState();
}

class _ServicechargesState extends ConsumerState<Servicecharges> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilterKey = "all";
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workOrdersState = ref.watch(
      serviceWorkOrdersProvider((
        status: _selectedFilterKey,
        search: _searchQuery,
      )),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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
                      "Service Charges",
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
                      "Dashboard → Service Charges",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
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
      body: workOrdersState.when(
        data: (apiResponse) {
          final data = apiResponse.data;
          return _buildContent(data);
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: AppColors.heading,
            strokeWidth: 2.w,
          ),
        ),
        error: (error, _) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildContent(Data? data) {
    final List<Record> records = data?.records ?? [];

    // Client-side search filtering
    final filteredRecords = _searchQuery.isEmpty
        ? records
        : records.where((item) {
            final query = _searchQuery.toLowerCase();
            final titleMatch = (item.title ?? "").toLowerCase().contains(query);
            final unitMatch = (item.unit ?? "").toLowerCase().contains(query);
            final vendorMatch = (item.vendor?.name ?? "")
                .toLowerCase()
                .contains(query);
            final codeMatch = (item.code ?? "").toLowerCase().contains(query);
            final categoryMatch = (item.category ?? "").toLowerCase().contains(
              query,
            );
            return titleMatch ||
                unitMatch ||
                vendorMatch ||
                codeMatch ||
                categoryMatch;
          }).toList();

    final summary = data?.summary;
    final complexName = data?.complex?.name ?? "Bharat Apartment";
    final totalAmount =
        summary?.totalCostText ??
        (summary?.totalCost != null
            ? "₹ ${summary!.totalCost!.toStringAsFixed(2)}"
            : "₹ 0");
    final footerNote =
        data?.note ??
        "Service work charges are the cost of repair / service jobs (work orders). They are separate from the Monthly Maintenance Charge (MMC).";

    return RefreshIndicator(
      color: AppColors.heading,
      onRefresh: () async {
        ref.invalidate(
          serviceWorkOrdersProvider((
            status: _selectedFilterKey,
            search: _searchQuery,
          )),
        );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),

            // Society Header Banner (Matching web design)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.heading, width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 242, 165, 0.55),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: AppColors.heading, width: 1.1),
                    ),
                    child: Icon(
                      Icons.build_rounded,
                      size: 18.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Charges – $complexName",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Repair and service work done in your society and its cost. Vendors are assigned by the management team.",
                          style: GoogleFonts.outfit(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(42, 41, 51, 0.75),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // 4 Summary Metrics (2x2 Grid)
            _buildMetricsGrid(summary, records),

            SizedBox(height: 18.h),

            // Filter Chips from API
            _buildFilterChips(data?.filterChips, records),

            SizedBox(height: 14.h),

            // Search Bar
            _buildSearchBar(),

            SizedBox(height: 16.h),

            // Work Orders List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Work Orders (${filteredRecords.length})",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = "";
                      });
                    },
                    child: Text(
                      "Clear Search",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 10.h),

            // Work Order Cards
            if (filteredRecords.isEmpty)
              _buildEmptyOrdersState(data?.emptyMessage?.toString())
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: filteredRecords.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return _buildWorkOrderCard(filteredRecords[index]);
                },
              ),

            SizedBox(height: 16.h),

            // Total All Work Orders Card
            _buildTotalCard(totalAmount),

            SizedBox(height: 16.h),

            // Footer Note
            _buildFooterNote(footerNote),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(Summary? summary, List<Record> rawOrders) {
    final totalCost =
        summary?.totalCostText ??
        (summary?.totalCost != null
            ? "₹ ${summary!.totalCost!.toStringAsFixed(2)}"
            : "₹ 0");
    final totalOrdersCount = summary?.totalOrders ?? rawOrders.length;
    final totalSub = "$totalOrdersCount work orders";

    final completedCost =
        summary?.completedCostText ??
        (summary?.completedCost != null
            ? "₹ ${summary!.completedCost!.toStringAsFixed(2)}"
            : "₹ 0");
    final completedCount =
        summary?.completed ??
        rawOrders
            .where((e) => (e.status ?? "").toLowerCase().contains("complete"))
            .length;
    final completedSub = "$completedCount completed";

    final openCost =
        summary?.openCostText ??
        (summary?.openCost != null ? "₹ ${summary!.openCost}" : "₹ 0");
    final openCount =
        summary?.requested ??
        rawOrders
            .where(
              (e) =>
                  (e.status ?? "").toLowerCase().contains("request") ||
                  (e.status ?? "").toLowerCase().contains("pending"),
            )
            .length;
    final openSub = "$openCount open";

    final waitingVal = "${summary?.notAssigned ?? summary?.requested ?? 0}";

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.45,
      children: [
        _buildMetricCard(
          icon: Icons.currency_rupee_rounded,
          iconColor: const Color(0xFFC18A00),
          iconBgColor: const Color.fromRGBO(255, 242, 165, 0.45),
          title: "Total Service Cost",
          value: totalCost,
          subtitle: totalSub,
        ),
        _buildMetricCard(
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF24B06A),
          iconBgColor: const Color.fromRGBO(36, 176, 106, 0.15),
          title: "Completed Work",
          value: completedCost,
          subtitle: completedSub,
        ),
        _buildMetricCard(
          icon: Icons.access_time_rounded,
          iconColor: const Color(0xFFE65100),
          iconBgColor: const Color.fromRGBO(230, 81, 0, 0.15),
          title: "Open Work (Estimated)",
          value: openCost,
          subtitle: openSub,
        ),
        _buildMetricCard(
          icon: Icons.manage_accounts_outlined,
          iconColor: const Color(0xFF0284C7),
          iconBgColor: const Color.fromRGBO(2, 132, 199, 0.15),
          title: "Waiting for Vendor",
          value: waitingVal,
          subtitle: "Admin will assign",
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.heading, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(icon, size: 17.sp, color: iconColor),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.65),
                    height: 1.15,
                  ),
                ),
              ),
            ],
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
              letterSpacing: -0.3,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(42, 41, 51, 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(List<FilterChip>? apiChips, List<Record> records) {
    // If API provided filter_chips, use them dynamically
    if (apiChips != null && apiChips.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(apiChips.length, (index) {
            final chip = apiChips[index];
            final chipKey = chip.key ?? "all";
            final isSelected = _selectedFilterKey == chipKey;
            final labelText = "${chip.label ?? ''} · ${chip.count ?? 0}";

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilterKey = chipKey;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.heading : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.heading
                          : const Color.fromRGBO(16, 28, 22, 0.25),
                      width: 1.1,
                    ),
                  ),
                  child: Text(
                    labelText,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    // Fallback default tabs
    final defaultTabs = [
      (key: "all", label: "All · ${records.length}"),
      (
        key: "pending",
        label:
            "Requested · ${records.where((e) => (e.status ?? '').toLowerCase().contains('request')).length}",
      ),
      (
        key: "in_progress",
        label:
            "In Progress · ${records.where((e) => (e.status ?? '').toLowerCase().contains('progress')).length}",
      ),
      (
        key: "completed",
        label:
            "Completed · ${records.where((e) => (e.status ?? '').toLowerCase().contains('complete')).length}",
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(defaultTabs.length, (index) {
          final tab = defaultTabs[index];
          final isSelected = _selectedFilterKey == tab.key;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterKey = tab.key;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.heading : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.heading
                        : const Color.fromRGBO(16, 28, 22, 0.25),
                    width: 1.1,
                  ),
                ),
                child: Text(
                  tab.label,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
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
          Icon(
            Icons.search_rounded,
            size: 20.sp,
            color: const Color.fromRGBO(16, 28, 22, 0.5),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
              decoration: InputDecoration(
                hintText: "Search work order, unit, vendor",
                hintStyle: GoogleFonts.outfit(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(16, 28, 22, 0.45),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = "";
                });
              },
              child: Icon(
                Icons.close_rounded,
                size: 18.sp,
                color: const Color.fromRGBO(16, 28, 22, 0.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkOrderCard(Record item) {
    final statusStr = item.status ?? "REQUESTED";
    final statusUpper = statusStr.toUpperCase().trim();
    final bool isCompleted = statusUpper == "COMPLETED";
    final bool isRequested =
        statusUpper == "REQUESTED" || statusUpper == "PENDING";

    final Color statusBg = isCompleted
        ? const Color(0xFFD1FADF)
        : isRequested
        ? const Color(0xFFE0EAFF)
        : const Color(0xFFFEF0C7);

    final Color statusTextColor = isCompleted
        ? const Color(0xFF027A48)
        : isRequested
        ? const Color(0xFF175CD3)
        : const Color(0xFFB54708);

    final bool isVendorAssigned =
        item.vendor?.isAssigned == true ||
        (item.vendor?.name != null &&
            item.vendor!.name!.trim().isNotEmpty &&
            !item.vendor!.name!.toLowerCase().contains("not assigned"));

    // Subtitle e.g. "MR-2046 · Repair"
    final subtitleParts = <String>[];
    if (item.code != null && item.code!.isNotEmpty) {
      subtitleParts.add(item.code!);
    }
    if (item.workType != null && item.workType!.isNotEmpty) {
      subtitleParts.add(item.workType!);
    }
    final subtitle = subtitleParts.join(" · ");

    // Date text
    String dateText = "--";
    if (item.actualCompletion != null && item.actualCompletion!.isNotEmpty) {
      dateText = "Done ${item.actualCompletion}";
    } else if (item.expectedCompletion != null &&
        item.expectedCompletion!.isNotEmpty) {
      dateText = "Due ${item.expectedCompletion}";
    } else if (item.raisedOn != null && item.raisedOn!.isNotEmpty) {
      dateText = item.raisedOn!;
    }

    // Cost text
    final costDisplay =
        item.costFormatted ?? (item.cost != null ? "₹ ${item.cost}" : "--");

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.heading, width: 1.2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title + Status Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "Maintenance",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8C733E),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  statusUpper,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: statusTextColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Divider(
            height: 1,
            thickness: 0.8,
            color: const Color.fromRGBO(16, 28, 22, 0.08),
          ),

          SizedBox(height: 10.h),

          // Detail Grid (Unit, Category, Vendor, Date)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unit
              Expanded(
                child: _buildItemAttribute(
                  label: "UNIT",
                  value: item.unit ?? "--",
                ),
              ),
              // Category
              Expanded(
                child: _buildItemAttribute(
                  label: "CATEGORY",
                  value: item.category ?? "--",
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "VENDOR",
                      style: GoogleFonts.outfit(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(42, 41, 51, 0.5),
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.vendor?.name ?? "Not assigned yet",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isVendorAssigned
                            ? AppColors.heading
                            : const Color(0xFFB58A16),
                      ),
                    ),
                    if (item.vendor?.phone != null &&
                        item.vendor!.phone!.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        item.vendor!.phone!,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(42, 41, 51, 0.65),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Date
              Expanded(
                child: _buildItemAttribute(label: "DATE", value: dateText),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Divider(
            height: 1,
            thickness: 0.8,
            color: const Color.fromRGBO(16, 28, 22, 0.08),
          ),

          SizedBox(height: 10.h),

          // Bottom Row: Cost + View Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "COST",
                    style: GoogleFonts.outfit(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(42, 41, 51, 0.5),
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        costDisplay,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      if (isRequested) ...[
                        SizedBox(width: 4.w),
                        Text(
                          "(estimated)",
                          style: GoogleFonts.outfit(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              // View > button
              GestureDetector(
                onTap: () {
                  // _showWorkOrderDetailsSheet(item);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          MantenanceServiceDetails(id: item.id.toString()),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.heading,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "View",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemAttribute({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(42, 41, 51, 0.5),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard(String totalAmount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.heading, width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 20.sp,
                color: AppColors.heading,
              ),
              SizedBox(width: 8.w),
              Text(
                "TOTAL (ALL WORK ORDERS)",
                style: GoogleFonts.outfit(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          Text(
            totalAmount,
            style: GoogleFonts.outfit(
              fontSize: 16.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterNote(String note) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: const Color.fromRGBO(184, 134, 11, 0.9),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.sp,
            color: const Color(0xFF8C733E),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              note,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B5829),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrdersState(String? emptyMsg) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.heading, width: 1.2),
      ),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 40.sp, color: Colors.grey),
          SizedBox(height: 10.h),
          Text(
            emptyMsg ?? "No work orders found",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Try changing your search query or filter tab",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 44.sp,
              color: Colors.redAccent,
            ),
            SizedBox(height: 12.h),
            Text(
              "Failed to load service charges",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              onPressed: () {
                ref.invalidate(
                  serviceWorkOrdersProvider((
                    status: _selectedFilterKey,
                    search: _searchQuery,
                  )),
                );
              },
              child: Text(
                "Retry",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

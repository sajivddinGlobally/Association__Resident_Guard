import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/AssociationPropertyUnitDetails.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/addUnitBodyModel.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/apiErrorWidget.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'Provider/getPropeertyUnitListProvider.dart';

class AssociationProperty extends ConsumerStatefulWidget {
  final bool isShowBack;
  const AssociationProperty({super.key, this.isShowBack = false});

  @override
  ConsumerState<AssociationProperty> createState() =>
      _AssociationPropertyState();
}

class _AssociationPropertyState extends ConsumerState<AssociationProperty> {
  int selectedFilter = 0;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusFilter = "";
    String blockFilter = "";

    final dynamicFilters = [
      "All Units",
      "Occupied",
      "Vacant",
      "Block A",
      "Block B",
      "Block C",
      "Block D",
    ];

    if (selectedFilter == 1) {
      statusFilter = "occupied";
    } else if (selectedFilter == 2) {
      statusFilter = "vacant";
    } else if (selectedFilter == 3) {
      blockFilter = "A";
    } else if (selectedFilter == 4) {
      blockFilter = "B";
    } else if (selectedFilter == 5) {
      blockFilter = "C";
    } else if (selectedFilter == 6) {
      blockFilter = "D";
    }

    final filterParams = (
      status: statusFilter,
      block: blockFilter,
      search: searchQuery,
    );

    final state = ref.watch(getPropertyUnitListProvider(filterParams));
    final complex = state.valueOrNull?.data?.complex;
    final summary = state.valueOrNull?.data?.summary;
    final disclaimer = state.valueOrNull?.data?.disclaimer;
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Row(
          children: [
            if (widget.isShowBack)
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Property / Unit List",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "View and monitor all units in your complex",
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
          ],
        ),
      ),
      body: state.hasError && state.valueOrNull == null
          ? RefreshIndicator(
              color: AppColors.heading,
              onRefresh: () async {
                return ref.refresh(
                  getPropertyUnitListProvider(filterParams).future,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 0.75.sh,
                  child: ApiErrorWidget(
                    error: state.error!,
                    onRetry: () =>
                        ref.refresh(getPropertyUnitListProvider(filterParams)),
                    defaultTitle: "Complex Not Found",
                    defaultSubtitle:
                        "Unable to load property units because no complex information is associated with this account.",
                    icon: Icons.apartment_outlined,
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              color: AppColors.heading,
              onRefresh: () async {
                return ref.refresh(
                  getPropertyUnitListProvider(filterParams).future,
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      height: 250.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: AppColors.heading,
                          width: 0.2.w,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.heading,
                                strokeWidth: 1.3.w,
                              ),
                            )
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child:
                                      (complex?.image != null &&
                                          complex!.image!.isNotEmpty)
                                      ? Image.network(
                                          complex.image!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'assets/document_img.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                        )
                                      : Image.asset(
                                          'assets/document_img.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0.0, 0.40, 0.72, 1.0],
                                        colors: [
                                          Colors.transparent,
                                          Colors.black12,
                                          Colors.black87,
                                          const Color(0xFF071A13),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 18.w,
                                  right: 18.w,
                                  bottom: 20.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Icon(
                                              Icons.home_outlined,
                                              color: Colors.white,
                                              size: 16.sp,
                                            ),
                                          ),
                                          SizedBox(width: 7.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  complex?.name ??
                                                      'Green Valley Residency',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.1,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  complex?.address ??
                                                      'Sector 45 · Noida, Uttar Pradesh',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.1,
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 4.h,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFF24B06A),
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            child: Text(
                                              complex?.status ?? 'Active',
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xFF24B06A),
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        height: 1.h,
                                        width: double.infinity,
                                        color: const Color(
                                          0xFFFFFFFF,
                                        ).withValues(alpha: 0.6),
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _statItem(
                                              value:
                                                  '${complex?.totalUnits ?? 0}',
                                              title: 'Total Units',
                                            ),
                                          ),
                                          Expanded(
                                            child: _statItem(
                                              value:
                                                  '${complex?.occupiedUnits ?? 0}',
                                              title: 'Occupied',
                                            ),
                                          ),
                                          Expanded(
                                            child: _statItem(
                                              value:
                                                  '${complex?.vacantUnits ?? 0}',
                                              title: 'Vacant',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 20.h),
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
                          Icon(
                            Icons.search,
                            size: 24.sp,
                            color: AppColors.heading,
                          ),
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
                              onChanged: (val) {
                                setState(() {
                                  searchQuery = val.trim();
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
                          if (searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                searchController.clear();
                                setState(() {
                                  searchQuery = "";
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 20.sp,
                                color: AppColors.heading,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(dynamicFilters.length, (index) {
                          final bool isSelected = selectedFilter == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xff101C16)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(40.r),
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.w,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  dynamicFilters[index],
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xff101C16),
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
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                summary?.label ?? 'All Units',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF000000),
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '(${summary?.totalUnitsDisplay ?? "${complex?.totalUnits ?? 0} Units"})',
                                style: GoogleFonts.outfit(
                                  color: const Color.fromRGBO(42, 41, 51, 0.6),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _showAddUnitBottomSheet(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.heading,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Add Unit / Flat",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 12.5.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    state.when(
                      data: (data) {
                        final blocks = data.data?.blocks ?? [];
                        if (blocks.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 30.h,
                            ),
                            child: Center(
                              child: Text(
                                "No units found",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final block in blocks) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                  top: 10.h,
                                  bottom: 10.h,
                                ),
                                child: Text(
                                  block.blockTitle?.toUpperCase() ??
                                      '${block.blockName ?? "BLOCK"} · ${block.units?.length ?? 0} UNITS',
                                  style: GoogleFonts.outfit(
                                    color: const Color.fromRGBO(0, 0, 0, 0.75),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                itemCount: block.units?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                ),
                                itemBuilder: (context, index) {
                                  final unit = block.units![index];

                                  final displayStatus =
                                      unit.occupancyStatus != null &&
                                          unit.occupancyStatus!.isNotEmpty
                                      ? (unit.occupancyStatus![0]
                                                .toUpperCase() +
                                            unit.occupancyStatus!
                                                .substring(1)
                                                .toLowerCase())
                                      : "N/A";
                                  return _unitCard(
                                    unitNumber:
                                        unit.badge ?? unit.unitNumber ?? "",
                                    apartmentName:
                                        unit.unitNumber ?? "Apartment",
                                    blockName:
                                        unit.subtitle ??
                                        "${unit.block ?? ""} · ${unit.floor ?? ""}",
                                    // status: displayStatus,
                                    owner: unit.propertyOwner ?? "N/A",
                                    residents: unit.residents ?? "N/A",
                                    // propertyStatus:
                                    //     unit.propertyStatus ?? "Good",
                                    inspectionDate: 'N/A',
                                    image: unit.image,
                                    id: unit.id.toString(),
                                  );
                                },
                              ),
                              SizedBox(height: 6.h),
                            ],
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return ApiErrorWidget(
                          error: error,
                          onRetry: () => ref.refresh(
                            getPropertyUnitListProvider(filterParams),
                          ),
                          defaultTitle: "Complex Not Found",
                          defaultSubtitle:
                              "Unable to load units for this complex.",
                          icon: Icons.apartment_outlined,
                        );
                      },
                      loading: () => Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: CircularProgressIndicator(
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          disclaimer ??
                              "Showing registered properties and units assigned to this association. Select any unit to view its details.",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 0.75),
                            letterSpacing: -0.2,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statItem({required String value, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.outfit(
            color: const Color.fromRGBO(255, 255, 255, 0.75),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _unitCard({
    required String unitNumber,
    required String apartmentName,
    required String blockName,
    // required String status,
    required String owner,
    required String residents,
    // required String propertyStatus,
    required String inspectionDate,
    String? image,
    required String id,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      width: double.infinity,
      height: 220.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.black,
        border: Border.all(color: const Color(0xFF17221D), width: 1.w),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: (image != null && image.isNotEmpty)
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/associationImage/propertyunitimage.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/associationImage/propertyunitimage.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.98),
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.48),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  stops: const [0.0, 0.42, 0.75, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Unit Number
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFEAD408),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        unitNumber,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFEAD408),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apartmentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            blockName,
                            style: GoogleFonts.outfit(
                              color: const Color.fromRGBO(255, 255, 255, 0.85),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PROPERTY OWNER",
                            style: GoogleFonts.outfit(
                              color: const Color.fromRGBO(255, 255, 255, 0.65),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            owner,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RESIDENT",
                            style: GoogleFonts.outfit(
                              color: const Color.fromRGBO(255, 255, 255, 0.65),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            residents,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              height: 1,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "PROPERTY STATUS",
                    //         style: GoogleFonts.outfit(
                    //           color: const Color.fromRGBO(255, 255, 255, 0.65),
                    //           fontSize: 12.sp,
                    //           fontWeight: FontWeight.w600,
                    //           letterSpacing: -0.2,
                    //         ),
                    //       ),
                    //       SizedBox(height: 2.h),
                    //       Text(
                    //         propertyStatus,
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //         style: GoogleFonts.outfit(
                    //           color: Colors.white,
                    //           fontSize: 15.sp,
                    //           fontWeight: FontWeight.w600,
                    //           height: 1,
                    //           letterSpacing: -0.2,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            AssociationPropertyUnitDetails(id: id),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFEAD408),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '→',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFEAD408),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool ingUnit = false;

  void _showAddUnitBottomSheet(BuildContext context) {
    final unitNumberController = TextEditingController();
    final locationController = TextEditingController();
    final floorController = TextEditingController();
    final areaController = TextEditingController();
    final bedroomsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                border: Border.all(color: AppColors.heading, width: 1.2),
              ),
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 14.h,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(16, 28, 22, 0.25),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Unit / Flat",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(16, 28, 22, 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18.sp,
                              color: AppColors.heading,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 242, 165, 0.45),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color.fromRGBO(184, 134, 11, 0.35),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18.sp,
                            color: const Color(0xFF8C733E),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              "The unit is sent to the Admin for approval. After approval it appears in the Add Resident form, where you can assign an Owner or Tenant.",
                              style: GoogleFonts.outfit(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6B5829),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _buildUnitFormField(
                      label: "UNIT / FLAT NUMBER",
                      hint: "e.g. A-101",
                      controller: unitNumberController,
                      isRequired: true,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnitFormField(
                            label: "LOCATION",
                            hint: "e.g. Tower 1, near Gate 2",
                            controller: locationController,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildUnitFormField(
                            label: "FLOOR",
                            hint: "e.g. 1st Floor",
                            controller: floorController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnitFormField(
                            label: "AREA",
                            hint: "e.g. 1,200 sq ft",
                            controller: areaController,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildUnitFormField(
                            label: "BEDROOMS",
                            hint: "e.g. 2 BHK",
                            controller: bedroomsController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 42.h,
                            padding: EdgeInsets.symmetric(horizontal: 22.w),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color.fromRGBO(16, 28, 22, 0.35),
                                width: 1.2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () async {
                            if (unitNumberController.text.trim().isEmpty) {
                              showErrorSnackBar(
                                "Please enter Unit / Flat Number",
                              );
                              return;
                            }
                            setState(() {
                              ingUnit = true;
                            });
                            try {
                              final service = ref.read(authServiceProvider);
                              final res = await service.addUnit(
                                name: unitNumberController.text.trim(),
                                area: areaController.text.trim(),
                                bedroom: bedroomsController.text.trim(),
                                floor: floorController.text.trim(),
                                location: locationController.text.trim(),
                              );
                              if (res.status == true) {
                                Navigator.pop(ctx);
                                showSuccessSnackBar(
                                  "Unit request sent to Admin for approval",
                                );
                              }
                            } catch (e) {
                              setState(() {
                                ingUnit = false;
                              });
                            } finally {
                              setState(() {
                                ingUnit = false;
                              });
                            }
                          },
                          child: Container(
                            height: 42.h,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: AppColors.heading,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            alignment: Alignment.center,
                            child: ingUnit
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                    ),
                                  )
                                : Text(
                                    "Send for Approval",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUnitFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.outfit(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
              letterSpacing: 0.2,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: " *",
                  style: GoogleFonts.outfit(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          cursorColor: AppColors.heading,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(16, 28, 22, 0.4),
            ),
            filled: true,
            fillColor: Colors.transparent,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 28, 22, 0.6),
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 28, 22, 0.6),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: AppColors.heading,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

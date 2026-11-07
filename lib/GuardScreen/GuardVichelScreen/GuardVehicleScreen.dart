import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/GuardScreen/GuardVichelScreen/Provider/recentVehicleSearchesProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardVichelScreen/Provider/vehicleSearchProvider.dart';

class Guardvehiclescreen extends ConsumerStatefulWidget {
  const Guardvehiclescreen({super.key});

  @override
  ConsumerState<Guardvehiclescreen> createState() => _GuardvehiclescreenState();
}

class _GuardvehiclescreenState extends ConsumerState<Guardvehiclescreen> {
  String searchQuery = "";
  final searchController = TextEditingController();
  // Pehle yahan fake gaadi numbers the; ab sirf server ki asli recent searches dikhti hain.
  final List<Map<String, dynamic>> recentSearches = [];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(vehicleSearchProvider(searchQuery));
    final recentSearchesAsync = ref.watch(recentVehicleSearchesProvider);
    final apiRecent = recentSearchesAsync.valueOrNull?.data ?? [];
    final displayRecent = apiRecent.isNotEmpty
        ? apiRecent
            .map((e) => {
                  "vehicle": (e.vehicleType?.toLowerCase() == "bike" ||
                              e.vehicleType?.toLowerCase() == "two_wheeler")
                      ? "🛵"
                      : "🚘",
                  "flat": e.vehicleNumber ?? "",
                  "time":
                      "${e.flatNumber != null ? 'Flat ${e.flatNumber} · ' : ''}${e.ownerName ?? 'Owner'}",
                })
            .toList()
        : recentSearches;

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vehicle Search",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Find vehicle and registered owner details",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VEHICLE NUMBER',
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        setState(() {
                          searchQuery = value.trim();
                        });
                      },
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        color: AppColors.heading,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "e.g. RJ14 AB 1234",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: const Color(0xff888891),
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 27.sp,
                          color: const Color(0xff858585),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchQuery = searchController.text.trim();
                            });
                          },
                          child: Container(
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: AppColors.heading,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.r),
                                bottomRight: Radius.circular(10.r),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Search",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 10.h,
                        ),
                        filled: true,
                        fillColor: AppColors.scaffoldBg,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: const BorderSide(
                            color: AppColors.heading,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              if (searchQuery.trim().isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 25.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Searches",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff111111),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (displayRecent.isEmpty)
                        Text(
                          "No recent searches yet.",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: const Color(0xFF777777),
                          ),
                        ),
                      ...displayRecent.map(
                        (item) => GestureDetector(
                          onTap: () {
                            searchController.text = item["flat"] ?? "";
                            setState(() {
                              searchQuery = item["flat"] ?? "";
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Row(
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF3F0E9),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item["vehicle"] ?? "🚗",
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["flat"] ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff111111),
                                          letterSpacing: -0.4,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        item["time"] ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff666666),
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
                      ),
                    ],
                  ),
                )
              else
                search.when(
                  data: (data) {
                    if (data?.data == null) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 25.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(22.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              data?.message ?? "No vehicle details found",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 25.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Vehicle Details",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff111111),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              if (data?.data?.verifiedBadge != null &&
                                  data!.data!.verifiedBadge!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      17,
                                      197,
                                      80,
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Text(
                                    data.data!.verifiedBadge!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff24B06A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Container(
                                height: 45.h,
                                width: 45.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F0E9),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "🚗",
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.data?.vehicleNumber ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff111111),
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    if (data?.data?.registeredOwner != null &&
                                        data!.data!.registeredOwner!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Text(
                                          "Owner: ${data.data!.registeredOwner!}",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff555555),
                                          ),
                                        ),
                                      ),
                                    if (data?.data?.flatNumber != null &&
                                        data!.data!.flatNumber!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Text(
                                          "Flat: ${data.data!.flatNumber!}",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    if (data?.data?.searchedAt != null &&
                                        data!.data!.searchedAt!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.h),
                                        child: Text(
                                          data!.data!.searchedAt!,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13.sp,
                                            color: const Color(0xff888888),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 35.sp,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Vehicle not found or error occurred",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.heading,
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

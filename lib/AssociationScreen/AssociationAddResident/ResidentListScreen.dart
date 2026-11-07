import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/ManageAccountProfile.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/provider/getResidentListProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class Residentlistscreen extends ConsumerStatefulWidget {
  const Residentlistscreen({super.key});

  @override
  ConsumerState<Residentlistscreen> createState() => _ResidentlistscreenState();
}

class _ResidentlistscreenState extends ConsumerState<Residentlistscreen> {
  @override
  Widget build(BuildContext context) {
    final residentState = ref.watch(getResidentListProvider);
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
                      "Resident List",
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
                      "All Resident Information",
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
      body: residentState.when(
        data: (data) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.data?.residents?.length ?? 0,
                    itemBuilder: (context, index) {
                      final resident = data.data?.residents?[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Manageaccountprofile(
                                id: resident!.id.toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFDF0),
                            border: Border.all(
                              color: const Color(0xFFD9D9D0),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              // Profile Image
                              ClipOval(
                                child: Image.network(
                                  // "assets/profile (2).png",
                                  resident?.avatar ?? "",
                                  width: 50.w,
                                  height: 50.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50.w,
                                      height: 50.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 193, 7, 0.2),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.person,
                                          color: const Color.fromRGBO(
                                            255,
                                            193,
                                            7,
                                            1,
                                          ),
                                          size: 30.sp,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              SizedBox(width: 12.w),

                              // Resident Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      resident?.name ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),

                                    SizedBox(height: 2.h),

                                    Text(
                                      resident?.unitNumber ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                          42,
                                          41,
                                          51,
                                          0.85,
                                        ),
                                      ),
                                    ),

                                    Text(
                                      resident?.phone ?? "N/A",
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8.w),

                              // Status + View
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4F0D2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      resident?.isActive ?? false
                                          ? "Active"
                                          : "Inactive",
                                      maxLines: 1,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF159447),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              Manageaccountprofile(
                                                id: resident!.id.toString(),
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View →",
                                      maxLines: 1,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFB8860B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
          return Center(child: Text("Something went wrong"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }
}

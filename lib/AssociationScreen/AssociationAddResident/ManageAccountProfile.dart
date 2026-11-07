import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/provider/getResidentDetailsProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class Manageaccountprofile extends ConsumerStatefulWidget {
  final String id;
  const Manageaccountprofile({super.key, required this.id});

  @override
  ConsumerState<Manageaccountprofile> createState() =>
      _ManageaccountprofileState();
}

class _ManageaccountprofileState extends ConsumerState<Manageaccountprofile> {
  @override
  Widget build(BuildContext context) {
    final getResidentState = ref.watch(getResidentDetailsProvider(widget.id));
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
                      "Account",
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
                      "Manage your account and profile",
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
      body: getResidentState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.heading,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                // "assets/profile (2).png",
                                data.data?.resident?.avatar ?? "",
                                width: 58.w,
                                height: 58.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 58.w,
                                    height: 58.w,
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

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data?.resident?.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "${data.data?.resident?.role ?? ""} · ${data.data?.resident?.unitNumber ?? ""}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.85),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF514719),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "•  Resident Access ${data.data?.resident?.status ?? ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE5C158),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Current Access",
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
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF101C16),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Resident Access",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8D4A0),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                data.data?.resident?.status ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB8860B),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 9.h),
                        Row(
                          children: [
                            Expanded(
                              child: _accessItem(
                                "Apartment",
                                data.data?.resident?.unitNumber ?? "",
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: _accessItem(
                                "Building",
                                data.data?.resident?.building ?? "",
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 11.h),
                        Row(
                          children: [
                            Expanded(
                              child: _accessItem(
                                "Property",
                                data.data?.resident?.complex ?? "",
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Expanded(
                              child: _accessItem(
                                "Role",
                                data.data?.resident?.role ?? "",
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
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Something went wrong"));
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _accessItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7C9),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              letterSpacing: -0.2,
            ),
          ),

          SizedBox(height: 3.h),

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
      ),
    );
  }
}

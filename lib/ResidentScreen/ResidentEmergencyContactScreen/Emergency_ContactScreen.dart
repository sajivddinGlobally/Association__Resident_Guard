import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Provider/emergencyContactProvider.dart';

class EmergencyContactscreen extends ConsumerStatefulWidget {
  const EmergencyContactscreen({super.key});

  @override
  ConsumerState<EmergencyContactscreen> createState() =>
      _EmergencyContactscreenState();
}

class _EmergencyContactscreenState
    extends ConsumerState<EmergencyContactscreen> {
  Future<void> _makeCall(String telUriOrPhone) async {
    try {
      final String cleanPhone = telUriOrPhone
          .replaceFirst('tel:', '')
          .replaceAll(RegExp(r'\s+'), '');

      final Uri uri = Uri(scheme: 'tel', path: cleanPhone);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          showErrorSnackBar("Could not open dialer for $cleanPhone");
        }
      }
    } catch (e) {
      showErrorSnackBar("Unable to make call: $e");
      log("Error making call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergenctState = ref.watch(emergencyContactProvider);
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
                    "Emergency Contact",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Need immediate assistance",
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
      body: emergenctState.when(
        data: (data) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffDDD9CE)),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: Color(0xffEEE6D2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.call,
                              size: 20.sp,
                              color: const Color(0xffB8860B),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.data.card.badge,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffD22424),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data.data.card.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data.data.card.subtitle.toString(),
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data.data.card.phone,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        height: 36.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffD22424),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            fixedSize: Size(double.infinity, 44.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                          onPressed: () {
                            _makeCall(data.data.card.phone);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Call Now",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
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

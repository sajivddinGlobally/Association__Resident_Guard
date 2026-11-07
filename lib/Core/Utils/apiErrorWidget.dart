import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

String extractApiErrorMessage(
  Object error, {
  String fallback = "Complex Not Found",
}) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      if (data['message'] != null &&
          data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString().trim();
      }
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        if (errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
          if (first != null) {
            return first.toString();
          }
        }
      }
    }
  }
  return fallback;
}

class ApiErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final String defaultTitle;
  final String? defaultSubtitle;
  final IconData icon;

  const ApiErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
    this.defaultTitle = "Complex Not Found",
    this.defaultSubtitle,
    this.icon = Icons.apartment_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final message = extractApiErrorMessage(error, fallback: defaultTitle);
    final subtitle =
        defaultSubtitle ??
        "We couldn't find any complex information associated with this account.";

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEA),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(184, 134, 11, 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(icon, size: 36.sp, color: const Color(0xFFB8860B)),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(41, 41, 51, 0.6),
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 22.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 18.sp, color: Colors.white),
              label: Text(
                "Retry",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heading,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 11.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

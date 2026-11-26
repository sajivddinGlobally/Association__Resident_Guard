import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart'
    show dioProvider;
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

/// Reports & Analytics - apni society ki report (Audit ke bina).
/// Backend signed link deta hai (60 min). Wahi report jo Admin panel export karta hai.
const String _societyReportApi =
    "https://admin.ascentpms.care/api/v1/committee/reports-analytics";

final societyReportProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  try {
    final res = await dio.get(_societyReportApi);
    final body = res.data;
    if (body is Map && body["status"] == true && body["data"] is Map) {
      return Map<String, dynamic>.from(body["data"]);
    }
    throw Exception(
      body is Map && body["message"] != null
          ? body["message"].toString()
          : "Could not load the report.",
    );
  } on DioException catch (e) {
    final data = e.response?.data;
    throw Exception(
      data is Map && data["message"] != null
          ? data["message"].toString()
          : "Could not load the report.",
    );
  }
});

class SocietyReportsAnalyticsScreen extends ConsumerStatefulWidget {
  const SocietyReportsAnalyticsScreen({super.key});

  @override
  ConsumerState<SocietyReportsAnalyticsScreen> createState() =>
      _SocietyReportsAnalyticsScreenState();
}

class _SocietyReportsAnalyticsScreenState
    extends ConsumerState<SocietyReportsAnalyticsScreen> {
  bool _opening = false;

  /// PDF download karke kholo. Server PDF na de sake to printable page (HTML) khulta hai.
  Future<void> _open(Map<String, dynamic> data) async {
    final url = (data["download_url"] ?? data["pdf_url"])?.toString();
    if (url == null || url.isEmpty || _opening) return;
    setState(() => _opening = true);
    try {
      final dir = await getTemporaryDirectory();
      var name = (data["file_name"] ?? "Reports_Analytics.pdf").toString();
      if (name.toLowerCase().endsWith('.pdf')) {
        name = name.substring(0, name.length - 4);
      }
      var path = '${dir.path}/$name.pdf';
      await Dio().download(url, path);

      final file = File(path);
      final head = await file.openRead(0, 5).first;
      if (String.fromCharCodes(head) != '%PDF-') {
        final htmlPath = '${dir.path}/$name.html';
        await file.rename(htmlPath);
        path = htmlPath;
      }

      final result = await OpenFilex.open(path);
      if (result.type == ResultType.noAppToOpen) {
        showErrorSnackBar(
          "No app found to open this report. Please install a PDF viewer.",
        );
      } else if (result.type != ResultType.done) {
        showErrorSnackBar("Could not open the report: ${result.message}");
      }
    } catch (e) {
      showErrorSnackBar("Could not download the report. Please try again.");
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(societyReportProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.heading),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Reports & Analytics",
          style: GoogleFonts.outfit(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(societyReportProvider),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            padding: EdgeInsets.all(24.w),
            children: [
              SizedBox(height: 60.h),
              Icon(Icons.error_outline, size: 46.sp, color: Colors.redAccent),
              SizedBox(height: 10.h),
              Text(
                e.toString().replaceFirst("Exception: ", ""),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: OutlinedButton(
                  onPressed: () => ref.invalidate(societyReportProvider),
                  child: const Text("Retry"),
                ),
              ),
            ],
          ),
          data: (data) {
            final complex = data["complex"] is Map
                ? data["complex"] as Map
                : {};
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
              children: [
                Text(
                  (data["description"] ??
                          "Society health score, complaints, service requests, dues and vendor performance.")
                      .toString(),
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    color: Colors.black54,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0x33101C16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.w,
                            decoration: BoxDecoration(
                              color: const Color(0x2EB8860B),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.insert_chart_outlined_rounded,
                              color: const Color(0xFFB8860B),
                              size: 26.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (complex["name"] ?? "Your Society")
                                      .toString(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                                Text(
                                  "Society report (PDF)",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton.icon(
                          onPressed: _opening ? null : () => _open(data),
                          icon: _opening
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                          label: Text(
                            _opening
                                ? "Preparing report..."
                                : "View / Download Report (PDF)",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.heading,
                            disabledBackgroundColor: const Color(0x99101C16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

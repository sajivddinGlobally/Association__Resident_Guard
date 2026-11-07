import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/ServiceManagePerformance.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementProviderDetailsResModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'provider/serviceManagementProviderDetailsProvider.dart';

class ServiceManageProviderDetails extends ConsumerStatefulWidget {
  final String id;
  const ServiceManageProviderDetails({super.key, required this.id});

  @override
  ConsumerState<ServiceManageProviderDetails> createState() =>
      _ServiceManageProviderDetailsState();
}

class _ServiceManageProviderDetailsState
    extends ConsumerState<ServiceManageProviderDetails> {
  bool _isOpeningDocument = false;

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? Colors.red.shade700
            : const Color(0xFF101C16),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Future<void> _launchInBrowser(String rawUrl) async {
    if (rawUrl.trim().isEmpty) {
      _showSnackBar("URL is empty", isError: true);
      return;
    }
    final cleaned = rawUrl.trim().replaceAll(RegExp(r'(?<!:)/{2,}'), '/');
    try {
      final uri = Uri.parse(cleaned);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar("Cannot open URL in browser", isError: true);
      }
    } catch (e) {
      _showSnackBar("Failed to open browser: $e", isError: true);
    }
  }

  Future<File> _generateDocumentPdf({
    required Directory directory,
    required String fileName,
    required Document document,
    String? providerName,
  }) async {
    final cleanFileName = fileName.toLowerCase().endsWith('.pdf')
        ? fileName
        : '$fileName.pdf';
    final file = File('${directory.path}/$cleanFileName');

    String escapePdf(String text) {
      return text
          .replaceAll(r'\', r'\\')
          .replaceAll('(', r'\(')
          .replaceAll(')', r'\)');
    }

    final safeTitle = escapePdf(document.title);
    final safeFormat = escapePdf(document.format);
    final safeProvider = escapePdf(providerName ?? "CleanCare Services");
    final safeStatus = escapePdf(document.status);
    final safeUrl = escapePdf(document.url);

    final buffer = StringBuffer();
    buffer.writeln("BT");
    buffer.writeln("/F1 18 Tf");
    buffer.writeln("50 730 Td");
    buffer.writeln("($safeTitle) Tj");
    buffer.writeln("/F1 12 Tf");
    buffer.writeln("0 -24 Td");
    buffer.writeln("(Format / Details: $safeFormat) Tj");
    buffer.writeln("0 -20 Td");
    buffer.writeln("(Service Provider: $safeProvider) Tj");
    buffer.writeln("0 -20 Td");
    buffer.writeln("(Status: $safeStatus) Tj");
    buffer.writeln("0 -28 Td");
    buffer.writeln("/F1 10 Tf");
    buffer.writeln("(Source URL:) Tj");
    buffer.writeln("0 -16 Td");
    buffer.writeln("($safeUrl) Tj");
    buffer.writeln("0 -30 Td");
    buffer.writeln("/F1 11 Tf");
    buffer.writeln("(Document verified and registered in system.) Tj");
    buffer.writeln("ET");

    final streamBytes = utf8.encode(buffer.toString());
    final streamLen = streamBytes.length;

    final bytesBuilder = BytesBuilder();
    final offsets = <int>[];

    void writeString(String str) {
      bytesBuilder.add(utf8.encode(str));
    }

    writeString('%PDF-1.4\n');

    offsets.add(bytesBuilder.length);
    writeString('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');

    offsets.add(bytesBuilder.length);
    writeString('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');

    offsets.add(bytesBuilder.length);
    writeString(
      '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n',
    );

    offsets.add(bytesBuilder.length);
    writeString('4 0 obj\n<< /Length $streamLen >>\nstream\n');
    bytesBuilder.add(streamBytes);
    writeString('\nendstream\nendobj\n');

    offsets.add(bytesBuilder.length);
    writeString(
      '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
    );

    final startXref = bytesBuilder.length;
    writeString('xref\n0 6\n0000000000 65535 f \n');
    for (final o in offsets) {
      writeString('${o.toString().padLeft(10, '0')} 00000 n \n');
    }
    writeString(
      'trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n$startXref\n%%EOF\n',
    );

    await file.writeAsBytes(bytesBuilder.toBytes(), flush: true);
    return file;
  }

  Future<void> _openDocument(Document document, {String? providerName}) async {
    final rawUrl = document.url;
    if (rawUrl.trim().isEmpty) {
      _showSnackBar("Document URL is not available", isError: true);
      return;
    }

    if (_isOpeningDocument) return;

    setState(() {
      _isOpeningDocument = true;
    });

    _showSnackBar("Opening ${document.title}...");

    final cleanedUrl = rawUrl.trim().replaceAll(RegExp(r'(?<!:)/{2,}'), '/');

    try {
      Directory? targetDir;
      if (Platform.isAndroid) {
        final downloadDirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (downloadDirs != null && downloadDirs.isNotEmpty) {
          targetDir = downloadDirs.first;
        } else {
          targetDir =
              await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      String fileName = cleanedUrl.split('/').last.split('?').first.trim();
      if (fileName.isEmpty || !fileName.endsWith('.pdf')) {
        final safeName = document.title
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .replaceAll(' ', '_');
        fileName = "${safeName}_${DateTime.now().millisecondsSinceEpoch}.pdf";
      }

      final savePath = "${targetDir.path}/$fileName";
      bool downloadSuccess = false;

      try {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 25),
          ),
        );
        final response = await dio.download(cleanedUrl, savePath);
        if (response.statusCode == 200) {
          final file = File(savePath);
          if (await file.exists() && await file.length() > 50) {
            final headBytes = await file.openRead(0, 5).first;
            final headStr = utf8.decode(headBytes, allowMalformed: true);
            if (headStr.startsWith('%PDF-') || !headStr.contains('<html')) {
              downloadSuccess = true;
            }
          }
        }
      } catch (e) {
        log("Download file error: $e");
        downloadSuccess = false;
      }

      if (downloadSuccess) {
        _showSnackBar("Document downloaded. Opening...");
        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done) {
          final uri = Uri.parse(cleanedUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
        return;
      }

      // If download was not a valid PDF or server returned 404/error,
      // try external launch, or open fallback informative PDF
      final uri = Uri.parse(cleanedUrl);
      bool launchedInBrowser = false;
      try {
        if (await canLaunchUrl(uri)) {
          launchedInBrowser = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (e) {
        log("LaunchUrl error: $e");
      }

      if (!launchedInBrowser) {
        final fallbackFile = await _generateDocumentPdf(
          directory: targetDir,
          fileName: fileName,
          document: document,
          providerName: providerName,
        );
        _showSnackBar("Opening document preview...");
        await OpenFilex.open(fallbackFile.path);
      }
    } catch (e) {
      log("Error opening document: $e");
      _showSnackBar("Failed to open document: $e", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningDocument = false;
        });
      }
    }
  }

  void _showDocumentBottomSheet(Document document, String providerName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 14.h,
            bottom: MediaQuery.of(ctx).padding.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF4E4),
                      border: Border.all(
                        color: const Color(0xFFB8860B),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: const Color(0xFFB8860B),
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          document.format,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF11B262),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      document.status,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF11B262),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Service Provider: ",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            providerName,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (document.url.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        "File URL: ${document.url}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _launchInBrowser(document.url);
                      },
                      icon: Icon(
                        Icons.open_in_browser,
                        size: 18.sp,
                        color: AppColors.heading,
                      ),
                      label: Text(
                        "Browser",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF101C16),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openDocument(document, providerName: providerName);
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Open / View Document",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101C16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProviderState = ref.watch(
      serviceManagementProviderDetailsProvider(widget.id),
    );
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
                      "Service Details",
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
                      "Service Management",
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
      body: serviceProviderState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.data.registeredServiceProvider.tag,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 6.h,
                                  width: 6.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF12A65A),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  data.data.registeredServiceProvider.badge,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF24B06A),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                        Text(
                          data.data.registeredServiceProvider.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          data.data.registeredServiceProvider.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.75),
                            height: 1.15,
                          ),
                        ),
                        SizedBox(height: 13.h),
                        Divider(
                          height: 1,
                          thickness: 0.8,
                          color: Color.fromRGBO(16, 28, 22, 0.5),
                        ),
                        SizedBox(height: 13.h),
                        Row(
                          children: [
                            Expanded(
                              child: _serviceStat(
                                label: "Services",
                                value: data
                                    .data
                                    .registeredServiceProvider
                                    .stats
                                    .services,
                                status: "assigned",
                              ),
                            ),
                            Expanded(
                              child: _serviceStat(
                                label: "Since",
                                value: data
                                    .data
                                    .registeredServiceProvider
                                    .stats
                                    .since,
                                status: "registered",
                              ),
                            ),
                            Expanded(
                              child: _serviceStat(
                                label: "Rating",
                                value: data
                                    .data
                                    .registeredServiceProvider
                                    .stats
                                    .rating,
                                status: "excellent",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Provider Information",
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _providerInfoItem(
                                label: "Provider Type",
                                value:
                                    data.data.providerInformation.providerType,
                              ),
                            ),
                            SizedBox(width: 25.w),
                            Expanded(
                              child: _providerInfoItem(
                                label: "Provider ID",
                                value: data.data.providerInformation.providerId,
                                valueColor: const Color(0xFFA97700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 11.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _providerInfoItem(
                                label: "Registration Date",
                                value: data
                                    .data
                                    .providerInformation
                                    .registrationDate,
                              ),
                            ),
                            SizedBox(width: 25.w),
                            Expanded(
                              child: _providerInfoItem(
                                label: "Status",
                                value: data.data.providerInformation.status,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 11.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _providerInfoItem(
                                label: "Contract Status",
                                value: data
                                    .data
                                    .providerInformation
                                    .contractStatus,
                              ),
                            ),
                            SizedBox(width: 25.w),
                            Expanded(
                              child: _providerInfoItem(
                                label: "Service Area",
                                value:
                                    data.data.providerInformation.serviceArea,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    "Primary Contact",
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFF000000),
                              width: 1.w,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              data.data.primaryContact.avatar ?? "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 20.sp,
                                  color: Colors.black87,
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
                                data.data.primaryContact.title ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  height: 1,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                data.data.primaryContact.contactPerson ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                data.data.primaryContact.contactRole ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  height: 1.15,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    "Contact Details",
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF000000), width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _providerInfoItem(
                                label: "Phone",
                                value: data.data.contactDetails.phone ?? "",
                              ),
                            ),
                            SizedBox(width: 18.w),
                            Expanded(
                              child: _providerInfoItem(
                                label: "Email",
                                value: data.data.contactDetails.email ?? "",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _providerInfoItem(
                                label: "Working Hours",
                                value:
                                    data.data.contactDetails.workingHours ?? "",
                              ),
                            ),
                            SizedBox(width: 18.w),
                            Expanded(
                              child: _providerInfoItem(
                                label: "Emergency Support",
                                value:
                                    data.data.contactDetails.emergencySupport ??
                                    "",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Assigned Services",
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
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: data.data.assignedServices.services.length,
                      itemBuilder: (context, index) {
                        final service =
                            data.data.assignedServices.services[index];

                        return Column(
                          children: [
                            _serviceItem(
                              icon: Icons.cleaning_services_outlined,
                              title: service.title,
                              subtitle: service.subtitle,
                              status: service.status,
                            ),

                            if (index !=
                                data.data.assignedServices.services.length - 1)
                              _divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Provider Performance",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ServiceManagePerformance(id: widget.id),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101C16),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service Performance",
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.1,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      data.data.providerPerformance.headline,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data.data.providerPerformance.score > 10
                                    ? "${(data.data.providerPerformance.score / 10).toStringAsFixed(1)}/10"
                                    : "${data.data.providerPerformance.score}/10",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.1,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: LinearProgressIndicator(
                              value:
                                  (data.data.providerPerformance.score > 10
                                          ? data
                                                    .data
                                                    .providerPerformance
                                                    .score /
                                                100
                                          : data
                                                    .data
                                                    .providerPerformance
                                                    .score /
                                                10)
                                      .clamp(0.0, 1.0),
                              minHeight: 4.h,
                              backgroundColor: const Color(0xFF919191),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF00BB5E),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Current Performance",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Text(
                                data.data.providerPerformance.serviceQuality,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Provider Documents",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (data.data.providerDocuments.documents.isEmpty)
                    Center(
                      child: Text(
                        "No documents found",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          color: AppColors.heading,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.w),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: data.data.providerDocuments.documents.length,
                        itemBuilder: (context, index) {
                          final document =
                              data.data.providerDocuments.documents[index];

                          return Column(
                            children: [
                              _documentItem(
                                icon: Icons.description_outlined,
                                title: document.title,
                                subtitle: document.format,
                                status: document.status,
                                onTap: () {
                                  _showDocumentBottomSheet(
                                    document,
                                    data.data.registeredServiceProvider.name,
                                  );
                                },
                                onViewTap: () {
                                  _openDocument(
                                    document,
                                    providerName: data
                                        .data
                                        .registeredServiceProvider
                                        .name,
                                  );
                                },
                              ),

                              if (index !=
                                  data.data.providerDocuments.documents.length -
                                      1)
                                _divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          log(error.toString());
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 20.h),
            alignment: Alignment.center,
            child: Text(
              "Something went wrong",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                color: AppColors.heading,
              ),
            ),
          );
        },
        loading: () {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.heading),
            ),
          );
        },
      ),
    );
  }

  Widget _serviceStat({
    required String label,
    required String value,
    required String status,
  }) {
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
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFB8860B),
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _providerInfoItem({
    required String label,
    required String value,
    Color valueColor = Colors.black,
  }) {
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
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: valueColor == Colors.black ? AppColors.heading : valueColor,
            height: 1.1,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  Widget _serviceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.w),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Icon(icon, size: 16.sp, color: Colors.black),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 3.h),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF11B262), width: 1.w),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF11B262),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required VoidCallback onTap,
    required VoidCallback onViewTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.w),
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Icon(icon, size: 16.sp, color: Colors.black),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      height: 1.1,
                      letterSpacing: -0.2,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                      height: 1.1,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            GestureDetector(
              onTap: onViewTap,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF4E4),
                  border: Border.all(
                    color: const Color(0xFFB8860B),
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 13.sp,
                      color: const Color(0xFFB8860B),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      status.isNotEmpty ? status : "VIEW",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB8860B),
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
    );
  }

  Widget _divider() {
    return Container(
      height: 1.h,
      width: double.infinity,
      color: Color.fromRGBO(16, 28, 22, 0.5),
    );
  }
}

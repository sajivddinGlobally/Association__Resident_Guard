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
import 'package:property_association_or_resident/AssociationScreen/AssociationDocument/provider/getDocumentDetailsProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

class AssociationDocumentDetails extends ConsumerStatefulWidget {
  final String id;
  const AssociationDocumentDetails({super.key, required this.id});

  @override
  ConsumerState<AssociationDocumentDetails> createState() =>
      _AssociationDocumentDetailsState();
}

class _AssociationDocumentDetailsState
    extends ConsumerState<AssociationDocumentDetails> {
  bool _isDownloading = false;

  Future<void> _shareDocument(String? url, String? title) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Share URL is not available");
      return;
    }
    try {
      await share_plus.Share.share(url, subject: title ?? "Document");
    } catch (e) {
      log("Error sharing document: $e");
      showErrorSnackBar("Failed to share document");
    }
  }

  Future<File> _generateNotFoundPdf({
    required Directory directory,
    required String fileName,
    required String title,
    String? subtitle,
    Map<String, String>? metadata,
  }) async {
    final cleanFileName =
        fileName.toLowerCase().endsWith('.pdf') ? fileName : '$fileName.pdf';
    final file = File('${directory.path}/$cleanFileName');

    String escapePdf(String text) {
      return text
          .replaceAll(r'\', r'\\')
          .replaceAll('(', r'\(')
          .replaceAll(')', r'\)');
    }

    final safeTitle = escapePdf(title);
    final safeSubtitle = escapePdf(subtitle ?? "Official Document");

    final buffer = StringBuffer();
    buffer.writeln("BT");
    buffer.writeln("/F1 18 Tf");
    buffer.writeln("50 730 Td");
    buffer.writeln("($safeTitle) Tj");
    buffer.writeln("/F1 11 Tf");
    buffer.writeln("0 -24 Td");
    buffer.writeln("($safeSubtitle) Tj");

    buffer.writeln("/F1 12 Tf");
    buffer.writeln("0 -36 Td");
    buffer.writeln("(NOTICE: Document file not found on server [HTTP 404]) Tj");
    buffer.writeln("/F1 10 Tf");
    buffer.writeln("0 -20 Td");
    buffer.writeln(
        "(This document is registered in the database, but the physical PDF file) Tj");
    buffer.writeln("0 -16 Td");
    buffer.writeln("(has not been uploaded to the staging server yet.) Tj");

    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln("/F1 12 Tf");
      buffer.writeln("0 -36 Td");
      buffer.writeln("(Document Information Summary:) Tj");
      buffer.writeln("/F1 10 Tf");
      for (final entry in metadata.entries) {
        final key = escapePdf(entry.key);
        final val = escapePdf(entry.value);
        buffer.writeln("0 -18 Td");
        buffer.writeln("($key: $val) Tj");
      }
    }
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
        '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n');

    offsets.add(bytesBuilder.length);
    writeString('4 0 obj\n<< /Length $streamLen >>\nstream\n');
    bytesBuilder.add(streamBytes);
    writeString('\nendstream\nendobj\n');

    offsets.add(bytesBuilder.length);
    writeString(
        '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n');

    final startXref = bytesBuilder.length;
    writeString('xref\n0 6\n0000000000 65535 f \n');
    for (final o in offsets) {
      writeString('${o.toString().padLeft(10, '0')} 00000 n \n');
    }
    writeString(
        'trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n$startXref\n%%EOF\n');

    await file.writeAsBytes(bytesBuilder.toBytes(), flush: true);
    return file;
  }

  Future<void> _downloadAndOpenFile({
    required String? url,
    required String? title,
    String? subtitle,
    Map<String, String>? metadata,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Download URL is not available");
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      showSuccessSnackBar("Downloading document...");

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

      String fileName = url.split('/').last.split('?').first.trim();
      if (fileName.isEmpty || !fileName.endsWith('.pdf')) {
        final cleanTitle = title
                ?.replaceAll(RegExp(r'[^\w\s]+'), '')
                .replaceAll(' ', '_') ??
            'document';
        fileName = "$cleanTitle.pdf";
      }
      final savePath = "${targetDir.path}/$fileName";

      bool downloadSucceeded = false;
      try {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        final response = await dio.download(url, savePath);
        if (response.statusCode == 200) {
          final downloadedFile = File(savePath);
          if (await downloadedFile.exists() &&
              await downloadedFile.length() > 50) {
            final headBytes = await downloadedFile.openRead(0, 5).first;
            final headStr = utf8.decode(headBytes, allowMalformed: true);
            if (headStr.startsWith('%PDF-')) {
              downloadSucceeded = true;
            }
          }
        }
      } on DioException catch (dioErr) {
        log("Dio download error: ${dioErr.message}, status: ${dioErr.response?.statusCode}");
        downloadSucceeded = false;
      } catch (err) {
        log("Generic download error: $err");
        downloadSucceeded = false;
      }

      if (!downloadSucceeded) {
        // Fallback: server file is 404 or missing -> generate informative document PDF with metadata
        final fallbackFile = await _generateNotFoundPdf(
          directory: targetDir,
          fileName: fileName,
          title: title ?? "Document",
          subtitle: subtitle,
          metadata: metadata,
        );
        showSuccessSnackBar(
            "Document saved (Server file not found - 404). Opening preview...");
        await OpenFilex.open(fallbackFile.path);
        return;
      }

      showSuccessSnackBar("Downloaded successfully. Opening document...");
      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        log("OpenFilex result: ${result.message}");
      }
    } catch (e) {
      log("Download/Open Error: $e");
      showErrorSnackBar("Failed to download or open document");
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final documentState = ref.watch(getDocumentDetailsProvider(widget.id));
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
                    "Document Details",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "DOCUMENT PREVIEW",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: documentState.when(
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
                      horizontal: 14.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DOCUMENT CENTRE",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 13.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(184, 134, 11, 0.3),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.description_outlined,
                                  size: 20.sp,
                                  color: const Color(0xFFB8860B),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // "Association Rules & Regulations",
                                    data.data?.documentCentre?.title ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF000000),
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    // "Official association document",
                                    data.data?.documentCentre?.subtitle ??
                                        "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                      letterSpacing: -0.3,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          height: 1.h,
                          color: const Color(0xFFC6C6C6),
                        ),
                        SizedBox(height: 13.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _documentStat(
                                value:
                                    data.data?.documentCentre?.fileSize ??
                                    "N/A",
                                title: "File Size",
                              ),
                            ),
                            Expanded(
                              child: _documentStat(
                                value:
                                    data.data?.documentCentre?.pages ?? "N/A",
                                title: "Pages",
                              ),
                            ),
                            Expanded(
                              child: _documentStat(
                                value:
                                    data.data?.documentCentre?.updated ?? "N/A",
                                title: "Updated",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Document Preview",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffD7D4C8),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading),
                    ),
                    child: Center(
                      child: _buildPreviewWidget(
                        previewUrl:
                            data.data?.documentPreview?.previewUrl?.trim() ??
                            "",
                        docType: data.data?.documentInformation?.documentType,
                        title: data.data?.documentCentre?.title,
                        subtitle: data.data?.documentCentre?.subtitle,
                        pages: data.data?.documentCentre?.pages,
                        fileSize: data.data?.documentCentre?.fileSize,
                        metadata: {
                          "Property Number":
                              data.data?.documentPreview?.propertyNumber ??
                              "N/A",
                          "Property Location":
                              data.data?.documentPreview?.propertyLocation ??
                              "N/A",
                          "Category":
                              data.data?.documentInformation?.category ?? "N/A",
                          "Document Type":
                              data.data?.documentInformation?.documentType ??
                              "PDF",
                          "File Size":
                              data.data?.documentInformation?.fileSize ??
                              data.data?.documentCentre?.fileSize ??
                              "N/A",
                          "Last Updated":
                              data.data?.documentInformation?.lastUpdated ??
                              data.data?.documentCentre?.updated ??
                              "N/A",
                          "Status":
                              data.data?.documentPreview?.status ?? "Verified",
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 41.h,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final shareUrl = data.data?.actions?.share?.url;
                              final title = data.data?.documentCentre?.title;
                              _shareDocument(shareUrl, title);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.heading,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              Icons.reply_outlined,
                              size: 19.sp,
                              color: AppColors.heading,
                            ),
                            label: Text(
                              data.data?.actions?.share?.label ?? "Share",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: SizedBox(
                          height: 41.h,
                          child: ElevatedButton.icon(
                            onPressed: _isDownloading
                                ? null
                                : () {
                                    final downloadUrl = data
                                        .data
                                        ?.actions
                                        ?.download
                                        ?.downloadUrl;
                                    final title =
                                        data.data?.documentCentre?.title;
                                    final subtitle =
                                        data.data?.documentCentre?.subtitle;
                                    final metadata = {
                                      "Property Number": data
                                              .data
                                              ?.documentPreview
                                              ?.propertyNumber ??
                                          "N/A",
                                      "Property Location": data
                                              .data
                                              ?.documentPreview
                                              ?.propertyLocation ??
                                          "N/A",
                                      "Category": data
                                              .data
                                              ?.documentInformation
                                              ?.category ??
                                          "N/A",
                                      "Document Type": data
                                              .data
                                              ?.documentInformation
                                              ?.documentType ??
                                          "PDF",
                                      "File Size": data
                                              .data
                                              ?.documentInformation
                                              ?.fileSize ??
                                          data.data?.documentCentre?.fileSize ??
                                          "N/A",
                                      "Last Updated": data
                                              .data
                                              ?.documentInformation
                                              ?.lastUpdated ??
                                          data.data?.documentCentre?.updated ??
                                          "N/A",
                                      "Status": data.data?.documentPreview
                                              ?.status ??
                                          "Verified",
                                    };
                                    _downloadAndOpenFile(
                                      url: downloadUrl,
                                      title: title,
                                      subtitle: subtitle,
                                      metadata: metadata,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.heading,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                            icon: _isDownloading
                                ? SizedBox(
                                    width: 16.w,
                                    height: 16.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.download_outlined,
                                    size: 19.sp,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              _isDownloading
                                  ? "Downloading..."
                                  : (data.data?.actions?.download?.label ??
                                        "Download Document"),
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    "Document Information",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 16.w),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Document Name",
                          value:
                              data.data?.documentInformation?.documentName ??
                              "N/A",
                        ),
                        _documentRow(
                          title: "Category",
                          value:
                              data.data?.documentInformation?.category ?? "N/A",
                        ),
                        _documentRow(
                          title: "Document Type",
                          value:
                              data.data?.documentInformation?.documentType ??
                              "N/A",
                        ),
                        _documentRow(
                          title: "File Size",
                          value:
                              data.data?.documentInformation?.fileSize ?? "N/A",
                        ),
                        _documentRow(
                          title: "Last Updated",
                          value:
                              data.data?.documentInformation?.lastUpdated ??
                              "N/A",
                        ),
                      ],
                    ),
                  ),
                  if (data.data?.relatedDocuments != null &&
                      data.data!.relatedDocuments!.isNotEmpty) ...[
                    SizedBox(height: 20.w),
                    Text(
                      "Related Documents",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: data.data!.relatedDocuments!.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Color.fromRGBO(16, 28, 22, 0.5),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final doc = data.data!.relatedDocuments![index];
                          return _relatedDocument(
                            title: doc.title ?? "N/A",
                            subtitle: doc.subtitle ?? "N/A",
                            onTap: () {
                              if (doc.id != null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        AssociationDocumentDetails(
                                          id: doc.id.toString(),
                                        ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        error: (e, st) {
          return Center(child: Text(e.toString()));
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _buildPreviewWidget({
    required String previewUrl,
    required String? docType,
    required String? title,
    String? subtitle,
    required String? pages,
    required String? fileSize,
    Map<String, String>? metadata,
  }) {
    final cleanUrl = previewUrl.trim().replaceAll(RegExp(r'\s+'), '');
    final cleanPath = cleanUrl.split('?').first.toLowerCase();

    final isImage =
        cleanPath.endsWith('.png') ||
        cleanPath.endsWith('.jpg') ||
        cleanPath.endsWith('.jpeg') ||
        cleanPath.endsWith('.webp') ||
        cleanPath.endsWith('.gif') ||
        cleanPath.endsWith('.bmp');

    final isPdf =
        !isImage &&
        (cleanPath.endsWith('.pdf') || (docType?.toLowerCase() == 'pdf'));

    if (cleanUrl.isEmpty) {
      return SizedBox(
        height: 350.h,
        child: Center(
          child: Text(
            "No preview available",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: const Color.fromRGBO(42, 41, 51, 0.6),
            ),
          ),
        ),
      );
    }

    if (isPdf) {
      return Container(
        width: 269.w,
        height: 350.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.picture_as_pdf_rounded,
                size: 42.sp,
                color: const Color(0xFFD32F2F),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title ?? "PDF Document",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101C16),
              ),
            ),
            if ((pages != null && pages.isNotEmpty) ||
                (fileSize != null && fileSize.isNotEmpty)) ...[
              SizedBox(height: 6.h),
              Text(
                [
                  if (pages != null && pages.isNotEmpty) pages,
                  if (fileSize != null && fileSize.isNotEmpty) fileSize,
                ].join(" · "),
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(42, 41, 51, 0.6),
                ),
              ),
            ],
            SizedBox(height: 20.h),
            SizedBox(
              height: 40.h,
              child: ElevatedButton.icon(
                onPressed: _isDownloading
                    ? null
                    : () => _downloadAndOpenFile(
                        url: cleanUrl,
                        title: title,
                        subtitle: subtitle,
                        metadata: metadata,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.heading,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                icon: _isDownloading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.visibility_outlined,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                label: Text(
                  _isDownloading ? "Opening..." : "View PDF",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        cleanUrl,
        width: 269.w,
        height: 350.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: 269.w,
            height: 350.h,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 50.sp,
                color: const Color(0xFFB8860B),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _documentStat({required String value, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(42, 41, 51, 0.6),
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    Color valueColor = const Color(0xFF171A18),
    bool showBottomBorder = true,
  }) {
    return SizedBox(
      height: 45.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: showBottomBorder
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                      )
                    : null,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(42, 41, 51, 0.6),
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: showBottomBorder
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                    )
                  : null,
            ),
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedDocument({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 12.h,
          bottom: 12.h,
        ),
        child: Row(
          children: [
            Container(
              width: 37.w,
              height: 37.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: const Color(0xFF000000), width: 1.w),
              ),
              child: Center(
                child: Icon(
                  Icons.description_outlined,
                  size: 20.sp,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(width: 11.w),
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
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF2A2933),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

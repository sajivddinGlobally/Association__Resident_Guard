import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import '../../Core/Constant/appColor.dart';
import '../../Core/Utils/showMessage.dart';
import 'provider/getInspectionReportDetailProvider.dart';

class AssociationReportDetails extends ConsumerStatefulWidget {
  final String id;
  final String? title;
  final String? date;
  final String? property;
  final String? auditType;
  final String? auditDate;
  final String? status;

  const AssociationReportDetails({
    super.key,
    required this.id,
    this.title,
    this.date,
    this.property,
    this.auditType,
    this.auditDate,
    this.status,
  });

  @override
  ConsumerState<AssociationReportDetails> createState() =>
      _AssociationReportDetailstailsScreenState();
}

class _AssociationReportDetailstailsScreenState
    extends ConsumerState<AssociationReportDetails> {
  bool _isDownloading = false;
  bool _isViewing = false;
  bool _isAttachedPdfLoading = false;

  Future<void> _handlePdfAction({
    required String? url,
    required bool openImmediately,
    String? defaultFileName,
    bool isAttachment = false,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar(
        isAttachment
            ? "Attached document is not available"
            : "Checklist PDF is not available",
      );
      return;
    }

    if (_isDownloading || _isViewing || _isAttachedPdfLoading) return;

    setState(() {
      if (isAttachment) {
        _isAttachedPdfLoading = true;
      } else if (openImmediately) {
        _isViewing = true;
      } else {
        _isDownloading = true;
      }
    });

    try {
      String resolvedUrl = url.trim();
      if (!resolvedUrl.startsWith('http://') &&
          !resolvedUrl.startsWith('https://')) {
        final clean = resolvedUrl.startsWith('/')
            ? resolvedUrl.substring(1)
            : resolvedUrl;
        resolvedUrl = 'https://realestate.gwsstaging.com/public/$clean';
      }

      final uri = Uri.tryParse(resolvedUrl);
      String resolvedFileName =
          defaultFileName ??
          (isAttachment
              ? 'attachment_${widget.id}.pdf'
              : 'audit_checklist_${widget.id}.pdf');
      if (uri != null && uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last.replaceAll(
          RegExp(r'[^\w\s\.-]'),
          '_',
        );
        if (lastSegment.toLowerCase().endsWith('.pdf')) {
          resolvedFileName = lastSegment;
        } else {
          resolvedFileName = '${lastSegment}_${widget.id}.pdf';
        }
      }

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

      final savePath = '${targetDir.path}/$resolvedFileName';
      final file = File(savePath);

      // Check if file already exists and is valid
      if (await file.exists()) {
        final len = await file.length();
        if (len > 10) {
          final headerBytes = await file.openRead(0, 5).first;
          final header = String.fromCharCodes(headerBytes);
          if (header == '%PDF-') {
            if (openImmediately) {
              showSuccessSnackBar("Opening document...");
              final openResult = await OpenFilex.open(savePath);
              if (openResult.type != ResultType.done) {
                if (openResult.type == ResultType.noAppToOpen) {
                  showErrorSnackBar(
                    "No app found to open PDF files. Please install a PDF viewer.",
                  );
                } else {
                  showErrorSnackBar(
                    "Could not open file: ${openResult.message}",
                  );
                }
              }
              return;
            } else {
              showSuccessSnackBar(
                "Document already saved to ${targetDir.path}",
              );
              return;
            }
          } else {
            await file.delete();
          }
        } else {
          await file.delete();
        }
      }

      showSuccessSnackBar(
        openImmediately ? "Opening document..." : "Downloading document...",
      );

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final box = Hive.isBoxOpen("userdata")
          ? Hive.box("userdata")
          : await Hive.openBox("userdata");
      final token = box.get("token");

      final options = Options(
        headers: {
          if (token != null && token.toString().isNotEmpty)
            "Authorization": "Bearer $token",
          "Accept": "application/pdf, application/json, */*",
        },
      );

      await dio.download(resolvedUrl, savePath, options: options);

      // Validate downloaded content
      if (await file.exists()) {
        final len = await file.length();
        if (len > 10) {
          final headerBytes = await file.openRead(0, 5).first;
          final header = String.fromCharCodes(headerBytes);
          if (header != '%PDF-') {
            String errorMsg = "The server did not return a valid PDF";
            try {
              final text = await file.readAsString();
              if (text.contains('"message"')) {
                final decoded = json.decode(text);
                if (decoded is Map && decoded['message'] != null) {
                  errorMsg = decoded['message'].toString();
                }
              }
            } catch (_) {}
            await file.delete();
            showErrorSnackBar("Failed: $errorMsg");
            return;
          }
        }
      }

      showSuccessSnackBar(
        openImmediately
            ? "Document opened successfully"
            : "Document downloaded successfully to ${targetDir.path}",
      );

      if (openImmediately) {
        final openResult = await OpenFilex.open(savePath);
        if (openResult.type != ResultType.done) {
          if (openResult.type == ResultType.noAppToOpen) {
            showErrorSnackBar(
              "No app found to open PDF files. Please install a PDF viewer.",
            );
          } else {
            showErrorSnackBar("Could not open file: ${openResult.message}");
          }
        }
      }
    } catch (e) {
      log("Error loading PDF: $e");
      showErrorSnackBar("Failed to load PDF document");
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isViewing = false;
          _isAttachedPdfLoading = false;
        });
      }
    }
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPdfAttachmentCard(String url) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (_isAttachedPdfLoading || _isViewing || _isDownloading)
          ? null
          : () => _handlePdfAction(
              url: url,
              openImmediately: true,
              defaultFileName: 'attachment_${widget.id}.pdf',
              isAttachment: true,
            ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.heading, width: 1.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: const Color(0xffF8F5ED),
                border: Border.all(color: AppColors.heading, width: 1.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: _isAttachedPdfLoading
                    ? SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xff101C16),
                        ),
                      )
                    : Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 20.sp,
                        color: AppColors.heading,
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attached Document",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isAttachedPdfLoading) ...[
                        SizedBox(
                          width: 12.sp,
                          height: 12.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Color(0xff101C16),
                          ),
                        ),
                        SizedBox(width: 6.w),
                      ],
                      Text(
                        _isAttachedPdfLoading ? "Opening..." : "View PDF",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
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
  }

  Widget _buildImagesAttachmentCard(List<String> images) {
    return GestureDetector(
      onTap: () {
        if (images.isNotEmpty) {
          _showImagePreview(images.first);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.heading, width: 1.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.network(
                images.first,
                width: 36.w,
                height: 36.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 36.w,
                  height: 36.h,
                  color: const Color(0xffF8F5ED),
                  child: Icon(
                    Icons.image,
                    size: 20.sp,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Photos (${images.length})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Tap to preview",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(16, 28, 22, 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGallery(List<String> images) {
    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final imgUrl = images[index];
          return GestureDetector(
            onTap: () => _showImagePreview(imgUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imgUrl,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffE8E6DE),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.heading),
                  ),
                  child: Icon(
                    Icons.broken_image,
                    size: 24.sp,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final getInspectionReportDetailsData = ref.watch(
      getInspectionReportDetailsProvider(widget.id),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
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
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AUDIT REPORTS",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "AUDIT REPORT DETAILS",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: getInspectionReportDetailsData.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xff101C16)),
        ),
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Failed to load audit details",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff101C16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => ref.refresh(
                    getInspectionReportDetailsProvider(widget.id),
                  ),
                  child: Text(
                    "Retry",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        data: (modelData) {
          final data = modelData.data;

          final title = widget.title ?? "Property Audit Report";

          String headerDate = data?.dateFormatted ?? widget.date ?? "--";
          String auditDate =
              data?.dateFormatted ?? widget.auditDate ?? widget.date ?? "--";
          if (data?.dateFormatted == null) {
            final rawDate = data?.inspectionDate ?? widget.date;
            if (rawDate != null && rawDate.isNotEmpty) {
              final parsed = DateTime.tryParse(rawDate);
              if (parsed != null) {
                headerDate = DateFormat("dd MMMM yyyy").format(parsed);
                auditDate = DateFormat("dd MMM yyyy").format(parsed);
              } else {
                headerDate = rawDate;
                auditDate = rawDate;
              }
            }
          }

          final property = formatPropertyTitle(
            data?.propertyName ??
                data?.complexName ??
                widget.property ??
                "Property",
          );
          final auditType =
              (data?.auditType != null &&
                  data!.auditType.toString().trim().isNotEmpty)
              ? data.auditType.toString()
              : (widget.auditType ?? "Property Audit");
          final rawStatus = data?.status ?? widget.status ?? "Completed";
          final status = rawStatus.isNotEmpty
              ? "${rawStatus[0].toUpperCase()}${rawStatus.substring(1).replaceAll('_', ' ')}"
              : "Completed";

          final overviewText =
              (data?.findings != null && data!.findings!.trim().isNotEmpty)
              ? data.findings!
              : "This audit report provides the recorded audit findings, observations and recommendations for the property.";

          final recommendationsText =
              (data?.recommendations != null &&
                  data!.recommendations!.trim().isNotEmpty)
              ? data.recommendations!
              : "Recommended actions based on the audit findings are available for review.";

          final checklist = data?.digitalChecklist ?? [];

          // Use checklist_pdf_url as per user instruction. Do NOT use download_url.
          String? checklistPdfUrl = data?.checklistPdfUrl;
          if (checklistPdfUrl == null || checklistPdfUrl.trim().isEmpty) {
            checklistPdfUrl = data?.reportPdfUrl;
          }
          if (checklistPdfUrl != null &&
              checklistPdfUrl.isNotEmpty &&
              !checklistPdfUrl.startsWith("http")) {
            final clean = checklistPdfUrl.startsWith("/")
                ? checklistPdfUrl.substring(1)
                : checklistPdfUrl;
            checklistPdfUrl = "https://realestate.gwsstaging.com/public/$clean";
          }

          // Attachments logic:
          String? attachedPdf =
              (data?.attachmentsUrls?.pdf != null &&
                  data!.attachmentsUrls!.pdf!.trim().isNotEmpty)
              ? data.attachmentsUrls!.pdf!.trim()
              : (data?.attachments?.pdf != null &&
                        data!.attachments!.pdf!.trim().isNotEmpty
                    ? data.attachments!.pdf!.trim()
                    : null);
          if (attachedPdf != null &&
              attachedPdf.isNotEmpty &&
              !attachedPdf.startsWith("http")) {
            final clean = attachedPdf.startsWith("/")
                ? attachedPdf.substring(1)
                : attachedPdf;
            attachedPdf = "https://realestate.gwsstaging.com/public/$clean";
          }

          final rawImages =
              (data?.attachmentsUrls?.images != null &&
                  data!.attachmentsUrls!.images!.isNotEmpty)
              ? data.attachmentsUrls!.images!
              : (data?.attachments?.images ?? []);
          final images = rawImages.where((img) => img.trim().isNotEmpty).map((
            img,
          ) {
            final trimmed = img.trim();
            if (trimmed.startsWith("http")) return trimmed;
            final clean = trimmed.startsWith("/")
                ? trimmed.substring(1)
                : trimmed;
            return "https://realestate.gwsstaging.com/public/$clean";
          }).toList();

          final bool hasAttachedPdf =
              attachedPdf != null && attachedPdf.isNotEmpty;
          final bool hasAttachedImages = images.isNotEmpty;
          final bool hasAttachments = hasAttachedPdf || hasAttachedImages;

          return RefreshIndicator(
            color: const Color(0xff101C16),
            onRefresh: () async {
              ref.invalidate(getInspectionReportDetailsProvider(widget.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // Overview Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 49.w,
                                height: 51.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.1,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.article_outlined,
                                    size: 22.sp,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 7.h),
                                    Text(
                                      headerDate,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          16,
                                          28,
                                          22,
                                          0.6,
                                        ),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                  ),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  status,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: const Color(0xffD0D2C8),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "PROPERTY",
                                  value: property,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _infoItem(
                                  title: "AUDIT TYPE",
                                  value: auditType,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "AUDIT DATE",
                                  value: auditDate,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _infoItem(
                                  title: "STATUS",
                                  value: status,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),
                    Text(
                      "Overview",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 14.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        overviewText,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                    Text(
                      "Findings",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 14.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: checklist.isNotEmpty
                          ? ListView.separated(
                              itemCount: checklist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Column(
                                children: [
                                  SizedBox(height: 14.h),
                                  Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: const Color(0xff777970),
                                  ),
                                  SizedBox(height: 14.h),
                                ],
                              ),
                              itemBuilder: (context, index) {
                                final checkItem = checklist[index];
                                final isPass =
                                    checkItem.status?.toLowerCase().contains(
                                      "pass",
                                    ) ??
                                    true;
                                return _auditItem(
                                  icon: isPass ? "✓" : "!",
                                  title: checkItem.itemName ?? "Audit Item",
                                  description:
                                      checkItem.remarks ?? "Observation logged",
                                );
                              },
                            )
                          : Column(
                              children: [
                                _auditItem(
                                  icon: "✓",
                                  title: "Physical Infrastructure",
                                  description:
                                      "Building structures, foundation and common areas are in standard operational condition.",
                                ),
                                SizedBox(height: 14.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 14.h),
                                _auditItem(
                                  icon: "!",
                                  title: "Service Requirements",
                                  description:
                                      "Follow-up inspections recommended for electrical and plumbing distribution points.",
                                ),
                                SizedBox(height: 14.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 14.h),
                                _auditItem(
                                  icon: "✓",
                                  title: "Statutory Compliance",
                                  description:
                                      "Safety and regulatory compliance verified for the property audit cycle.",
                                ),
                              ],
                            ),
                    ),

                    // SizedBox(height: 30.h),
                    // Text(
                    //   "Recommendations",
                    //   style: GoogleFonts.outfit(
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColors.heading,
                    //     fontSize: 18.sp,
                    //     letterSpacing: -0.2,
                    //   ),
                    // ),
                    // SizedBox(height: 14.h),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(
                    //     vertical: 14.h,
                    //     horizontal: 14.w,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: AppColors.heading),
                    //     borderRadius: BorderRadius.circular(10.r),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         recommendationsText,
                    //         style: GoogleFonts.outfit(
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.heading,
                    //           fontSize: 15.sp,
                    //           letterSpacing: -0.2,
                    //         ),
                    //       ),
                    //       SizedBox(height: 14.h),
                    //       Container(
                    //         padding: EdgeInsets.symmetric(
                    //           vertical: 5.h,
                    //           horizontal: 21.w,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           border: Border.all(color: AppColors.heading),
                    //           borderRadius: BorderRadius.circular(50.r),
                    //         ),
                    //         child: Text(
                    //           "Review Recommended Actions",
                    //           style: GoogleFonts.outfit(
                    //             fontWeight: FontWeight.w500,
                    //             color: AppColors.heading,
                    //             fontSize: 15.sp,
                    //             letterSpacing: -0.2,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Audit Checklist Document Card with Eye (View) and Download icons
                    if (checklistPdfUrl != null &&
                        checklistPdfUrl.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Text(
                        "Audit Checklist Document",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff101C16),
                                  width: 1.1,
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 22.sp,
                                  color: const Color(0xff101C16),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Checklist Report PDF",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "Official Audit Checklist",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        16,
                                        28,
                                        22,
                                        0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Eye Icon: View / Open PDF
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  (_isViewing ||
                                      _isDownloading ||
                                      _isAttachedPdfLoading)
                                  ? null
                                  : () => _handlePdfAction(
                                      url: checklistPdfUrl,
                                      openImmediately: true,
                                      defaultFileName:
                                          'audit_checklist_${widget.id}.pdf',
                                    ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: _isViewing
                                    ? SizedBox(
                                        width: 18.sp,
                                        height: 18.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xff101C16),
                                        ),
                                      )
                                    : Icon(
                                        Icons.visibility_outlined,
                                        size: 18.sp,
                                        color: const Color(0xff101C16),
                                      ),
                              ),
                            ),

                            SizedBox(width: 8.w),

                            // Download Icon: Download PDF to device
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap:
                                  (_isViewing ||
                                      _isDownloading ||
                                      _isAttachedPdfLoading)
                                  ? null
                                  : () => _handlePdfAction(
                                      url: checklistPdfUrl,
                                      openImmediately: false,
                                      defaultFileName:
                                          'audit_checklist_${widget.id}.pdf',
                                    ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff101C16),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: _isDownloading
                                    ? SizedBox(
                                        width: 18.sp,
                                        height: 18.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        Icons.file_download_outlined,
                                        size: 18.sp,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Attached Documents / Images (only shown if attachments exist)
                    if (hasAttachments) ...[
                      SizedBox(height: 24.h),
                      Text(
                        "Attached Documents / Images",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      if (hasAttachedPdf && hasAttachedImages) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildPdfAttachmentCard(attachedPdf),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(child: _buildImagesAttachmentCard(images)),
                          ],
                        ),
                      ] else if (hasAttachedPdf) ...[
                        _buildPdfAttachmentCard(attachedPdf),
                      ] else if (hasAttachedImages) ...[
                        _buildImagesGallery(images),
                      ],
                    ],

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(16, 28, 22, 0.6),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _auditItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(16, 28, 22, 0.2),
            borderRadius: BorderRadius.circular(3.r),
          ),
          alignment: Alignment.center,
          child: Text(
            icon,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.5),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


String formatPropertyTitle(String? text) {
  if (text == null || text.trim().isEmpty) return "";
  final trimmed = text.trim();
  final lower = trimmed.toLowerCase();
  if (lower == "independent_house") return "Independent House";
  if (lower == "apartment") return "Apartment";
  if (lower == "villa_compound") return "Villa Compound";
  if (lower == "commercial") return "Commercial";
  if (lower == "commercial_complex") return "Commercial Complex";

  if (trimmed.contains('_') && !trimmed.contains(' ')) {
    return trimmed
        .split('_')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
  return trimmed;
}
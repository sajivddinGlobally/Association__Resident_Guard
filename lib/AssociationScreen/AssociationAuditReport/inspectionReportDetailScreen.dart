import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'provider/getInspectionReportDetailProvider.dart';

class InspectionReportDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final String? title;
  final String? date;
  final String? property;
  final String? inspector;
  final String? inspectionDate;
  final String? status;

  const InspectionReportDetailsScreen({
    super.key,
    required this.id,
    this.title,
    this.date,
    this.property,
    this.inspector,
    this.inspectionDate,
    this.status,
  });

  @override
  ConsumerState<InspectionReportDetailsScreen> createState() =>
      _InspectionReportDetailsScreenState();
}

class _InspectionReportDetailsScreenState
    extends ConsumerState<InspectionReportDetailsScreen> {
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
              : 'inspection_checklist_${widget.id}.pdf');
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
          border: Border.all(color: const Color(0xff101C16), width: 1.1),
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
                    color: const Color(0xff101C16),
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
                      color: const Color(0xff101C16),
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

  String formatPropertyTitle(String? text) {
    if (text == null || text.trim().isEmpty) return "";
    return text
        .replaceAll(
          RegExp(r'independent[_\s]house', caseSensitive: false),
          "Home Care",
        )
        .replaceAll(RegExp(r'home[_\s]care', caseSensitive: false), "Home Care")
        .replaceAll(
          RegExp(r'apartments?', caseSensitive: false),
          "Community Care",
        )
        .replaceAll(
          RegExp(r'community[_\s]care', caseSensitive: false),
          "Community Care",
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
                    "INSPECTION REPORTS",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "INSPECTION REPORT DETAILS",
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
                  "Failed to load inspection details",
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

          final title = widget.title ?? "Property Inspection Report";
          final headerDate = data?.inspectionDate ?? widget.date ?? "--";
          final property = formatPropertyTitle(
            data?.propertyName ?? widget.property ?? "Property",
          );
          final inspector = data?.inspector?.name ?? widget.inspector ?? "N/A";
          final inspectionDate =
              data?.inspectionDate ??
              widget.inspectionDate ??
              widget.date ??
              "--";
          final rawStatus = data?.status ?? widget.status ?? "Completed";
          final status = rawStatus.isNotEmpty
              ? "${rawStatus[0].toUpperCase()}${rawStatus.substring(1)}"
              : "Completed";

          final recommendationsText =
              (data?.recommendations != null &&
                  data!.recommendations!.trim().isNotEmpty)
              ? data.recommendations!
              : "Recommended actions and priority items are available based on the inspection findings.";

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
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.1,
                                  ),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.article_outlined,
                                    size: 20.sp,
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
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
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
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.1,
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

                          SizedBox(height: 12.h),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: const Color(0xffD0D2C8),
                          ),
                          SizedBox(height: 12.h),

                          // Grid details: PROPERTY & INSPECTOR
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
                                  title: "INSPECTOR",
                                  value: inspector,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Grid details: INSPECTION DATE & STATUS
                          Row(
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "INSPECTION DATE",
                                  value: inspectionDate,
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

                    SizedBox(height: 24.h),

                    // Inspection Findings Header
                    Text(
                      "Inspection Findings",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Findings Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff999999),
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: checklist.isNotEmpty
                          ? ListView.separated(
                              itemCount: checklist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Column(
                                children: [
                                  SizedBox(height: 12.h),
                                  Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: const Color(0xff777970),
                                  ),
                                  SizedBox(height: 12.h),
                                ],
                              ),
                              itemBuilder: (context, index) {
                                final checkItem = checklist[index];
                                final isPass =
                                    checkItem.status?.toLowerCase().contains(
                                      "pass",
                                    ) ??
                                    true;
                                return _findingItem(
                                  iconType: isPass
                                      ? _IconBadgeType.check
                                      : _IconBadgeType.warning,
                                  title: checkItem.itemName ?? "",
                                  subtitle: checkItem.remarks ?? "",
                                );
                              },
                            )
                          : Column(
                              children: [
                                _findingItem(
                                  iconType: _IconBadgeType.check,
                                  title: "General Property Condition",
                                  subtitle:
                                      "Property condition reviewed during the scheduled inspection.",
                                ),
                                SizedBox(height: 12.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 12.h),
                                _findingItem(
                                  iconType: _IconBadgeType.warning,
                                  title: "Maintenance Observation",
                                  subtitle:
                                      "Minor maintenance attention is recommended for the identified area.",
                                ),
                                SizedBox(height: 12.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 12.h),
                                _findingItem(
                                  iconType: _IconBadgeType.check,
                                  title: "Safety Check",
                                  subtitle:
                                      "Safety-related observations recorded in the inspection report.",
                                ),
                              ],
                            ),
                    ),

                    // SizedBox(height: 24.h),
                    // // Recommendations Header
                    // Text(
                    //   "Recommendations",
                    //   style: GoogleFonts.outfit(
                    //     fontSize: 18.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.heading,
                    //     letterSpacing: -0.2,
                    //   ),
                    // ),
                    // SizedBox(height: 12.h),
                    // Recommendations Card
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 14.w,
                    //     vertical: 14.h,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: const Color(0xff101C16),
                    //       width: 1.1,
                    //     ),
                    //     borderRadius: BorderRadius.circular(10.r),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         recommendationsText,
                    //         style: GoogleFonts.outfit(
                    //           fontSize: 12.5.sp,
                    //           fontWeight: FontWeight.w500,
                    //           color: const Color.fromRGBO(16, 28, 22, 0.75),
                    //           letterSpacing: -0.2,
                    //           height: 1.35,
                    //         ),
                    //       ),
                    //       SizedBox(height: 12.h),
                    //       GestureDetector(
                    //         onTap: () {},
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 18.w,
                    //             vertical: 7.h,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(
                    //               color: const Color(0xff101C16),
                    //               width: 1.1,
                    //             ),
                    //             borderRadius: BorderRadius.circular(25.r),
                    //           ),
                    //           child: Text(
                    //             "Review Recommended Actions",
                    //             style: GoogleFonts.outfit(
                    //               fontSize: 15.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: const Color(0xff101C16),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 24.h),

                    // Checklist PDF Card with Eye (View) and Download icons
                    if (checklistPdfUrl != null &&
                        checklistPdfUrl.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Text(
                        "Inspection Checklist Document",
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
                                    "Official Inspection Checklist",
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
                                          'inspection_checklist_${widget.id}.pdf',
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
                                          'inspection_checklist_${widget.id}.pdf',
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

                    // Attached Documents / Images Header & Content (only shown if attachments exist)
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
          border: Border.all(color: const Color(0xff101C16), width: 1.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff101C16), width: 1.1),
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
                        color: const Color(0xff101C16),
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
                      color: const Color(0xff101C16),
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
                    border: Border.all(color: const Color(0xff101C16)),
                  ),
                  child: Icon(
                    Icons.broken_image,
                    size: 24.sp,
                    color: const Color(0xff101C16),
                  ),
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
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(16, 28, 22, 0.55),
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
            fontWeight: FontWeight.w600,
            color: const Color(0xff101C16),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _findingItem({
    required _IconBadgeType iconType,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: const Color(0xffD9DCD3),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: iconType == _IconBadgeType.check
                ? Icon(Icons.check, size: 18.sp, color: const Color(0xff101C16))
                : Text(
                    "!",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff101C16),
                    ),
                  ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff101C16),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
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

enum _IconBadgeType { check, warning }

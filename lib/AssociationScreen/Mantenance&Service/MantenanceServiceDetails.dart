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
import 'package:property_association_or_resident/AssociationScreen/Mantenance&Service/Provider/maintananceDetailsProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/maintananceDetailsModel.dart'
    hide Image;

class MantenanceServiceDetails extends ConsumerStatefulWidget {
  final String id;
  const MantenanceServiceDetails({super.key, required this.id});

  @override
  ConsumerState<MantenanceServiceDetails> createState() =>
      _MantenanceServiceDetailsState();
}

class _MantenanceServiceDetailsState
    extends ConsumerState<MantenanceServiceDetails> {
  String? _loadingViewingUrl;
  String? _loadingDownloadingUrl;

  @override
  Widget build(BuildContext context) {
    final maintananceState = ref.watch(maintananceDetailsProvider(widget.id));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
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
                      "Service Charges Details",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(right: 16.w),
        //     child: maintananceState.whenOrNull(
        //       data: (data) => InkWell(
        //         onTap: () {
        //           _showUpdateStatusModal(
        //             context,
        //             data.data?.header?.statusBadge ??
        //                 data.data?.maintenanceDetails?.status ??
        //                 "Pending",
        //           );
        //         },
        //         child: Container(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: 10.w,
        //             vertical: 6.h,
        //           ),
        //           decoration: BoxDecoration(
        //             color: const Color(0xff101C16),
        //             borderRadius: BorderRadius.circular(6.r),
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(Icons.edit_note, color: Colors.white, size: 16.sp),
        //               SizedBox(width: 4.w),
        //               Text(
        //                 "Status",
        //                 style: GoogleFonts.outfit(
        //                   fontSize: 12.sp,
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: maintananceState.when(
        data: (data) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 11.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              // "MAINTENANCE REQUEST · MR-2048",
                              data.data?.header?.badgeRequest ?? "N/A",
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
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 13.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              border: Border.all(
                                color: const Color(0xFFB8860B),
                                width: 1.w,
                              ),
                            ),
                            child: Text(
                              // "In Progress",
                              data.data?.header?.statusBadge ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFC18A00),
                                height: 1,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        // "Water Leakage Repair",
                        data.data?.header?.title ?? "N/A",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          height: 1.1,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        // "Plumbing maintenance request",
                        data.data?.header?.screenTitle ?? "N/A",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.75),
                          height: 1.15,
                          letterSpacing: -0.15,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _divider(),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Priority',
                              value: data.data?.header?.priority ?? "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Raised On',
                              value: data.data?.header?.raisedOn ?? "N/A",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Expected Completion',
                              value:
                                  data.data?.header?.expectedCompletion ??
                                  "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Actual Completion',
                              value:
                                  data.data?.header?.actualCompletion ?? "N/A",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                // _buildProgressStepper(
                //   data.data?.header?.statusBadge ??
                //       data.data?.maintenanceDetails?.status ??
                //       "Pending",
                // ),
                // SizedBox(height: 24.h),
                // _sectionHeader("Request Information", "DETAILS"),
                // SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(21.w, 20.h, 21.w, 18.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 242, 165, 0.55),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 19.sp,
                              color: const Color(0xFF9D8422),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Maintenance Request",
                                  data.data?.requestInformation?.title ?? "N/A",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    height: 1.1,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  // "Repair required in apartment plumbing area",
                                  data.data?.requestInformation?.subtitle ??
                                      "N/A",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.75,
                                    ),
                                    height: 1.15,
                                    letterSpacing: -0.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _divider(),
                      SizedBox(height: 14.h),
                      Text(
                        "Description",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        // "Water leakage reported from the bathroom plumbing connection. Maintenance team has been assigned to inspect and complete the required repair.",
                        data.data?.requestInformation?.description ?? "N/A",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.heading,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                // Property / Unit Section
                SizedBox(height: 19.h),
                _sectionHeader("Property / Unit", "LOCATION"),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 9.h,
                    horizontal: 14.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.w),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.home_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Property / Unit",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(42, 41, 51, 0.75),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              // "Apartment A-204",
                              data.data?.propertyUnit?.unitName ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              // "Green Valley Residency · Jaipur",
                              data.data?.propertyUnit?.fullLocation ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(42, 41, 51, 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.chevron_right,
                      //   color: Colors.black,
                      //   size: 20.sp,
                      // ),
                    ],
                  ),
                ),

                // Maintenance Details Section
                SizedBox(height: 20.h),
                _sectionHeader("Maintenance Details", "ACTIVE"),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 17.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Category',
                              value:
                                  data.data?.maintenanceDetails?.category ??
                                  "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Priority',
                              value:
                                  data.data?.maintenanceDetails?.priority ??
                                  "N/A",
                              valueColor: const Color(0xFFB8860B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Status',
                              value:
                                  data.data?.maintenanceDetails?.status ??
                                  "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Raised Date',
                              value:
                                  data.data?.maintenanceDetails?.raisedDate ??
                                  "N/A",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Expected Completion',
                              value:
                                  data
                                      .data
                                      ?.maintenanceDetails
                                      ?.expectedCompletion ??
                                  "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Actual Completion',
                              value:
                                  data
                                      .data
                                      ?.maintenanceDetails
                                      ?.actualCompletion ??
                                  "-",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _InfoItem(
                              label: 'Cost / Reference',
                              value:
                                  data
                                      .data
                                      ?.maintenanceDetails
                                      ?.costReference ??
                                  "N/A",
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: _InfoItem(
                              label: 'Request Reference',
                              value:
                                  data
                                      .data
                                      ?.maintenanceDetails
                                      ?.requestReference ??
                                  "N/A",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (data.data?.maintenanceDetails != null) ...[
                  // Assigned Person Section
                  SizedBox(height: 20.h),
                  Text(
                    "Assigned Person / Vendor",
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
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1.w),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              // 'assets/images/provider.png',
                              data.data?.assignedVendor?.avatar ?? "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 24.sp,
                                  color: Colors.black87,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assigned Person / Vendor",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                // "Raj Kumar",
                                data.data?.assignedVendor?.name ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                // "Plumbing Maintenance",
                                data.data?.assignedVendor?.role ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon(
                        //   Icons.chevron_right,
                        //   color: Colors.black,
                        //   size: 20.sp,
                        // ),
                      ],
                    ),
                  ),
                ],
                // Maintenance History Section
                SizedBox(height: 18.h),
                _sectionHeader("Maintenance History", "ACTIVITY"),
                SizedBox(height: 16.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 19.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  // child: Column(
                  //   children: [
                  //     _timelineTile(
                  //       title: "Maintenance Request Raised",
                  //       subtitle: "Water leakage repair request created.",
                  //       date: "20 Aug 2026 · 10:25 AM",
                  //       isFirst: true,
                  //       isLast: false,
                  //       isActive: false,
                  //     ),
                  //     _timelineTile(
                  //       title: "Maintenance Request Raised",
                  //       subtitle: "Water leakage repair request created.",
                  //       date: "20 Aug 2026 · 10:25 AM",
                  //       isFirst: false,
                  //       isLast: false,
                  //       isActive: false,
                  //     ),
                  //     _timelineTile(
                  //       title: "Maintenance Request Raised",
                  //       subtitle: "Water leakage repair request created.",
                  //       date: "20 Aug 2026 · 10:25 AM",
                  //       isFirst: false,
                  //       isLast: true,
                  //       isActive: true,
                  //     ),
                  //   ],
                  // ),
                  child: Column(
                    children: List.generate(
                      data.data?.activityHistory?.timeline?.length ?? 0,
                      (index) {
                        final item =
                            data.data?.activityHistory!.timeline![index];
                        return _timelineTile(
                          title: item?.title ?? "N/A",
                          subtitle: item?.status ?? "N/A",
                          date: item?.timestamp.toString() ?? "N/A",
                          isFirst: index == 0,
                          isLast:
                              index ==
                              data.data!.activityHistory!.timeline!.length - 1,
                          isActive: item?.status?.toLowerCase() == "completed",
                        );
                      },
                    ),
                  ),
                ),

                // Supporting Documents & Images logic
                ...(() {
                  final files =
                      data.data?.supportingDocuments?.files
                          ?.where(
                            (f) =>
                                (f.downloadUrl != null &&
                                    f.downloadUrl!.trim().isNotEmpty) ||
                                (f.fileName != null &&
                                    f.fileName!.trim().isNotEmpty) ||
                                (f.title != null && f.title!.trim().isNotEmpty),
                          )
                          .toList() ??
                      [];

                  final images =
                      data.data?.supportingDocuments?.images
                          ?.where(
                            (img) =>
                                (img.imageUrl != null &&
                                    img.imageUrl!.trim().isNotEmpty) ||
                                (img.placeholder != null &&
                                    img.placeholder!.trim().isNotEmpty),
                          )
                          .toList() ??
                      [];

                  final bool hasFiles = files.isNotEmpty;
                  final bool hasImages = images.isNotEmpty;
                  final String? imageNote =
                      data.data?.supportingDocuments?.imageNote;

                  return [
                    // Supporting Documents (Only shown if files exist)
                    if (hasFiles) ...[
                      SizedBox(height: 20.h),
                      _sectionHeader("Supporting Documents", "ATTACHMENTS"),
                      SizedBox(height: 14.h),
                      ...files.map((file) => _buildDocumentItem(file)),
                    ],

                    // Supporting Image (Only shown if images exist)
                    if (hasImages) ...[
                      SizedBox(height: 20.h),
                      _sectionHeader("Supporting Image", "ATTACHMENTS"),
                      SizedBox(height: 16.h),
                      Row(
                        children: List.generate(images.length, (index) {
                          final image = images[index];
                          final isLast = index == images.length - 1;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: isLast ? 0 : 20.w,
                              ),
                              child: _imageAttachmentCard(
                                image.label ??
                                    (index == 0 ? "BEFORE" : "AFTER"),
                                image.imageUrl ?? image.placeholder ?? "",
                                placeholder: image.placeholder,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],

                    // Image Note (Only shown if files or images exist, and note is not empty)
                    if ((hasFiles || hasImages) &&
                        imageNote != null &&
                        imageNote.trim().isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFFC18A00)),
                        ),
                        child: Text(
                          imageNote,
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFC18A00),
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                    ],
                  ];
                })(),

                SizedBox(height: 24.h),
                // Bottom Bar
                // Row(
                //   children: [
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "CURRENT STATUS",
                //             style: GoogleFonts.outfit(
                //               fontSize: 12.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //           SizedBox(height: 4.h),
                //           Text(
                //             // "Maintenance work in progress",
                //             data.data?.currentStatusBar?.statusText ?? "N/A",
                //             style: GoogleFonts.outfit(
                //               fontSize: 14.sp,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.black,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 10.w,
                //         vertical: 4.h,
                //       ),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(40.r),
                //         border: Border.all(color: Colors.black, width: 1.w),
                //       ),
                //       child: Text(
                //         "View Full History →",
                //         style: GoogleFonts.outfit(
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 30.h),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "No Data Found",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.h,
      thickness: 0.8.w,
      color: const Color.fromRGBO(42, 41, 51, 0.6),
    );
  }

  Widget _timelineTile({
    required String title,
    required String subtitle,
    required String date,
    required bool isFirst,
    required bool isLast,
    required bool isActive,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: const Color(0xFFF2E6C6),
                  color: isActive
                      ? const Color(0xFFF2E6C6)
                      : Colors.grey.shade200,
                ),
                child: Center(
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: const Color(0xFFC18A00),
                      color: isActive
                          ? const Color(0xFFC18A00)
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.w,
                    // color: const Color(0xFFC18A00).withOpacity(0.5),
                    color: isActive
                        ? const Color(0xFFC18A00).withOpacity(0.5)
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, bottom: isLast ? 0 : 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    date,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    if (imageUrl.trim().isEmpty) return;
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

  Future<void> _handlePdfAction({
    required String? url,
    required bool openImmediately,
    String? defaultFileName,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Attached document is not available");
      return;
    }

    if (_loadingViewingUrl != null || _loadingDownloadingUrl != null) return;

    setState(() {
      if (openImmediately) {
        _loadingViewingUrl = url;
      } else {
        _loadingDownloadingUrl = url;
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
          defaultFileName ?? 'maintenance_doc_${widget.id}.pdf';
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
          _loadingViewingUrl = null;
          _loadingDownloadingUrl = null;
        });
      }
    }
  }

  Widget _buildDocumentItem(FileElement file) {
    final isViewingThis = _loadingViewingUrl == file.downloadUrl;
    final isDownloadingThis = _loadingDownloadingUrl == file.downloadUrl;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xff101C16), width: 1.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff101C16), width: 1.1),
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
                  file.title ?? file.fileName ?? "Work Report",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "${file.fileType ?? 'PDF'} · ${file.fileSize ?? '1 file'}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(16, 28, 22, 0.6),
                  ),
                ),
              ],
            ),
          ),

          // Eye Icon: View / Open PDF
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (isViewingThis || isDownloadingThis)
                ? null
                : () => _handlePdfAction(
                    url: file.downloadUrl,
                    openImmediately: true,
                    defaultFileName: file.fileName,
                  ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff101C16), width: 1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: isViewingThis
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
            onTap: (isViewingThis || isDownloadingThis)
                ? null
                : () => _handlePdfAction(
                    url: file.downloadUrl,
                    openImmediately: false,
                    defaultFileName: file.fileName,
                  ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xff101C16),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: isDownloadingThis
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
    );
  }

  Widget _imageAttachmentCard(
    String label,
    String imagePath, {
    String? placeholder,
  }) {
    final bool isNetwork =
        imagePath.startsWith('http') ||
        (placeholder != null && placeholder.startsWith('http'));
    final String mainUrl = imagePath.isNotEmpty
        ? imagePath
        : (placeholder ?? "");

    return GestureDetector(
      onTap: () {
        if (mainUrl.isNotEmpty) {
          _showImagePreview(mainUrl);
        }
      },
      child: Stack(
        children: [
          Container(
            height: 103.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: isNetwork
                  ? Image.network(
                      mainUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (placeholder != null &&
                            placeholder.isNotEmpty &&
                            placeholder != mainUrl) {
                          return Image.network(
                            placeholder,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 40.sp,
                            ),
                          );
                        }
                        return Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40.sp,
                        );
                      },
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40.sp,
                        );
                      },
                    ),
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFF292832),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getActiveStep(String? status) {
    final s = (status ?? '').toLowerCase().trim();
    if (s.contains('complete') ||
        s.contains('resolve') ||
        s.contains('closed')) {
      return 2;
    } else if (s.contains('progress')) {
      return 1;
    }
    return 0;
  }

  Widget _buildProgressStepper(String currentStatus) {
    final activeStep = _getActiveStep(currentStatus);
    final steps = [
      {'title': 'Requested', 'sub': 'Pending review'},
      {'title': 'In Progress', 'sub': 'Work underway'},
      {'title': 'Completed', 'sub': 'Work finished'},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timeline,
                    size: 18.sp,
                    color: const Color(0xFFB8860B),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "WORK ORDER PROGRESS",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showUpdateStatusModal(context, currentStatus),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101C16),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note, size: 14.sp, color: Colors.white),
                      SizedBox(width: 4.w),
                      Text(
                        "Update",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(steps.length, (index) {
              final isPassed = index < activeStep;
              final isCurrent = index == activeStep;
              final isLast = index == steps.length - 1;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: index == 0
                                ? Colors.transparent
                                : (isPassed || isCurrent
                                      ? const Color(0xFF24B06A)
                                      : Colors.grey.shade300),
                          ),
                        ),
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPassed
                                ? const Color(0xFF24B06A)
                                : isCurrent
                                ? const Color(0xFFB8860B)
                                : Colors.grey.shade200,
                            border: Border.all(
                              color: isPassed
                                  ? const Color(0xFF24B06A)
                                  : isCurrent
                                  ? const Color(0xFFB8860B)
                                  : Colors.grey.shade400,
                              width: 1.5.w,
                            ),
                          ),
                          child: Center(
                            child: isPassed
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color: Colors.white,
                                  )
                                : isCurrent
                                ? Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "${index + 1}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: isLast
                                ? Colors.transparent
                                : (isPassed
                                      ? const Color(0xFF24B06A)
                                      : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      steps[index]['title']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: isCurrent
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isCurrent
                            ? const Color(0xFFB8860B)
                            : isPassed
                            ? const Color(0xFF24B06A)
                            : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      steps[index]['sub']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusModal(BuildContext context, String currentStatus) {
    String selectedStatus = 'in_progress';
    final cur = currentStatus.toLowerCase();
    if (cur.contains('complete') || cur.contains('resolve')) {
      selectedStatus = 'completed';
    } else if (cur.contains('progress')) {
      selectedStatus = 'in_progress';
    } else {
      selectedStatus = 'pending';
    }

    final notesController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 25.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Status",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Select current maintenance work order status:",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ...[
                    {
                      'key': 'pending',
                      'label': 'Pending / Requested',
                      'icon': Icons.pending_actions,
                    },
                    {
                      'key': 'in_progress',
                      'label': 'In Progress',
                      'icon': Icons.construction,
                    },
                    {
                      'key': 'completed',
                      'label': 'Completed',
                      'icon': Icons.check_circle_outline,
                    },
                  ].map((item) {
                    final isSel = selectedStatus == item['key'];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: InkWell(
                        onTap: () {
                          setModalState(() {
                            selectedStatus = item['key'] as String;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: isSel
                                  ? const Color(0xFF101C16)
                                  : Colors.black26,
                              width: isSel ? 1.5.w : 1.w,
                            ),
                            color: isSel
                                ? const Color(0xFF101C16).withOpacity(0.06)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 18.sp,
                                color: isSel
                                    ? const Color(0xFF101C16)
                                    : Colors.black54,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  item['label'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: isSel
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (isSel)
                                Icon(
                                  Icons.radio_button_checked,
                                  size: 18.sp,
                                  color: const Color(0xFF101C16),
                                )
                              else
                                Icon(
                                  Icons.radio_button_off,
                                  size: 18.sp,
                                  color: Colors.black38,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 8.h),
                  Text(
                    "Remark Notes (Optional)",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "Enter remarks (e.g. Work inspected and verified)...",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(16, 28, 22, 0.6),
                        letterSpacing: -0.2,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(16, 28, 22, 0.6),
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(16, 28, 22, 0.6),
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: BorderSide(
                          color: AppColors.heading,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setModalState(() => isSubmitting = true);
                              try {
                                await ref
                                    .read(authServiceProvider)
                                    .updateMaintenanceStatus(
                                      id: widget.id,
                                      status: selectedStatus,
                                      notes: notesController.text.trim(),
                                    );
                                ref.invalidate(
                                  maintananceDetailsProvider(widget.id),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  showSuccessSnackBar(
                                    "Work order status updated successfully",
                                  );
                                }
                              } catch (e) {
                                setModalState(() => isSubmitting = false);
                                showErrorSnackBar(
                                  "Failed to update status: $e",
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF101C16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Save & Update Status",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
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
            height: 1,
            letterSpacing: -0.15,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.heading,
            height: 1.1,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

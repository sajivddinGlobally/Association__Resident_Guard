// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/ServiceManagePerformance.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/ServiceManageProviderDetails.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';

// import 'Provider/serviceManagementDetailsProvider.dart';

// class AssociationServiceManageDetails extends ConsumerStatefulWidget {
//   final String id;
//   const AssociationServiceManageDetails({super.key, required this.id});

//   @override
//   ConsumerState<AssociationServiceManageDetails> createState() =>
//       _AssociationServiceManageDetailsState();
// }

// class _AssociationServiceManageDetailsState
//     extends ConsumerState<AssociationServiceManageDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final serviceDetailsState = ref.watch(
//       serviceManagementDetailsProvider(widget.id),
//     );
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBg,
//         automaticallyImplyLeading: false,
//         titleSpacing: 20.w,
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   width: 44.w,
//                   height: 44.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: const Color.fromRGBO(16, 28, 22, 0.3),
//                     ),
//                     borderRadius: BorderRadius.circular(6.r),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: const Color(0xff101C16),
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Service Details",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.outfit(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       "Service Management",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.outfit(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w400,
//                         color: const Color.fromRGBO(42, 41, 51, 0.7),
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: serviceDetailsState.when(
//         data: (data) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 16.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 17.w,
//                       vertical: 12.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14.r),
//                       border: Border.all(color: Color(0xFF000000), width: 1.w),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 data.data.header.complexName,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColors.heading,
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10.w,
//                                 vertical: 4.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(34.r),
//                                 border: Border.all(
//                                   color: const Color(0xFF000000),
//                                   width: 1.w,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.circle,
//                                     color: Color(0xFF000000),
//                                     size: 10.sp,
//                                   ),
//                                   SizedBox(width: 5.w),
//                                   Text(
//                                     data.data.heroCard.badgeStatus,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 13.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xFF000000),
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 17.w),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 34.w,
//                               height: 34.w,
//                               decoration: BoxDecoration(
//                                 color: Color(0xFFB8860B),
//                                 borderRadius: BorderRadius.circular(4.r),
//                               ),
//                               child: Icon(
//                                 Icons.cleaning_services_outlined,
//                                 size: 18.sp,
//                                 color: const Color(0xFF000000),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data.data.heroCard.title,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.w700,
//                                       color: AppColors.heading,
//                                       height: 1.1,
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                   SizedBox(height: 4.h),
//                                   Text(
//                                     data.data.heroCard.subtitle,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: const Color.fromRGBO(
//                                         42,
//                                         41,
//                                         51,
//                                         0.75,
//                                       ),
//                                       height: 1.15,
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 17.h),
//                         Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: Color.fromRGBO(16, 28, 22, 0.5),
//                         ),
//                         SizedBox(height: 12.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _serviceStat(
//                                 label: "Schedule",
//                                 value: data.data.heroCard.metrics.schedule,
//                               ),
//                             ),

//                             Expanded(
//                               child: _serviceStat(
//                                 label: "Service Since",
//                                 value: data.data.heroCard.metrics.serviceSince,
//                               ),
//                             ),

//                             Expanded(
//                               child: _serviceStat(
//                                 label: "Issues",
//                                 value: data.data.heroCard.metrics.issues,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Service Information",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14.w,
//                       vertical: 18.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Color(0xFF000000), width: 1.w),
//                     ),
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       crossAxisSpacing: 20.w,
//                       mainAxisSpacing: 16.h,
//                       childAspectRatio: 4,
//                       children: [
//                         _infoItem(
//                           label: "Service Type",
//                           value: data.data.serviceInformation.serviceType,
//                         ),

//                         _infoItem(
//                           label: "Current Status",
//                           value: data.data.serviceInformation.currentStatus,
//                         ),

//                         _infoItem(
//                           label: "Service Schedule",
//                           value: data.data.serviceInformation.serviceSchedule,
//                         ),

//                         _infoItem(
//                           label: "Service Time",
//                           value: data.data.serviceInformation.serviceTime,
//                         ),

//                         _infoItem(
//                           label: "Last Service",
//                           value: data.data.serviceInformation.lastService,
//                         ),

//                         _infoItem(
//                           label: "Next Review",
//                           value: data.data.serviceInformation.nextReview,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Assigned Person / Vendor",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                           builder: (context) =>
//                               ServiceManageProviderDetails(id: widget.id),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 15.w,
//                         vertical: 14.h,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.r),
//                         border: Border.all(
//                           color: Color(0xFF000000),
//                           width: 1.w,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 50.w,
//                             height: 50.w,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Color(0xFF000000),
//                                 width: 1.w,
//                               ),
//                             ),
//                             child: ClipOval(
//                               child: Image.network(
//                                 data.data.assignedVendor.avatar,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Icon(
//                                     Icons.person,
//                                     size: 20.sp,
//                                     color: Colors.black87,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12.w),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   data.data.assignedVendor.providerLabel,
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: const Color.fromRGBO(
//                                       42,
//                                       41,
//                                       51,
//                                       0.75,
//                                     ),
//                                     height: 1,
//                                     letterSpacing: -0.1,
//                                   ),
//                                 ),
//                                 SizedBox(height: 3.h),
//                                 Text(
//                                   data.data.assignedVendor.name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 18.sp,
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColors.heading,
//                                     letterSpacing: -0.1,
//                                   ),
//                                 ),
//                                 SizedBox(height: 2.h),
//                                 Text(
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   data.data.assignedVendor.roleDescription,
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: const Color.fromRGBO(
//                                       42,
//                                       41,
//                                       51,
//                                       0.75,
//                                     ),
//                                     height: 1.2,
//                                     letterSpacing: -0.1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 10.w),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             color: Color(0xFF2A2933),
//                             size: 16.sp,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Scope of Work",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 16.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Colors.black, width: 1.w),
//                     ),
//                     child: Column(
//                       children: List.generate(
//                         data.data.scopeOfWork.checklistItems.length,
//                         (index) {
//                           final item =
//                               data.data.scopeOfWork.checklistItems[index];

//                           return Padding(
//                             padding: EdgeInsets.only(
//                               bottom:
//                                   index ==
//                                       data
//                                               .data
//                                               .scopeOfWork
//                                               .checklistItems
//                                               .length -
//                                           1
//                                   ? 0
//                                   : 16.h,
//                             ),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 28.w,
//                                   height: 28.w,
//                                   decoration: BoxDecoration(
//                                     color: item.isCompleted
//                                         ? const Color(0xFFB8860B)
//                                         : Colors.transparent,
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     border: Border.all(
//                                       color: const Color(0xFF101C16),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   child: item.isCompleted
//                                       ? Center(
//                                           child: Icon(
//                                             Icons.check,
//                                             color: const Color(0xFF000000),
//                                             size: 18.sp,
//                                           ),
//                                         )
//                                       : null,
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Expanded(
//                                   child: Text(
//                                     item.task,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.heading,
//                                       height: 1.1,
//                                       letterSpacing: -0.3,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   // SizedBox(height: 20.h),
//                   // Text(
//                   //   "Reported Issues",
//                   //   style: GoogleFonts.outfit(
//                   //     fontSize: 18.sp,
//                   //     fontWeight: FontWeight.w700,
//                   //     color: AppColors.heading,
//                   //     letterSpacing: -0.2,
//                   //   ),
//                   // ),
//                   // SizedBox(height: 10.h),
//                   // Container(
//                   //   width: double.infinity,
//                   //   padding: EdgeInsets.symmetric(
//                   //     horizontal: 10.w,
//                   //     vertical: 10.h,
//                   //   ),
//                   //   decoration: BoxDecoration(
//                   //     borderRadius: BorderRadius.circular(10.r),
//                   //     border: Border.all(color: Color(0xFFB8860B), width: 1.w),
//                   //   ),
//                   //   child: Row(
//                   //     children: [
//                   //       Container(
//                   //         width: 35.w,
//                   //         height: 34.h,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(10.r),
//                   //           color: Color.fromRGBO(184, 134, 11, 0.9),
//                   //         ),
//                   //         child: Center(
//                   //           child: Text(
//                   //             data.data.reportedIssues.badge,
//                   //             style: GoogleFonts.outfit(
//                   //               fontSize: 13.sp,
//                   //               fontWeight: FontWeight.w600,
//                   //               color: Color(0xFFFFFFFF),
//                   //               height: 1,
//                   //               letterSpacing: -0.1,
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //       SizedBox(width: 12.w),
//                   //       Expanded(
//                   //         child: Column(
//                   //           crossAxisAlignment: CrossAxisAlignment.start,
//                   //           children: [
//                   //             Text(
//                   //               data.data.reportedIssues.title,
//                   //               maxLines: 1,
//                   //               overflow: TextOverflow.ellipsis,
//                   //               style: GoogleFonts.outfit(
//                   //                 fontSize: 16.sp,
//                   //                 fontWeight: FontWeight.w600,
//                   //                 color: AppColors.heading,
//                   //                 height: 1.1,
//                   //                 letterSpacing: -0.1,
//                   //               ),
//                   //             ),
//                   //             SizedBox(height: 3.h),
//                   //             Text(
//                   //               data.data.reportedIssues.subtitle,
//                   //               maxLines: 2,
//                   //               overflow: TextOverflow.ellipsis,
//                   //               style: GoogleFonts.outfit(
//                   //                 fontSize: 14.sp,
//                   //                 fontWeight: FontWeight.w500,
//                   //                 color: const Color.fromRGBO(42, 41, 51, 0.75),
//                   //                 letterSpacing: -0.1,
//                   //               ),
//                   //             ),
//                   //           ],
//                   //         ),
//                   //       ),
//                   //       SizedBox(width: 10.w),
//                   //       Icon(
//                   //         Icons.arrow_forward_ios,
//                   //         color: Color(0xFF2A2933),
//                   //         size: 16.sp,
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Service Performance",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                           builder: (context) =>
//                               ServiceManagePerformance(id: widget.id),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20.w,
//                         vertical: 16.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF101C16),
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       data.data.servicePerformance.title,
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                         height: 1.1,
//                                         letterSpacing: -0.2,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4.h),
//                                     Text(
//                                       "Based on service monitoring",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 13.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white70,
//                                         height: 1.1,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(
//                                 data.data.servicePerformance.formatted,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.white,
//                                   height: 1.1,
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12.h),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10.r),
//                             child: LinearProgressIndicator(
//                               value:
//                                   (data.data.servicePerformance.score > 10
//                                           ? data.data.servicePerformance.score /
//                                                 100
//                                           : data.data.servicePerformance.score /
//                                                 10)
//                                       .clamp(0.0, 1.0),
//                               minHeight: 4.h,
//                               backgroundColor: const Color(0xFF919191),
//                               valueColor: const AlwaysStoppedAnimation<Color>(
//                                 Color(0xFF00BB5E),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Current Performance",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white70,
//                                     height: 1.1,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 data.data.servicePerformance.currentPerformance,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                   height: 1.1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),
//           );
//         },
//         error: (error, stackTrace) {
//           log(stackTrace.toString());
//           log(error.toString());
//           return Container(
//             margin: EdgeInsets.symmetric(horizontal: 20.w),
//             padding: EdgeInsets.symmetric(vertical: 20.h),
//             alignment: Alignment.center,
//             child: Text(
//               "Something went wrong",
//               style: GoogleFonts.outfit(
//                 fontSize: 15.sp,
//                 color: AppColors.heading,
//               ),
//             ),
//           );
//         },
//         loading: () {
//           return SizedBox(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height / 2,
//             child: const Center(
//               child: CircularProgressIndicator(color: AppColors.heading),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _serviceStat({required String label, required String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.outfit(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromRGBO(42, 41, 51, 0.75),
//             letterSpacing: -0.2,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.outfit(
//             fontSize: 17.sp,
//             fontWeight: FontWeight.w700,
//             color: AppColors.heading,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoItem({required final String label, required final String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.outfit(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w500,
//             color: const Color.fromRGBO(42, 41, 51, 0.75),
//             height: 1.1,
//             letterSpacing: -0.2,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: GoogleFonts.outfit(
//             fontSize: 17.sp,
//             fontWeight: FontWeight.w700,
//             color: AppColors.heading,
//             height: 1.1,
//             letterSpacing: -0.2,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/ServiceRequestDetails.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/ServiceManagementDetailsResModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'provider/serviceManagementDetailsProvider.dart';

/// Vendor ki poori jaankari EK hi screen par.
/// (Pehle "Service Performance" aur "Provider Details" alag screens thi - unka data
/// yahin aa gaya; wahan nakli graph / % the. Score sirf ek jagah, 100 mein se.)
class AssociationServiceManageDetails extends ConsumerStatefulWidget {
  final String id;
  const AssociationServiceManageDetails({super.key, required this.id});

  @override
  ConsumerState<AssociationServiceManageDetails> createState() =>
      _AssociationServiceManageDetailsState();
}

class _AssociationServiceManageDetailsState
    extends ConsumerState<AssociationServiceManageDetails> {
  static const Color _gold = Color(0xFFB8860B);
  static const Color _green = Color(0xFF24B06A);
  static const Color _muted = Color.fromRGBO(42, 41, 51, 0.75);

  /// Khaali value -> "-" (kabhi nakli value nahi)
  String _v(String? value) {
    final s = (value ?? '').trim();
    return s.isEmpty ? '-' : s;
  }

  Future<void> _open(String url) async {
    final raw = url.trim();
    if (raw.isEmpty) return;
    try {
      final ok = await launchUrl(
        Uri.parse(raw),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open")));
      }
    } catch (e) {
      log("open url failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Could not open")));
      }
    }
  }

  IconData _serviceIcon(String icon) {
    switch (icon) {
      case 'shield':
        return Icons.shield_outlined;
      case 'settings':
        return Icons.settings_outlined;
      default:
        return Icons.cleaning_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceDetailsState = ref.watch(
      serviceManagementDetailsProvider(widget.id),
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
      body: serviceDetailsState.when(
        data: (data) {
          final d = data.data;
          final vendor = d.vendorDetails;
          final vendorName = vendor.name.isNotEmpty
              ? vendor.name
              : (d.assignedVendor.name.isNotEmpty
                    ? d.assignedVendor.name
                    : d.heroCard.subtitle);
          final category = vendor.category.isNotEmpty
              ? vendor.category
              : d.heroCard.category;

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              try {
                await ref.refresh(
                  serviceManagementDetailsProvider(widget.id).future,
                );
              } catch (_) {
                // error screen provider khud dikha deta hai
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _heroCard(d, vendorName, category),
                    SizedBox(height: 16.h),
                    _sectionTitle("Vendor & Contact"),
                    SizedBox(height: 12.h),
                    _vendorCard(d, vendor, vendorName),
                    SizedBox(height: 16.h),
                    _sectionTitle("Service Information"),
                    SizedBox(height: 12.h),
                    _serviceInfoCard(d, vendor, category),
                    if (d.scopeOfWork.checklistItems.any(
                      (i) => i.task.trim().isNotEmpty,
                    )) ...[
                      SizedBox(height: 16.h),
                      _sectionTitle("Scope of Work"),
                      SizedBox(height: 12.h),
                      _scopeCard(d),
                    ],
                    SizedBox(height: 16.h),
                    _sectionTitle("Performance Score"),
                    SizedBox(height: 10.h),
                    _performanceCard(d.servicePerformance),
                    SizedBox(height: 16.h),
                    _requestsHeader(d),
                    SizedBox(height: 10.h),
                    _requestsCard(d.recentRequests),
                    if (vendor.documents.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _sectionTitle("Documents"),
                      SizedBox(height: 10.h),
                      _documentsCard(vendor.documents),
                    ],
                    SizedBox(height: 24.h),
                  ],
                ),
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

  // ---------------------------------------------------------------- sections

  Widget _heroCard(Data d, String vendorName, String category) {
    final subtitle = [
      category,
      d.vendorDetails.providerType,
    ].where((s) => s.trim().isNotEmpty).join(" · ");
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _v(d.header.complexName),
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
              if (d.heroCard.badgeStatus.trim().isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34.r),
                    border: Border.all(
                      color: const Color(0xFF000000),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: const Color(0xFF000000),
                        size: 10.sp,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        d.heroCard.badgeStatus,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 17.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  _serviceIcon(d.heroCard.icon),
                  size: 18.sp,
                  color: const Color(0xFF000000),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _v(vendorName),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        height: 1.1,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: _muted,
                          height: 1.15,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 17.h),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(16, 28, 22, 0.5),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _serviceStat(
                  label: "Schedule",
                  value: _v(d.heroCard.metrics.schedule.split('•').first),
                ),
              ),
              Expanded(
                child: _serviceStat(
                  label: "Service Since",
                  value: _v(d.heroCard.metrics.serviceSince),
                ),
              ),
              Expanded(
                child: _serviceStat(
                  label: "Open Issues",
                  value: _v(d.heroCard.metrics.issues),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vendorCard(Data d, VendorDetails vendor, String vendorName) {
    final avatar = vendor.avatar.isNotEmpty
        ? vendor.avatar
        : d.assignedVendor.avatar;
    final initial = vendorName.trim().isNotEmpty
        ? vendorName.trim()[0].toUpperCase()
        : "?";
    final role = vendor.providerType.isNotEmpty
        ? vendor.providerType
        : d.assignedVendor.roleDescription;
    final contact = vendor.contactPerson.isNotEmpty
        ? (vendor.contactRole.isNotEmpty
              ? "${vendor.contactPerson} (${vendor.contactRole})"
              : vendor.contactPerson)
        : "";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.heading,
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.w,
                  ),
                ),
                child: ClipOval(
                  child: avatar.trim().isEmpty
                      ? Center(
                          child: Text(
                            initial,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Image.network(
                          avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                initial,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
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
                      _v(vendorName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (role.trim().isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        role,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: _muted,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromRGBO(16, 28, 22, 0.2),
          ),
          _contactRow(
            Icons.badge_outlined,
            "Provider ID",
            _v(vendor.providerCode),
          ),
          _contactRow(Icons.person_outline, "Contact Person", _v(contact)),
          _contactRow(
            Icons.phone_outlined,
            "Phone",
            _v(vendor.phone),
            onTap: vendor.phone.isNotEmpty
                ? () => _open(
                    "tel:${vendor.phone.replaceAll(RegExp(r'\s+'), '')}",
                  )
                : null,
          ),
          _contactRow(
            Icons.mail_outline,
            "Email",
            _v(vendor.email),
            onTap: vendor.email.isNotEmpty
                ? () => _open("mailto:${vendor.email}")
                : null,
          ),
        ],
      ),
    );
  }

  Widget _serviceInfoCard(Data d, VendorDetails vendor, String category) {
    final info = d.serviceInformation;
    final hasPlan = vendor.planLabel.isNotEmpty;
    String planTill = _v(vendor.planExpiry);
    if (hasPlan && planTill != '-') {
      if (vendor.planStatus == 'expired') planTill = "$planTill (Expired)";
      if (vendor.planStatus == 'expiring') planTill = "$planTill (Expiring)";
    }
    final items = <MapEntry<String, String>>[
      MapEntry(
        "Service Type",
        _v(category.isNotEmpty ? category : info.serviceType),
      ),
      MapEntry("Current Status", _v(info.currentStatus)),
      MapEntry(
        "Working Hours",
        _v(
          vendor.workingHours.isNotEmpty
              ? vendor.workingHours
              : info.serviceTime,
        ),
      ),
      MapEntry("Last Service", _v(info.lastService)),
      MapEntry("Plan", hasPlan ? vendor.planLabel : "No Plan"),
      if (hasPlan) MapEntry("Plan Valid Till", planTill),
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 3.2,
        children: items
            .map((e) => _infoItem(label: e.key, value: e.value))
            .toList(),
      ),
    );
  }

  Widget _scopeCard(Data d) {
    final items = d.scopeOfWork.checklistItems
        .where((i) => i.task.trim().isNotEmpty)
        .toList();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : 16.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: item.isCompleted ? _gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child: item.isCompleted
                      ? Center(
                          child: Icon(
                            Icons.check,
                            color: const Color(0xFF000000),
                            size: 18.sp,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    item.task,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      height: 1.1,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Score sirf yahin - hamesha 100 mein se. Tap karke koi alag screen nahi.
  Widget _performanceCard(ServicePerformance perf) {
    final hasScore = perf.score > 0;
    final score = perf.score.clamp(0, 100);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF101C16),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: hasScore
                    ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$score",
                              style: GoogleFonts.outfit(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: "/100",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        "Not rated yet",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
              if (hasScore && perf.currentPerformance.trim().isNotEmpty)
                Text(
                  perf.currentPerformance,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00BB5E),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            hasScore ? "Overall score out of 100" : _v(perf.headline),
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          if (hasScore) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 4.h,
                backgroundColor: const Color(0xFF919191),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF00BB5E),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _requestsHeader(Data d) {
    final open = int.tryParse(d.reportedIssues.badge.trim()) ?? 0;
    return Row(
      children: [
        Expanded(child: _sectionTitle("Service Requests")),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(184, 134, 11, 0.2),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Text(
            "$open Open",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: _gold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _requestsCard(List<RecentRequest> list) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: list.isEmpty ? 16.h : 6.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
      ),
      child: list.isEmpty
          ? Text(
              "No service requests assigned yet.",
              style: GoogleFonts.outfit(fontSize: 14.sp, color: _muted),
            )
          : Column(
              children: List.generate(list.length, (i) {
                final r = list[i];
                final meta = [
                  r.ticketNumber,
                  r.date,
                ].where((s) => s.isNotEmpty).join(" · ");
                return InkWell(
                  onTap: r.id > 0
                      ? () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ServiceRequestDetails(id: r.id.toString()),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      border: i < list.length - 1
                          ? const Border(
                              bottom: BorderSide(
                                color: Color.fromRGBO(16, 28, 22, 0.15),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                ),
                              ),
                              if (meta.isNotEmpty) ...[
                                SizedBox(height: 3.h),
                                Text(
                                  meta,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: r.isDone
                                ? const Color.fromRGBO(36, 176, 106, 0.15)
                                : const Color.fromRGBO(184, 134, 11, 0.15),
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: Text(
                            _v(r.status),
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: r.isDone ? _green : _gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }

  Widget _documentsCard(List<VendorDocument> docs) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
      ),
      child: Column(
        children: List.generate(docs.length, (i) {
          final doc = docs[i];
          return InkWell(
            onTap: () => _open(doc.url),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: i < docs.length - 1
                    ? const Border(
                        bottom: BorderSide(
                          color: Color.fromRGBO(16, 28, 22, 0.15),
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, color: _gold, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      doc.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                  Text(
                    "VIEW",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _gold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------- small widgets

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.heading,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _contactRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    final row = Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: _gold),
          SizedBox(width: 10.w),
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: _muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: onTap != null ? _gold : AppColors.heading,
                decoration: onTap != null ? TextDecoration.underline : null,
                decorationColor: _gold,
              ),
            ),
          ),
        ],
      ),
    );
    return onTap == null ? row : InkWell(onTap: onTap, child: row);
  }

  Widget _serviceStat({required String label, required String value}) {
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
            color: _muted,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value.trim(),
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
    );
  }

  Widget _infoItem({required final String label, required final String value}) {
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
            color: _muted,
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            height: 1.1,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

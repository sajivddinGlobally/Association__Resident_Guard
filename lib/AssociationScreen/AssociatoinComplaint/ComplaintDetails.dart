// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/ComplaintStatus.dart';
// import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';
// import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getComplaintDetailsResModel.dart';

// import 'Provider/getComplaintProvider.dart';
// import 'provider/getComplaintDetailsProvider.dart';

// class ComplaintDetails extends ConsumerStatefulWidget {
//   final String id;
//   const ComplaintDetails({super.key, required this.id});

//   @override
//   ConsumerState<ComplaintDetails> createState() => _ComplaintDetailsState();
// }

// class _ComplaintDetailsState extends ConsumerState<ComplaintDetails> {
//   static const List<String> statuses = [
//     'Submitted',
//     'Under Review',
//     'Assigned',
//     'In Progress',
//     'Resolved',
//     'Closed',
//   ];

//   String? selectedStatus;
//   bool _isUpdatingStatus = false;

//   String _statusToApiValue(String status) {
//     switch (status.toLowerCase()) {
//       case 'submitted':
//         return 'submitted';
//       case 'under review':
//       case 'review':
//       case 'under_review':
//         return 'under_review';
//       case 'assigned':
//         return 'assigned';
//       case 'in progress':
//       case 'in_progress':
//         return 'in_progress';
//       case 'resolved':
//         return 'resolved';
//       case 'closed':
//         return 'closed';
//       default:
//         return status.toLowerCase().replaceAll(' ', '_');
//     }
//   }

//   String _matchStatus(String? apiStatus) {
//     if (apiStatus == null || apiStatus.isEmpty) return statuses.first;
//     final lower = apiStatus.trim().toLowerCase().replaceAll('_', ' ');
//     for (final s in statuses) {
//       if (s.toLowerCase() == lower) return s;
//     }
//     if (lower.contains('review')) return 'Review';
//     if (lower.contains('assign')) return 'Assigned';
//     if (lower.contains('progress')) return 'In Progress';
//     if (lower.contains('resolve')) return 'Resolved';
//     if (lower.contains('close')) return 'Closed';
//     return 'Submitted';
//   }

//   List<StatusStepper> _getDynamicSteps(String activeStatus) {
//     final lower = activeStatus.trim().toLowerCase().replaceAll('_', ' ');

//     int activeIndex = 0;
//     if (lower.contains('review')) {
//       activeIndex = 1;
//     } else if (lower.contains('assign')) {
//       activeIndex = 2;
//     } else if (lower.contains('progress')) {
//       activeIndex = 3;
//     } else if (lower.contains('resolve') || lower.contains('close')) {
//       activeIndex = 4;
//     } else {
//       activeIndex = 0;
//     }

//     final stepNames = [
//       'Submitted',
//       'Review',
//       'Assigned',
//       'In Progress',
//       'Resolved',
//       'Closed',
//     ];

//     final bool isAllCompleted =
//         lower.contains('resolve') || lower.contains('close');

//     return List.generate(stepNames.length, (index) {
//       if (isAllCompleted) {
//         return StatusStepper(
//           name: stepNames[index],
//           isCompleted: true,
//           isCurrent: index == 4,
//         );
//       }

//       if (index < activeIndex) {
//         return StatusStepper(
//           name: stepNames[index],
//           isCompleted: true,
//           isCurrent: false,
//         );
//       } else if (index == activeIndex) {
//         return StatusStepper(
//           name: stepNames[index],
//           isCompleted: true,
//           isCurrent: true,
//         );
//       } else {
//         return StatusStepper(
//           name: stepNames[index],
//           isCompleted: false,
//           isCurrent: false,
//         );
//       }
//     });
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'submitted':
//         return const Color(0xFFFB8C00); // Orange
//       case 'review':
//       case 'under review':
//       case 'under_review':
//         return const Color(0xFF7B1FA2); // Purple
//       case 'assigned':
//         return const Color(0xFF00796B); // Teal
//       case 'in progress':
//       case 'in_progress':
//         return const Color(0xFF1E5993); // Blue
//       case 'resolved':
//         return const Color(0xFF24B06A); // Green
//       case 'closed':
//         return const Color(0xFF616161); // Grey
//       default:
//         return const Color(0xFF1E5993);
//     }
//   }

//   Color _getPriorityColor(String? priority) {
//     final p = (priority ?? '').toLowerCase();
//     if (p.contains('high') || p.contains('urgent')) {
//       return const Color(0xFFE3240F);
//     } else if (p.contains('medium')) {
//       return const Color(0xFFFB8C00);
//     } else if (p.contains('low')) {
//       return const Color(0xFF24B06A);
//     }
//     return const Color(0xFFE3240F);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final complaintStatus = ref.watch(getComplaintDetailsProvider(widget.id));
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBg,
//         automaticallyImplyLeading: false,
//         titleSpacing: 20.w,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 width: 44.w,
//                 height: 44.h,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: const Color.fromRGBO(16, 28, 22, 0.3),
//                   ),
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: const Color(0xff101C16),
//                   size: 20.sp,
//                 ),
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Complaint Details",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     "View complete complaint information",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w400,
//                       color: const Color.fromRGBO(42, 41, 51, 0.7),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: complaintStatus.when(
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
//                     padding: EdgeInsets.only(
//                       left: 14.w,
//                       top: 12.h,
//                       right: 14.w,
//                       bottom: 15.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: Colors.black, width: 1.w),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 44.w,
//                               height: 44.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 border: Border.all(
//                                   color: const Color(0xFF101C16),
//                                   width: 1.w,
//                                 ),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(7.r),
//                                 child: Image.network(
//                                   data.data.banner.thumbnail,
//                                   width: 44.w,
//                                   height: 44.h,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) {
//                                     return Container(
//                                       width: 44.w,
//                                       height: 44.h,
//                                       color: Colors.grey.shade300,
//                                       child: Icon(
//                                         Icons.image_outlined,
//                                         size: 22.sp,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data.data.banner.title,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 19.sp,
//                                       fontWeight: FontWeight.w700,
//                                       color: AppColors.heading,
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                   SizedBox(height: 2.h),
//                                   Text(
//                                     data.data.banner.ticketNumber,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color.fromRGBO(
//                                         42,
//                                         41,
//                                         51,
//                                         0.75,
//                                       ),
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10.w,
//                                 vertical: 4.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(45.r),
//                                 border: Border.all(
//                                   color: _getPriorityColor(
//                                     data.data.banner.priority,
//                                   ),
//                                   width: 1.w,
//                                 ),
//                               ),
//                               child: Text(
//                                 data.data.banner.priorityBadge.isNotEmpty
//                                     ? data.data.banner.priorityBadge
//                                     : data.data.banner.priority,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: _getPriorityColor(
//                                     data.data.banner.priority,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12.h),
//                         Divider(
//                           height: 1.h,
//                           thickness: 1.h,
//                           color: const Color.fromRGBO(16, 28, 22, 0.3),
//                         ),
//                         SizedBox(height: 12.h),
//                         Builder(
//                           builder: (context) {
//                             final apiStatus =
//                                 data.data.banner.status ??
//                                 data.data.banner.statusRaw ??
//                                 data.data.banner.statusBadge ??
//                                 data.data.complaintInformation.status;
//                             final currentActiveStatus =
//                                 selectedStatus ?? _matchStatus(apiStatus);

//                             final dynamicSteps =
//                                 (selectedStatus == null &&
//                                     data.data.banner.statusStepper.isNotEmpty)
//                                 ? data.data.banner.statusStepper
//                                 : _getDynamicSteps(currentActiveStatus);

//                             final dropdownValue =
//                                 statuses.contains(currentActiveStatus)
//                                 ? currentActiveStatus
//                                 : _matchStatus(currentActiveStatus);

//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Current Status',
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 15.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: AppColors.heading,
//                                         letterSpacing: -0.2,
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 34.h,
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 10.w,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFFFFCEB),
//                                         borderRadius: BorderRadius.circular(
//                                           6.r,
//                                         ),
//                                         border: Border.all(
//                                           color: const Color(0xFF101C16),
//                                           width: 1.w,
//                                         ),
//                                       ),
//                                       child: DropdownButtonHideUnderline(
//                                         child: DropdownButton<String>(
//                                           value: dropdownValue,
//                                           icon: Padding(
//                                             padding: EdgeInsets.only(left: 4.w),
//                                             child: _isUpdatingStatus
//                                                 ? SizedBox(
//                                                     width: 14.w,
//                                                     height: 14.w,
//                                                     child:
//                                                         const CircularProgressIndicator(
//                                                           strokeWidth: 1.8,
//                                                           color: Color(
//                                                             0xFF101C16,
//                                                           ),
//                                                         ),
//                                                   )
//                                                 : Icon(
//                                                     Icons.keyboard_arrow_down,
//                                                     size: 18.sp,
//                                                     color: const Color(
//                                                       0xFF101C16,
//                                                     ),
//                                                   ),
//                                           ),
//                                           isDense: true,
//                                           dropdownColor: const Color(
//                                             0xFFFFFCEB,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             8.r,
//                                           ),
//                                           onChanged: _isUpdatingStatus
//                                               ? null
//                                               : (String? newValue) async {
//                                                   if (newValue == null ||
//                                                       newValue ==
//                                                           dropdownValue) {
//                                                     return;
//                                                   }

//                                                   setState(() {
//                                                     _isUpdatingStatus = true;
//                                                   });

//                                                   final apiStatusValue =
//                                                       _statusToApiValue(
//                                                         newValue,
//                                                       );

//                                                   try {
//                                                     final authService = ref
//                                                         .read(
//                                                           authServiceProvider,
//                                                         );
//                                                     await authService
//                                                         .updateTicketStatus(
//                                                           id: widget.id,
//                                                           status:
//                                                               apiStatusValue,
//                                                         );

//                                                     if (mounted) {
//                                                       setState(() {
//                                                         selectedStatus =
//                                                             newValue;
//                                                         _isUpdatingStatus =
//                                                             false;
//                                                       });
//                                                       showSuccessSnackBar(
//                                                         "Status updated to $newValue",
//                                                       );
//                                                       ref.invalidate(
//                                                         getComplaintDetailsProvider(
//                                                           widget.id,
//                                                         ),
//                                                       );
//                                                       ref.invalidate(
//                                                         getComplaintProvider,
//                                                       );
//                                                     }
//                                                   } catch (e) {
//                                                     if (mounted) {
//                                                       setState(() {
//                                                         _isUpdatingStatus =
//                                                             false;
//                                                       });
//                                                       showErrorSnackBar(
//                                                         "Failed to update status. Please try again.",
//                                                       );
//                                                     }
//                                                   }
//                                                 },
//                                           items: statuses
//                                               .map<DropdownMenuItem<String>>((
//                                                 String value,
//                                               ) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: value,
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     children: [
//                                                       Container(
//                                                         width: 8.w,
//                                                         height: 8.w,
//                                                         decoration: BoxDecoration(
//                                                           shape:
//                                                               BoxShape.circle,
//                                                           color:
//                                                               _getStatusColor(
//                                                                 value,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(width: 6.w),
//                                                       Text(
//                                                         value,
//                                                         style: GoogleFonts.outfit(
//                                                           fontSize: 14.sp,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           color:
//                                                               _getStatusColor(
//                                                                 value,
//                                                               ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 );
//                                               })
//                                               .toList(),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 12.h),
//                                 ComplaintTimeline(steps: dynamicSteps),
//                               ],
//                             );
//                           },
//                         ),
//                         SizedBox(height: 4.h),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                   Text(
//                     'Complaint Information',
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14.w,
//                       vertical: 13.h,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: const Color(0xFF000000),
//                         width: 1.w,
//                       ),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Column(
//                       children: [
//                         _informationRow(
//                           icon: Icons.home_outlined,
//                           label: "Property / Unit",
//                           value: data.data.complaintInformation.propertyUnit,
//                         ),
//                         if (data.data.complaintInformation.areaTypeLabel !=
//                                 null ||
//                             data.data.complaintInformation.areaType !=
//                                 null) ...[
//                           _divider(),
//                           _informationRow(
//                             icon: Icons.domain_outlined,
//                             label: "Area Scope",
//                             value:
//                                 data.data.complaintInformation.areaTypeLabel ??
//                                 (data.data.complaintInformation.areaType ==
//                                         'common_area'
//                                     ? 'Common Area'
//                                     : 'Inside Flat'),
//                           ),
//                         ],
//                         if (data.data.complaintInformation.location != null &&
//                             data.data.complaintInformation.location!
//                                 .trim()
//                                 .isNotEmpty) ...[
//                           _divider(),
//                           _informationRow(
//                             icon: Icons.place_outlined,
//                             label: "Location",
//                             value: data.data.complaintInformation.location!,
//                           ),
//                         ],
//                         _divider(),
//                         _informationRow(
//                           icon: Icons.receipt_long_outlined,
//                           label: "Category",
//                           value: data.data.complaintInformation.category,
//                           action: "View ›",
//                           id: widget.id,
//                         ),
//                         _divider(),
//                         _informationRow(
//                           icon: Icons.person_outline,
//                           label: "Submitted By",
//                           value: data.data.complaintInformation.submittedBy,
//                         ),
//                         _divider(),
//                         _informationRow(
//                           icon: Icons.calendar_today_outlined,
//                           label: "Submitted Date",
//                           value: data.data.complaintInformation.submittedDate,
//                         ),
//                         _divider(),
//                         _informationRow(
//                           icon: Icons.flag_outlined,
//                           label: "Urgency",
//                           value: data.data.complaintInformation.urgency,
//                         ),
//                         if (data.data.complaintInformation.status != null &&
//                             data
//                                 .data
//                                 .complaintInformation
//                                 .status!
//                                 .isNotEmpty) ...[
//                           _divider(),
//                           _informationRow(
//                             icon: Icons.info_outline,
//                             label: "Status",
//                             value: data.data.complaintInformation.status!,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 18.h),
//                   Text(
//                     'Description',
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14.w,
//                       vertical: 12.h,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.heading, width: 1.w),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Text(
//                       data.data.description.content,
//                       style: GoogleFonts.outfit(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.heading,
//                         height: 1.35,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 18.h),
//                   Text(
//                     "Assigned Person",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 15.w,
//                       vertical: 14.h,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: AppColors.heading, width: 1.w),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 48.w,
//                           height: 48.w,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: AppColors.heading,
//                               width: 1.w,
//                             ),
//                           ),
//                           child: ClipOval(
//                             child:
//                                 data.data.assignedPerson.avatar != null &&
//                                     data.data.assignedPerson.avatar
//                                         .toString()
//                                         .trim()
//                                         .isNotEmpty &&
//                                     data.data.assignedPerson.avatar
//                                             .toString() !=
//                                         "null"
//                                 ? Image.network(
//                                     data.data.assignedPerson.avatar.toString(),
//                                     width: 48.w,
//                                     height: 48.w,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Icon(
//                                         Icons.person,
//                                         size: 24.sp,
//                                         color: Colors.black87,
//                                       );
//                                     },
//                                   )
//                                 : Icon(
//                                     Icons.person,
//                                     size: 24.sp,
//                                     color: Colors.black87,
//                                   ),
//                           ),
//                         ),
//                         SizedBox(width: 12.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 data.data.assignedPerson.name,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: AppColors.heading,
//                                   letterSpacing: -0.1,
//                                 ),
//                               ),
//                               SizedBox(height: 2.h),
//                               Text(
//                                 data.data.assignedPerson.subtitle,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: const Color.fromRGBO(42, 41, 52, 0.75),
//                                   letterSpacing: -0.1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 10.w),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 4.h,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50.r),
//                             border: Border.all(
//                               color: const Color(0xFF24B06A),
//                               width: 1.w,
//                             ),
//                           ),
//                           child: Text(
//                             data.data.assignedPerson.status,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.outfit(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w600,
//                               color: const Color(0xFF24B06A),
//                               letterSpacing: -0.1,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 18.h),
//                   Text(
//                     "Attachments",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _attachmentCard(
//                           icon: Icons.image_outlined,
//                           title:
//                               data.data.attachments.complaintPhoto.title ??
//                               "N/A",
//                           subtitle:
//                               data.data.attachments.complaintPhoto.action ??
//                               "N/A",
//                           imageUrl: data.data.attachments.complaintPhoto.url,
//                           onTap: () {
//                             _showAttachmentDialog(
//                               context,
//                               data.data.attachments.complaintPhoto.title ??
//                                   "N/A",
//                               data
//                                           .data
//                                           .attachments
//                                           .complaintPhoto
//                                           .url
//                                           ?.isNotEmpty ==
//                                       true
//                                   ? data.data.attachments.complaintPhoto.url!
//                                   : "No file available to preview",
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 14.w),
//                       Expanded(
//                         child: _attachmentCard(
//                           icon: Icons.description_outlined,
//                           title:
//                               data.data.attachments.supportingDocument.title ??
//                               "N/A",
//                           subtitle:
//                               data.data.attachments.supportingDocument.action ??
//                               "N/A",
//                           imageUrl:
//                               data.data.attachments.supportingDocument.url,
//                           onTap: () {
//                             _showAttachmentDialog(
//                               context,
//                               data.data.attachments.supportingDocument.title ??
//                                   "N/A",
//                               data.data.attachments.supportingDocument.url,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 18.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       vertical: 12.h,
//                       horizontal: 14.w,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: AppColors.heading, width: 1.w),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 36.w,
//                               height: 36.w,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(6.r),
//                                 border: Border.all(
//                                   color: const Color(0xFF1E5993),
//                                   width: 1.2.w,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "✓",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 18.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: const Color(0xFF1E5993),
//                                     height: 1,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 12.w),
//                             Expanded(
//                               child: Text(
//                                 data.data.currentResolutionUpdate.title,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 17.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: AppColors.heading,
//                                   letterSpacing: -0.1,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10.h),
//                         Text(
//                           data.data.currentResolutionUpdate.message,
//                           style: GoogleFonts.outfit(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.heading,
//                             height: 1.35,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 18.h),
//                   Text(
//                     "Complaint Activity",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   Column(
//                     children: [
//                       ...List.generate(data.data.complaintActivity.length, (
//                         index,
//                       ) {
//                         final activity = data.data.complaintActivity[index];

//                         return _TimelineItem(
//                           title: activity.title,
//                           date: activity.timestamp,
//                           desc: activity.note,
//                           isCompleted: activity.isCompleted,
//                           isLast:
//                               index == data.data.complaintActivity.length - 1,
//                         );
//                       }),
//                     ],
//                   ),
//                   if (data.data.actionButton.label.isNotEmpty) ...[
//                     SizedBox(height: 20.h),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52.h,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             CupertinoPageRoute(
//                               builder: (context) =>
//                                   ComplaintStatus(id: widget.id),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.heading,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(6.r),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           data.data.actionButton.label.toUpperCase(),
//                           style: GoogleFonts.outfit(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   SizedBox(height: 30.h),
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
//                 fontWeight: FontWeight.w500,
//                 color: const Color.fromRGBO(42, 41, 51, 0.75),
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

//   Widget _attachmentCard({
//     required VoidCallback onTap,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     String? imageUrl,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10.r),
//       child: Container(
//         height: 100.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(color: AppColors.heading, width: 1.w),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(6.r),
//               child: imageUrl != null && imageUrl.isNotEmpty
//                   ? Image.network(
//                       imageUrl,
//                       width: 36.w,
//                       height: 32.h,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(
//                           icon,
//                           size: 26.sp,
//                           color: AppColors.heading,
//                         );
//                       },
//                     )
//                   : Icon(icon, size: 26.sp, color: AppColors.heading),
//             ),
//             SizedBox(height: 6.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.w),
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.outfit(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.heading,
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ),
//             SizedBox(height: 3.h),
//             Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.outfit(
//                 fontSize: 13.sp,
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF1E5993),
//                 letterSpacing: -0.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _informationRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     String? action,
//     String? id,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           height: 38.h,
//           width: 38.w,
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColors.heading, width: 1.w),
//             borderRadius: BorderRadius.circular(6.r),
//           ),
//           child: Icon(icon, size: 18.sp, color: AppColors.heading),
//         ),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.outfit(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color.fromRGBO(42, 41, 51, 0.75),
//                   letterSpacing: -0.2,
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 value,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.outfit(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.heading,
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (action != null)
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => ComplaintStatus(id: id.toString()),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: EdgeInsets.only(left: 6.w),
//               child: Text(
//                 action,
//                 style: GoogleFonts.outfit(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF1E5993),
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _divider() {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: const Divider(height: 1, color: Color.fromRGBO(41, 42, 51, 0.2)),
//     );
//   }

//   void _showAttachmentDialog(
//     BuildContext context,
//     String title,
//     String? imageUrl,
//   ) {
//     if (imageUrl == null || imageUrl.isEmpty) {
//       showErrorSnackBar("No attachment available");
//       return;
//     }
//     showDialog(
//       context: context,
//       builder: (ctx) => Dialog(
//         backgroundColor: AppColors.scaffoldBg,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           side: BorderSide(color: AppColors.heading, width: 1.w),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: GoogleFonts.outfit(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.heading,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(ctx),
//                     child: Icon(
//                       Icons.close,
//                       size: 20.sp,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 14.h),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8.r),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 150.h,
//                     alignment: Alignment.center,
//                     child: Text(
//                       "No attachment available",
//                       style: GoogleFonts.outfit(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w500,
//                         color: const Color.fromRGBO(42, 41, 51, 0.75),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ComplaintTimeline extends StatelessWidget {
//   final List<dynamic> steps;

//   const ComplaintTimeline({super.key, required this.steps});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: List.generate(steps.length, (index) {
//             final step = steps[index];

//             final bool completed = step.isCompleted;
//             final bool active = step.isCurrent;

//             final bool nextReached =
//                 (index + 1 < steps.length) &&
//                 (steps[index + 1].isCompleted || steps[index + 1].isCurrent);

//             return Expanded(
//               child: Row(
//                 children: [
//                   _buildDot(completed: completed, active: active),
//                   if (index != steps.length - 1)
//                     Expanded(child: _buildLine(completed: nextReached)),
//                 ],
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 6.h),
//         Row(
//           children: List.generate(steps.length, (index) {
//             final step = steps[index];

//             return Expanded(
//               child: Text(
//                 step.name,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: _getTextAlignment(index, steps.length),
//                 style: GoogleFonts.outfit(
//                   fontSize: 12.sp,
//                   fontWeight: step.isCurrent
//                       ? FontWeight.w700
//                       : FontWeight.w500,
//                   color: step.isCurrent
//                       ? const Color(0xFF1E5993)
//                       : AppColors.heading,
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildDot({required bool completed, required bool active}) {
//     Color color;

//     if (active) {
//       color = const Color(0xFF1E5993);
//     } else if (completed) {
//       color = const Color(0xFFB8860B);
//     } else {
//       color = const Color(0xFFFFFDF0);
//     }

//     return Container(
//       width: 20.w,
//       height: 20.w,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: Border.all(
//           color: active || completed ? color : AppColors.heading,
//           width: 1.3.w,
//         ),
//       ),
//     );
//   }

//   Widget _buildLine({required bool completed}) {
//     return Container(
//       height: 1.2.h,
//       color: completed
//           ? const Color.fromRGBO(184, 134, 11, 0.7)
//           : const Color.fromRGBO(16, 28, 22, 0.3),
//     );
//   }

//   TextAlign _getTextAlignment(int index, int total) {
//     if (index == 0) {
//       return TextAlign.left;
//     }

//     if (index == total - 1) {
//       return TextAlign.right;
//     }

//     return TextAlign.center;
//   }
// }

// class _TimelineItem extends StatelessWidget {
//   final String title;
//   final String date;
//   final String desc;
//   final bool isCompleted;
//   final bool isLast;

//   const _TimelineItem({
//     required this.title,
//     required this.date,
//     required this.desc,
//     required this.isCompleted,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 26.w,
//             child: Column(
//               children: [
//                 Container(
//                   width: 26.w,
//                   height: 26.h,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isCompleted
//                         ? const Color(0xFF101C16)
//                         : const Color(0xFFFFFEF4),
//                     border: Border.all(
//                       color: const Color(0xFF101C16),
//                       width: 1.w,
//                     ),
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 10.w,
//                       height: 10.h,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: isCompleted
//                             ? const Color(0xFFFFFEF4)
//                             : const Color(0xFF101C16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (!isLast)
//                   Expanded(
//                     child: Container(
//                       width: 1.w,
//                       color: const Color.fromRGBO(16, 28, 22, 0.35),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 3.h),
//                   Text(
//                     date,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color.fromRGBO(42, 41, 51, 0.75),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     desc,
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color.fromRGBO(42, 41, 51, 0.75),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/ComplaintStatus.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getComplaintDetailsResModel.dart';

import 'Provider/getComplaintProvider.dart';
import 'provider/getComplaintDetailsProvider.dart';

class ComplaintDetails extends ConsumerStatefulWidget {
  final String id;
  const ComplaintDetails({super.key, required this.id});

  @override
  ConsumerState<ComplaintDetails> createState() => _ComplaintDetailsState();
}

class _ComplaintDetailsState extends ConsumerState<ComplaintDetails> {
  static const List<String> statuses = [
    'Submitted',
    'Under Review',
    'Assigned',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  String? selectedStatus;
  bool _isUpdatingStatus = false;

  String _statusToApiValue(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'submitted';
      case 'under review':
      case 'review':
      case 'under_review':
        return 'under_review';
      case 'assigned':
        return 'assigned';
      case 'in progress':
      case 'in_progress':
        return 'in_progress';
      case 'resolved':
        return 'resolved';
      case 'closed':
        return 'closed';
      default:
        return status.toLowerCase().replaceAll(' ', '_');
    }
  }

  String _matchStatus(String? apiStatus) {
    if (apiStatus == null || apiStatus.isEmpty) return statuses.first;
    final lower = apiStatus.trim().toLowerCase().replaceAll('_', ' ');
    for (final s in statuses) {
      if (s.toLowerCase() == lower) return s;
    }
    if (lower.contains('review')) return 'Review';
    if (lower.contains('assign')) return 'Assigned';
    if (lower.contains('progress')) return 'In Progress';
    if (lower.contains('resolve')) return 'Resolved';
    if (lower.contains('close')) return 'Closed';
    return 'Submitted';
  }

  List<StatusStepper> _getDynamicSteps(String activeStatus) {
    final lower = activeStatus.trim().toLowerCase().replaceAll('_', ' ');

    int activeIndex = 0;
    if (lower.contains('review')) {
      activeIndex = 1;
    } else if (lower.contains('assign')) {
      activeIndex = 2;
    } else if (lower.contains('progress')) {
      activeIndex = 3;
    } else if (lower.contains('resolve') || lower.contains('close')) {
      activeIndex = 4;
    } else {
      activeIndex = 0;
    }

    final stepNames = [
      'Submitted',
      'Review',
      'Assigned',
      'In Progress',
      'Resolved',
      'Closed',
    ];

    final bool isAllCompleted =
        lower.contains('resolve') || lower.contains('close');

    return List.generate(stepNames.length, (index) {
      if (isAllCompleted) {
        return StatusStepper(
          name: stepNames[index],
          isCompleted: true,
          isCurrent: index == 4,
        );
      }

      if (index < activeIndex) {
        return StatusStepper(
          name: stepNames[index],
          isCompleted: true,
          isCurrent: false,
        );
      } else if (index == activeIndex) {
        return StatusStepper(
          name: stepNames[index],
          isCompleted: true,
          isCurrent: true,
        );
      } else {
        return StatusStepper(
          name: stepNames[index],
          isCompleted: false,
          isCurrent: false,
        );
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return const Color(0xFFFB8C00); // Orange
      case 'review':
      case 'under review':
      case 'under_review':
        return const Color(0xFF7B1FA2); // Purple
      case 'assigned':
        return const Color(0xFF00796B); // Teal
      case 'in progress':
      case 'in_progress':
        return const Color(0xFF1E5993); // Blue
      case 'resolved':
        return const Color(0xFF24B06A); // Green
      case 'closed':
        return const Color(0xFF616161); // Grey
      default:
        return const Color(0xFF1E5993);
    }
  }

  Color _getPriorityColor(String? priority) {
    final p = (priority ?? '').toLowerCase();
    if (p.contains('high') || p.contains('urgent')) {
      return const Color(0xFFE3240F);
    } else if (p.contains('medium')) {
      return const Color(0xFFFB8C00);
    } else if (p.contains('low')) {
      return const Color(0xFF24B06A);
    }
    return const Color(0xFFE3240F);
  }

  @override
  Widget build(BuildContext context) {
    final complaintStatus = ref.watch(getComplaintDetailsProvider(widget.id));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
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
                    "Complaint Details",
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
                    "View complete complaint information",
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
      body: complaintStatus.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      left: 14.w,
                      top: 12.h,
                      right: 14.w,
                      bottom: 15.h,
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
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFF101C16),
                                  width: 1.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.r),
                                child: Image.network(
                                  data.data.banner.thumbnail,
                                  width: 44.w,
                                  height: 44.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 44.w,
                                      height: 44.h,
                                      color: Colors.grey.shade300,
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 22.sp,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data.banner.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    data.data.banner.ticketNumber,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.75,
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
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.r),
                                border: Border.all(
                                  color: _getPriorityColor(
                                    data.data.banner.priority,
                                  ),
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                data.data.banner.priorityBadge.isNotEmpty
                                    ? data.data.banner.priorityBadge
                                    : data.data.banner.priority,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _getPriorityColor(
                                    data.data.banner.priority,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Divider(
                          height: 1.h,
                          thickness: 1.h,
                          color: const Color.fromRGBO(16, 28, 22, 0.3),
                        ),
                        SizedBox(height: 12.h),
                        Builder(
                          builder: (context) {
                            final apiStatus =
                                data.data.banner.status ??
                                data.data.banner.statusRaw ??
                                data.data.banner.statusBadge ??
                                data.data.complaintInformation.status;
                            final currentActiveStatus =
                                selectedStatus ?? _matchStatus(apiStatus);

                            final dynamicSteps =
                                (selectedStatus == null &&
                                    data.data.banner.statusStepper.isNotEmpty)
                                ? data.data.banner.statusStepper
                                : _getDynamicSteps(currentActiveStatus);

                            final dropdownValue =
                                statuses.contains(currentActiveStatus)
                                ? currentActiveStatus
                                : _matchStatus(currentActiveStatus);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Current Status',
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    Container(
                                      height: 34.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFCEB),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFF101C16),
                                          width: 1.w,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          icon: Padding(
                                            padding: EdgeInsets.only(left: 4.w),
                                            child: _isUpdatingStatus
                                                ? SizedBox(
                                                    width: 14.w,
                                                    height: 14.w,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          strokeWidth: 1.8,
                                                          color: Color(
                                                            0xFF101C16,
                                                          ),
                                                        ),
                                                  )
                                                : Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 18.sp,
                                                    color: const Color(
                                                      0xFF101C16,
                                                    ),
                                                  ),
                                          ),
                                          isDense: true,
                                          dropdownColor: const Color(
                                            0xFFFFFCEB,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          onChanged: _isUpdatingStatus
                                              ? null
                                              : (String? newValue) async {
                                                  if (newValue == null ||
                                                      newValue ==
                                                          dropdownValue) {
                                                    return;
                                                  }

                                                  setState(() {
                                                    _isUpdatingStatus = true;
                                                  });

                                                  final apiStatusValue =
                                                      _statusToApiValue(
                                                        newValue,
                                                      );

                                                  try {
                                                    final authService = ref
                                                        .read(
                                                          authServiceProvider,
                                                        );
                                                    await authService
                                                        .updateTicketStatus(
                                                          id: widget.id,
                                                          status:
                                                              apiStatusValue,
                                                        );

                                                    if (mounted) {
                                                      setState(() {
                                                        selectedStatus =
                                                            newValue;
                                                        _isUpdatingStatus =
                                                            false;
                                                      });
                                                      showSuccessSnackBar(
                                                        "Status updated to $newValue",
                                                      );
                                                      ref.invalidate(
                                                        getComplaintDetailsProvider(
                                                          widget.id,
                                                        ),
                                                      );
                                                      ref.invalidate(
                                                        getComplaintProvider,
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      setState(() {
                                                        _isUpdatingStatus =
                                                            false;
                                                      });
                                                      showErrorSnackBar(
                                                        "Failed to update status. Please try again.",
                                                      );
                                                    }
                                                  }
                                                },
                                          items: statuses
                                              .where((s) => (s != 'Resolved' && s != 'Closed') || s == dropdownValue)
                                              .map<DropdownMenuItem<String>>((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 8.w,
                                                        height: 8.w,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              _getStatusColor(
                                                                value,
                                                              ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        value,
                                                        style: GoogleFonts.outfit(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              _getStatusColor(
                                                                value,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                ComplaintTimeline(steps: dynamicSteps),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Complaint Information',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF000000),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _informationRow(
                          icon: Icons.home_outlined,
                          label: "Property / Unit",
                          value: data.data.complaintInformation.propertyUnit,
                        ),
                        if (data.data.complaintInformation.areaTypeLabel !=
                                null ||
                            data.data.complaintInformation.areaType !=
                                null) ...[
                          _divider(),
                          _informationRow(
                            icon: Icons.domain_outlined,
                            label: "Area Scope",
                            value:
                                data.data.complaintInformation.areaTypeLabel ??
                                (data.data.complaintInformation.areaType ==
                                        'common_area'
                                    ? 'Common Area'
                                    : 'Inside Flat'),
                          ),
                        ],
                        if (data.data.complaintInformation.location != null &&
                            data.data.complaintInformation.location!
                                .trim()
                                .isNotEmpty) ...[
                          _divider(),
                          _informationRow(
                            icon: Icons.place_outlined,
                            label: "Location",
                            value: data.data.complaintInformation.location!,
                          ),
                        ],
                        _divider(),
                        _informationRow(
                          icon: Icons.receipt_long_outlined,
                          label: "Category",
                          value: data.data.complaintInformation.category,
                          action: "View ›",
                          id: widget.id,
                        ),
                        _divider(),
                        _informationRow(
                          icon: Icons.person_outline,
                          label: "Submitted By",
                          value: data.data.complaintInformation.submittedBy,
                        ),
                        _divider(),
                        _informationRow(
                          icon: Icons.calendar_today_outlined,
                          label: "Submitted Date",
                          value: data.data.complaintInformation.submittedDate,
                        ),
                        _divider(),
                        _informationRow(
                          icon: Icons.flag_outlined,
                          label: "Urgency",
                          value: data.data.complaintInformation.urgency,
                        ),
                        if (data.data.complaintInformation.status != null &&
                            data
                                .data
                                .complaintInformation
                                .status!
                                .isNotEmpty) ...[
                          _divider(),
                          _informationRow(
                            icon: Icons.info_outline,
                            label: "Status",
                            value: data.data.complaintInformation.status!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    'Description',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.w),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      data.data.description.content,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Assigned Person",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1.w,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                data.data.assignedPerson.avatar != null &&
                                    data.data.assignedPerson.avatar
                                        .toString()
                                        .trim()
                                        .isNotEmpty &&
                                    data.data.assignedPerson.avatar
                                            .toString() !=
                                        "null"
                                ? Image.network(
                                    data.data.assignedPerson.avatar.toString(),
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 24.sp,
                                        color: Colors.black87,
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 24.sp,
                                    color: Colors.black87,
                                  ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.data.assignedPerson.name,
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
                                data.data.assignedPerson.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 52, 0.75),
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: const Color(0xFF24B06A),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            data.data.assignedPerson.status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF24B06A),
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Attachments",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _attachmentCard(
                          icon: Icons.image_outlined,
                          title:
                              data.data.attachments.complaintPhoto.title ??
                              "N/A",
                          subtitle:
                              data.data.attachments.complaintPhoto.action ??
                              "N/A",
                          imageUrl: data.data.attachments.complaintPhoto.url,
                          onTap: () {
                            _showAttachmentDialog(
                              context,
                              data.data.attachments.complaintPhoto.title ??
                                  "N/A",
                              data
                                          .data
                                          .attachments
                                          .complaintPhoto
                                          .url
                                          ?.isNotEmpty ==
                                      true
                                  ? data.data.attachments.complaintPhoto.url!
                                  : "No file available to preview",
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: _attachmentCard(
                          icon: Icons.description_outlined,
                          title:
                              data.data.attachments.supportingDocument.title ??
                              "N/A",
                          subtitle:
                              data.data.attachments.supportingDocument.action ??
                              "N/A",
                          imageUrl:
                              data.data.attachments.supportingDocument.url,
                          onTap: () {
                            _showAttachmentDialog(
                              context,
                              data.data.attachments.supportingDocument.title ??
                                  "N/A",
                              data.data.attachments.supportingDocument.url,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 14.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: const Color(0xFF1E5993),
                                  width: 1.2.w,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "✓",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E5993),
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                data.data.currentResolutionUpdate.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          data.data.currentResolutionUpdate.message,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Complaint Activity",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Column(
                    children: [
                      ...List.generate(data.data.complaintActivity.length, (
                        index,
                      ) {
                        final activity = data.data.complaintActivity[index];

                        return _TimelineItem(
                          title: activity.title,
                          date: activity.timestamp,
                          desc: activity.note,
                          isCompleted: activity.isCompleted,
                          isLast:
                              index == data.data.complaintActivity.length - 1,
                        );
                      }),
                    ],
                  ),
                  if (data.data.actionButton.label.isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ComplaintStatus(id: widget.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.heading,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          data.data.actionButton.label.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
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
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(42, 41, 51, 0.75),
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

  Widget _attachmentCard({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    String? imageUrl,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.heading, width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 36.w,
                      height: 32.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          icon,
                          size: 26.sp,
                          color: AppColors.heading,
                        );
                      },
                    )
                  : Icon(icon, size: 26.sp, color: AppColors.heading),
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E5993),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String label,
    required String value,
    String? action,
    String? id,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 38.h,
          width: 38.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.heading, width: 1.w),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.heading),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ComplaintStatus(id: id.toString()),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                action,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E5993),
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: const Divider(height: 1, color: Color.fromRGBO(41, 42, 51, 0.2)),
    );
  }

  void _showAttachmentDialog(
    BuildContext context,
    String title,
    String? imageUrl,
  ) {
    if (imageUrl == null || imageUrl.isEmpty) {
      showErrorSnackBar("No attachment available");
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.scaffoldBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.heading, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: AppColors.heading,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150.h,
                    alignment: Alignment.center,
                    child: Text(
                      "No attachment available",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.75),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintTimeline extends StatelessWidget {
  final List<dynamic> steps;

  const ComplaintTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(steps.length, (index) {
            final step = steps[index];

            final bool completed = step.isCompleted;
            final bool active = step.isCurrent;

            final bool nextReached =
                (index + 1 < steps.length) &&
                (steps[index + 1].isCompleted || steps[index + 1].isCurrent);

            return Expanded(
              child: Row(
                children: [
                  _buildDot(completed: completed, active: active),
                  if (index != steps.length - 1)
                    Expanded(child: _buildLine(completed: nextReached)),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 6.h),
        Row(
          children: List.generate(steps.length, (index) {
            final step = steps[index];

            return Expanded(
              child: Text(
                step.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: _getTextAlignment(index, steps.length),
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: step.isCurrent
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: step.isCurrent
                      ? const Color(0xFF1E5993)
                      : AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDot({required bool completed, required bool active}) {
    Color color;

    if (active) {
      color = const Color(0xFF1E5993);
    } else if (completed) {
      color = const Color(0xFFB8860B);
    } else {
      color = const Color(0xFFFFFDF0);
    }

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: active || completed ? color : AppColors.heading,
          width: 1.3.w,
        ),
      ),
    );
  }

  Widget _buildLine({required bool completed}) {
    return Container(
      height: 1.2.h,
      color: completed
          ? const Color.fromRGBO(184, 134, 11, 0.7)
          : const Color.fromRGBO(16, 28, 22, 0.3),
    );
  }

  TextAlign _getTextAlignment(int index, int total) {
    if (index == 0) {
      return TextAlign.left;
    }

    if (index == total - 1) {
      return TextAlign.right;
    }

    return TextAlign.center;
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final String desc;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.desc,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26.w,
            child: Column(
              children: [
                Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFF101C16)
                        : const Color(0xFFFFFEF4),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? const Color(0xFFFFFEF4)
                            : const Color(0xFF101C16),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: const Color.fromRGBO(16, 28, 22, 0.35),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    date,
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
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                      letterSpacing: -0.2,
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
}

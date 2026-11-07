// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';
// import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

// import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';

// import '../GuardHistoryScreen/Provider/HistoryRecordsProvider.dart';

// class GuardGateParcelsScreen extends ConsumerStatefulWidget {
//   const GuardGateParcelsScreen({super.key});

//   @override
//   ConsumerState<GuardGateParcelsScreen> createState() =>
//       _GuardGateParcelsScreenState();
// }

// class _GuardGateParcelsScreenState
//     extends ConsumerState<GuardGateParcelsScreen> {
//   final TextEditingController searchController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   bool isverify = false;

//   void _showReleaseParcelDialog(dynamic parcel) {
//     otpController.clear();

//     final String company = parcel is Record
//         ? (parcel.title ?? parcel.vendorName ?? "Parcel")
//         : (parcel is Map
//               ? (parcel['company']?.toString() ?? "Parcel")
//               : "Parcel");
//     final String flatOrCategory = parcel is Record
//         ? (parcel.categoryLabel ?? "Flat")
//         : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
//     final String rawParcelId = parcel is Record
//         ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
//         : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
//     final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
//     if (numericId.isEmpty) {
//       showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
//       return;
//     }
//     final effectiveId = numericId;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (dialogContext, setDialogState) {
//             return AlertDialog(
//               backgroundColor: AppColors.scaffoldBg,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               title: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.r),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F0E9),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Icon(
//                       Icons.lock_open_rounded,
//                       color: AppColors.heading,
//                       size: 20.sp,
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: Text(
//                       "Release Parcel",
//                       style: GoogleFonts.outfit(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Verify resident's 4-digit pickup code or scan QR to release parcel for $flatOrCategory.",
//                     style: GoogleFonts.outfit(
//                       fontSize: 13.sp,
//                       color: const Color(0xFF666666),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   Container(
//                     padding: EdgeInsets.all(12.w),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFBF9F4),
//                       borderRadius: BorderRadius.circular(10.r),
//                       border: Border.all(color: const Color(0xFFE5E0D5)),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           company,
//                           style: GoogleFonts.outfit(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.heading,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Enter 4-Digit Pickup OTP",
//                     style: GoogleFonts.outfit(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                   SizedBox(height: 6.h),
//                   TextField(
//                     controller: otpController,
//                     keyboardType: TextInputType.number,
//                     maxLength: 4,
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.outfit(
//                       fontSize: 22.sp,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 8,
//                       color: AppColors.heading,
//                     ),
//                     decoration: InputDecoration(
//                       counterText: "",
//                       hintText: "••••",
//                       hintStyle: GoogleFonts.outfit(
//                         fontSize: 22.sp,
//                         color: Colors.grey,
//                         letterSpacing: 8,
//                       ),
//                       contentPadding: EdgeInsets.symmetric(vertical: 10.h),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(
//                           color: AppColors.heading,
//                           width: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: isverify
//                       ? null
//                       : () => Navigator.pop(dialogContext),
//                   child: Text(
//                     "Cancel",
//                     style: GoogleFonts.outfit(
//                       color: const Color(0xFF666666),
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.heading,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                   onPressed: isverify
//                       ? null
//                       : () async {
//                           final otp = otpController.text.trim();
//                           if (otp.length != 4) {
//                             showErrorSnackBar(
//                               "Please enter the resident's 4-digit pickup code.",
//                             );
//                             return;
//                           }
//                           setDialogState(() {
//                             isverify = true;
//                           });
//                           try {
//                             final res = await ref
//                                 .read(authServiceProvider)
//                                 .verifyParcelHandoverData(
//                                   id: effectiveId,
//                                   pickupCode: otp,
//                                 );
//                             if (res.status == true) {
//                               ref.invalidate(historyRecordsProvider("parcel"));
//                               showSuccessSnackBar(
//                                 res.message ?? "Parcel released successfully.",
//                               );
//                               if (dialogContext.mounted) {
//                                 Navigator.pop(dialogContext);
//                               }
//                             } else {
//                               otpController.clear();
//                               showErrorSnackBar(
//                                 res.message ??
//                                     "Incorrect pickup code. Please try again.",
//                               );
//                             }
//                           } catch (e) {
//                             log(e.toString());
//                             otpController.clear();
//                           } finally {
//                             if (dialogContext.mounted) {
//                               setDialogState(() {
//                                 isverify = false;
//                               });
//                             }
//                           }
//                         },
//                   child: isverify
//                       ? Center(
//                           child: SizedBox(
//                             width: 20.w,
//                             height: 20.h,
//                             child: const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           "Verify & Hand Over",
//                           style: GoogleFonts.outfit(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showMarkExitDialog(dynamic parcel) {
//     final String company = parcel is Record
//         ? (parcel.title ?? parcel.vendorName ?? "Parcel Delivery")
//         : (parcel is Map
//               ? (parcel['company']?.toString() ?? "Parcel Delivery")
//               : "Parcel Delivery");
//     final String flatOrCategory = parcel is Record
//         ? (parcel.categoryLabel ?? "Flat")
//         : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
//     final String rawParcelId = parcel is Record
//         ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
//         : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
//     final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
//     if (numericId.isEmpty) {
//       showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
//       return;
//     }
//     final effectiveId = numericId;

//     bool isExiting = false;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (dialogContext, setDialogState) {
//             return AlertDialog(
//               backgroundColor: AppColors.scaffoldBg,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               title: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(8.r),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF3F0E9),
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Icon(
//                       Icons.logout_rounded,
//                       color: AppColors.heading,
//                       size: 20.sp,
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: Text(
//                       "Mark Delivery Exit",
//                       style: GoogleFonts.outfit(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Delivery agent for $company has finished delivery at $flatOrCategory. Confirm mark exit?",
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       color: const Color(0xFF555555),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: isExiting
//                       ? null
//                       : () => Navigator.pop(dialogContext),
//                   child: Text(
//                     "Cancel",
//                     style: GoogleFonts.outfit(
//                       color: const Color(0xFF666666),
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.heading,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                   onPressed: isExiting
//                       ? null
//                       : () async {
//                           setDialogState(() {
//                             isExiting = true;
//                           });

//                           try {
//                             final res = await ref
//                                 .read(authServiceProvider)
//                                 .parcelHandoverData(effectiveId);
//                             ref.invalidate(historyRecordsProvider("parcel"));
//                             if (res.status == true) {
//                               showSuccessSnackBar(
//                                 res.message ?? "Delivery exit marked.",
//                               );
//                               if (dialogContext.mounted) {
//                                 Navigator.pop(dialogContext);
//                               }
//                             } else {
//                               showErrorSnackBar(
//                                 res.message ?? "Could not mark delivery exit.",
//                               );
//                             }
//                           } catch (e) {
//                             // Server ka asli error Dio interceptor already dikha deta hai.
//                             log(e.toString());
//                           } finally {
//                             if (dialogContext.mounted) {
//                               setDialogState(() {
//                                 isExiting = false;
//                               });
//                             }
//                           }
//                         },
//                   child: isExiting
//                       ? Center(
//                           child: SizedBox(
//                             width: 20.w,
//                             height: 20.h,
//                             child: const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         )
//                       : Text(
//                           "Confirm Exit",
//                           style: GoogleFonts.outfit(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final historyRecords = ref.watch(historyRecordsProvider("parcel"));

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
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 41.w,
//                   height: 41.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: const Color.fromRGBO(16, 28, 22, 0.3),
//                     ),
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: const Color(0xff101C16),
//                     size: 16.sp,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Gate Held Parcels",
//                     style: GoogleFonts.outfit(
//                       fontSize: 19.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     "Leave-at-gate locker & pickup verification",
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color.fromRGBO(42, 41, 51, 0.65),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: historyRecords.when(
//         data: (data) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 18.h),
//                   ListView.builder(
//                     itemCount: data.data?.records?.length ?? 0,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final parcel = data.data?.records?[index];
//                       final badgeUpper = (parcel?.badge ?? "")
//                           .toUpperCase()
//                           .trim();
//                       final handoverLower = (parcel?.handoverTime ?? "")
//                           .toLowerCase()
//                           .trim();

//                       // Status Checks:
//                       final isAtGate =
//                           handoverLower == "left at gate" ||
//                           badgeUpper == "GATE";
//                       final isPending =
//                           badgeUpper == "PENDING" || handoverLower == "--";

//                       // Badge styling
//                       String badgeText = "DELIVERED";
//                       Color badgeBg = const Color(0xFFD4F5E1);
//                       Color badgeColor = const Color(0xFF16A765);

//                       if (isAtGate) {
//                         badgeText = "AT GATE";
//                         badgeBg = const Color(0xFFFFF4D1);
//                         badgeColor = const Color(0xFFB8860B);
//                       } else if (isPending) {
//                         badgeText = "PENDING";
//                         badgeBg = const Color(0xFFFEF3C7);
//                         badgeColor = const Color(0xFFD97706);
//                       } else {
//                         badgeText = parcel?.badge ?? "DELIVERED";
//                         badgeBg = const Color(0xFFD4F5E1);
//                         badgeColor = const Color(0xFF16A765);
//                       }

//                       return Container(
//                         margin: EdgeInsets.only(bottom: 14.h),
//                         padding: EdgeInsets.all(14.w),
//                         decoration: BoxDecoration(
//                           color: AppColors.scaffoldBg,
//                           borderRadius: BorderRadius.circular(14.r),
//                           border: Border.all(
//                             color: const Color(0xff101C16),
//                             width: 1.w,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(10.w),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFF3F0E9),
//                                     borderRadius: BorderRadius.circular(10.r),
//                                   ),
//                                   child: Icon(
//                                     Icons.inventory_2_outlined,
//                                     color: AppColors.heading,
//                                     size: 22.sp,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             parcel?.title ?? "N/A",
//                                             style: GoogleFonts.outfit(
//                                               fontSize: 16.sp,
//                                               fontWeight: FontWeight.w600,
//                                               color: AppColors.heading,
//                                             ),
//                                           ),
//                                           SizedBox(width: 6.w),
//                                         ],
//                                       ),
//                                       SizedBox(height: 2.h),
//                                       Text(
//                                         parcel?.categoryLabel ?? "N/A",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 13.sp,
//                                           color: const Color(0xFF666666),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w,
//                                     vertical: 4.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: badgeBg,
//                                     borderRadius: BorderRadius.circular(20.r),
//                                   ),
//                                   child: Text(
//                                     badgeText,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 11.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: badgeColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 12.h),
//                             const Divider(height: 1, color: Color(0xFFEEEEEE)),
//                             SizedBox(height: 10.h),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "In-Time: ${parcel?.receivedTime ?? "N/A"}",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 13.sp,
//                                     color: const Color(0xFF777777),
//                                   ),
//                                 ),
//                                 if (isAtGate)
//                                   SizedBox(
//                                     height: 34.h,
//                                     child: ElevatedButton.icon(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: AppColors.heading,
//                                         foregroundColor: Colors.white,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 14.w,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             6.r,
//                                           ),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         _showReleaseParcelDialog(parcel);
//                                       },
//                                       icon: Icon(Icons.qr_code_2, size: 16.sp),
//                                       label: Text(
//                                         "Verify & Release",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 13.sp,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 else if (isPending)
//                                   SizedBox(
//                                     height: 34.h,
//                                     child: ElevatedButton.icon(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: const Color(
//                                           0xFF0D1C16,
//                                         ),
//                                         foregroundColor: Colors.white,
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 14.w,
//                                         ),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             6.r,
//                                           ),
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         _showMarkExitDialog(parcel);
//                                       },
//                                       icon: Icon(
//                                         Icons.logout_rounded,
//                                         size: 15.sp,
//                                       ),
//                                       label: Text(
//                                         parcel?.actionButton?.label ??
//                                             "Mark Exit",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 13.sp,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 else
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.check_circle_outline_rounded,
//                                         size: 14.sp,
//                                         color: const Color(0xFF16A765),
//                                       ),
//                                       SizedBox(width: 4.w),
//                                       Text(
//                                         "Handed Over: ${parcel?.handoverTime ?? "N/A"}",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 13.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: const Color(0xFF16A765),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 24.h),
//                 ],
//               ),
//             ),
//           );
//         },
//         error: (error, stackTrace) {
//           return Center(
//             child: Column(
//               children: [
//                 Text(
//                   "Failed to Load Parcels",
//                   style: GoogleFonts.outfit(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.heading,
//                   ),
//                 ),
//                 Text(
//                   "Please try again later",
//                   style: GoogleFonts.outfit(
//                     fontSize: 14.sp,
//                     color: AppColors.heading,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     ref.invalidate(historyRecordsProvider("parcel"));
//                   },
//                   child: Text("Refresh"),
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () {
//           return Center(
//             child: CircularProgressIndicator(color: AppColors.heading),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';

import '../GuardHistoryScreen/Provider/HistoryRecordsProvider.dart';

class GuardGateParcelsScreen extends ConsumerStatefulWidget {
  const GuardGateParcelsScreen({super.key});

  @override
  ConsumerState<GuardGateParcelsScreen> createState() =>
      _GuardGateParcelsScreenState();
}

class _GuardGateParcelsScreenState
    extends ConsumerState<GuardGateParcelsScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isverify = false;

  void _showReleaseParcelDialog(dynamic parcel) {
    otpController.clear();

    final String company = parcel is Record
        ? (parcel.title ?? parcel.vendorName ?? "Parcel")
        : (parcel is Map
              ? (parcel['company']?.toString() ?? "Parcel")
              : "Parcel");
    final String flatOrCategory = parcel is Record
        ? (parcel.categoryLabel ?? "Flat")
        : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
    final String rawParcelId = parcel is Record
        ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
        : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
    final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericId.isEmpty) {
      showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
      return;
    }
    final effectiveId = numericId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: AppColors.heading,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Release Parcel",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify resident's 4-digit pickup code or scan QR to release parcel for $flatOrCategory.",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F4),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFE5E0D5)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          company,
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Enter 4-Digit Pickup OTP",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8,
                      color: AppColors.heading,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "••••",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        color: Colors.grey,
                        letterSpacing: 8,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.heading,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isverify
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF666666),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isverify
                      ? null
                      : () async {
                          final otp = otpController.text.trim();
                          if (otp.length != 4) {
                            showErrorSnackBar(
                              "Please enter the resident's 4-digit pickup code.",
                            );
                            return;
                          }
                          setDialogState(() {
                            isverify = true;
                          });
                          try {
                            final res = await ref
                                .read(authServiceProvider)
                                .verifyParcelHandoverData(
                                  id: effectiveId,
                                  pickupCode: otp,
                                );
                            if (res.status == true) {
                              ref.invalidate(historyRecordsProvider("parcel"));
                              showSuccessSnackBar(
                                res.message ?? "Parcel released successfully.",
                              );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            } else {
                              otpController.clear();
                              showErrorSnackBar(
                                res.message ??
                                    "Incorrect pickup code. Please try again.",
                              );
                            }
                          } catch (e) {
                            log(e.toString());
                            otpController.clear();
                          } finally {
                            if (dialogContext.mounted) {
                              setDialogState(() {
                                isverify = false;
                              });
                            }
                          }
                        },
                  child: isverify
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          "Verify & Hand Over",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMarkExitDialog(dynamic parcel) {
    final String company = parcel is Record
        ? (parcel.title ?? parcel.vendorName ?? "Parcel Delivery")
        : (parcel is Map
              ? (parcel['company']?.toString() ?? "Parcel Delivery")
              : "Parcel Delivery");
    final String flatOrCategory = parcel is Record
        ? (parcel.categoryLabel ?? "Flat")
        : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
    final String rawParcelId = parcel is Record
        ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
        : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
    final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericId.isEmpty) {
      showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
      return;
    }
    final effectiveId = numericId;

    bool isExiting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: AppColors.heading,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Mark Delivery Exit",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery agent for $company has finished delivery at $flatOrCategory. Confirm mark exit?",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isExiting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF666666),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isExiting
                      ? null
                      : () async {
                          setDialogState(() {
                            isExiting = true;
                          });

                          try {
                            final res = await ref
                                .read(authServiceProvider)
                                .parcelHandoverData(effectiveId);
                            ref.invalidate(historyRecordsProvider("parcel"));
                            if (res.status == true) {
                              showSuccessSnackBar(
                                res.message ?? "Delivery exit marked.",
                              );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            } else {
                              showErrorSnackBar(
                                res.message ?? "Could not mark delivery exit.",
                              );
                            }
                          } catch (e) {
                            // Server ka asli error Dio interceptor already dikha deta hai.
                            log(e.toString());
                          } finally {
                            if (dialogContext.mounted) {
                              setDialogState(() {
                                isExiting = false;
                              });
                            }
                          }
                        },
                  child: isExiting
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          "Confirm Exit",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyRecords = ref.watch(historyRecordsProvider("parcel"));

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
                onTap: () => Navigator.pop(context),
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
                    "Gate Held Parcels",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Leave-at-gate locker & pickup verification",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
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
      body: historyRecords.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18.h),
                  ListView.builder(
                    itemCount: data.data?.records?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final parcel = data.data?.records?[index];
                      final badgeUpper = (parcel?.badge ?? "")
                          .toUpperCase()
                          .trim();
                      final handoverLower = (parcel?.handoverTime ?? "")
                          .toLowerCase()
                          .trim();

                      // Status Checks:
                      final isAtGate =
                          handoverLower == "left at gate" ||
                          badgeUpper == "GATE";
                      final isPending =
                          badgeUpper == "PENDING" || handoverLower == "--";

                      // Badge styling
                      String badgeText = "DELIVERED";
                      Color badgeBg = const Color(0xFFD4F5E1);
                      Color badgeColor = const Color(0xFF16A765);

                      if (badgeUpper == "HOME DELIVERY") {
                        badgeText = "TAKE TO FLAT";
                        badgeBg = const Color(0xFFDBEAFE);
                        badgeColor = const Color(0xFF2563EB);
                      } else if (badgeUpper == "REJECTED") {
                        badgeText = "REJECTED";
                        badgeBg = const Color(0xFFFEE2E2);
                        badgeColor = const Color(0xFFDC2626);
                      } else if (isAtGate) {
                        badgeText = "AT GATE";
                        badgeBg = const Color(0xFFFFF4D1);
                        badgeColor = const Color(0xFFB8860B);
                      } else if (isPending) {
                        badgeText = "PENDING";
                        badgeBg = const Color(0xFFFEF3C7);
                        badgeColor = const Color(0xFFD97706);
                      } else {
                        badgeText = parcel?.badge ?? "DELIVERED";
                        badgeBg = const Color(0xFFD4F5E1);
                        badgeColor = const Color(0xFF16A765);
                      }

                      return Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F0E9),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    color: AppColors.heading,
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            parcel?.title ?? "N/A",
                                            style: GoogleFonts.outfit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.heading,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        parcel?.categoryLabel ?? "N/A",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          color: const Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    badgeText,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: badgeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),
                            const Divider(height: 1, color: Color(0xFFEEEEEE)),
                            SizedBox(height: 10.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "In-Time: ${parcel?.receivedTime ?? "N/A"}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                                if (isAtGate)
                                  SizedBox(
                                    height: 34.h,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.heading,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showReleaseParcelDialog(parcel);
                                      },
                                      icon: Icon(Icons.qr_code_2, size: 16.sp),
                                      label: Text(
                                        "Verify & Release",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                else if (isPending)
                                  SizedBox(
                                    height: 34.h,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0D1C16,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showMarkExitDialog(parcel);
                                      },
                                      icon: Icon(
                                        Icons.logout_rounded,
                                        size: 15.sp,
                                      ),
                                      label: Text(
                                        parcel?.actionButton?.label ??
                                            "Mark Exit",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 14.sp,
                                        color: const Color(0xFF16A765),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Handed Over: ${parcel?.handoverTime ?? "N/A"}",
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF16A765),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              children: [
                Text(
                  "Failed to Load Parcels",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                Text(
                  "Please try again later",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: AppColors.heading,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(historyRecordsProvider("parcel"));
                  },
                  child: Text("Refresh"),
                ),
              ],
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }
}

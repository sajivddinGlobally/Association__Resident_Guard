// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';
// import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
// import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/GuaredHistoryScreen.dart';
// import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardParcelScreen/GuardGateParcelsScreen.dart';
// import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/Provider/getFlatApartmentProvider.dart';
// import 'package:property_association_or_resident/GuardScreen/Model/getFlatApartmentModel.dart';

// class Guardparcelregisterscreen extends ConsumerStatefulWidget {
//   const Guardparcelregisterscreen({super.key});

//   @override
//   ConsumerState<Guardparcelregisterscreen> createState() =>
//       _GuardparcelregisterscreenState();
// }

// class _GuardparcelregisterscreenState
//     extends ConsumerState<Guardparcelregisterscreen> {
//   final TextEditingController vendorNameController = TextEditingController();
//   final TextEditingController trackingNumberController =
//       TextEditingController();
//   final TextEditingController flatNumberController = TextEditingController();
//   final FocusNode flatFocusNode = FocusNode();
//   final GlobalKey _autocompleteKey = GlobalKey();
//   Datum? selectedFlat;
//   bool isSubmitting = false;

//   String? selectedVisitType;
//   int selectedOption = 0;
//   File? visitorPhoto;
//   late String entryTime;

//   @override
//   void initState() {
//     super.initState();
//     entryTime = _formatCurrentTime();
//   }

//   @override
//   void dispose() {
//     vendorNameController.dispose();
//     trackingNumberController.dispose();
//     flatNumberController.dispose();
//     flatFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> pickVisitorPhoto() async {
//     final ImagePicker picker = ImagePicker();

//     final ImageSource? source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       backgroundColor: AppColors.scaffoldBg,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 12.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Select Photo",
//                   style: GoogleFonts.outfit(
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.heading,
//                   ),
//                 ),

//                 SizedBox(height: 8.h),

//                 ListTile(
//                   leading: Icon(
//                     Icons.camera_alt_outlined,
//                     color: AppColors.heading,
//                     size: 25.sp,
//                   ),
//                   title: Text(
//                     "Camera",
//                     style: GoogleFonts.outfit(
//                       fontSize: 16.sp,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context, ImageSource.camera);
//                   },
//                 ),

//                 ListTile(
//                   leading: Icon(
//                     Icons.photo_library_outlined,
//                     color: AppColors.heading,
//                     size: 25.sp,
//                   ),
//                   title: Text(
//                     "Gallery",
//                     style: GoogleFonts.outfit(
//                       fontSize: 16.sp,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context, ImageSource.gallery);
//                   },
//                 ),

//                 SizedBox(height: 8.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     if (source == null) return;

//     final XFile? pickedFile = await picker.pickImage(
//       source: source,
//       imageQuality: 80,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         visitorPhoto = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _submitParcel() async {
//     if (visitorPhoto == null) {
//       showErrorSnackBar("Please capture or select parcel photo");
//       return;
//     }

//     final vendorName = vendorNameController.text.trim();
//     if (vendorName.isEmpty) {
//       showErrorSnackBar("Please enter vendor name");
//       return;
//     }

//     final flatNumber = flatNumberController.text.trim();
//     if (flatNumber.isEmpty) {
//       showErrorSnackBar("Please select a flat number");
//       return;
//     }

//     setState(() {
//       isSubmitting = true;
//     });

//     try {
//       final authService = ref.read(authServiceProvider);
//       final res = await authService.addParcelData(
//         vendorName: vendorName,
//         flatNumber: flatNumber,
//         parcelType: selectedVisitType ?? "Box",
//         trackingNumber: trackingNumberController.text.trim(),
//         handlingType: selectedOption == 0 ? "ask_resident" : "leave_at_gate",
//         parcelPhoto: visitorPhoto!,
//       );
//       if (!mounted) return;
//       if (res.status != true) {
//         showErrorSnackBar(res.message ?? "Could not register the parcel.");
//         return;
//       }
//       showSuccessSnackBar(res.message ?? "Parcel registered.");
//       Navigator.pushReplacement(
//         context,
//         CupertinoPageRoute(
//           builder: (context) => Guaredhistoryscreen(isBackButtonShow: true),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       // showErrorSnackBar(e.toString());
//       log(e.toString());
//     } finally {
//       if (mounted) {
//         setState(() {
//           isSubmitting = false;
//         });
//       }
//     }
//   }

//   String _formatCurrentTime() {
//     final now = DateTime.now();
//     final hour = now.hour == 0
//         ? 12
//         : (now.hour > 12 ? now.hour - 12 : now.hour);
//     final minute = now.minute.toString().padLeft(2, '0');
//     final period = now.hour >= 12 ? "PM" : "AM";
//     return "$hour:$minute $period";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final getFlatApartmentState = ref.watch(getFlatApartmentProvider);
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
//               SizedBox(width: 20.w),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Parcel Registration",
//                       style: GoogleFonts.outfit(
//                         fontSize: 19.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       "Register incoming parcel for resident approval",
//                       style: GoogleFonts.outfit(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: const Color.fromRGBO(42, 41, 51, 0.65),
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 16.w),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   CupertinoPageRoute(
//                     builder: (context) => const GuardGateParcelsScreen(),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFFDF0),
//                   borderRadius: BorderRadius.circular(8.r),
//                   border: Border.all(color: const Color(0xFFE8B900)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.inventory_2_outlined,
//                       size: 16.sp,
//                       color: AppColors.heading,
//                     ),
//                     SizedBox(width: 4.w),
//                     Text(
//                       "Gate Parcels",
//                       style: GoogleFonts.outfit(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             children: [
//               SizedBox(height: 16.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.scaffoldBg,
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(
//                     color: const Color(0xff101C16),
//                     width: 1.w,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Parcel Photo",
//                       style: GoogleFonts.outfit(
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.3,
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     GestureDetector(
//                       onTap: () {
//                         pickVisitorPhoto();
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 110.h,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF1F1F1),
//                           borderRadius: BorderRadius.circular(16.r),
//                           border: Border.all(
//                             color: AppColors.heading,
//                             style: BorderStyle.solid,
//                           ),
//                         ),
//                         child: visitorPhoto != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(16.r),
//                                 child: Image.file(
//                                   visitorPhoto!,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt_outlined,
//                                     size: 48.sp,
//                                     color: Colors.black,
//                                   ),
//                                   SizedBox(height: 8.h),
//                                   Text(
//                                     'Take Parcel Photo',
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 17.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.heading,
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),

//                                   SizedBox(height: 2.h),
//                                   Text(
//                                     'Capture clear photo of the parcel',
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: const Color(0xFF666666),
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.scaffoldBg,
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: const Color(0xff101C16),
//                     width: 1.w,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Parcel Details",
//                       style: GoogleFonts.outfit(
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     Text(
//                       "Vendor Name *",
//                       style: GoogleFonts.outfit(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                     SizedBox(height: 10.h),
//                     _textField(
//                       controller: vendorNameController,
//                       hintText: "e.g. Amazon, Flipkart, DHL",
//                       keyboardType: TextInputType.name,
//                     ),
//                     SizedBox(height: 16.h),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Parcel Type',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                 ),
//                               ),
//                               SizedBox(height: 8.h),

//                               Container(
//                                 height: 46.h,
//                                 decoration: BoxDecoration(
//                                   color: AppColors.scaffoldBg,
//                                   borderRadius: BorderRadius.circular(4.r),
//                                   border: Border.all(
//                                     color: const Color(0xff101C16),
//                                     width: 1.w,
//                                   ),
//                                 ),
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButton<String>(
//                                     value: selectedVisitType,
//                                     isExpanded: true,

//                                     hint: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 11,
//                                       ),
//                                       child: Text(
//                                         'Select Type',
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 13.sp,
//                                           color: const Color(0xff888891),
//                                         ),
//                                       ),
//                                     ),

//                                     icon: const Padding(
//                                       padding: EdgeInsets.only(right: 8),
//                                       child: Icon(
//                                         Icons.keyboard_arrow_down_rounded,
//                                         size: 22,
//                                         color: Color(0xff77777F),
//                                       ),
//                                     ),

//                                     items:
//                                         [
//                                           'Box',
//                                           'Small Box',
//                                           'Large Box / Carton',
//                                           'Packet / Bag',
//                                           'Envelope / Document',
//                                           'Food / Grocery',
//                                           'Fragile / Electronics',
//                                           'Other',
//                                         ].map((String type) {
//                                           return DropdownMenuItem<String>(
//                                             value: type,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 11,
//                                                   ),
//                                               child: Text(
//                                                 type,
//                                                 style: GoogleFonts.outfit(
//                                                   fontSize: 13.sp,
//                                                   color: const Color(
//                                                     0xff222222,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),

//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedVisitType = value;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Tracking / Reference',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 13.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                 ),
//                               ),

//                               const SizedBox(height: 8),

//                               SizedBox(
//                                 height: 46.h,
//                                 child: _textField(
//                                   controller: trackingNumberController,
//                                   hintText: "Optional",
//                                   keyboardType: TextInputType.name,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.scaffoldBg,
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: const Color(0xff101C16),
//                     width: 1.w,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Flat Number *",
//                       style: GoogleFonts.outfit(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                     SizedBox(height: 10.h),

//                     // RawAutocomplete for Flat / Apartment with dynamic suggestions
//                     RawAutocomplete<Datum>(
//                       textEditingController: flatNumberController,
//                       focusNode: flatFocusNode,
//                       optionsBuilder: (TextEditingValue textEditingValue) {
//                         final allFlats =
//                             getFlatApartmentState.value?.data ??
//                             getFlatApartmentState.value?.properties ??
//                             [];
//                         if (textEditingValue.text.isEmpty) {
//                           return allFlats;
//                         }
//                         final q = textEditingValue.text.trim().toLowerCase();
//                         return allFlats.where((flat) {
//                           final fNo =
//                               (flat.flatNumber ?? flat.propertyNameNumber ?? '')
//                                   .toLowerCase();
//                           final res = (flat.residentName ?? '').toLowerCase();
//                           final ph = (flat.residentPhone ?? '').toLowerCase();
//                           final loc = (flat.location ?? '').toLowerCase();
//                           return fNo.contains(q) ||
//                               res.contains(q) ||
//                               ph.contains(q) ||
//                               loc.contains(q);
//                         });
//                       },
//                       displayStringForOption: (Datum option) =>
//                           option.flatNumber ?? option.propertyNameNumber ?? '',
//                       fieldViewBuilder:
//                           (
//                             BuildContext context,
//                             TextEditingController controller,
//                             FocusNode focusNode,
//                             VoidCallback onFieldSubmitted,
//                           ) {
//                             return TextField(
//                               key: _autocompleteKey,
//                               controller: controller,
//                               focusNode: focusNode,
//                               onSubmitted: (_) => onFieldSubmitted(),
//                               style: GoogleFonts.outfit(
//                                 fontSize: 16.sp,
//                                 color: AppColors.heading,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: "Enter flat no. or resident name...",
//                                 hintStyle: GoogleFonts.outfit(
//                                   fontSize: 14.sp,
//                                   color: const Color(0xff888891),
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.apartment_rounded,
//                                   size: 20.sp,
//                                   color: controller.text.isNotEmpty
//                                       ? AppColors.heading
//                                       : const Color(0xff888891),
//                                 ),
//                                 suffixIcon: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     if (controller.text.isNotEmpty)
//                                       GestureDetector(
//                                         onTap: () {
//                                           controller.clear();
//                                           setState(() {
//                                             selectedFlat = null;
//                                           });
//                                         },
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: 4.w,
//                                           ),
//                                           child: Icon(
//                                             Icons.cancel_rounded,
//                                             size: 20.sp,
//                                             color: const Color(0xFF9CA3AF),
//                                           ),
//                                         ),
//                                       ),
//                                     Padding(
//                                       padding: EdgeInsets.only(right: 8.w),
//                                       child: Container(
//                                         height: 32.h,
//                                         width: 32.w,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             6.r,
//                                           ),
//                                           color: const Color(0xFFF3F4F6),
//                                         ),
//                                         child: Center(
//                                           child: Icon(
//                                             Icons.search,
//                                             color: AppColors.heading,
//                                             size: 18.sp,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 12.w,
//                                   vertical: 12.h,
//                                 ),
//                                 filled: true,
//                                 fillColor: AppColors.scaffoldBg,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   borderSide: BorderSide(
//                                     color: controller.text.isNotEmpty
//                                         ? AppColors.heading
//                                         : const Color(0xff101C16),
//                                     width: 1.w,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   borderSide: const BorderSide(
//                                     color: AppColors.heading,
//                                     width: 1.2,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                       optionsViewBuilder:
//                           (
//                             BuildContext context,
//                             AutocompleteOnSelected<Datum> onSelected,
//                             Iterable<Datum> options,
//                           ) {
//                             final renderBox =
//                                 _autocompleteKey.currentContext
//                                         ?.findRenderObject()
//                                     as RenderBox?;
//                             final fieldWidth =
//                                 renderBox?.size.width ??
//                                 (MediaQuery.of(context).size.width - 72.w);

//                             return Align(
//                               alignment: Alignment.topLeft,
//                               child: Material(
//                                 elevation: 6.0,
//                                 shadowColor: Colors.black26,
//                                 borderRadius: BorderRadius.circular(12.r),
//                                 color: AppColors.scaffoldBg,
//                                 child: Container(
//                                   width: fieldWidth,
//                                   constraints: BoxConstraints(maxHeight: 260.h),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.scaffoldBg,
//                                     borderRadius: BorderRadius.circular(12.r),
//                                     border: Border.all(
//                                       color: const Color(0xff101C16),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   child: options.isEmpty
//                                       ? Padding(
//                                           padding: EdgeInsets.symmetric(
//                                             vertical: 16.h,
//                                             horizontal: 14.w,
//                                           ),
//                                           child: Text(
//                                             "No matching flat or resident found",
//                                             style: GoogleFonts.outfit(
//                                               fontSize: 13.sp,
//                                               color: const Color(0xFF6B7280),
//                                             ),
//                                           ),
//                                         )
//                                       : ListView.separated(
//                                           padding: EdgeInsets.symmetric(
//                                             vertical: 4.h,
//                                           ),
//                                           shrinkWrap: true,
//                                           itemCount: options.length,
//                                           separatorBuilder: (_, __) =>
//                                               const Divider(
//                                                 height: 1,
//                                                 color: Color(0xFFF3F4F6),
//                                               ),
//                                           itemBuilder: (BuildContext context, int index) {
//                                             final Datum flat = options
//                                                 .elementAt(index);
//                                             final flatNumber =
//                                                 flat.flatNumber ??
//                                                 flat.propertyNameNumber ??
//                                                 'Flat';
//                                             final residentName =
//                                                 (flat.residentName != null &&
//                                                     flat.residentName!
//                                                         .trim()
//                                                         .isNotEmpty)
//                                                 ? flat.residentName!
//                                                 : 'Vacant / Unassigned';
//                                             final isSelected =
//                                                 selectedFlat?.id != null
//                                                 ? selectedFlat?.id == flat.id
//                                                 : flatNumberController.text ==
//                                                       flatNumber;

//                                             return InkWell(
//                                               onTap: () {
//                                                 onSelected(flat);
//                                               },
//                                               child: Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 12.w,
//                                                   vertical: 10.h,
//                                                 ),
//                                                 color: isSelected
//                                                     ? const Color(0xFFF0FDF4)
//                                                     : Colors.transparent,
//                                                 child: Row(
//                                                   children: [
//                                                     Container(
//                                                       width: 36.w,
//                                                       height: 36.w,
//                                                       decoration: BoxDecoration(
//                                                         color: isSelected
//                                                             ? const Color(
//                                                                 0xFFDCFCE7,
//                                                               )
//                                                             : const Color(
//                                                                 0xFFF3F4F6,
//                                                               ),
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               8.r,
//                                                             ),
//                                                       ),
//                                                       child: Center(
//                                                         child: Icon(
//                                                           Icons
//                                                               .apartment_rounded,
//                                                           size: 18.sp,
//                                                           color: isSelected
//                                                               ? const Color(
//                                                                   0xFF16A34A,
//                                                                 )
//                                                               : AppColors
//                                                                     .heading,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 10.w),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Text(
//                                                                 flatNumber,
//                                                                 style: GoogleFonts.outfit(
//                                                                   fontSize:
//                                                                       14.sp,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                   color: AppColors
//                                                                       .heading,
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 width: 6.w,
//                                                               ),
//                                                               Container(
//                                                                 padding:
//                                                                     EdgeInsets.symmetric(
//                                                                       horizontal:
//                                                                           5.w,
//                                                                       vertical:
//                                                                           1.h,
//                                                                     ),
//                                                                 decoration: BoxDecoration(
//                                                                   color: const Color(
//                                                                     0xFFECFDF5,
//                                                                   ),
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                         4.r,
//                                                                       ),
//                                                                 ),
//                                                                 child: Text(
//                                                                   "OCCUPIED",
//                                                                   style: GoogleFonts.outfit(
//                                                                     fontSize:
//                                                                         9.sp,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     color: const Color(
//                                                                       0xFF065F46,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(height: 2.h),
//                                                           Row(
//                                                             children: [
//                                                               Icon(
//                                                                 Icons
//                                                                     .person_outline_rounded,
//                                                                 size: 12.sp,
//                                                                 color:
//                                                                     const Color(
//                                                                       0xFF6B7280,
//                                                                     ),
//                                                               ),
//                                                               SizedBox(
//                                                                 width: 4.w,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Text(
//                                                                   residentName,
//                                                                   maxLines: 1,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   style: GoogleFonts.outfit(
//                                                                     fontSize:
//                                                                         12.sp,
//                                                                     color: const Color(
//                                                                       0xFF374151,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               if (flat.residentPhone !=
//                                                                       null &&
//                                                                   flat
//                                                                       .residentPhone!
//                                                                       .isNotEmpty) ...[
//                                                                 SizedBox(
//                                                                   width: 6.w,
//                                                                 ),
//                                                                 Text(
//                                                                   flat.residentPhone!,
//                                                                   style: GoogleFonts.outfit(
//                                                                     fontSize:
//                                                                         11.sp,
//                                                                     color: const Color(
//                                                                       0xFF9CA3AF,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     if (isSelected)
//                                                       Icon(
//                                                         Icons
//                                                             .check_circle_rounded,
//                                                         color: const Color(
//                                                           0xFF16A34A,
//                                                         ),
//                                                         size: 18.sp,
//                                                       ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                 ),
//                               ),
//                             );
//                           },
//                       onSelected: (Datum selection) {
//                         setState(() {
//                           selectedFlat = selection;
//                           flatNumberController.text =
//                               selection.flatNumber ??
//                               selection.propertyNameNumber ??
//                               '';
//                         });
//                         flatFocusNode.unfocus();
//                       },
//                     ),

//                     // Rich Resident Card Preview when a flat is selected
//                     if (selectedFlat != null) ...[
//                       SizedBox(height: 12.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 14.w,
//                           vertical: 12.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF9FAFB),
//                           borderRadius: BorderRadius.circular(12.r),
//                           border: Border.all(
//                             color: const Color(0xFFE5E7EB),
//                             width: 1.2,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.person_outline_rounded,
//                                         size: 16.sp,
//                                         color: AppColors.heading,
//                                       ),
//                                       SizedBox(width: 6.w),
//                                       Expanded(
//                                         child: Text(
//                                           selectedFlat!.residentName ??
//                                               "Vacant / Unassigned",
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: GoogleFonts.outfit(
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.heading,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 8.w,
//                                     vertical: 3.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFECFDF5),
//                                     borderRadius: BorderRadius.circular(6.r),
//                                     border: Border.all(
//                                       color: const Color(0xFFA7F3D0),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         width: 6.w,
//                                         height: 6.w,
//                                         decoration: const BoxDecoration(
//                                           color: Color(0xFF10B981),
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                       SizedBox(width: 4.w),
//                                       Text(
//                                         selectedFlat!.statusBadge != null
//                                             ? (statusBadgeValues
//                                                       .reverse[selectedFlat!
//                                                       .statusBadge] ??
//                                                   "OCCUPIED")
//                                             : "OCCUPIED",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 11.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: const Color(0xFF065F46),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             if (selectedFlat!.residentPhone != null &&
//                                 selectedFlat!.residentPhone!.isNotEmpty) ...[
//                               SizedBox(height: 6.h),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.phone_outlined,
//                                     size: 14.sp,
//                                     color: const Color(0xFF6B7280),
//                                   ),
//                                   SizedBox(width: 6.w),
//                                   Text(
//                                     "Mobile: ${selectedFlat!.residentPhone}",
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 13.sp,
//                                       color: const Color(0xFF4B5563),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                             if (selectedFlat!.location != null &&
//                                 selectedFlat!.location!.isNotEmpty) ...[
//                               SizedBox(height: 6.h),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.location_on_outlined,
//                                     size: 14.sp,
//                                     color: const Color(0xFF6B7280),
//                                   ),
//                                   SizedBox(width: 6.w),
//                                   Expanded(
//                                     child: Text(
//                                       "Location: ${selectedFlat!.location}",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 13.sp,
//                                         color: const Color(0xFF6B7280),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ] else ...[
//                       SizedBox(height: 10.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 11.w,
//                           vertical: 7.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(17, 197, 80, 0.1),
//                           borderRadius: BorderRadius.circular(8.r),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromRGBO(17, 197, 80, 0.2),
//                                 borderRadius: BorderRadius.circular(10.r),
//                               ),
//                               child: Image.asset(
//                                 "assets/home.png",
//                                 height: 27.h,
//                                 width: 27.w,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             SizedBox(width: 8.w),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Resident",
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.heading,
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Resident details will be identified automatically",
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: const Color.fromRGBO(0, 0, 0, 0.6),
//                                       letterSpacing: -0.2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Text(
//                               "Contact Hidden",
//                               style: GoogleFonts.outfit(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color.fromRGBO(0, 0, 0, 0.6),
//                                 letterSpacing: -0.2,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.scaffoldBg,
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: const Color(0xff101C16),
//                     width: 1.w,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Entry Information',
//                       style: GoogleFonts.outfit(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),

//                     SizedBox(height: 10.h),
//                     Container(
//                       width: double.infinity,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 14.w,
//                         vertical: 10.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(16, 28, 22, 0.1),
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.access_time_rounded,
//                             size: 20.sp,
//                             color: Colors.black,
//                           ),

//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'In-Time',
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                     height: 1.15,
//                                   ),
//                                 ),

//                                 SizedBox(height: 2.h),

//                                 Text(
//                                   'Automatically recorded',
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w400,
//                                     color: const Color(0xFF656565),
//                                     height: 1.2,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             entryTime,
//                             style: GoogleFonts.outfit(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.heading,
//                               letterSpacing: -0.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.scaffoldBg,
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: const Color(0xff101C16),
//                     width: 1.w,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Parcel Handling",
//                       style: GoogleFonts.outfit(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                     SizedBox(height: 17.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _parcelOption(
//                             index: 0,
//                             icon: "🔔",
//                             // title: "Ask Resident",
//                             title: "Home Delivery",
//                             subtitle: "Send approval request to resident",
//                           ),
//                         ),
//                         SizedBox(width: 20.w),
//                         Expanded(
//                           child: _parcelOption(
//                             index: 1,
//                             icon: "📦",
//                             title: "Leave at Gate",
//                             subtitle: "Resident has selected gate delivery",
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               SizedBox(
//                 width: double.infinity,
//                 height: 44.h,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.heading,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                   ),
//                   onPressed: isSubmitting ? null : _submitParcel,
//                   child: isSubmitting
//                       ? const SizedBox(
//                           height: 22,
//                           width: 22,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                         )
//                       : Text(
//                           'Register Parcel & Send Approval',
//                           style: GoogleFonts.outfit(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             letterSpacing: -0.2,
//                           ),
//                         ),
//                 ),
//               ),
//               // SizedBox(height: 16.h),
//               // SizedBox(
//               //   width: double.infinity,
//               //   height: 44.h,
//               //   child: ElevatedButton(
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: AppColors.scaffoldBg,
//               //       shape: RoundedRectangleBorder(
//               //         side: BorderSide(color: AppColors.heading),
//               //         borderRadius: BorderRadius.circular(8.r),
//               //       ),
//               //     ),
//               //     onPressed: () {
//               //       Navigator.pop(context);
//               //     },
//               //     child: Text(
//               //       'Cancel',
//               //       style: GoogleFonts.outfit(
//               //         fontSize: 16.sp,
//               //         fontWeight: FontWeight.w500,
//               //         color: AppColors.heading,
//               //         letterSpacing: -0.2,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _textField({
//     required String hintText,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     TextEditingController? controller,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       style: GoogleFonts.outfit(
//         fontSize: 16.sp,
//         color: AppColors.heading,
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: GoogleFonts.outfit(
//           fontSize: 13.sp,
//           color: const Color(0xff888891),
//           fontWeight: FontWeight.w400,
//         ),
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: 11.w,
//           vertical: maxLines > 1 ? 12.h : 0,
//         ),
//         filled: true,
//         fillColor: AppColors.scaffoldBg,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4.r),
//           borderSide: BorderSide(color: const Color(0xff101C16), width: 1.w),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(4.r),
//           borderSide: BorderSide(color: AppColors.heading, width: 1.2.w),
//         ),
//       ),
//     );
//   }

//   Widget _parcelOption({
//     required int index,
//     required String icon,
//     required String title,
//     required String subtitle,
//   }) {
//     final bool isSelected = selectedOption == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedOption = index;
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xffC9F3D9) : AppColors.scaffoldBg,
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(
//             color: isSelected
//                 ? const Color(0xff16B364)
//                 : const Color(0xff101C16),
//             width: 1.w,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(icon, style: GoogleFonts.outfit(fontSize: 16.sp)),

//                 SizedBox(width: 2.w),
//                 Expanded(
//                   child: Text(
//                     title,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 8.h),

//             Text(
//               subtitle,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: GoogleFonts.outfit(
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xff666666),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/GuaredHistoryScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardParcelScreen/GuardGateParcelsScreen.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/VisitorScreen/Provider/getFlatApartmentProvider.dart';
import 'package:property_association_or_resident/GuardScreen/Model/getFlatApartmentModel.dart';

class Guardparcelregisterscreen extends ConsumerStatefulWidget {
  const Guardparcelregisterscreen({super.key});

  @override
  ConsumerState<Guardparcelregisterscreen> createState() =>
      _GuardparcelregisterscreenState();
}

class _GuardparcelregisterscreenState
    extends ConsumerState<Guardparcelregisterscreen> {
  final TextEditingController vendorNameController = TextEditingController();
  final TextEditingController trackingNumberController =
      TextEditingController();
  final TextEditingController flatNumberController = TextEditingController();
  final FocusNode flatFocusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  Datum? selectedFlat;
  bool isSubmitting = false;

  String? selectedVisitType;
  int selectedOption = 0;
  File? visitorPhoto;
  late String entryTime;

  @override
  void initState() {
    super.initState();
    entryTime = _formatCurrentTime();
    flatNumberController.addListener(() {
      if (selectedFlat != null &&
          flatNumberController.text.trim().toLowerCase() !=
              (selectedFlat!.flatNumber ??
                      selectedFlat!.propertyNameNumber ??
                      '')
                  .trim()
                  .toLowerCase()) {
        setState(() {
          selectedFlat = null;
        });
      }
    });
  }

  @override
  void dispose() {
    vendorNameController.dispose();
    trackingNumberController.dispose();
    flatNumberController.dispose();
    flatFocusNode.dispose();
    super.dispose();
  }

  Future<void> pickVisitorPhoto() async {
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Photo",
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),

                SizedBox(height: 8.h),

                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.heading,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Camera",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.heading,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Gallery",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        visitorPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitParcel() async {
    if (visitorPhoto == null) {
      showErrorSnackBar("Please capture or select parcel photo");
      return;
    }

    final vendorName = vendorNameController.text.trim();
    if (vendorName.isEmpty) {
      showErrorSnackBar("Please enter vendor name");
      return;
    }

    final flatNumber = flatNumberController.text.trim();
    if (flatNumber.isEmpty) {
      showErrorSnackBar("Please select a flat number");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final res = await authService.addParcelData(
        vendorName: vendorName,
        flatNumber: flatNumber,
        parcelType: selectedVisitType ?? "Box",
        trackingNumber: trackingNumberController.text.trim(),
        handlingType: "ask_resident",
        parcelPhoto: visitorPhoto!,
      );
      if (!mounted) return;
      if (res.status != true) {
        showErrorSnackBar(res.message ?? "Could not register the parcel.");
        return;
      }
      showSuccessSnackBar(res.message ?? "Parcel registered.");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => Guaredhistoryscreen(isBackButtonShow: true),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // showErrorSnackBar(e.toString());
      log(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour == 0
        ? 12
        : (now.hour > 12 ? now.hour - 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final getFlatApartmentState = ref.watch(getFlatApartmentProvider);
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
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Parcel Registration",
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Register incoming parcel for resident approval",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.65),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const GuardGateParcelsScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF0),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE8B900)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 16.sp,
                      color: AppColors.heading,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Gate Parcels",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Parcel Photo",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {
                        pickVisitorPhoto();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 110.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.heading,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: visitorPhoto != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  visitorPhoto!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 48.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Take Parcel Photo',
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),

                                  SizedBox(height: 2.h),
                                  Text(
                                    'Capture clear photo of the parcel',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF666666),
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
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Parcel Details",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Vendor Name *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _textField(
                      controller: vendorNameController,
                      hintText: "e.g. Amazon, Flipkart, DHL",
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parcel Type',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),
                              SizedBox(height: 8.h),

                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBg,
                                  borderRadius: BorderRadius.circular(4.r),
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.w,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedVisitType,
                                    isExpanded: true,

                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 11,
                                      ),
                                      child: Text(
                                        'Select Type',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.sp,
                                          color: const Color(0xff888891),
                                        ),
                                      ),
                                    ),

                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 22,
                                        color: Color(0xff77777F),
                                      ),
                                    ),

                                    items:
                                        [
                                          'Box',
                                          'Small Box',
                                          'Large Box / Carton',
                                          'Packet / Bag',
                                          'Envelope / Document',
                                          'Food / Grocery',
                                          'Fragile / Electronics',
                                          'Other',
                                        ].map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 11,
                                                  ),
                                              child: Text(
                                                type,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 13.sp,
                                                  color: const Color(
                                                    0xff222222,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),

                                    onChanged: (value) {
                                      setState(() {
                                        selectedVisitType = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tracking / Reference',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                height: 46.h,
                                child: _textField(
                                  controller: trackingNumberController,
                                  hintText: "Optional",
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat Number *",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // RawAutocomplete for Flat / Apartment with dynamic suggestions
                    RawAutocomplete<Datum>(
                      textEditingController: flatNumberController,
                      focusNode: flatFocusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final allFlats =
                            getFlatApartmentState.value?.data ??
                            getFlatApartmentState.value?.properties ??
                            [];
                        if (textEditingValue.text.isEmpty) {
                          return allFlats;
                        }
                        final q = textEditingValue.text.trim().toLowerCase();
                        return allFlats.where((flat) {
                          final fNo =
                              (flat.flatNumber ?? flat.propertyNameNumber ?? '')
                                  .toLowerCase();
                          final res = (flat.residentName ?? '').toLowerCase();
                          final ph = (flat.residentPhone ?? '').toLowerCase();
                          final loc = (flat.location ?? '').toLowerCase();
                          final st =
                              (flat.status ?? flat.statusBadge ?? '')
                                  .toLowerCase();
                          return fNo.contains(q) ||
                              res.contains(q) ||
                              ph.contains(q) ||
                              loc.contains(q) ||
                              st.contains(q);
                        });
                      },
                      displayStringForOption: (Datum option) =>
                          option.flatNumber ?? option.propertyNameNumber ?? '',
                      fieldViewBuilder:
                          (
                            BuildContext context,
                            TextEditingController controller,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextField(
                              key: _autocompleteKey,
                              controller: controller,
                              focusNode: focusNode,
                              onSubmitted: (_) => onFieldSubmitted(),
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                color: AppColors.heading,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Enter flat no. or resident name...",
                                hintStyle: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  color: const Color(0xff888891),
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Icons.apartment_rounded,
                                  size: 20.sp,
                                  color: controller.text.isNotEmpty
                                      ? AppColors.heading
                                      : const Color(0xff888891),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.text.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          controller.clear();
                                          setState(() {
                                            selectedFlat = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            size: 20.sp,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Container(
                                        height: 32.h,
                                        width: 32.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                          color: const Color(0xFFF3F4F6),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.search,
                                            color: AppColors.heading,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                filled: true,
                                fillColor: AppColors.scaffoldBg,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                    color: controller.text.isNotEmpty
                                        ? AppColors.heading
                                        : const Color(0xff101C16),
                                    width: 1.w,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                    color: AppColors.heading,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder:
                          (
                            BuildContext context,
                            AutocompleteOnSelected<Datum> onSelected,
                            Iterable<Datum> options,
                          ) {
                            final renderBox =
                                _autocompleteKey.currentContext
                                        ?.findRenderObject()
                                    as RenderBox?;
                            final fieldWidth =
                                renderBox?.size.width ??
                                (MediaQuery.of(context).size.width - 72.w);

                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 6.0,
                                shadowColor: Colors.black26,
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.scaffoldBg,
                                child: Container(
                                  width: fieldWidth,
                                  constraints: BoxConstraints(maxHeight: 260.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.scaffoldBg,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: options.isEmpty
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 14.w,
                                          ),
                                          child: Text(
                                            "No matching flat or resident found",
                                            style: GoogleFonts.outfit(
                                              fontSize: 13.sp,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                height: 1,
                                                color: Color(0xFFF3F4F6),
                                              ),
                                          itemBuilder: (BuildContext context, int index) {
                                            final Datum flat = options
                                                .elementAt(index);
                                            final flatNumber =
                                                flat.flatNumber ??
                                                flat.propertyNameNumber ??
                                                'Flat';
                                            final residentName =
                                                (flat.residentName != null &&
                                                    flat.residentName!
                                                        .trim()
                                                        .isNotEmpty)
                                                ? flat.residentName!
                                                : 'Vacant / Unassigned';
                                            final isSelected =
                                                selectedFlat?.id != null
                                                ? selectedFlat?.id == flat.id
                                                : flatNumberController.text ==
                                                      flatNumber;

                                            return InkWell(
                                              onTap: () {
                                                onSelected(flat);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h,
                                                ),
                                                color: isSelected
                                                    ? const Color(0xFFF0FDF4)
                                                    : Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 36.w,
                                                      height: 36.w,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? const Color(
                                                                0xFFDCFCE7,
                                                              )
                                                            : const Color(
                                                                0xFFF3F4F6,
                                                              ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8.r,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .apartment_rounded,
                                                          size: 18.sp,
                                                          color: isSelected
                                                              ? const Color(
                                                                  0xFF16A34A,
                                                                )
                                                              : AppColors
                                                                    .heading,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                flatNumber,
                                                                style: GoogleFonts.outfit(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .heading,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.w,
                                                                      vertical:
                                                                          1.h,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: flat
                                                                      .badgeBgColor,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4.r,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: flat
                                                                        .badgeBorderColor,
                                                                        width: 0.8,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  flat.displayStatusBadge,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        9.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: flat
                                                                        .badgeTextColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2.h),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                flat.isVacant
                                                                    ? Icons
                                                                        .person_off_outlined
                                                                    : Icons
                                                                        .person_outline_rounded,
                                                                size: 12.sp,
                                                                color: flat.isVacant
                                                                    ? const Color(
                                                                        0xFF9CA3AF,
                                                                      )
                                                                    : const Color(
                                                                        0xFF6B7280,
                                                                      ),
                                                              ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  residentName,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: flat.isVacant
                                                                        ? const Color(
                                                                            0xFF6B7280,
                                                                          )
                                                                        : const Color(
                                                                            0xFF374151,
                                                                          ),
                                                                    fontStyle: flat.isVacant
                                                                        ? FontStyle
                                                                            .italic
                                                                        : FontStyle
                                                                            .normal,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (flat.residentPhone !=
                                                                      null &&
                                                                  flat
                                                                      .residentPhone!
                                                                      .isNotEmpty) ...[
                                                                SizedBox(
                                                                  width: 6.w,
                                                                ),
                                                                Text(
                                                                  flat.residentPhone!,
                                                                  style: GoogleFonts.outfit(
                                                                    fontSize:
                                                                        11.sp,
                                                                    color: const Color(
                                                                      0xFF9CA3AF,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: const Color(
                                                          0xFF16A34A,
                                                        ),
                                                        size: 18.sp,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                            );
                          },
                      onSelected: (Datum selection) {
                        setState(() {
                          selectedFlat = selection;
                          flatNumberController.text =
                              selection.flatNumber ??
                              selection.propertyNameNumber ??
                              '';
                        });
                        flatFocusNode.unfocus();
                      },
                    ),

                    // Rich Resident Card Preview when a flat is selected
                    if (selectedFlat != null) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedFlat!.isVacant
                                            ? Icons.person_off_outlined
                                            : Icons.person_outline_rounded,
                                        size: 16.sp,
                                        color: AppColors.heading,
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          selectedFlat!.residentName ??
                                              "Vacant / Unassigned",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                            fontStyle: selectedFlat!.isVacant
                                                ? FontStyle.italic
                                                : FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedFlat!.badgeBgColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: selectedFlat!.badgeBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6.w,
                                        height: 6.w,
                                        decoration: BoxDecoration(
                                          color: selectedFlat!.badgeColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        selectedFlat!.displayStatusBadge,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: selectedFlat!.badgeTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (selectedFlat!.residentPhone != null &&
                                selectedFlat!.residentPhone!.isNotEmpty) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_outlined,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Mobile: ${selectedFlat!.residentPhone}",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (selectedFlat!.location != null &&
                                selectedFlat!.location!.isNotEmpty) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "Location: ${selectedFlat!.location}",
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (selectedFlat!.isVacant) ...[
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 14.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      "This unit is currently vacant / unassigned.",
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 11.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(17, 197, 80, 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(17, 197, 80, 0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Image.asset(
                                "assets/home.png",
                                height: 27.h,
                                width: 27.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Resident",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  Text(
                                    "Resident details will be identified automatically",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Contact Hidden",
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, 0.6),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entry Information',
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(16, 28, 22, 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 20.sp,
                            color: Colors.black,
                          ),

                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'In-Time',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    height: 1.15,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                Text(
                                  'Automatically recorded',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF656565),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            entryTime,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Parcel Handling",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 17.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffC9F3D9),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xff16B364),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        "🔔 Resident will be asked to choose Home Delivery or Leave at Gate. You will see their choice in the parcel list.",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isSubmitting ? null : _submitParcel,
                  child: isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Register Parcel & Send Approval',
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
              // SizedBox(height: 16.h),
              // SizedBox(
              //   width: double.infinity,
              //   height: 44.h,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.scaffoldBg,
              //       shape: RoundedRectangleBorder(
              //         side: BorderSide(color: AppColors.heading),
              //         borderRadius: BorderRadius.circular(8.r),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: Text(
              //       'Cancel',
              //       style: GoogleFonts.outfit(
              //         fontSize: 16.sp,
              //         fontWeight: FontWeight.w500,
              //         color: AppColors.heading,
              //         letterSpacing: -0.2,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.outfit(
        fontSize: 16.sp,
        color: AppColors.heading,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 13.sp,
          color: const Color(0xff888891),
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 11.w,
          vertical: maxLines > 1 ? 12.h : 0,
        ),
        filled: true,
        fillColor: AppColors.scaffoldBg,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: const Color(0xff101C16), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.heading, width: 1.2.w),
        ),
      ),
    );
  }

  Widget _parcelOption({
    required int index,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffC9F3D9) : AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xff16B364)
                : const Color(0xff101C16),
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: GoogleFonts.outfit(fontSize: 16.sp)),

                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
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
              ],
            ),

            SizedBox(height: 8.h),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

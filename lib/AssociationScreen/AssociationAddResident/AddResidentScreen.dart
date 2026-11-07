// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/ResidentListScreen.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';

// import '../../Core/Utils/showMessage.dart';
// import '../../Core/AuthService/AuthServiceProvider.dart';
// import 'provider/addResidentProvider.dart';

// class Addresidentscreen extends ConsumerStatefulWidget {
//   const Addresidentscreen({super.key});

//   @override
//   ConsumerState<Addresidentscreen> createState() => _AddresidentscreenState();
// }

// class _AddresidentscreenState extends ConsumerState<Addresidentscreen> {
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//   bool associationAgreeTerms = false;
//   String? unitNumber;
//   String selectedResidentType = ""; // "owner" | "tenant"
//   final _formKeyResident = GlobalKey<FormState>();
//   bool isLoading = false;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController associationController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController vehicleNumberController = TextEditingController();

//   @override
//   void dispose() {
//     nameController.dispose();
//     mobileController.dispose();
//     emailController.dispose();
//     associationController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     vehicleNumberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final getUnit = ref.watch(addResidentProvider);
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.h),
//         child: AppBar(
//           backgroundColor: AppColors.scaffoldBg,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           surfaceTintColor: Colors.transparent,
//           titleSpacing: 0,
//           title: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     width: 44.w,
//                     height: 44.h,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: const Color.fromRGBO(16, 28, 22, 0.3),
//                       ),
//                       borderRadius: BorderRadius.circular(6.r),
//                     ),
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: const Color(0xff101C16),
//                       size: 20.sp,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Add Resident",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.outfit(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.heading,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         "All Resident Information",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.outfit(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           color: const Color.fromRGBO(42, 41, 51, 0.7),
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                         builder: (context) => Residentlistscreen(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     "Resident List",
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: GoogleFonts.outfit(
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xffB8860B),
//                       fontSize: 15.sp,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Form(
//         key: _formKeyResident,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 18.w),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: const Color(0xFF101C16),
//                       width: 1.w,
//                     ),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "ACCOUNT INFORMATION",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: GoogleFonts.outfit(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.heading,
//                           letterSpacing: -0.2,
//                         ),
//                       ),

//                       SizedBox(height: 15.h),

//                       fieldLabel("FULL NAME"),
//                       customTextField(
//                         controller: nameController,
//                         hintText: "Enter Your Full Name",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your full name";
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 10.h),

//                       fieldLabel("EMAIL ADDRESS"),
//                       customTextField(
//                         controller: emailController,
//                         hintText: "Enter Your Email Address",
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your email address";
//                           }
//                           if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                             return "Please enter a valid email address";
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 10.h),

//                       fieldLabel("MOBILE NUMBER"),
//                       customTextField(
//                         controller: mobileController,
//                         hintText: "Enter Your Mobile Number",
//                         keyboardType: TextInputType.phone,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your mobile number";
//                           }
//                           if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                             return "Please enter a valid 10-digit mobile number";
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 10.h),

//                       fieldLabel("PASSWORD"),
//                       customTextField(
//                         controller: passwordController,
//                         hintText: "Current Password",
//                         obscureText: !isPasswordVisible,
//                         showVisibilityIcon: true,
//                         onVisibilityTap: () {
//                           setState(() {
//                             isPasswordVisible = !isPasswordVisible;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your password";
//                           }
//                           return null;
//                         },
//                       ),

//                       SizedBox(height: 10.h),

//                       fieldLabel("CONFIRM PASSWORD"),
//                       customTextField(
//                         controller: confirmPasswordController,
//                         hintText: "Confirm Your Password",
//                         obscureText: !isConfirmPasswordVisible,
//                         showVisibilityIcon: true,
//                         onVisibilityTap: () {
//                           setState(() {
//                             isConfirmPasswordVisible =
//                                 !isConfirmPasswordVisible;
//                           });
//                         },
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your confirm password";
//                           }
//                           if (value != passwordController.text) {
//                             return "Passwords do not match";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 10.h),
//                       fieldLabel("SELECT UNIT / FLAT *"),
//                       getUnit.when(
//                         data: (data) {
//                           final units = data.data?.availableUnits ?? [];
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               DropdownButtonFormField<String>(
//                                 value: unitNumber,
//                                 isExpanded: true,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return "Please select an apartment / flat";
//                                   }
//                                   return null;
//                                 },
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: const Color(0xFF000000),
//                                   size: 20.sp,
//                                 ),
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: const Color(0xFF000000),
//                                 ),
//                                 autovalidateMode:
//                                     AutovalidateMode.onUserInteraction,
//                                 hint: Text(
//                                   'Select Unit / Flat *',
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: const Color(0xFF000000),
//                                     letterSpacing: -0.3,
//                                   ),
//                                 ),
//                                 decoration: InputDecoration(
//                                   isDense: true,
//                                   hintText: 'Select Unit / Flat *',
//                                   hintStyle: GoogleFonts.outfit(
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: const Color(0xFF000000),
//                                     letterSpacing: -0.3,
//                                   ),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 10.w,
//                                     vertical: 10.h,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     borderSide: BorderSide(
//                                       color: const Color(0xFF000000),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     borderSide: BorderSide(
//                                       color: const Color(0xFF000000),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     borderSide: BorderSide(
//                                       color: const Color(0xFF000000),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   errorBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     borderSide: BorderSide(
//                                       color: const Color(0xFF000000),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                   focusedErrorBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(4.r),
//                                     borderSide: BorderSide(
//                                       color: const Color(0xFF000000),
//                                       width: 1.w,
//                                     ),
//                                   ),
//                                 ),
//                                 selectedItemBuilder: (context) {
//                                   return [
//                                     const SizedBox.shrink(),
//                                     ...units.map((e) {
//                                       final isSelectable =
//                                           (e.isSelectable == true) ||
//                                           (e.isVacant == true &&
//                                               e.isOccupied != true);
//                                       final label =
//                                           e.label ??
//                                           '${e.propertyName ?? e.unitNumber ?? ""} (${isSelectable ? "Vacant" : "Occupied"})';
//                                       return Text(
//                                         label,
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: const Color(0xFF000000),
//                                           letterSpacing: -0.2,
//                                         ),
//                                       );
//                                     }),
//                                   ];
//                                 },
//                                 items: [
//                                   DropdownMenuItem<String>(
//                                     enabled: false,
//                                     value: null,
//                                     child: Container(
//                                       width: double.infinity,
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8.w,
//                                         vertical: 6.h,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFBFBFBF),
//                                         borderRadius:
//                                             BorderRadius.circular(2.r),
//                                       ),
//                                       child: Text(
//                                         "Select Unit / Flat *",
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   ...units.map((e) {
//                                     final isSelectable =
//                                         (e.isSelectable == true) ||
//                                         (e.isVacant == true &&
//                                             e.isOccupied != true);
//                                     final label =
//                                         e.label ??
//                                         '${e.propertyName ?? e.unitNumber ?? ""} (${isSelectable ? "Vacant" : "Occupied"})';
//                                     return DropdownMenuItem<String>(
//                                       enabled: isSelectable,
//                                       value: (e.unitNumber ??
//                                               e.propertyName ??
//                                               '')
//                                           .toString(),
//                                       child: Text(
//                                         label,
//                                         style: GoogleFonts.outfit(
//                                           fontSize: 15.sp,
//                                           fontWeight: isSelectable
//                                               ? FontWeight.w500
//                                               : FontWeight.w400,
//                                           color: isSelectable
//                                               ? const Color(0xFF000000)
//                                               : const Color(0xFF9E9E9E),
//                                           letterSpacing: -0.2,
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     unitNumber = value;
//                                   });
//                                 },
//                               ),
//                               SizedBox(height: 6.h),
//                               RichText(
//                                 text: TextSpan(
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 12.sp,
//                                     color: const Color(0xFF6B7280),
//                                     height: 1.3,
//                                   ),
//                                   children: [
//                                     const TextSpan(
//                                       text:
//                                           "One unit can have only one resident. New unit? Add it from ",
//                                     ),
//                                     TextSpan(
//                                       text:
//                                           "Property / Unit List (available after Admin approval)",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 12.sp,
//                                         color: const Color(0xFF9E7B35),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                         error: (e, s) {
//                           log("error $e");
//                           return Center(child: Text("Something went wrong"));
//                         },
//                         loading: () {
//                           return Center(
//                             child: CircularProgressIndicator(
//                               color: AppColors.heading,
//                             ),
//                           );
//                         },
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         "Resident Type",
//                         style: GoogleFonts.outfit(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.heading,
//                           letterSpacing: -0.2,
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   selectedResidentType = "owner";
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 11.h),
//                                 decoration: BoxDecoration(
//                                   color: selectedResidentType == "owner"
//                                       ? const Color(0xFFE8F5E9)
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   border: Border.all(
//                                     color: selectedResidentType == "owner"
//                                         ? const Color(0xFF2E7D32)
//                                         : const Color(0xFFD9D9D0),
//                                     width: selectedResidentType == "owner"
//                                         ? 1.6
//                                         : 1,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "👑",
//                                       style: TextStyle(fontSize: 15.sp),
//                                     ),
//                                     SizedBox(width: 6.w),
//                                     Text(
//                                       "Owner",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 14.sp,
//                                         fontWeight:
//                                             selectedResidentType == "owner"
//                                             ? FontWeight.w600
//                                             : FontWeight.w500,
//                                         color: selectedResidentType == "owner"
//                                             ? const Color(0xFF2E7D32)
//                                             : AppColors.heading,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12.w),
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   selectedResidentType = "tenant";
//                                 });
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 11.h),
//                                 decoration: BoxDecoration(
//                                   color: selectedResidentType == "tenant"
//                                       ? const Color(0xFFFFF3E0)
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(8.r),
//                                   border: Border.all(
//                                     color: selectedResidentType == "tenant"
//                                         ? const Color(0xFFE65100)
//                                         : const Color(0xFFD9D9D0),
//                                     width: selectedResidentType == "tenant"
//                                         ? 1.6
//                                         : 1,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "📄",
//                                       style: TextStyle(fontSize: 15.sp),
//                                     ),
//                                     SizedBox(width: 6.w),
//                                     Text(
//                                       "Tenant",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 14.sp,
//                                         fontWeight:
//                                             selectedResidentType == "tenant"
//                                             ? FontWeight.w600
//                                             : FontWeight.w500,
//                                         color: selectedResidentType == "tenant"
//                                             ? const Color(0xFFE65100)
//                                             : AppColors.heading,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16.h),
//                       fieldLabel("VEHICLE NUMBER"),
//                       customTextField(
//                         controller: vehicleNumberController,
//                         hintText: "Enter Vehicle Number",
//                         textCapitalization: TextCapitalization.characters,
//                         validator: (value) {
//                           if ((value ?? "").trim().isEmpty) {
//                             return "Vehicle number cannot be empty";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 16.h),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 27.w,
//                             height: 27.w,
//                             child: Checkbox(
//                               value: associationAgreeTerms,
//                               onChanged: (value) {
//                                 setState(() {
//                                   associationAgreeTerms = value ?? false;
//                                 });
//                               },
//                               materialTapTargetSize:
//                                   MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                               side: const BorderSide(
//                                 color: Color(0xFF101C16),
//                                 width: 1,
//                               ),
//                             ),
//                           ),

//                           SizedBox(width: 8.w),

//                           Expanded(
//                             child: Text(
//                               "I agree to the Terms & Conditions and Privacy Policy.",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.outfit(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: const Color(0xFF101C16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 18.h),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 52.h,
//                         child: ElevatedButton(
//                           onPressed: isLoading
//                               ? null
//                               : () async {
//                                   if (!_formKeyResident.currentState!
//                                       .validate()) {
//                                     return;
//                                   }
//                                   // if (selectedResidentType.isEmpty ||
//                                   //     selectedResidentType == "") {
//                                   //   showErrorSnackBar(
//                                   //     "Please select resident type",
//                                   //   );
//                                   //   return;
//                                   // }
//                                   if (associationAgreeTerms == false) {
//                                     showErrorSnackBar(
//                                       "Please agree to the terms and conditions",
//                                     );
//                                     return;
//                                   }
//                                   try {
//                                     setState(() {
//                                       isLoading = true;
//                                     });
//                                     final service = ref.read(
//                                       authServiceProvider,
//                                     );
//                                     final response = await service.addResident(
//                                       name: nameController.text.trim(),
//                                       email: emailController.text.trim(),
//                                       phone: mobileController.text.trim(),
//                                       password: passwordController.text.trim(),
//                                       confirmPassword: confirmPasswordController
//                                           .text
//                                           .trim(),
//                                       unitNumber: unitNumber!,
//                                       termsAccepted: associationAgreeTerms,
//                                       residentType: selectedResidentType,
//                                       vehicleNumber:
//                                           vehicleNumberController.text
//                                               .trim()
//                                               .isNotEmpty
//                                           ? vehicleNumberController.text.trim()
//                                           : null,
//                                     );
//                                     if (response.status == true) {
//                                       showSuccessSnackBar(
//                                         response.message ?? "Sucess",
//                                       );
//                                       if (context.mounted) {
//                                         Navigator.pushReplacement(
//                                           context,
//                                           CupertinoPageRoute(
//                                             builder: (context) =>
//                                                 Residentlistscreen(),
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   } catch (e) {
//                                     log(e.toString());
//                                   } finally {
//                                     if (mounted) {
//                                       setState(() {
//                                         isLoading = false;
//                                       });
//                                     }
//                                   }
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF101C16),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                           ),
//                           child: isLoading
//                               ? Center(
//                                   child: SizedBox(
//                                     width: 20.w,
//                                     height: 20.h,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 1.5,
//                                     ),
//                                   ),
//                                 )
//                               : Text(
//                                   "Create Account",
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     letterSpacing: 0.2,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget customTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     VoidCallback? onVisibilityTap,
//     bool showVisibilityIcon = false,
//     String? Function(String?)? validator,
//     TextCapitalization textCapitalization = TextCapitalization.none,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       textCapitalization: textCapitalization,
//       validator: validator,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       style: GoogleFonts.outfit(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w600,
//         color: const Color(0xff101C16),
//         letterSpacing: -0.2,
//       ),
//       decoration: InputDecoration(
//         isDense: true,
//         hintText: hintText,
//         hintStyle: GoogleFonts.outfit(
//           fontSize: 15.sp,
//           fontWeight: FontWeight.w500,
//           color: const Color.fromRGBO(0, 0, 0, 0.55),
//           letterSpacing: -0.2,
//         ),
//         contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
//         suffixIcon: showVisibilityIcon
//             ? InkWell(
//                 onTap: onVisibilityTap,
//                 child: Icon(
//                   obscureText
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   size: 22.sp,
//                   color: const Color(0xFF000000),
//                 ),
//               )
//             : null,
//         suffixIconConstraints: BoxConstraints(
//           minHeight: 52.h,
//           maxHeight: 52.h,
//           minWidth: 46.w,
//           maxWidth: 46.w,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(
//             color: const Color.fromRGBO(16, 28, 22, 0.6),
//             width: 1.2.w,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(color: AppColors.heading, width: 1.5.w),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(color: Colors.red, width: 1.w),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6.r),
//           borderSide: BorderSide(color: Colors.red, width: 1.5.w),
//         ),
//       ),
//     );
//   }

//   Widget fieldLabel(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.h),
//       child: Text(
//         text,
//         style: GoogleFonts.outfit(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w600,
//           color: AppColors.heading,
//           letterSpacing: 0.1,
//         ),
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
import 'package:property_association_or_resident/AssociationScreen/AssociationAddResident/ResidentListScreen.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

import '../../Core/Utils/showMessage.dart';
import '../../Core/AuthService/AuthServiceProvider.dart';
import 'provider/addResidentProvider.dart';

class Addresidentscreen extends ConsumerStatefulWidget {
  const Addresidentscreen({super.key});

  @override
  ConsumerState<Addresidentscreen> createState() => _AddresidentscreenState();
}

class _AddresidentscreenState extends ConsumerState<Addresidentscreen> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool associationAgreeTerms = false;
  String? unitNumber;
  String selectedResidentType = ""; // "owner" | "tenant"
  final _formKeyResident = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController associationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    associationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUnit = ref.watch(addResidentProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          automaticallyImplyLeading: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    alignment: Alignment.center,
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
                        "Add Resident",
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
                        "All Resident Information",
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
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Residentlistscreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Resident List",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffB8860B),
                      fontSize: 15.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKeyResident,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ACCOUNT INFORMATION",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      fieldLabel("FULL NAME"),
                      customTextField(
                        controller: nameController,
                        hintText: "Enter Your Full Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your full name";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      fieldLabel("EMAIL ADDRESS"),
                      customTextField(
                        controller: emailController,
                        hintText: "Enter Your Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email address";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      fieldLabel("MOBILE NUMBER"),
                      customTextField(
                        controller: mobileController,
                        hintText: "Enter Your Mobile Number",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your mobile number";
                          }
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return "Please enter a valid 10-digit mobile number";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      fieldLabel("PASSWORD"),
                      customTextField(
                        controller: passwordController,
                        hintText: "Current Password",
                        obscureText: !isPasswordVisible,
                        showVisibilityIcon: true,
                        onVisibilityTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10.h),

                      fieldLabel("CONFIRM PASSWORD"),
                      customTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Your Password",
                        obscureText: !isConfirmPasswordVisible,
                        showVisibilityIcon: true,
                        onVisibilityTap: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your confirm password";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      fieldLabel("SELECT UNIT / FLAT *"),
                      getUnit.when(
                        data: (data) {
                          final units = data.data?.availableUnits ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                value: unitNumber,
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select an apartment / flat";
                                  }
                                  return null;
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: const Color(0xFF000000),
                                  size: 20.sp,
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF000000),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                hint: Text(
                                  'Select Unit / Flat *',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF000000),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Select Unit / Flat *',
                                  hintStyle: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF000000),
                                    letterSpacing: -0.3,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF000000),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                selectedItemBuilder: (context) {
                                  return [
                                    const SizedBox.shrink(),
                                    ...units.map((e) {
                                      final isSelectable =
                                          (e.isSelectable == true) ||
                                          (e.isVacant == true &&
                                              e.isOccupied != true);
                                      final label =
                                          e.label ??
                                          '${e.propertyName ?? e.unitNumber ?? ""} (${isSelectable ? "Vacant" : "Occupied"})';
                                      return Text(
                                        label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000000),
                                          letterSpacing: -0.2,
                                        ),
                                      );
                                    }),
                                  ];
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    enabled: false,
                                    value: null,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFBFBFBF),
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Select Unit / Flat *",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...units.map((e) {
                                    final isSelectable =
                                        (e.isSelectable == true) ||
                                        (e.isVacant == true &&
                                            e.isOccupied != true);
                                    final label =
                                        e.label ??
                                        '${e.propertyName ?? e.unitNumber ?? ""} (${isSelectable ? "Vacant" : "Occupied"})';
                                    return DropdownMenuItem<String>(
                                      enabled: isSelectable,
                                      value:
                                          (e.unitNumber ?? e.propertyName ?? '')
                                              .toString(),
                                      child: Text(
                                        label,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: isSelectable
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          color: isSelectable
                                              ? const Color(0xFF000000)
                                              : const Color(0xFF9E9E9E),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    unitNumber = value;
                                  });
                                },
                              ),
                              SizedBox(height: 6.h),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF6B7280),
                                    height: 1.3,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                          "One unit can have only one resident. New unit? Add it from ",
                                    ),
                                    TextSpan(
                                      text:
                                          "Property / Unit List (available immediately, no Admin approval needed)",
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF9E7B35),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        error: (e, s) {
                          log("error $e");
                          return Center(child: Text("Something went wrong"));
                        },
                        loading: () {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.heading,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Resident Type",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedResidentType = "owner";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                decoration: BoxDecoration(
                                  color: selectedResidentType == "owner"
                                      ? const Color(0xFFE8F5E9)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: selectedResidentType == "owner"
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFD9D9D0),
                                    width: selectedResidentType == "owner"
                                        ? 1.6
                                        : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "👑",
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Owner",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight:
                                            selectedResidentType == "owner"
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: selectedResidentType == "owner"
                                            ? const Color(0xFF2E7D32)
                                            : AppColors.heading,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedResidentType = "tenant";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 11.h),
                                decoration: BoxDecoration(
                                  color: selectedResidentType == "tenant"
                                      ? const Color(0xFFFFF3E0)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: selectedResidentType == "tenant"
                                        ? const Color(0xFFE65100)
                                        : const Color(0xFFD9D9D0),
                                    width: selectedResidentType == "tenant"
                                        ? 1.6
                                        : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "📄",
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Tenant",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight:
                                            selectedResidentType == "tenant"
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: selectedResidentType == "tenant"
                                            ? const Color(0xFFE65100)
                                            : AppColors.heading,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      fieldLabel("VEHICLE NUMBER"),
                      customTextField(
                        controller: vehicleNumberController,
                        hintText: "Enter Vehicle Number",
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if ((value ?? "").trim().isEmpty) {
                            return "Vehicle number cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 27.w,
                            height: 27.w,
                            child: Checkbox(
                              value: associationAgreeTerms,
                              onChanged: (value) {
                                setState(() {
                                  associationAgreeTerms = value ?? false;
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(
                                color: Color(0xFF101C16),
                                width: 1,
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Expanded(
                            child: Text(
                              "I agree to the Terms & Conditions and Privacy Policy.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101C16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!_formKeyResident.currentState!
                                      .validate()) {
                                    return;
                                  }
                                  if (selectedResidentType.isEmpty ||
                                      selectedResidentType == "") {
                                    showErrorSnackBar(
                                      "Please select resident type",
                                    );
                                    return;
                                  }
                                  if (associationAgreeTerms == false) {
                                    showErrorSnackBar(
                                      "Please agree to the terms and conditions",
                                    );
                                    return;
                                  }
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final service = ref.read(
                                      authServiceProvider,
                                    );
                                    final response = await service.addResident(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone: mobileController.text.trim(),
                                      password: passwordController.text.trim(),
                                      confirmPassword: confirmPasswordController
                                          .text
                                          .trim(),
                                      unitNumber: unitNumber!,
                                      termsAccepted: associationAgreeTerms,
                                      residentType: selectedResidentType,
                                      vehicleNumber:
                                          vehicleNumberController.text
                                              .trim()
                                              .isNotEmpty
                                          ? vehicleNumberController.text.trim()
                                          : null,
                                    );
                                    if (response.status == true) {
                                      showSuccessSnackBar(
                                        response.message ?? "Sucess",
                                      );
                                      if (context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                Residentlistscreen(),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    log(e.toString());
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF101C16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: isLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Create Account",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onVisibilityTap,
    bool showVisibilityIcon = false,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.outfit(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 0.55),
          letterSpacing: -0.2,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        suffixIcon: showVisibilityIcon
            ? InkWell(
                onTap: onVisibilityTap,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 22.sp,
                  color: const Color(0xFF000000),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(
          minHeight: 52.h,
          maxHeight: 52.h,
          minWidth: 46.w,
          maxWidth: 46.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: const Color.fromRGBO(16, 28, 22, 0.6),
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: AppColors.heading, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.5.w),
        ),
      ),
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.heading,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

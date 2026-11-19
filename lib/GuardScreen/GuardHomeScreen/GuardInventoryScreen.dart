// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';
// import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

// /// Guard: Society Inventory (sirf dekhna) + "kam hai / chahiye" request Association ko.
// /// Quantity Association website se badalti hai; ye screen har baar khulne / refresh par taaza data laati hai.
// class GuardInventoryScreen extends ConsumerStatefulWidget {
//   const GuardInventoryScreen({super.key});

//   @override
//   ConsumerState<GuardInventoryScreen> createState() =>
//       _GuardInventoryScreenState();
// }

// class _GuardInventoryScreenState extends ConsumerState<GuardInventoryScreen> {
//   static const _green = Color(0xFF24B06A);
//   static const _amber = Color(0xFF9A6B00);
//   static const _red = Color(0xFFDC2626);
//   static const _grey = Color(0xFF777777);

//   bool _loading = true;
//   String? _error;
//   List<Map<String, dynamic>> _items = [];
//   List<Map<String, dynamic>> _requests = [];
//   Map<String, dynamic> _summary = {};

//   int _tab = 0; // 0 = Items, 1 = My Requests
//   String _filter = "all"; // all | low | out
//   String _search = "";

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   static String _msg(Object e, String fallback) {
//     if (e is DioException) {
//       final d = e.response?.data;
//       if (d is Map && d["message"] != null) return d["message"].toString();
//       if (e.type == DioExceptionType.connectionError ||
//           e.type == DioExceptionType.connectionTimeout) {
//         return "No internet connection. Please try again.";
//       }
//     }
//     return fallback;
//   }

//   static List<Map<String, dynamic>> _list(dynamic raw) => raw is List
//       ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
//       : <Map<String, dynamic>>[];

//   static String _fmt(dynamic v) {
//     final n = v is num ? v : num.tryParse("${v ?? 0}") ?? 0;
//     return n == n.roundToDouble()
//         ? n.toInt().toString()
//         : n.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
//   }

//   Future<void> _load() async {
//     setState(() {
//       _loading = _items.isEmpty;
//       _error = null;
//     });
//     try {
//       final res = await ref.read(authServiceProvider).getGuardInventory();
//       if (!mounted) return;
//       if (res["status"] == false) {
//         setState(
//           () => _error = (res["message"] ?? "Could not load inventory.")
//               .toString(),
//         );
//         return;
//       }
//       setState(() {
//         _items = _list(res["data"]);
//         _requests = _list(res["my_requests"]);
//         _summary = res["summary"] is Map
//             ? Map<String, dynamic>.from(res["summary"])
//             : {};
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(
//         () => _error = _msg(
//           e,
//           "Could not load inventory. Pull down to try again.",
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   Color _statusColor(String? s) =>
//       s == "out" ? _red : (s == "low" ? _amber : _green);

//   List<Map<String, dynamic>> get _visibleItems {
//     final q = _search.trim().toLowerCase();
//     return _items.where((i) {
//       if (_filter != "all" && i["stock_status"] != _filter) return false;
//       if (q.isEmpty) return true;
//       return "${i["name"]} ${i["category_label"]} ${i["location"] ?? ""}"
//           .toLowerCase()
//           .contains(q);
//     }).toList();
//   }

//   // ------------------------------------------------------------------ Request sheet
//   Future<void> _openRequestSheet({Map<String, dynamic>? item}) async {
//     final sent = await showModalBottomSheet<bool>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
//       ),
//       builder: (ctx) => _RequestSheet(
//         item: item,
//         stockColor: _statusColor(item?["stock_status"]?.toString()),
//         fmt: _fmt,
//         onSend: (name, qty, message) async {
//           try {
//             final res = await ref
//                 .read(authServiceProvider)
//                 .sendInventoryRequest(
//                   itemId: item == null
//                       ? null
//                       : (item["id"] is int
//                             ? item["id"] as int
//                             : int.tryParse("${item["id"]}")),
//                   itemName: item == null ? name : null,
//                   quantity: qty,
//                   message: message,
//                 );
//             if (res["status"] == false) {
//               return (res["message"] ?? "Could not send the request.")
//                   .toString();
//             }
//             showSuccessSnackBar(
//               (res["message"] ?? "Request sent to the association.").toString(),
//             );
//             return null;
//           } catch (e) {
//             return _msg(e, "Could not send the request. Please try again.");
//           }
//         },
//       ),
//     );

//     if (sent == true && mounted) {
//       setState(() => _tab = 1);
//       _load();
//     }
//   }

//   // ------------------------------------------------------------------ UI
//   @override
//   Widget build(BuildContext context) {
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
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
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
//                       color: AppColors.heading,
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
//                         "Inventory",
//                         style: GoogleFonts.outfit(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.heading,
//                         ),
//                       ),
//                       SizedBox(height: 2.h),
//                       Text(
//                         "Society store stock · view only",
//                         style: GoogleFonts.outfit(
//                           fontSize: 14.sp,
//                           color: const Color.fromRGBO(42, 41, 51, 0.7),
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
//       body: _loading
//           ? const Center(
//               child: CircularProgressIndicator(color: AppColors.heading),
//             )
//           : RefreshIndicator(
//               color: AppColors.heading,
//               onRefresh: _load,
//               child: ListView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
//                 children: _error != null && _items.isEmpty && _requests.isEmpty
//                     ? [_errorBox()]
//                     : [
//                         _summaryRow(),
//                         SizedBox(height: 14.h),
//                         _tabs(),
//                         SizedBox(height: 14.h),
//                         if (_tab == 0) ..._itemsTab() else ..._requestsTab(),
//                       ],
//               ),
//             ),
//     );
//   }

//   Widget _errorBox() {
//     return Padding(
//       padding: EdgeInsets.only(top: 120.h),
//       child: Column(
//         children: [
//           Icon(Icons.cloud_off_outlined, size: 40.sp, color: _grey),
//           SizedBox(height: 10.h),
//           Text(
//             _error ?? "",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.outfit(fontSize: 16.sp, color: _grey),
//           ),
//           SizedBox(height: 10.h),
//           TextButton(
//             onPressed: _load,
//             child: Text(
//               "Retry",
//               style: GoogleFonts.outfit(
//                 fontSize: 16.sp,
//                 color: AppColors.heading,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryTile(
//     String label,
//     String value,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
//           ),
//           child: Column(
//             children: [
//               Text(
//                 value,
//                 style: GoogleFonts.outfit(
//                   fontSize: 22.sp,
//                   fontWeight: FontWeight.w600,
//                   color: color,
//                 ),
//               ),
//               SizedBox(height: 2.h),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.outfit(fontSize: 12.sp, color: _grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow() {
//     return Row(
//       children: [
//         _summaryTile(
//           "Low stock",
//           "${_summary["low_stock"] ?? 0}",
//           _amber,
//           () => setState(() {
//             _tab = 0;
//             _filter = "low";
//           }),
//         ),
//         SizedBox(width: 10.w),
//         _summaryTile(
//           "Out of stock",
//           "${_summary["out_of_stock"] ?? 0}",
//           _red,
//           () => setState(() {
//             _tab = 0;
//             _filter = "out";
//           }),
//         ),
//         SizedBox(width: 10.w),
//         _summaryTile(
//           "My pending\nrequests",
//           "${_summary["my_open_requests"] ?? 0}",
//           AppColors.heading,
//           () => setState(() => _tab = 1),
//         ),
//       ],
//     );
//   }

//   Widget _tabs() {
//     Widget tab(int i, String label) {
//       final on = _tab == i;
//       return Expanded(
//         child: GestureDetector(
//           onTap: () => setState(() => _tab = i),
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 10.h),
//             decoration: BoxDecoration(
//               color: on ? AppColors.heading : Colors.white,
//               borderRadius: BorderRadius.circular(8.r),
//               border: Border.all(
//                 color: AppColors.heading.withValues(alpha: 0.3),
//               ),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: GoogleFonts.outfit(
//                 fontSize: 15.sp,
//                 fontWeight: FontWeight.w500,
//                 color: on ? Colors.white : AppColors.heading,
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     return Row(
//       children: [
//         tab(0, "Items (${_items.length})"),
//         SizedBox(width: 10.w),
//         tab(1, "My Requests"),
//       ],
//     );
//   }

//   Widget _chip(String key, String label) {
//     final on = _filter == key;
//     return Padding(
//       padding: EdgeInsets.only(right: 8.w),
//       child: ChoiceChip(
//         label: Text(
//           label,
//           style: GoogleFonts.outfit(
//             fontSize: 14.sp,
//             color: on ? Colors.white : AppColors.heading,
//           ),
//         ),
//         selected: on,
//         showCheckmark: false,
//         selectedColor: AppColors.heading,
//         backgroundColor: Colors.white,
//         side: BorderSide(color: AppColors.heading.withValues(alpha: 0.25)),
//         onSelected: (_) => setState(() => _filter = key),
//       ),
//     );
//   }

//   List<Widget> _itemsTab() {
//     final list = _visibleItems;
//     return [
//       TextField(
//         onChanged: (v) => setState(() => _search = v),
//         decoration: InputDecoration(
//           hintText: "Search item",
//           hintStyle: GoogleFonts.outfit(
//             fontSize: 15.sp,
//             color: const Color(0x66101C16),
//           ),
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: EdgeInsets.symmetric(vertical: 10.h),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.r),
//             borderSide: const BorderSide(color: Color(0x33101C16)),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.r),
//             borderSide: const BorderSide(color: Color(0x33101C16)),
//           ),
//         ),
//       ),
//       SizedBox(height: 10.h),
//       SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _chip("all", "All"),
//             _chip("low", "Low stock"),
//             _chip("out", "Out of stock"),
//           ],
//         ),
//       ),
//       SizedBox(height: 8.h),
//       OutlinedButton.icon(
//         onPressed: () => _openRequestSheet(),
//         icon: const Icon(Icons.add, color: AppColors.heading),
//         label: Text(
//           "Need something not in the list?",
//           style: GoogleFonts.outfit(fontSize: 15.sp, color: AppColors.heading),
//         ),
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(color: AppColors.heading.withValues(alpha: 0.4)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//         ),
//       ),
//       SizedBox(height: 8.h),
//       if (list.isEmpty)
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 40.h),
//           child: Column(
//             children: [
//               Icon(
//                 Icons.inventory_2_outlined,
//                 size: 40.sp,
//                 color: const Color(0x33101C16),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 _items.isEmpty
//                     ? "The association has not added any items yet."
//                     : "No item matches.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.outfit(fontSize: 15.sp, color: _grey),
//               ),
//             ],
//           ),
//         )
//       else
//         ...list.map(_itemCard),
//     ];
//   }

//   Widget _badge(String text, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(70.r),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.outfit(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w500,
//           color: color,
//         ),
//       ),
//     );
//   }

//   Widget _itemCard(Map<String, dynamic> i) {
//     final status = i["stock_status"]?.toString();
//     final color = _statusColor(status);
//     final requested = i["my_open_request"] == true;
//     final sub = [
//       i["category_label"],
//       if ((i["location"] ?? "").toString().isNotEmpty) i["location"],
//     ].join(" · ");

//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       padding: EdgeInsets.all(14.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: status == "ok"
//               ? const Color.fromRGBO(0, 0, 0, 0.12)
//               : color.withValues(alpha: 0.45),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${i["name"] ?? ""}",
//                       style: GoogleFonts.outfit(
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.heading,
//                       ),
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       sub,
//                       style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
//                     ),
//                     SizedBox(height: 6.h),
//                     Wrap(
//                       spacing: 6.w,
//                       runSpacing: 4.h,
//                       children: [
//                         _badge("${i["stock_status_label"] ?? ""}", color),
//                         if (requested) _badge("Requested", AppColors.heading),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     _fmt(i["quantity"]),
//                     style: GoogleFonts.outfit(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.w600,
//                       color: color,
//                     ),
//                   ),
//                   Text(
//                     "${i["unit"] ?? ""}",
//                     style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 10.h),
//           SizedBox(
//             width: double.infinity,
//             height: 40.h,
//             child: OutlinedButton(
//               onPressed: () => _openRequestSheet(item: i),
//               style: OutlinedButton.styleFrom(
//                 side: BorderSide(
//                   color: status == "ok"
//                       ? AppColors.heading.withValues(alpha: 0.3)
//                       : color,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               child: Text(
//                 requested
//                     ? "Update my request"
//                     : (status == "ok"
//                           ? "Request more"
//                           : "Alert association - stock low"),
//                 style: GoogleFonts.outfit(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                   color: status == "ok" ? AppColors.heading : color,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _requestsTab() {
//     if (_requests.isEmpty) {
//       return [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 40.h),
//           child: Text(
//             "You have not sent any request yet.\nTap \"Alert association\" on a low item to send one.",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.outfit(fontSize: 15.sp, color: _grey),
//           ),
//         ),
//       ];
//     }
//     return _requests.map((r) {
//       final st = r["status"]?.toString();
//       final color = st == "resolved"
//           ? _green
//           : (st == "rejected" ? _grey : _amber);
//       return Container(
//         margin: EdgeInsets.only(bottom: 10.h),
//         padding: EdgeInsets.all(14.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "${r["item_name"] ?? ""}",
//                     style: GoogleFonts.outfit(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                 ),
//                 _badge("${r["status_label"] ?? ""}", color),
//               ],
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               [
//                 if (r["requested_label"] != null)
//                   "Asked: ${r["requested_label"]}",
//                 if (r["current_label"] != null)
//                   "In stock now: ${r["current_label"]}",
//               ].join(" · "),
//               style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
//             ),
//             if ((r["message"] ?? "").toString().isNotEmpty) ...[
//               SizedBox(height: 4.h),
//               Text(
//                 "“${r["message"]}”",
//                 style: GoogleFonts.outfit(
//                   fontSize: 14.sp,
//                   color: AppColors.heading,
//                 ),
//               ),
//             ],
//             if ((r["response_note"] ?? "").toString().isNotEmpty) ...[
//               SizedBox(height: 6.h),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(10.w),
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.08),
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Text(
//                   "Association: ${r["response_note"]}",
//                   style: GoogleFonts.outfit(
//                     fontSize: 13.sp,
//                     color: AppColors.heading,
//                   ),
//                 ),
//               ),
//             ],
//             SizedBox(height: 6.h),
//             Text(
//               "Sent ${r["requested_at"] ?? ""}${st != "open" && r["resolved_at"] != null ? " · Closed ${r["resolved_at"]}" : ""}",
//               style: GoogleFonts.outfit(fontSize: 12.sp, color: _grey),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
// }

// /// Request bhejne ka bottom sheet (apne text controllers khud sambhalta hai)
// class _RequestSheet extends StatefulWidget {
//   const _RequestSheet({
//     required this.item,
//     required this.stockColor,
//     required this.fmt,
//     required this.onSend,
//   });

//   final Map<String, dynamic>? item;
//   final Color stockColor;
//   final String Function(dynamic) fmt;

//   /// null = bhej diya; warna galti ka message
//   final Future<String?> Function(String name, num? quantity, String message)
//   onSend;

//   @override
//   State<_RequestSheet> createState() => _RequestSheetState();
// }

// class _RequestSheetState extends State<_RequestSheet> {
//   final _nameCtrl = TextEditingController();
//   final _qtyCtrl = TextEditingController();
//   final _msgCtrl = TextEditingController();
//   bool _sending = false;
//   String? _error;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _qtyCtrl.dispose();
//     _msgCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _send() async {
//     final item = widget.item;
//     final name = _nameCtrl.text.trim();
//     if (item == null && name.length < 2) {
//       setState(() => _error = "Please enter the item name.");
//       return;
//     }
//     final qtyText = _qtyCtrl.text.trim();
//     final qty = qtyText.isEmpty ? null : num.tryParse(qtyText);
//     if (qtyText.isNotEmpty && (qty == null || qty <= 0)) {
//       setState(() => _error = "Please enter a valid quantity.");
//       return;
//     }
//     setState(() {
//       _sending = true;
//       _error = null;
//     });
//     final err = await widget.onSend(name, qty, _msgCtrl.text);
//     if (!mounted) return;
//     if (err != null) {
//       setState(() {
//         _sending = false;
//         _error = err;
//       });
//       return;
//     }
//     Navigator.pop(context, true);
//   }

//   InputDecoration _deco(String hint) => InputDecoration(
//     hintText: hint,
//     hintStyle: GoogleFonts.outfit(
//       fontSize: 15.sp,
//       color: const Color(0x66101C16),
//     ),
//     contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8.r),
//       borderSide: const BorderSide(color: Color(0x66101C16)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8.r),
//       borderSide: const BorderSide(color: AppColors.heading),
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     final item = widget.item;
//     const grey = Color(0xFF777777);
//     final label = GoogleFonts.outfit(
//       fontSize: 14.sp,
//       fontWeight: FontWeight.w500,
//       color: AppColors.heading,
//     );

//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20.w,
//         right: 20.w,
//         top: 18.h,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     item == null
//                         ? "Request a new item"
//                         : "Request: ${item["name"]}",
//                     style: GoogleFonts.outfit(
//                       fontSize: 19.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context, false),
//                   icon: const Icon(Icons.close),
//                 ),
//               ],
//             ),
//             Text(
//               "The association will get your message. They buy the items and update the stock.",
//               style: GoogleFonts.outfit(fontSize: 14.sp, color: grey),
//             ),
//             SizedBox(height: 14.h),
//             if (item != null)
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF7F5EF),
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       "In stock now",
//                       style: GoogleFonts.outfit(fontSize: 14.sp, color: grey),
//                     ),
//                     const Spacer(),
//                     Text(
//                       "${widget.fmt(item["quantity"])} ${item["unit"] ?? ""}",
//                       style: GoogleFonts.outfit(
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w600,
//                         color: widget.stockColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else ...[
//               Text("Item name *", style: label),
//               SizedBox(height: 6.h),
//               TextField(
//                 controller: _nameCtrl,
//                 maxLength: 100,
//                 textCapitalization: TextCapitalization.sentences,
//                 decoration: _deco("e.g. Torch battery"),
//               ),
//             ],
//             SizedBox(height: 12.h),
//             Text("How many needed? (optional)", style: label),
//             SizedBox(height: 6.h),
//             TextField(
//               controller: _qtyCtrl,
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
//               ],
//               decoration: _deco(
//                 item == null ? "e.g. 10" : "e.g. 10 ${item["unit"] ?? ""}",
//               ),
//             ),
//             SizedBox(height: 12.h),
//             Text("Message (optional)", style: label),
//             SizedBox(height: 6.h),
//             TextField(
//               controller: _msgCtrl,
//               maxLength: 500,
//               maxLines: 3,
//               minLines: 2,
//               textCapitalization: TextCapitalization.sentences,
//               decoration: _deco(
//                 "e.g. Gate light is not working, bulbs finished",
//               ),
//             ),
//             if (_error != null) ...[
//               SizedBox(height: 4.h),
//               Text(
//                 _error!,
//                 style: GoogleFonts.outfit(
//                   fontSize: 14.sp,
//                   color: const Color(0xFFDC2626),
//                 ),
//               ),
//             ],
//             SizedBox(height: 12.h),
//             SizedBox(
//               width: double.infinity,
//               height: 48.h,
//               child: ElevatedButton(
//                 onPressed: _sending ? null : _send,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.heading,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                 ),
//                 child: _sending
//                     ? SizedBox(
//                         width: 20.w,
//                         height: 20.w,
//                         child: const CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Text(
//                         "Send to Association",
//                         style: GoogleFonts.outfit(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

/// Guard: Society Inventory (sirf dekhna) + "kam hai / chahiye" request Association ko.
/// Quantity Association website se badalti hai; ye screen har baar khulne / refresh par taaza data laati hai.
class GuardInventoryScreen extends ConsumerStatefulWidget {
  const GuardInventoryScreen({super.key});

  @override
  ConsumerState<GuardInventoryScreen> createState() =>
      _GuardInventoryScreenState();
}

class _GuardInventoryScreenState extends ConsumerState<GuardInventoryScreen> {
  static const _green = Color(0xFF24B06A);
  static const _amber = Color(0xFF9A6B00);
  static const _red = Color(0xFFDC2626);
  static const _grey = Color(0xFF777777);

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _requests = [];
  Map<String, dynamic> _summary = {};

  int _tab = 0; // 0 = Items, 1 = My Requests
  String _filter = "all"; // all | low | out
  String _search = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  static String _msg(Object e, String fallback) {
    if (e is DioException) {
      final d = e.response?.data;
      if (d is Map && d["message"] != null) return d["message"].toString();
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return "No internet connection. Please try again.";
      }
    }
    return fallback;
  }

  static List<Map<String, dynamic>> _list(dynamic raw) => raw is List
      ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
      : <Map<String, dynamic>>[];

  static String _fmt(dynamic v) {
    final n = v is num ? v : num.tryParse("${v ?? 0}") ?? 0;
    return n == n.roundToDouble()
        ? n.toInt().toString()
        : n.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '');
  }

  Future<void> _load() async {
    setState(() {
      _loading = _items.isEmpty;
      _error = null;
    });
    try {
      final res = await ref.read(authServiceProvider).getGuardInventory();
      if (!mounted) return;
      if (res["status"] == false) {
        setState(
          () => _error = (res["message"] ?? "Could not load inventory.")
              .toString(),
        );
        return;
      }
      setState(() {
        _items = _list(res["data"]);
        _requests = _list(res["my_requests"]);
        _summary = res["summary"] is Map
            ? Map<String, dynamic>.from(res["summary"])
            : {};
      });
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _error = _msg(
          e,
          "Could not load inventory. Pull down to try again.",
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _statusColor(String? s) =>
      s == "out" ? _red : (s == "low" ? _amber : _green);

  List<Map<String, dynamic>> get _visibleItems {
    final q = _search.trim().toLowerCase();
    return _items.where((i) {
      if (_filter != "all" && i["stock_status"] != _filter) return false;
      if (q.isEmpty) return true;
      return "${i["name"]} ${i["category_label"]} ${i["location"] ?? ""}"
          .toLowerCase()
          .contains(q);
    }).toList();
  }

  // ------------------------------------------------------------------ Request sheet
  Future<void> _openRequestSheet({Map<String, dynamic>? item}) async {
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (ctx) => _RequestSheet(
        item: item,
        stockColor: _statusColor(item?["stock_status"]?.toString()),
        fmt: _fmt,
        onSend: (name, qty, message) async {
          try {
            final res = await ref
                .read(authServiceProvider)
                .sendInventoryRequest(
                  itemId: item == null
                      ? null
                      : (item["id"] is int
                            ? item["id"] as int
                            : int.tryParse("${item["id"]}")),
                  itemName: item == null ? name : null,
                  quantity: qty,
                  message: message,
                );
            if (res["status"] == false) {
              return (res["message"] ?? "Could not send the request.")
                  .toString();
            }
            showSuccessSnackBar(
              (res["message"] ?? "Request sent to the association.").toString(),
            );
            return null;
          } catch (e) {
            return _msg(e, "Could not send the request. Please try again.");
          }
        },
      ),
    );

    if (sent == true && mounted) {
      setState(() => _tab = 1);
      _load();
    }
  }

  // ------------------------------------------------------------------ UI
  @override
  Widget build(BuildContext context) {
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
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                      color: AppColors.heading,
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
                        "Inventory",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Society store stock · view only",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.7),
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.heading),
            )
          : RefreshIndicator(
              color: AppColors.heading,
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
                children: _error != null && _items.isEmpty && _requests.isEmpty
                    ? [_errorBox()]
                    : [
                        _summaryRow(),
                        SizedBox(height: 14.h),
                        _tabs(),
                        SizedBox(height: 14.h),
                        if (_tab == 0) ..._itemsTab() else ..._requestsTab(),
                      ],
              ),
            ),
    );
  }

  Widget _errorBox() {
    return Padding(
      padding: EdgeInsets.only(top: 120.h),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 40.sp, color: _grey),
          SizedBox(height: 10.h),
          Text(
            _error ?? "",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 16.sp, color: _grey),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: _load,
            child: Text(
              "Retry",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(
    String label,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 12.sp, color: _grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow() {
    return Row(
      children: [
        _summaryTile(
          "Low stock",
          "${_summary["low_stock"] ?? 0}",
          _amber,
          () => setState(() {
            _tab = 0;
            _filter = "low";
          }),
        ),
        SizedBox(width: 10.w),
        _summaryTile(
          "Out of stock",
          "${_summary["out_of_stock"] ?? 0}",
          _red,
          () => setState(() {
            _tab = 0;
            _filter = "out";
          }),
        ),
        SizedBox(width: 10.w),
        _summaryTile(
          "My pending\nrequests",
          "${_summary["my_open_requests"] ?? 0}",
          AppColors.heading,
          () => setState(() => _tab = 1),
        ),
      ],
    );
  }

  Widget _tabs() {
    Widget tab(int i, String label) {
      final on = _tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: on ? AppColors.heading : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.heading.withValues(alpha: 0.3),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: on ? Colors.white : AppColors.heading,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab(0, "Items (${_items.length})"),
        SizedBox(width: 10.w),
        tab(1, "My Requests"),
      ],
    );
  }

  Widget _chip(String key, String label) {
    final on = _filter == key;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: on ? Colors.white : AppColors.heading,
          ),
        ),
        selected: on,
        showCheckmark: false,
        selectedColor: AppColors.heading,
        backgroundColor: Colors.white,
        side: BorderSide(color: AppColors.heading.withValues(alpha: 0.25)),
        onSelected: (_) => setState(() => _filter = key),
      ),
    );
  }

  List<Widget> _itemsTab() {
    final list = _visibleItems;
    return [
      TextField(
        onChanged: (v) => setState(() => _search = v),
        decoration: InputDecoration(
          hintText: "Search item",
          hintStyle: GoogleFonts.outfit(
            fontSize: 15.sp,
            color: const Color(0x66101C16),
          ),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Color(0x33101C16)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Color(0x33101C16)),
          ),
        ),
      ),
      SizedBox(height: 10.h),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip("all", "All"),
            _chip("low", "Low stock"),
            _chip("out", "Out of stock"),
          ],
        ),
      ),
      SizedBox(height: 8.h),
      OutlinedButton.icon(
        onPressed: () => _openRequestSheet(),
        icon: const Icon(Icons.add, color: AppColors.heading),
        label: Text(
          "Need something not in the list?",
          style: GoogleFonts.outfit(fontSize: 15.sp, color: AppColors.heading),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.heading.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
      SizedBox(height: 8.h),
      if (list.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 40.sp,
                color: const Color(0x33101C16),
              ),
              SizedBox(height: 8.h),
              Text(
                _items.isEmpty
                    ? "The association has not added any items yet."
                    : "No item matches.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 15.sp, color: _grey),
              ),
            ],
          ),
        )
      else
        ...list.map(_itemCard),
    ];
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(70.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _itemCard(Map<String, dynamic> i) {
    final status = i["stock_status"]?.toString();
    final color = _statusColor(status);
    final requested = i["my_open_request"] == true;
    final sub = [
      i["category_label"],
      if ((i["location"] ?? "").toString().isNotEmpty) i["location"],
    ].join(" · ");

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: status == "ok"
              ? const Color.fromRGBO(0, 0, 0, 0.12)
              : color.withValues(alpha: 0.45),
        ),
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
                      "${i["name"] ?? ""}",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      sub,
                      style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        _badge("${i["stock_status_label"] ?? ""}", color),
                        if (requested) _badge("Requested", AppColors.heading),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(i["quantity"]),
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    "${i["unit"] ?? ""}",
                    style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: OutlinedButton(
              onPressed: () => _openRequestSheet(item: i),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: status == "ok"
                      ? AppColors.heading.withValues(alpha: 0.3)
                      : color,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                requested
                    ? "Update my request"
                    : (status == "ok"
                          ? "Request more"
                          : "Alert association - stock low"),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: status == "ok" ? AppColors.heading : color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _requestsTab() {
    if (_requests.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            "You have not sent any request yet.\nTap \"Alert association\" on a low item to send one.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 15.sp, color: _grey),
          ),
        ),
      ];
    }
    return _requests.map((r) {
      final st = r["status"]?.toString();
      final color = st == "resolved"
          ? _green
          : (st == "rejected" ? _grey : _amber);
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${r["item_name"] ?? ""}",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                _badge("${r["status_label"] ?? ""}", color),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              [
                if (r["requested_label"] != null)
                  "Asked: ${r["requested_label"]}",
                if (r["current_label"] != null)
                  "In stock now: ${r["current_label"]}",
              ].join(" · "),
              style: GoogleFonts.outfit(fontSize: 13.sp, color: _grey),
            ),
            if ((r["message"] ?? "").toString().isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                "“${r["message"]}”",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: AppColors.heading,
                ),
              ),
            ],
            if ((r["response_note"] ?? "").toString().isNotEmpty) ...[
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Association: ${r["response_note"]}",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
            SizedBox(height: 6.h),
            Text(
              "Sent ${r["requested_at"] ?? ""}${st != "open" && r["resolved_at"] != null ? " · Closed ${r["resolved_at"]}" : ""}",
              style: GoogleFonts.outfit(fontSize: 12.sp, color: _grey),
            ),
          ],
        ),
      );
    }).toList();
  }
}

/// Request bhejne ka bottom sheet (apne text controllers khud sambhalta hai)
class _RequestSheet extends StatefulWidget {
  const _RequestSheet({
    required this.item,
    required this.stockColor,
    required this.fmt,
    required this.onSend,
  });

  final Map<String, dynamic>? item;
  final Color stockColor;
  final String Function(dynamic) fmt;

  /// null = bhej diya; warna galti ka message
  final Future<String?> Function(String name, num? quantity, String message)
  onSend;

  @override
  State<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<_RequestSheet> {
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final item = widget.item;
    final name = _nameCtrl.text.trim();
    if (item == null && name.length < 2) {
      setState(() => _error = "Please enter the item name.");
      return;
    }
    final qtyText = _qtyCtrl.text.trim();
    final qty = qtyText.isEmpty ? null : num.tryParse(qtyText);
    if (qtyText.isNotEmpty && (qty == null || qty <= 0)) {
      setState(() => _error = "Please enter a valid quantity.");
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    final err = await widget.onSend(name, qty, _msgCtrl.text);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _sending = false;
        _error = err;
      });
      return;
    }
    Navigator.pop(context, true);
  }

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.outfit(
      fontSize: 15.sp,
      color: const Color(0x66101C16),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Color(0x66101C16)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.heading),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    const grey = Color(0xFF777777);
    final label = GoogleFonts.outfit(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.heading,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 18.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item == null
                        ? "Request a new item"
                        : "Request: ${item["name"]}",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Text(
              "The association will get your message. They buy the items and update the stock.",
              style: GoogleFonts.outfit(fontSize: 14.sp, color: grey),
            ),
            SizedBox(height: 14.h),
            if (item != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5EF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Text(
                      "In stock now",
                      style: GoogleFonts.outfit(fontSize: 14.sp, color: grey),
                    ),
                    const Spacer(),
                    Text(
                      "${widget.fmt(item["quantity"])} ${item["unit"] ?? ""}",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.stockColor,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Text("Item name *", style: label),
              SizedBox(height: 6.h),
              TextField(
                controller: _nameCtrl,
                maxLength: 100,
                textCapitalization: TextCapitalization.sentences,
                decoration: _deco("e.g. Torch battery"),
              ),
            ],
            SizedBox(height: 12.h),
            Text("How many needed? (optional)", style: label),
            SizedBox(height: 6.h),
            TextField(
              controller: _qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: _deco(
                item == null ? "e.g. 10" : "e.g. 10 ${item["unit"] ?? ""}",
              ),
            ),
            SizedBox(height: 12.h),
            Text("Message (optional)", style: label),
            SizedBox(height: 6.h),
            TextField(
              controller: _msgCtrl,
              maxLength: 500,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: _deco(
                "e.g. Gate light is not working, bulbs finished",
              ),
            ),
            if (_error != null) ...[
              SizedBox(height: 4.h),
              Text(
                _error!,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.heading,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _sending
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Send to Association",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

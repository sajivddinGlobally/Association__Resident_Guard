// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestDetailsProvider.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestProvider.dart';
// import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestStatusProvider.dart';
// import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
// import 'package:property_association_or_resident/Core/Constant/appColor.dart';
// import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
// import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestDetailsModel.dart';

// /// Association: Service Request manage karna (naya flow)
// ///   Submitted -> Vendor Assigned -> In Progress -> Completed (resident) -> Closed (association)
// /// Kaun sa button dikhega ye backend `actions` batata hai. Charges ka koi record nahi.
// class SrActionsPanel extends ConsumerStatefulWidget {
//   final String ticketId;
//   final SrActions actions;

//   const SrActionsPanel({
//     super.key,
//     required this.ticketId,
//     required this.actions,
//   });

//   @override
//   ConsumerState<SrActionsPanel> createState() => _SrActionsPanelState();
// }

// class _SrActionsPanelState extends ConsumerState<SrActionsPanel> {
//   static const List<String> _steps = [
//     "Submitted",
//     "Vendor Assigned",
//     "In Progress",
//     "Completed",
//     "Closed",
//   ];

//   int? _vendorId;
//   String _busy = ""; // vendor / in_progress / resolved / closed

//   @override
//   void initState() {
//     super.initState();
//     _vendorId = widget.actions.assignedVendorId;
//   }

//   @override
//   void didUpdateWidget(covariant SrActionsPanel oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.actions.assignedVendorId != widget.actions.assignedVendorId) {
//       _vendorId = widget.actions.assignedVendorId;
//     }
//   }

//   void _refreshAll() {
//     ref.invalidate(getServiceRequestDetailsProvider(widget.ticketId));
//     ref.invalidate(getServiceRequestStatusProvider(widget.ticketId));
//     ref.invalidate(getServiceRequestProvider);
//   }

//   Future<void> _assignVendor() async {
//     if (_vendorId == null) {
//       showErrorSnackBar("Please select a vendor");
//       return;
//     }
//     if (_busy.isNotEmpty) return;
//     setState(() => _busy = "vendor");
//     try {
//       final res = await ref
//           .read(authServiceProvider)
//           .assignServiceRequestVendor(id: widget.ticketId, vendorId: _vendorId!);
//       if (res['status'] == true) {
//         showSuccessSnackBar(res['message']?.toString() ?? "Vendor assigned");
//         _refreshAll();
//       } else {
//         showErrorSnackBar(res['message']?.toString() ?? "Failed to assign vendor");
//       }
//     } on DioException catch (_) {
//       // Error message interceptor already dikha deta hai
//     } catch (_) {
//       showErrorSnackBar("Failed to assign vendor");
//     } finally {
//       if (mounted) setState(() => _busy = "");
//     }
//   }

//   Future<void> _updateStatus(String status, String confirmText) async {
//     if (_busy.isNotEmpty) return;
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: AppColors.scaffoldBg,
//         content: Text(
//           confirmText,
//           style: GoogleFonts.outfit(fontSize: 15.sp, color: AppColors.heading),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: Text("Cancel", style: GoogleFonts.outfit(color: AppColors.heading)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: Text(
//               "Yes",
//               style: GoogleFonts.outfit(color: AppColors.heading, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
//       ),
//     );
//     if (ok != true || !mounted) return;

//     setState(() => _busy = status);
//     try {
//       final res = await ref
//           .read(authServiceProvider)
//           .updateServiceRequestStatus(id: widget.ticketId, status: status);
//       if (res['status'] == true) {
//         showSuccessSnackBar(res['message']?.toString() ?? "Status updated");
//         _refreshAll();
//       } else {
//         showErrorSnackBar(res['message']?.toString() ?? "Failed to update status");
//       }
//     } on DioException catch (_) {
//       // Error message interceptor already dikha deta hai
//     } catch (_) {
//       showErrorSnackBar("Failed to update status");
//     } finally {
//       if (mounted) setState(() => _busy = "");
//     }
//   }

//   Widget _button({
//     required String label,
//     required IconData icon,
//     required String busyKey,
//     required VoidCallback? onTap,
//     bool filled = true,
//     Color color = AppColors.heading,
//   }) {
//     final isBusy = _busy == busyKey;
//     return SizedBox(
//       width: double.infinity,
//       height: 46.h,
//       child: ElevatedButton(
//         onPressed: (_busy.isNotEmpty || onTap == null) ? null : onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: filled ? color : Colors.transparent,
//           foregroundColor: filled ? Colors.white : color,
//           disabledBackgroundColor: filled ? color.withOpacity(0.5) : Colors.transparent,
//           elevation: 0,
//           side: filled ? null : BorderSide(color: color, width: 1.2),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
//         ),
//         child: isBusy
//             ? SizedBox(
//                 width: 18.w,
//                 height: 18.w,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 1.8,
//                   color: filled ? Colors.white : color,
//                 ),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: 18.sp),
//                   SizedBox(width: 6.w),
//                   Text(
//                     label,
//                     style: GoogleFonts.outfit(fontSize: 15.sp, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final a = widget.actions;
//     final int step = (a.step ?? 1).clamp(1, _steps.length).toInt();
//     final vendors = a.vendorOptions.where((v) => v.id != null).toList();
//     final selectedValid = vendors.any((v) => v.id == _vendorId);
//     final vendorChanged = _vendorId != null && _vendorId != a.assignedVendorId;

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(14.w),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFF000000), width: 1.w),
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   "Manage Request",
//                   style: GoogleFonts.outfit(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.heading,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                 decoration: BoxDecoration(
//                   color: step >= 4
//                       ? const Color.fromRGBO(36, 176, 106, 0.2)
//                       : const Color.fromRGBO(184, 134, 11, 0.25),
//                   borderRadius: BorderRadius.circular(40.r),
//                 ),
//                 child: Text(
//                   a.statusLabel ?? _steps[step - 1],
//                   style: GoogleFonts.outfit(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w700,
//                     color: step >= 4 ? const Color(0xFF24B06A) : const Color(0xFF8A6508),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           // 5-step progress
//           Row(
//             children: List.generate(_steps.length, (i) {
//               final done = i < step;
//               return Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(right: i == _steps.length - 1 ? 0 : 4.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 5.h,
//                         decoration: BoxDecoration(
//                           color: done ? AppColors.heading : const Color.fromRGBO(16, 28, 22, 0.12),
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       Text(
//                         _steps[i],
//                         maxLines: 2,
//                         style: GoogleFonts.outfit(
//                           fontSize: 9.5.sp,
//                           height: 1.1,
//                           color: done ? AppColors.heading : const Color.fromRGBO(16, 28, 22, 0.45),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//           if ((a.hint ?? "").isNotEmpty) ...[
//             SizedBox(height: 12.h),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(10.w),
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(255, 242, 165, 0.45),
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               child: Text(
//                 a.hint!,
//                 style: GoogleFonts.outfit(
//                   fontSize: 12.5.sp,
//                   color: const Color(0xFF6B5829),
//                   height: 1.3,
//                 ),
//               ),
//             ),
//           ],
//           if (a.canAssignVendor) ...[
//             SizedBox(height: 14.h),
//             Text(
//               a.hasVendor ? "CHANGE VENDOR" : "ASSIGN VENDOR",
//               style: GoogleFonts.outfit(
//                 fontSize: 11.5.sp,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.heading,
//                 letterSpacing: 0.2,
//               ),
//             ),
//             SizedBox(height: 6.h),
//             if (vendors.isEmpty)
//               Text(
//                 "No active vendor in your society. Please ask the Admin to add a vendor.",
//                 style: GoogleFonts.outfit(fontSize: 12.5.sp, color: Colors.red.shade700),
//               )
//             else ...[
//               DropdownButtonFormField<int>(
//                 value: selectedValid ? _vendorId : null,
//                 isExpanded: true,
//                 dropdownColor: AppColors.scaffoldBg,
//                 hint: Text(
//                   "Select vendor",
//                   style: GoogleFonts.outfit(
//                     fontSize: 13.5.sp,
//                     color: const Color.fromRGBO(16, 28, 22, 0.4),
//                   ),
//                 ),
//                 style: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.heading),
//                 items: vendors
//                     .map((v) => DropdownMenuItem<int>(
//                           value: v.id,
//                           child: Text(
//                             v.label ?? v.name ?? "Vendor",
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: _busy.isNotEmpty ? null : (v) => setState(() => _vendorId = v),
//                 decoration: InputDecoration(
//                   isDense: true,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(6.r),
//                     borderSide: const BorderSide(color: Color.fromRGBO(16, 28, 22, 0.6)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               _button(
//                 label: a.hasVendor ? "Change Vendor" : "Assign Vendor",
//                 icon: Icons.engineering_outlined,
//                 busyKey: "vendor",
//                 onTap: vendorChanged ? _assignVendor : null,
//               ),
//             ],
//           ],
//           if (a.canMarkInProgress) ...[
//             SizedBox(height: 10.h),
//             _button(
//               label: "Mark In Progress",
//               icon: Icons.play_circle_outline,
//               busyKey: "in_progress",
//               filled: false,
//               color: const Color(0xFF1E5993),
//               onTap: () => _updateStatus(
//                 "in_progress",
//                 "Mark this service request In Progress? The resident will then be able to mark it Completed.",
//               ),
//             ),
//           ],
//           if (a.canMarkCompleted) ...[
//             SizedBox(height: 10.h),
//             _button(
//               label: "Mark Completed",
//               icon: Icons.check_circle_outline,
//               busyKey: "resolved",
//               filled: false,
//               color: const Color(0xFF24B06A),
//               onTap: () => _updateStatus("resolved", "Mark this service request Completed?"),
//             ),
//           ],
//           if (a.canClose) ...[
//             SizedBox(height: 10.h),
//             _button(
//               label: "Close Request",
//               icon: Icons.lock_outline,
//               busyKey: "closed",
//               color: const Color(0xFF24B06A),
//               onTap: () => _updateStatus(
//                 "closed",
//                 "Close this service request? This cannot be undone.",
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestDetailsProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestStatusProvider.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestDetailsModel.dart';

/// Association: Service Request / Society Complaint manage karna
///   Service Request: Submitted -> Vendor Assigned -> In Progress -> Completed (resident) -> Closed (association)
///   Complaint (actions.kind = "complaint"): Submitted -> Vendor Assigned -> In Progress -> Resolved -> Closed (sab association)
/// Kaun sa button dikhega ye backend `actions` batata hai.
class SrActionsPanel extends ConsumerStatefulWidget {
  final String ticketId;
  final SrActions actions;

  /// Update ke baad screen refresh (complaint screen deti hai). Na ho to Service Request providers refresh.
  final VoidCallback? onUpdated;

  const SrActionsPanel({
    super.key,
    required this.ticketId,
    required this.actions,
    this.onUpdated,
  });

  @override
  ConsumerState<SrActionsPanel> createState() => _SrActionsPanelState();
}

class _SrActionsPanelState extends ConsumerState<SrActionsPanel> {
  static const List<String> _steps = [
    "Submitted",
    "Vendor Assigned",
    "In Progress",
    "Completed",
    "Closed",
  ];

  int? _vendorId;
  String _busy = ""; // vendor / in_progress / resolved / closed

  @override
  void initState() {
    super.initState();
    _vendorId = widget.actions.assignedVendorId;
  }

  @override
  void didUpdateWidget(covariant SrActionsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actions.assignedVendorId != widget.actions.assignedVendorId) {
      _vendorId = widget.actions.assignedVendorId;
    }
  }

  void _refreshAll() {
    if (widget.onUpdated != null) {
      widget.onUpdated!();
      return;
    }
    ref.invalidate(getServiceRequestDetailsProvider(widget.ticketId));
    ref.invalidate(getServiceRequestStatusProvider(widget.ticketId));
    ref.invalidate(getServiceRequestProvider);
  }

  Future<void> _assignVendor() async {
    if (_vendorId == null) {
      showErrorSnackBar("Please select a vendor");
      return;
    }
    if (_busy.isNotEmpty) return;
    setState(() => _busy = "vendor");
    try {
      final service = ref.read(authServiceProvider);
      final res = widget.actions.isComplaint
          ? await service.assignComplaintVendor(id: widget.ticketId, vendorId: _vendorId!)
          : await service.assignServiceRequestVendor(id: widget.ticketId, vendorId: _vendorId!);
      if (res['status'] == true) {
        showSuccessSnackBar(res['message']?.toString() ?? "Vendor assigned");
        _refreshAll();
      } else {
        showErrorSnackBar(res['message']?.toString() ?? "Failed to assign vendor");
      }
    } on DioException catch (_) {
      // Error message interceptor already dikha deta hai
    } catch (_) {
      showErrorSnackBar("Failed to assign vendor");
    } finally {
      if (mounted) setState(() => _busy = "");
    }
  }

  Future<void> _updateStatus(String status, String confirmText) async {
    if (_busy.isNotEmpty) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBg,
        content: Text(
          confirmText,
          style: GoogleFonts.outfit(fontSize: 15.sp, color: AppColors.heading),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel", style: GoogleFonts.outfit(color: AppColors.heading)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              "Yes",
              style: GoogleFonts.outfit(color: AppColors.heading, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = status);
    try {
      final res = await ref
          .read(authServiceProvider)
          .updateServiceRequestStatus(id: widget.ticketId, status: status);
      if (res['status'] == true) {
        showSuccessSnackBar(res['message']?.toString() ?? "Status updated");
        _refreshAll();
      } else {
        showErrorSnackBar(res['message']?.toString() ?? "Failed to update status");
      }
    } on DioException catch (_) {
      // Error message interceptor already dikha deta hai
    } catch (_) {
      showErrorSnackBar("Failed to update status");
    } finally {
      if (mounted) setState(() => _busy = "");
    }
  }

  Widget _button({
    required String label,
    required IconData icon,
    required String busyKey,
    required VoidCallback? onTap,
    bool filled = true,
    Color color = AppColors.heading,
  }) {
    final isBusy = _busy == busyKey;
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        onPressed: (_busy.isNotEmpty || onTap == null) ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? color : Colors.transparent,
          foregroundColor: filled ? Colors.white : color,
          disabledBackgroundColor: filled ? color.withOpacity(0.5) : Colors.transparent,
          elevation: 0,
          side: filled ? null : BorderSide(color: color, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        ),
        child: isBusy
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 1.8,
                  color: filled ? Colors.white : color,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18.sp),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    style: GoogleFonts.outfit(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.actions;
    final List<String> steps = a.steps.isNotEmpty ? a.steps : _steps;
    final String noun = a.isComplaint ? "complaint" : "service request";
    final int step = (a.step ?? 1).clamp(1, steps.length).toInt();
    final vendors = a.vendorOptions.where((v) => v.id != null).toList();
    final selectedValid = vendors.any((v) => v.id == _vendorId);
    final vendorChanged = _vendorId != null && _vendorId != a.assignedVendorId;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  a.title ?? "Manage Request",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: step >= 4
                      ? const Color.fromRGBO(36, 176, 106, 0.2)
                      : const Color.fromRGBO(184, 134, 11, 0.25),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Text(
                  a.statusLabel ?? steps[step - 1],
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: step >= 4 ? const Color(0xFF24B06A) : const Color(0xFF8A6508),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // 5-step progress
          Row(
            children: List.generate(steps.length, (i) {
              final done = i < step;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == steps.length - 1 ? 0 : 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: done ? AppColors.heading : const Color.fromRGBO(16, 28, 22, 0.12),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        steps[i],
                        maxLines: 2,
                        style: GoogleFonts.outfit(
                          fontSize: 9.5.sp,
                          height: 1.1,
                          color: done ? AppColors.heading : const Color.fromRGBO(16, 28, 22, 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          if ((a.hint ?? "").isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 242, 165, 0.45),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                a.hint!,
                style: GoogleFonts.outfit(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF6B5829),
                  height: 1.3,
                ),
              ),
            ),
          ],
          if (a.canAssignVendor) ...[
            SizedBox(height: 14.h),
            Text(
              a.hasVendor ? "CHANGE VENDOR" : "ASSIGN VENDOR",
              style: GoogleFonts.outfit(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: 6.h),
            if (vendors.isEmpty)
              Text(
                "No active vendor in your society. Please ask the Admin to add a vendor.",
                style: GoogleFonts.outfit(fontSize: 12.5.sp, color: Colors.red.shade700),
              )
            else ...[
              DropdownButtonFormField<int>(
                value: selectedValid ? _vendorId : null,
                isExpanded: true,
                dropdownColor: AppColors.scaffoldBg,
                hint: Text(
                  "Select vendor",
                  style: GoogleFonts.outfit(
                    fontSize: 13.5.sp,
                    color: const Color.fromRGBO(16, 28, 22, 0.4),
                  ),
                ),
                style: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.heading),
                items: vendors
                    .map((v) => DropdownMenuItem<int>(
                          value: v.id,
                          child: Text(
                            v.label ?? v.name ?? "Vendor",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: _busy.isNotEmpty ? null : (v) => setState(() => _vendorId = v),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: const BorderSide(color: Color.fromRGBO(16, 28, 22, 0.6)),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              _button(
                label: a.hasVendor ? "Change Vendor" : "Assign Vendor",
                icon: Icons.engineering_outlined,
                busyKey: "vendor",
                onTap: vendorChanged ? _assignVendor : null,
              ),
            ],
          ],
          if (a.canMarkInProgress) ...[
            SizedBox(height: 10.h),
            _button(
              label: "Mark In Progress",
              icon: Icons.play_circle_outline,
              busyKey: "in_progress",
              filled: false,
              color: const Color(0xFF1E5993),
              onTap: () => _updateStatus(
                "in_progress",
                a.isComplaint
                    ? "Mark this complaint In Progress?"
                    : "Mark this service request In Progress? The resident will then be able to mark it Completed.",
              ),
            ),
          ],
          if (a.canMarkCompleted) ...[
            SizedBox(height: 10.h),
            _button(
              label: a.completeLabel ?? "Mark Completed",
              icon: Icons.check_circle_outline,
              busyKey: "resolved",
              filled: false,
              color: const Color(0xFF24B06A),
              onTap: () => _updateStatus(
                "resolved",
                a.isComplaint ? "Mark this complaint Resolved?" : "Mark this service request Completed?",
              ),
            ),
          ],
          if (a.canClose) ...[
            SizedBox(height: 10.h),
            _button(
              label: a.closeLabel ?? "Close Request",
              icon: Icons.lock_outline,
              busyKey: "closed",
              color: const Color(0xFF24B06A),
              onTap: () => _updateStatus(
                "closed",
                "Close this $noun? This cannot be undone.",
              ),
            ),
          ],
        ],
      ),
    );
  }
}

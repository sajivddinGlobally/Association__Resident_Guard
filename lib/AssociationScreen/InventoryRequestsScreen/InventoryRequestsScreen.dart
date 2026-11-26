import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart'
    show dioProvider;
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

/// Guards / caretakers ki inventory requests (Association app).
/// Pehle ye sirf website par dikhti thi - app mein koi screen nahi thi.
///  GET  /committee/inventory/requests?status=open|resolved|rejected|all
///  POST /committee/inventory/requests/{id}/resolve  { status: resolved|rejected, note }
const String _invBase =
    "https://admin.ascentpms.care/api/v1/committee/inventory/requests";

String _errMsg(Object e, String fallback) {
  if (e is DioException) {
    final d = e.response?.data;
    if (d is Map && d["message"] != null) return d["message"].toString();
  }
  return fallback;
}

final inventoryRequestsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, status) async {
      final dio = ref.read(dioProvider);
      try {
        final res = await dio.get(
          _invBase,
          queryParameters: {"status": status},
        );
        final body = res.data;
        if (body is Map && body["status"] == true) {
          return Map<String, dynamic>.from(body);
        }
        throw Exception(
          body is Map && body["message"] != null
              ? body["message"].toString()
              : "Could not load inventory requests.",
        );
      } on DioException catch (e) {
        throw Exception(_errMsg(e, "Could not load inventory requests."));
      }
    });

class InventoryRequestsScreen extends ConsumerStatefulWidget {
  const InventoryRequestsScreen({super.key});

  @override
  ConsumerState<InventoryRequestsScreen> createState() =>
      _InventoryRequestsScreenState();
}

class _InventoryRequestsScreenState
    extends ConsumerState<InventoryRequestsScreen> {
  static const _tabs = [
    ("open", "Pending"),
    ("resolved", "Done"),
    ("rejected", "Not needed"),
    ("all", "All"),
  ];
  String _status = "open";
  int? _busyId;

  Future<void> _resolve(Map r, String status) async {
    final id = int.tryParse("${r["id"]}");
    if (id == null || _busyId != null) return;
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBg,
        title: Text(
          status == "resolved" ? "Mark as done?" : "Mark as not needed?",
          style: GoogleFonts.outfit(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${r["item_name"] ?? "Item"} · requested by ${r["requested_by"] ?? "guard"}",
              style: GoogleFonts.outfit(fontSize: 15.sp, color: Colors.black54),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: noteCtrl,
              maxLines: 2,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "Note for the guard (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == "resolved"
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF6B7280),
            ),
            child: Text(
              status == "resolved" ? "Mark Done" : "Not Needed",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    final note = noteCtrl.text.trim();
    noteCtrl.dispose();
    if (ok != true) return;

    setState(() => _busyId = id);
    try {
      final res = await ref
          .read(dioProvider)
          .post(
            "$_invBase/$id/resolve",
            data: {"status": status, if (note.isNotEmpty) "note": note},
          );
      final body = res.data;
      if (body is Map && body["status"] == true) {
        showSuccessSnackBar((body["message"] ?? "Request updated.").toString());
        ref.invalidate(inventoryRequestsProvider);
      } else {
        showErrorSnackBar(
          body is Map && body["message"] != null
              ? body["message"].toString()
              : "Could not update the request.",
        );
      }
    } catch (e) {
      showErrorSnackBar(_errMsg(e, "Could not update the request."));
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryRequestsProvider(_status));
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp, color: AppColors.heading),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Inventory Requests",
              style: GoogleFonts.outfit(
                fontSize: 19.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            Text(
              "Items requested by guards & caretakers",
              style: GoogleFonts.outfit(fontSize: 13.sp, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 46.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: _tabs.map((t) {
                final sel = t.$1 == _status;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w, top: 4.h, bottom: 4.h),
                  child: ChoiceChip(
                    label: Text(
                      t.$2,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : AppColors.heading,
                      ),
                    ),
                    selected: sel,
                    selectedColor: AppColors.heading,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _status = t.$1),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(inventoryRequestsProvider(_status)),
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  padding: EdgeInsets.all(24.w),
                  children: [
                    SizedBox(height: 50.h),
                    Text(
                      e.toString().replaceFirst("Exception: ", ""),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 16.sp),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: OutlinedButton(
                        onPressed: () =>
                            ref.invalidate(inventoryRequestsProvider(_status)),
                        child: const Text("Retry"),
                      ),
                    ),
                  ],
                ),
                data: (body) {
                  final canManage = body["can_manage"] == true;
                  final rows =
                      (body["data"] is List ? body["data"] as List : [])
                          .whereType<Map>()
                          .toList();
                  if (rows.isEmpty) {
                    return ListView(
                      padding: EdgeInsets.all(24.w),
                      children: [
                        SizedBox(height: 60.h),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48.sp,
                          color: Colors.black26,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          _status == "open"
                              ? "No pending requests from guards."
                              : "Nothing here yet.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 30.h),
                    children: rows.map((r) => _card(r, canManage)).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Map r, bool canManage) {
    final st = "${r["status"] ?? "open"}";
    final color = st == "open"
        ? const Color(0xFFE08A00)
        : st == "resolved"
        ? const Color(0xFF16A34A)
        : const Color(0xFF6B7280);
    final busy = _busyId == int.tryParse("${r["id"]}");
    final stock = "${r["stock_status"] ?? ""}".toLowerCase();

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.45), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: color, size: 22.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "${r["item_name"] ?? "Item"}",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "${r["status_label"] ?? st}",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 14.w,
            runSpacing: 4.h,
            children: [
              if (r["requested_label"] != null)
                _info(
                  Icons.shopping_cart_outlined,
                  "Needs: ${r["requested_label"]}",
                ),
              if (r["current_label"] != null)
                _info(
                  Icons.store_mall_directory_outlined,
                  "In stock: ${r["current_label"]}",
                  color: stock.contains("out") || stock.contains("low")
                      ? const Color(0xFFD93025)
                      : null,
                ),
              if (r["is_new_item"] == true)
                _info(Icons.fiber_new_outlined, "New item"),
            ],
          ),
          if ("${r["message"] ?? ""}".trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              "“${r["message"]}”",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF374151),
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            "By ${r["requested_by"] ?? "-"} · ${r["requested_at"] ?? ""}",
            style: GoogleFonts.outfit(fontSize: 13.sp, color: Colors.black54),
          ),
          if (st != "open" && r["resolved_at"] != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                "Closed by ${r["resolved_by"] ?? "-"} · ${r["resolved_at"]}"
                "${"${r["response_note"] ?? ""}".isNotEmpty ? "\nNote: ${r["response_note"]}" : ""}",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          if (st == "open" && canManage) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy ? null : () => _resolve(r, "rejected"),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    child: Text(
                      "Not Needed",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: busy ? null : () => _resolve(r, "resolved"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      elevation: 0,
                    ),
                    child: busy
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Mark Done",
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text, {Color? color}) {
    final c = color ?? const Color(0xFF4B5563);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: c),
        SizedBox(width: 4.w),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: c,
          ),
        ),
      ],
    );
  }
}

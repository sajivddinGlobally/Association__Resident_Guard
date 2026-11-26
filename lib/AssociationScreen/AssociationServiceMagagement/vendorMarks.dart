import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart'
    show dioProvider;
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';

/// Vendor Performance Marks (Association deti hai).
/// Weightage FIXED: Service Quality 30 + Work Completion 30 + Response Time 20 + Issue Resolution 20 = 100.
/// Admin panel wahi marks dikhata hai. Naya vendor society ke default marks se shuru hota hai.

const String _marksApi =
    "https://admin.ascentpms.care/api/v1/committee/vendor-performance";

class MarkCriterion {
  final String key;
  final String label;
  final String note;
  final double max;

  const MarkCriterion(this.key, this.label, this.max, this.note);

  factory MarkCriterion.fromJson(Map<String, dynamic> j) => MarkCriterion(
    (j["key"] ?? "").toString(),
    (j["label"] ?? "").toString(),
    double.tryParse("${j["max"]}") ?? 0,
    (j["note"] ?? "").toString(),
  );
}

/// Server na de to bhi yahi (fixed) criteria
const List<MarkCriterion> kDefaultCriteria = [
  MarkCriterion(
    "quality",
    "Service Quality",
    30,
    "Workmanship & resident satisfaction",
  ),
  MarkCriterion(
    "completion",
    "Work Completion",
    30,
    "Scope of work & checklist done on time",
  ),
  MarkCriterion(
    "response",
    "Response Time",
    20,
    "Attends calls / issues on time",
  ),
  MarkCriterion(
    "resolution",
    "Issue Resolution",
    20,
    "Problems fixed without repeat visits",
  ),
];

String fmtMarks(num? v) {
  if (v == null) return "-";
  final d = v.toDouble();
  return d == d.roundToDouble() ? d.toInt().toString() : d.toStringAsFixed(1);
}

String _dioMessage(Object e, String fallback) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data["message"] != null)
      return data["message"].toString();
  }
  return fallback;
}

/// GET /committee/vendor-performance (raw map - chhota sa data)
final vendorMarksProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  try {
    final res = await dio.get(_marksApi);
    final body = res.data;
    if (body is Map && body["status"] == true && body["data"] is Map) {
      return Map<String, dynamic>.from(body["data"]);
    }
    throw Exception(
      body is Map && body["message"] != null
          ? body["message"].toString()
          : "Could not load vendor marks.",
    );
  } catch (e) {
    if (e is Exception && e is! DioException) rethrow;
    throw Exception(_dioMessage(e, "Could not load vendor marks."));
  }
});

List<MarkCriterion> criteriaFrom(Map<String, dynamic>? data) {
  final list = data?["criteria"];
  if (list is List && list.isNotEmpty) {
    final parsed = list
        .whereType<Map>()
        .map((e) => MarkCriterion.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.key.isNotEmpty && c.max > 0)
        .toList();
    if (parsed.length == 4) return parsed;
  }
  return kDefaultCriteria;
}

/// Vendor ke "performance" map (marksBreakdown) se key => marks
Map<String, double> marksFromBreakdown(dynamic perf) {
  final out = <String, double>{};
  if (perf is Map && perf["criteria"] is List) {
    for (final c in (perf["criteria"] as List).whereType<Map>()) {
      final v = double.tryParse("${c["marks"]}");
      if (v != null) out["${c["key"]}"] = v;
    }
  }
  return out;
}

/// Marks dene ki sheet. vendorId == null -> society default marks.
/// true = save ho gaya.
Future<bool> showVendorMarksSheet(
  BuildContext context,
  WidgetRef ref, {
  int? vendorId,
  required String title,
  Map<String, double>? initial,
  List<MarkCriterion> criteria = kDefaultCriteria,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.scaffoldBg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (_) => _VendorMarksSheet(
      vendorId: vendorId,
      title: title,
      initial: initial ?? const {},
      criteria: criteria,
    ),
  );
  return saved == true;
}

class _VendorMarksSheet extends ConsumerStatefulWidget {
  final int? vendorId;
  final String title;
  final Map<String, double> initial;
  final List<MarkCriterion> criteria;

  const _VendorMarksSheet({
    required this.vendorId,
    required this.title,
    required this.initial,
    required this.criteria,
  });

  @override
  ConsumerState<_VendorMarksSheet> createState() => _VendorMarksSheetState();
}

class _VendorMarksSheetState extends ConsumerState<_VendorMarksSheet> {
  late final Map<String, double> _marks;
  final Map<String, TextEditingController> _ctrl = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _marks = {
      for (final c in widget.criteria)
        c.key: (widget.initial[c.key] ?? c.max).clamp(0, c.max).toDouble(),
    };
    for (final c in widget.criteria) {
      _ctrl[c.key] = TextEditingController(text: fmtMarks(_marks[c.key]));
    }
  }

  @override
  void dispose() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _total => _marks.values.fold(0.0, (a, b) => a + b);

  void _set(MarkCriterion c, double v, {bool fromText = false}) {
    final clamped = v.clamp(0, c.max).toDouble();
    final rounded = (clamped * 2).round() / 2; // 0.5 ke steps
    setState(() => _marks[c.key] = fromText ? clamped : rounded);
    if (!fromText) _ctrl[c.key]?.text = fmtMarks(rounded);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final dio = ref.read(dioProvider);
    final url = widget.vendorId == null
        ? "$_marksApi/default"
        : "$_marksApi/${widget.vendorId}";
    try {
      final res = await dio.put(url, data: _marks);
      final body = res.data;
      if (body is Map && body["status"] == true) {
        showSuccessSnackBar((body["message"] ?? "Marks saved").toString());
        if (mounted) Navigator.pop(context, true);
        return;
      }
      showErrorSnackBar(
        body is Map && body["message"] != null
            ? body["message"].toString()
            : "Could not save marks.",
      );
    } catch (e) {
      showErrorSnackBar(
        _dioMessage(e, "Could not save marks. Please try again."),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                widget.vendorId == null
                    ? "Society Default Marks"
                    : "Give Performance Marks",
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.title,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                widget.vendorId == null
                    ? "New vendors start with these marks until you mark them separately. Weightage is fixed."
                    : "Weightage is fixed (30 + 30 + 20 + 20). Admin sees the marks you give.",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16.h),
              ...widget.criteria.map(_criterionRow),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.heading,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Text(
                      "Total Score",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${fmtMarks(_total)} / 100",
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5C451),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    disabledBackgroundColor: const Color(0x99B8860B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: _saving
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Save Marks",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

  Widget _criterionRow(MarkCriterion c) {
    final v = _marks[c.key] ?? 0;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 10.w, 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0x33101C16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${c.label}  (max ${fmtMarks(c.max)})",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    Text(
                      c.note,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 64.w,
                child: TextField(
                  controller: _ctrl[c.key],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,2}(\.\d?)?'),
                    ),
                  ],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onChanged: (t) {
                    final p = double.tryParse(t);
                    if (p != null) _set(c, p, fromText: true);
                  },
                  onEditingComplete: () {
                    _ctrl[c.key]?.text = fmtMarks(_marks[c.key]);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
          Slider(
            value: v,
            min: 0,
            max: c.max,
            divisions: (c.max * 2).round(),
            activeColor: const Color(0xFFB8860B),
            label: fmtMarks(v),
            onChanged: (nv) => _set(c, nv),
          ),
        ],
      ),
    );
  }
}

/// Society ke saare vendors + default marks
class VendorMarksScreen extends ConsumerWidget {
  const VendorMarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vendorMarksProvider);
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
        title: Text(
          "Vendor Performance Marks",
          style: GoogleFonts.outfit(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(vendorMarksProvider),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            padding: EdgeInsets.all(24.w),
            children: [
              SizedBox(height: 60.h),
              Icon(Icons.error_outline, size: 46.sp, color: Colors.redAccent),
              SizedBox(height: 10.h),
              Text(
                e.toString().replaceFirst("Exception: ", ""),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: OutlinedButton(
                  onPressed: () => ref.invalidate(vendorMarksProvider),
                  child: const Text("Retry"),
                ),
              ),
            ],
          ),
          data: (data) => _body(context, ref, data),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, Map<String, dynamic> data) {
    final criteria = criteriaFrom(data);
    final def = data["society_default"] is Map
        ? data["society_default"] as Map
        : {};
    final defMarks = <String, double>{};
    if (def["marks"] is Map) {
      (def["marks"] as Map).forEach((k, v) {
        final d = double.tryParse("$v");
        if (d != null) defMarks["$k"] = d;
      });
    }
    final vendors = (data["vendors"] is List ? data["vendors"] as List : [])
        .whereType<Map>()
        .toList();
    final summary = data["summary"] is Map ? data["summary"] as Map : {};

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 30.h),
      children: [
        Text(
          (data["weightage_note"] ??
                  "Weightage is fixed: 30 + 30 + 20 + 20 = 100. Admin sees the marks you give.")
              .toString(),
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: Colors.black54,
            height: 1.35,
          ),
        ),
        SizedBox(height: 14.h),
        // Society default
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFB8860B), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: const Color(0xFFB8860B),
                    size: 22.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Society Default Marks",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                  Text(
                    def["is_set"] == true
                        ? "${fmtMarks(double.tryParse("${def["total"]}"))}/100"
                        : "Not set",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: def["is_set"] == true
                          ? const Color(0xFF16A34A)
                          : Colors.black45,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                (def["note"] ?? "A newly added vendor starts with these marks.")
                    .toString(),
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              if (defMarks.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: criteria
                      .map(
                        (c) => _chip(
                          "${c.label} ${fmtMarks(defMarks[c.key])}/${fmtMarks(c.max)}",
                        ),
                      )
                      .toList(),
                ),
              ],
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final ok = await showVendorMarksSheet(
                      context,
                      ref,
                      title:
                          (data["complex"] is Map
                                  ? data["complex"]["name"]
                                  : null)
                              ?.toString() ??
                          "Your society",
                      initial: defMarks,
                      criteria: criteria,
                    );
                    if (ok) ref.invalidate(vendorMarksProvider);
                  },
                  icon: Icon(Icons.edit_outlined, size: 18.sp),
                  label: Text(
                    def["is_set"] == true
                        ? "Edit Default Marks"
                        : "Set Default Marks",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.heading,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            Text(
              "Vendors",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const Spacer(),
            Text(
              "${summary["rated_vendors"] ?? 0} of ${summary["total_vendors"] ?? vendors.length} rated",
              style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.black54),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (vendors.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Text(
              "No vendors added for your society yet.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 15.sp, color: Colors.black54),
            ),
          ),
        ...vendors.map((v) => _vendorCard(context, ref, v, criteria)),
      ],
    );
  }

  Widget _chip(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: const Color(0x1AB8860B),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF8A6508),
      ),
    ),
  );

  Widget _vendorCard(
    BuildContext context,
    WidgetRef ref,
    Map v,
    List<MarkCriterion> criteria,
  ) {
    final perf = v["performance"] is Map ? v["performance"] as Map : {};
    final rated = perf["is_rated"] == true;
    final total = double.tryParse("${perf["total"]}");
    final marks = marksFromBreakdown(perf);
    final id = int.tryParse("${v["id"]}");
    final name = (v["vendor_name"] ?? "Vendor").toString();
    final color = !rated
        ? Colors.black38
        : (total ?? 0) >= 75
        ? const Color(0xFF16A34A)
        : (total ?? 0) >= 50
        ? const Color(0xFFE08A00)
        : const Color(0xFFD93025);

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: id == null
          ? null
          : () async {
              final ok = await showVendorMarksSheet(
                context,
                ref,
                vendorId: id,
                title: name,
                initial: marks,
                criteria: criteria,
              );
              if (ok) ref.invalidate(vendorMarksProvider);
            },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0x33101C16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      Text(
                        "${v["category_label"] ?? ""}  •  ${perf["source_label"] ?? ""}",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    rated ? "${fmtMarks(total)}/100" : "Not rated",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            if (marks.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: criteria
                    .map(
                      (c) => _chip(
                        "${c.label} ${fmtMarks(marks[c.key])}/${fmtMarks(c.max)}",
                      ),
                    )
                    .toList(),
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16.sp,
                  color: const Color(0xFFB8860B),
                ),
                SizedBox(width: 4.w),
                Text(
                  rated ? "Edit marks" : "Give marks",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB8860B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

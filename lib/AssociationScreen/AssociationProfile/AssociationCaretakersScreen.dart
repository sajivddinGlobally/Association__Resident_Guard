import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:url_launcher/url_launcher.dart';

/// Association: Society Caretakers (sirf contact - naam + mobile number, koi login nahi).
/// Add / Edit / Remove yahan se. Unit ko caretaker "Unit Details -> Edit" se assign hota hai.
/// API: GET /committee/caretakers, POST /committee/caretakers, /{id}/update, /{id}/delete
class AssociationCaretakersScreen extends ConsumerStatefulWidget {
  const AssociationCaretakersScreen({super.key});

  @override
  ConsumerState<AssociationCaretakersScreen> createState() =>
      _AssociationCaretakersScreenState();
}

class _AssociationCaretakersScreenState
    extends ConsumerState<AssociationCaretakersScreen> {
  bool _loading = true;
  String? _loadError;
  bool _canManage = true;
  List<Map<String, dynamic>> _caretakers = [];
  String _search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final res = await ref.read(authServiceProvider).getCaretakers();
      if (!mounted) return;
      if (res["status"] == false) {
        setState(() {
          _loadError = (res["message"] ?? "Failed to load caretakers.")
              .toString();
          _caretakers = [];
        });
        return;
      }
      final data = res["data"];
      setState(() {
        _caretakers = data is List
            ? data
                  .whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList()
            : [];
        _canManage = res["can_manage"] != false;
      });
    } catch (e) {
      if (!mounted) return;
      // Server ka error message dio interceptor dikha deta hai
      setState(() {
        _loadError = "Failed to load caretakers.";
        _caretakers = [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return _caretakers;
    return _caretakers.where((c) {
      return (c["name"] ?? "").toString().toLowerCase().contains(q) ||
          (c["phone"] ?? "").toString().toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _call(Map<String, dynamic> c) async {
    final raw = (c["tel_uri"] ?? "tel:${c["phone"] ?? ""}").toString();
    final uri = Uri.parse(raw.replaceAll(" ", ""));
    try {
      await launchUrl(uri);
    } catch (_) {
      showErrorSnackBar("Unable to open the dialer.");
    }
  }

  // ---------------------------------------------------------------- Add / Edit
  void _openForm({Map<String, dynamic>? caretaker}) {
    final String? editId = caretaker?["id"]?.toString();
    final isEdit = editId != null && editId.isNotEmpty;
    final nameC = TextEditingController(
      text: (caretaker?["name"] ?? "").toString(),
    );
    final phoneC = TextEditingController(
      text: (caretaker?["phone"] ?? "").toString(),
    );
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? "Edit Caretaker" : "Add Caretaker",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Caretaker is a contact only (no login). Assign units from Unit Details → Edit.",
                        style: GoogleFonts.outfit(
                          fontSize: 12.5.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.7),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _field(
                        "CARETAKER NAME *",
                        nameC,
                        "e.g. Ramesh Kumar",
                        TextInputType.name,
                      ),
                      _field(
                        "MOBILE NUMBER *",
                        phoneC,
                        "e.g. 9876543210",
                        TextInputType.phone,
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: double.infinity,
                        height: 46.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.heading,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          onPressed: saving
                              ? null
                              : () async {
                                  final name = nameC.text.trim();
                                  final phone = phoneC.text.trim();
                                  final digits = phone.replaceAll(
                                    RegExp(r'\D'),
                                    '',
                                  );
                                  if (name.isEmpty) {
                                    showErrorSnackBar(
                                      "Please enter the caretaker name.",
                                    );
                                    return;
                                  }
                                  if (digits.length < 10 ||
                                      digits.length > 15) {
                                    showErrorSnackBar(
                                      "Please enter a valid mobile number (10 to 15 digits).",
                                    );
                                    return;
                                  }
                                  setSheet(() => saving = true);
                                  try {
                                    final res = await ref
                                        .read(authServiceProvider)
                                        .saveCaretaker(
                                          id: isEdit ? editId : null,
                                          name: name,
                                          phone: phone,
                                        );
                                    if (res["status"] == false) {
                                      showErrorSnackBar(
                                        (res["message"] ??
                                                "Failed to save caretaker.")
                                            .toString(),
                                      );
                                    } else {
                                      if (ctx.mounted) Navigator.pop(ctx);
                                      showSuccessSnackBar(
                                        (res["message"] ??
                                                (isEdit
                                                    ? "Caretaker updated."
                                                    : "Caretaker added."))
                                            .toString(),
                                      );
                                      _load();
                                    }
                                  } catch (e) {
                                    // Server ka error message dio interceptor dikha deta hai
                                  } finally {
                                    if (ctx.mounted)
                                      setSheet(() => saving = false);
                                  }
                                },
                          child: saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ),
                                )
                              : Text(
                                  isEdit ? "Save Changes" : "Add Caretaker",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
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
          },
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController c,
    String hint,
    TextInputType type,
  ) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.r),
      borderSide: const BorderSide(
        color: Color.fromRGBO(16, 28, 22, 0.6),
        width: 1.2,
      ),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            controller: c,
            keyboardType: type,
            maxLength: type == TextInputType.phone ? 20 : 100,
            cursorColor: AppColors.heading,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                fontSize: 13.5.sp,
                color: const Color.fromRGBO(16, 28, 22, 0.4),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.h,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(
                  color: AppColors.heading,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- Remove
  void _confirmRemove(Map<String, dynamic> c) {
    final count = int.tryParse("${c["units_count"] ?? 0}") ?? 0;
    showDialog(
      context: context,
      builder: (dCtx) {
        bool removing = false;
        return StatefulBuilder(
          builder: (dCtx, setDlg) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              title: Text(
                "Remove Caretaker?",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              content: Text(
                "${c["name"] ?? "This caretaker"} will be removed from your society."
                "${count > 0 ? " $count ${count == 1 ? "unit" : "units"} assigned to this caretaker will show \"Caretaker not assigned\"." : ""}"
                " Units and residents are not deleted.",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color.fromRGBO(42, 41, 51, 0.8),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: removing ? null : () => Navigator.pop(dCtx),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(color: AppColors.heading),
                  ),
                ),
                TextButton(
                  onPressed: removing
                      ? null
                      : () async {
                          setDlg(() => removing = true);
                          try {
                            final res = await ref
                                .read(authServiceProvider)
                                .deleteCaretaker(id: c["id"].toString());
                            if (res["status"] == false) {
                              showErrorSnackBar(
                                (res["message"] ??
                                        "Failed to remove caretaker.")
                                    .toString(),
                              );
                            } else {
                              if (dCtx.mounted) Navigator.pop(dCtx);
                              showSuccessSnackBar(
                                (res["message"] ?? "Caretaker removed.")
                                    .toString(),
                              );
                              _load();
                            }
                          } catch (e) {
                            // Server ka error message dio interceptor dikha deta hai
                          } finally {
                            if (dCtx.mounted) setDlg(() => removing = false);
                          }
                        },
                  child: Text(
                    removing ? "Removing..." : "Remove",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFDC2626),
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

  // ---------------------------------------------------------------- UI
  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        titleSpacing: 18.w,
        title: Row(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Caretakers",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Society caretakers · name and number",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (_canManage)
              GestureDetector(
                onTap: () => _openForm(),
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.heading,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "Add",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.heading,
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 24.h),
          children: [
            TextField(
              onChanged: (v) => setState(() => _search = v),
              cursorColor: AppColors.heading,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: AppColors.heading,
              ),
              decoration: InputDecoration(
                hintText: "Search name or number",
                hintStyle: GoogleFonts.outfit(
                  fontSize: 13.5.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.4),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.5),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.heading),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            if (_loading)
              Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.heading),
                ),
              )
            else if (_loadError != null)
              _emptyState(_loadError!, showRetry: true)
            else if (list.isEmpty)
              _emptyState(
                _caretakers.isEmpty
                    ? "No caretakers added yet."
                    : "No caretaker matches your search.",
              )
            else
              ...list.map(_caretakerCard),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String text, {bool showRetry = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Icon(
            Icons.support_agent,
            size: 44.sp,
            color: const Color.fromRGBO(16, 28, 22, 0.3),
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: const Color.fromRGBO(42, 41, 51, 0.7),
            ),
          ),
          if (showRetry) ...[
            SizedBox(height: 10.h),
            TextButton(
              onPressed: _load,
              child: Text(
                "Retry",
                style: GoogleFonts.outfit(
                  color: AppColors.heading,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _caretakerCard(Map<String, dynamic> c) {
    final units = (c["units"] is List)
        ? (c["units"] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    final count =
        int.tryParse("${c["units_count"] ?? units.length}") ?? units.length;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1)),
        borderRadius: BorderRadius.circular(12.r),
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
                      (c["name"] ?? "-").toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () => _call(c),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.call,
                            size: 15.sp,
                            color: const Color(0xFFB8860B),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            (c["phone"] ?? "-").toString(),
                            style: GoogleFonts.outfit(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(42, 41, 51, 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(36, 176, 106, 0.15),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Text(
                  "$count ${count == 1 ? "Unit" : "Units"}",
                  style: GoogleFonts.outfit(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF24B06A),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (units.isEmpty)
            Text(
              "No units assigned yet · assign from Unit Details → Edit",
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: const Color.fromRGBO(42, 41, 51, 0.6),
              ),
            )
          else
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                ...units
                    .take(6)
                    .map(
                      (u) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2EFE8),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Text(
                          "${u["unit_number"] ?? "-"}${(u["block"] ?? "").toString().isNotEmpty ? " · ${u["block"]}" : ""}",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ),
                if (units.length > 6)
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: Text(
                      "+${units.length - 6} more",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          if (_canManage) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _openForm(caretaker: c),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 17.sp,
                    color: AppColors.heading,
                  ),
                  label: Text(
                    "Edit",
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                TextButton.icon(
                  onPressed: () => _confirmRemove(c),
                  icon: Icon(
                    Icons.delete_outline,
                    size: 17.sp,
                    color: const Color(0xFFDC2626),
                  ),
                  label: Text(
                    "Remove",
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      color: const Color(0xFFDC2626),
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
}

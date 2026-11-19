import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:url_launcher/url_launcher.dart';

/// Association: apni society ke guards ki list + Edit + Remove from Society.
/// API: GET /committee/guards, POST /committee/guards/{id}/update, POST /committee/guards/{id}/remove
/// (Admin ke paas guard edit / remove ka option nahi - sirf Association.)
class AssociationGuardListScreen extends ConsumerStatefulWidget {
  const AssociationGuardListScreen({super.key});

  @override
  ConsumerState<AssociationGuardListScreen> createState() =>
      _AssociationGuardListScreenState();
}

class _AssociationGuardListScreenState
    extends ConsumerState<AssociationGuardListScreen> {
  bool _loading = true;
  String? _loadError;
  List<Map<String, dynamic>> _guards = [];

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
      final res = await ref.read(authServiceProvider).getCommitteeGuards();
      if (!mounted) return;
      if (res["status"] == false) {
        setState(() {
          _loadError = (res["message"] ?? "Failed to load guards.").toString();
          _guards = [];
        });
        return;
      }
      final data = res["data"];
      setState(() {
        _guards = data is List
            ? data
                  .whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList()
            : [];
      });
    } catch (e) {
      if (!mounted) return;
      // Server ka message dio interceptor dikha deta hai
      setState(() {
        _loadError = "Failed to load guards.";
        _guards = [];
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _shiftText(Map<String, dynamic> g) {
    final s = g["shift"];
    if (s is Map) {
      final name = (s["name"] ?? "").toString();
      final t = (s["timings"] ?? "").toString();
      return t.isNotEmpty ? "$name ($t)" : name;
    }
    return "-";
  }

  // ---------------------------------------------------------------- Edit
  Future<void> _openEdit(Map<String, dynamic> g) async {
    final nameC = TextEditingController(text: (g["name"] ?? "").toString());
    final phoneC = TextEditingController(
      text: (g["mobile_number"] ?? g["phone"] ?? "").toString(),
    );
    final postC = TextEditingController(
      text: (g["guard_post"] ?? "").toString(),
    );
    final passC = TextEditingController();
    String? shiftId = (g["shift"] is Map && g["shift"]["id"] != null)
        ? g["shift"]["id"].toString()
        : null;

    List<Map<String, dynamic>> shifts = [];
    try {
      final res = await ref.read(authServiceProvider).getCommitteeShifts();
      final data = res["data"] ?? res["shifts"];
      if (data is List) {
        shifts = data
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {
      // shifts na mile to bhi edit chale (shift dropdown khaali)
    }
    if (shiftId != null && !shifts.any((s) => s["id"].toString() == shiftId)) {
      shiftId = null;
    }
    if (!mounted) return;
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
            final border = OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: Color.fromRGBO(16, 28, 22, 0.6),
                width: 1.2,
              ),
            );
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
                        "Edit Guard",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _field(
                        "GUARD NAME *",
                        nameC,
                        "e.g. Ramesh Singh",
                        TextInputType.name,
                      ),
                      _field(
                        "MOBILE NUMBER *",
                        phoneC,
                        "e.g. 9876543210",
                        TextInputType.phone,
                      ),
                      _field(
                        "GUARD POST",
                        postC,
                        "e.g. Main Gate 1",
                        TextInputType.text,
                      ),
                      Text(
                        "SHIFT",
                        style: GoogleFonts.outfit(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      DropdownButtonFormField<String>(
                        value: shiftId,
                        isExpanded: true,
                        dropdownColor: AppColors.scaffoldBg,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              "No shift",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                color: const Color.fromRGBO(16, 28, 22, 0.6),
                              ),
                            ),
                          ),
                          ...shifts.map(
                            (s) => DropdownMenuItem<String>(
                              value: s["id"].toString(),
                              child: Text(
                                "${s["name"] ?? "-"}${(s["timings"] ?? "").toString().isNotEmpty ? " (${s["timings"]})" : ""}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) => setSheet(() => shiftId = v),
                        decoration: InputDecoration(
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
                      SizedBox(height: 12.h),
                      _field(
                        "NEW PASSWORD",
                        passC,
                        "Leave blank to keep",
                        TextInputType.visiblePassword,
                        obscure: true,
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
                                      "Please enter the guard name.",
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
                                  if (passC.text.isNotEmpty &&
                                      passC.text.length < 6) {
                                    showErrorSnackBar(
                                      "Password must be at least 6 characters.",
                                    );
                                    return;
                                  }
                                  setSheet(() => saving = true);
                                  try {
                                    final body = <String, dynamic>{
                                      "name": name,
                                      "mobile_number": phone,
                                      "guard_post": postC.text.trim(),
                                      "shift_id": shiftId,
                                    };
                                    if (passC.text.isNotEmpty)
                                      body["password"] = passC.text;
                                    final res = await ref
                                        .read(authServiceProvider)
                                        .updateGuard(
                                          id: g["id"].toString(),
                                          body: body,
                                        );
                                    if (res["status"] == false) {
                                      showErrorSnackBar(
                                        (res["message"] ??
                                                "Failed to update guard.")
                                            .toString(),
                                      );
                                    } else {
                                      if (ctx.mounted) Navigator.pop(ctx);
                                      showSuccessSnackBar(
                                        (res["message"] ?? "Guard updated.")
                                            .toString(),
                                      );
                                      _load();
                                    }
                                  } catch (e) {
                                    // Server ka message dio interceptor dikha deta hai
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
                                  "Save Changes",
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
    TextInputType type, {
    bool obscure = false,
  }) {
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
            obscureText: obscure,
            cursorColor: AppColors.heading,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
            decoration: InputDecoration(
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
  void _confirmRemove(Map<String, dynamic> g) {
    showDialog(
      context: context,
      builder: (dCtx) {
        bool removing = false;
        return StatefulBuilder(
          builder: (dCtx, setDlg) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              title: Text(
                "Remove Guard?",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              content: Text(
                "${g["name"] ?? "This guard"} will be removed from your society and will not be able to log in "
                "to the guard app. Visitor entries and parcels stay in history. Nothing is deleted.",
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
                                .removeGuard(id: g["id"].toString());
                            if (res["status"] == false) {
                              showErrorSnackBar(
                                (res["message"] ?? "Failed to remove guard.")
                                    .toString(),
                              );
                            } else {
                              if (dCtx.mounted) Navigator.pop(dCtx);
                              showSuccessSnackBar(
                                (res["message"] ?? "Guard removed.").toString(),
                              );
                              _load();
                            }
                          } catch (e) {
                            // Server ka message dio interceptor dikha deta hai
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
                    "Guard List",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Edit or remove your society's guards",
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
            if (_loading)
              Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.heading),
                ),
              )
            else if (_loadError != null)
              _empty(_loadError!, retry: true)
            else if (_guards.isEmpty)
              _empty("No guards added yet.")
            else
              ..._guards.map(_guardCard),
          ],
        ),
      ),
    );
  }

  Widget _empty(String text, {bool retry = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Icon(
            Icons.security,
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
          if (retry)
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
      ),
    );
  }

  Widget _guardCard(Map<String, dynamic> g) {
    final onDuty = g["is_on_duty"] == true;
    final phone = (g["mobile_number"] ?? g["phone"] ?? "").toString();
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
                      (g["name"] ?? "-").toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "${g["guard_post"] ?? "-"} · ${_shiftText(g)}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.75),
                      ),
                    ),
                    if (phone.isNotEmpty) ...[
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await launchUrl(
                              Uri.parse(
                                "tel:${phone.replaceAll(RegExp(r'[^0-9+]'), '')}",
                              ),
                            );
                          } catch (_) {
                            showErrorSnackBar("Unable to open the dialer.");
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.call,
                              size: 14.sp,
                              color: const Color(0xFFB8860B),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              phone,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color.fromRGBO(42, 41, 51, 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: onDuty
                      ? const Color.fromRGBO(36, 176, 106, 0.15)
                      : const Color.fromRGBO(0, 0, 0, 0.05),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Text(
                  onDuty ? "On Duty" : "Off Duty",
                  style: GoogleFonts.outfit(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: onDuty
                        ? const Color(0xFF24B06A)
                        : const Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _openEdit(g),
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
                onPressed: () => _confirmRemove(g),
                icon: Icon(
                  Icons.person_remove_outlined,
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
      ),
    );
  }
}

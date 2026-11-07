import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:url_launcher/url_launcher.dart';

final residentFrequentVisitorsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
      return ref.read(authServiceProvider).getResidentFrequentVisitors();
    });

/// Guard jin logon ko is flat ke liye "frequent" banata hai (maid, driver, cook...),
/// wo resident ko yaha dikhte hain. GET /resident/frequent-visitors
class ResidentFrequentVisitorsScreen extends ConsumerStatefulWidget {
  const ResidentFrequentVisitorsScreen({super.key});

  @override
  ConsumerState<ResidentFrequentVisitorsScreen> createState() =>
      _ResidentFrequentVisitorsScreenState();
}

class _ResidentFrequentVisitorsScreenState
    extends ConsumerState<ResidentFrequentVisitorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _selectedFilterIndex = 0; // 0 = All, 1 = Inside Now, 2 = Outside

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getRoleIcon(String role) {
    final lower = role.toLowerCase();
    if (lower.contains('maid') ||
        lower.contains('clean') ||
        lower.contains('housekeep')) {
      return Icons.cleaning_services_outlined;
    } else if (lower.contains('cook') || lower.contains('chef')) {
      return Icons.restaurant_outlined;
    } else if (lower.contains('driver')) {
      return Icons.directions_car_outlined;
    } else if (lower.contains('milk') || lower.contains('paper')) {
      return Icons.local_shipping_outlined;
    } else if (lower.contains('tutor') || lower.contains('teach')) {
      return Icons.school_outlined;
    } else if (lower.contains('electric') ||
        lower.contains('plumb') ||
        lower.contains('repair')) {
      return Icons.build_outlined;
    } else if (lower.contains('guard') || lower.contains('secur')) {
      return Icons.security_outlined;
    }
    return Icons.person_outline_rounded;
  }

  Future<void> _makeCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.isEmpty) return;
    final uri = Uri.parse("tel:$cleanPhone");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Could not launch call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(residentFrequentVisitorsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequent Visitors",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Registered regular staff for your flat",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.heading),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 42.sp,
                  color: Colors.red.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  "Could not load frequent visitors",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Please check your internet connection and try again.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    color: const Color.fromRGBO(42, 41, 51, 0.7),
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.invalidate(residentFrequentVisitorsProvider),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: Text(
                    "Retry",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (res) {
          final data = (res['data'] as Map?)?.cast<String, dynamic>() ?? {};
          final rawList = ((data['frequent_visitors'] as List?) ?? const [])
              .map((e) => (e as Map).cast<String, dynamic>())
              .toList();

          final int totalCount = data['total'] ?? rawList.length;
          final int insideNowCount = data['inside_now'] ??
              rawList.where((v) => v['is_inside'] == true).length;
          final int outsideCount =
              (totalCount - insideNowCount).clamp(0, totalCount);

          // Filtering by tab
          List<Map<String, dynamic>> filtered = rawList;
          if (_selectedFilterIndex == 1) {
            filtered = filtered
                .where((v) =>
                    v['is_inside'] == true ||
                    v['inside'] == true ||
                    v['status']?.toString().toLowerCase() == 'inside')
                .toList();
          } else if (_selectedFilterIndex == 2) {
            filtered = filtered
                .where((v) =>
                    v['is_inside'] != true &&
                    v['inside'] != true &&
                    v['status']?.toString().toLowerCase() != 'inside')
                .toList();
          }

          // Search filtering
          if (_searchQuery.trim().isNotEmpty) {
            final query = _searchQuery.trim().toLowerCase();
            filtered = filtered.where((v) {
              final name = (v['name'] ?? v['visitor_name'] ?? '')
                  .toString()
                  .toLowerCase();
              final role = (v['role'] ?? v['type'] ?? '')
                  .toString()
                  .toLowerCase();
              final phone = (v['phone'] ?? v['mobile'] ?? '')
                  .toString()
                  .toLowerCase();
              return name.contains(query) ||
                  role.contains(query) ||
                  phone.contains(query);
            }).toList();
          }

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async =>
                ref.refresh(residentFrequentVisitorsProvider.future),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                // Summary Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF101C16),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.groups_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$totalCount",
                                  style: GoogleFonts.outfit(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  "Registered",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: insideNowCount > 0
                              ? const Color(0xFFF0FDF4)
                              : Colors.white,
                          border: Border.all(
                            color: insideNowCount > 0
                                ? const Color(0xFF22C55E)
                                : const Color(0xff101C16),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: insideNowCount > 0
                                    ? const Color(0xFF16A34A)
                                    : const Color(0xFF101C16),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.login_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "$insideNowCount",
                                      style: GoogleFonts.outfit(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: insideNowCount > 0
                                            ? const Color(0xFF16A34A)
                                            : AppColors.heading,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    if (insideNowCount > 0) ...[
                                      SizedBox(width: 6.w),
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF22C55E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  "Inside Now",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: insideNowCount > 0
                                        ? const Color(0xFF15803D)
                                        : const Color.fromRGBO(
                                            42,
                                            41,
                                            51,
                                            0.65,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Search Bar
                Container(
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: AppColors.heading,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search by name, role or phone...",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.heading,
                        size: 20.sp,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppColors.heading,
                                size: 18.sp,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = "";
                                });
                              },
                            )
                          : null,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // Filter Tabs (All, Inside Now, Outside)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: "All ($totalCount)",
                        isSelected: _selectedFilterIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedFilterIndex = 0;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: "Inside Now ($insideNowCount)",
                        isSelected: _selectedFilterIndex == 1,
                        activeColor: const Color(0xFF16A34A),
                        onTap: () {
                          setState(() {
                            _selectedFilterIndex = 1;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      _buildFilterChip(
                        label: "Outside ($outsideCount)",
                        isSelected: _selectedFilterIndex == 2,
                        onTap: () {
                          setState(() {
                            _selectedFilterIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Visitor List or Empty State
                if (filtered.isEmpty) ...[
                  SizedBox(height: 40.h),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 68.w,
                          height: 68.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff101C16),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            Icons.group_off_outlined,
                            size: 32.sp,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "No visitors matching '$_searchQuery'"
                              : "No frequent visitors found",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? "Try searching with a different name or role."
                                : "Daily help, drivers, or staff registered for your flat by security will appear here.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color.fromRGBO(42, 41, 51, 0.65),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...filtered.map((v) => _buildVisitorCard(v)),
                  SizedBox(height: 20.h),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? activeColor,
  }) {
    final effectiveColor = activeColor ?? const Color(0xff101C16);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? effectiveColor : Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: isSelected ? effectiveColor : const Color(0xff101C16),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xff101C16),
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorCard(Map<String, dynamic> v) {
    final name = (v['name'] ?? v['visitor_name'] ?? 'Visitor').toString();
    final phone =
        (v['phone'] ?? v['mobile'] ?? v['phone_number'] ?? '').toString();
    final role =
        (v['role'] ?? v['type'] ?? v['designation'] ?? 'Staff').toString();
    final isInside = v['is_inside'] == true ||
        v['inside'] == true ||
        v['status']?.toString().toLowerCase() == 'inside';
    final addedBy =
        (v['added_by_name'] ?? v['added_by'] ?? 'Security').toString();
    final addedOn = (v['added_on'] ?? v['created_at'] ?? '').toString();
    final totalVisits =
        v['total_visits'] ?? v['visit_count'] ?? v['visits'] ?? 0;
    final lastVisit =
        (v['last_visit'] ?? v['last_entry_time'] ?? v['last_entry'] ?? '')
            .toString();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isInside ? const Color(0xFFFDFAF0) : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isInside
              ? const Color(0xff101C16)
              : const Color.fromRGBO(16, 28, 22, 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar, Name & Role, Inside/Outside Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: isInside
                      ? const Color(0xFF101C16)
                      : const Color(0xFFF3F0E9),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xff101C16),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  _getRoleIcon(role),
                  color: isInside ? Colors.white : AppColors.heading,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        role.isEmpty ? "Staff" : role,
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Inside Status Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isInside
                      ? const Color(0xFFD4F5E1)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isInside
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFD1D5DB),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isInside
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF9CA3AF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      isInside ? "Inside" : "Outside",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isInside
                            ? const Color(0xFF15803D)
                            : const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          const Divider(height: 1, color: Color(0xFFE8E5DC)),
          SizedBox(height: 10.h),

          // Contact & Visits Info Row
          Row(
            children: [
              if (phone.isNotEmpty) ...[
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 15.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.7),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _makeCall(phone),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101C16),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.call,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Text(
                    "No phone registered",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromRGBO(42, 41, 51, 0.5),
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 8.h),

          // Total Visits & Last Visit
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0E9),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 13.sp,
                      color: AppColors.heading,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "$totalVisits visits",
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
              if (lastVisit.isNotEmpty) ...[
                SizedBox(width: 8.w),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 13.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          "Last: $lastVisit",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 8.h),

          // Registered By Footer
          Text(
            "Registered by $addedBy${addedOn.isNotEmpty ? ' · $addedOn' : ''}",
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              color: const Color.fromRGBO(42, 41, 51, 0.55),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

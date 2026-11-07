import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAnnouncement/AssociationAddAnnouncementScreen.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationAnnouncement/provider/getCommitteeAnnouncementProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getCommitteeAnnouncementModel.dart';

class AssociationAnnouncementListScreen extends ConsumerStatefulWidget {
  const AssociationAnnouncementListScreen({super.key});

  @override
  ConsumerState<AssociationAnnouncementListScreen> createState() =>
      _AssociationAnnouncementListScreenState();
}

class _AssociationAnnouncementListScreenState
    extends ConsumerState<AssociationAnnouncementListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "ALL"; // ALL, PINNED, MAINTENANCE, RESIDENTS

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToAddAnnouncement() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AssociationAddAnnouncementScreen(),
      ),
    );

    // If an announcement was added, refresh the list
    if (result == true) {
      ref.invalidate(getCommitteeAnnouncementProvider);
    }
  }

  List<AnnouncementItemData> _applyFilters(List<AnnouncementItemData> items) {
    return items.where((item) {
      // Search filter
      final title = (item.title ?? "").toLowerCase();
      final msg = (item.message ?? "").toLowerCase();
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty || title.contains(q) || msg.contains(q);

      if (!matchesSearch) return false;

      // Category tab filter
      switch (_selectedFilter) {
        case "PINNED":
          return item.pinned == true;
        case "MAINTENANCE":
          return (item.type ?? "").toLowerCase() == "maintenance";
        case "RESIDENTS":
          return (item.targetAudience ?? "").toLowerCase().contains("resident");
        case "ALL":
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(getCommitteeAnnouncementProvider);

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
                        "Announcements",
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
                        "Committee broadcast notices & updates",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(42, 41, 51, 0.7),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Add Icon Button in AppBar
                GestureDetector(
                  onTap: _navigateToAddAnnouncement,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101C16),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "New",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF101C16),
        elevation: 4,
        onPressed: _navigateToAddAnnouncement,
        icon: Icon(Icons.campaign_outlined, color: Colors.white, size: 20.sp),
        label: Text(
          "Add Announcement",
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: announcementsAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32.w,
                height: 32.h,
                child: const CircularProgressIndicator(
                  color: Color(0xFF101C16),
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Loading announcements...",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: const Color(0xFF6F7672),
                ),
              ),
            ],
          ),
        ),
        error: (err, stack) => RefreshIndicator(
          color: const Color(0xFF101C16),
          onRefresh: () async {
            ref.invalidate(getCommitteeAnnouncementProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 80.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    size: 46.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Unable to load announcements",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    err.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: const Color(0xFF6F7672),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101C16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    onPressed: () {
                      ref.invalidate(getCommitteeAnnouncementProvider);
                    },
                    icon: Icon(Icons.refresh, color: Colors.white, size: 16.sp),
                    label: Text(
                      "Retry",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (announcementModel) {
          final rawItems = announcementModel.data ?? [];
          final filteredItems = _applyFilters(rawItems);

          return RefreshIndicator(
            color: const Color(0xFF101C16),
            onRefresh: () async {
              ref.invalidate(getCommitteeAnnouncementProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              children: [
                // -------------------------------------------------------------
                // SEARCH BAR
                // -------------------------------------------------------------
                // Container(
                //   height: 46.h,
                //   decoration: BoxDecoration(
                //     color: Colors.white.withValues(alpha: 0.6),
                //     borderRadius: BorderRadius.circular(8.r),
                //     border: Border.all(
                //       color: const Color.fromRGBO(16, 28, 22, 0.25),
                //       width: 1.2,
                //     ),
                //   ),
                //   child: TextField(
                //     controller: _searchController,
                //     onChanged: (val) {
                //       setState(() {
                //         _searchQuery = val.trim();
                //       });
                //     },
                //     style: GoogleFonts.outfit(
                //       fontSize: 14.sp,
                //       color: AppColors.heading,
                //     ),
                //     decoration: InputDecoration(
                //       isDense: true,
                //       hintText: "Search announcements...",
                //       hintStyle: GoogleFonts.outfit(
                //         fontSize: 13.5.sp,
                //         color: const Color.fromRGBO(42, 41, 51, 0.5),
                //       ),
                //       prefixIcon: Icon(
                //         Icons.search,
                //         color: const Color(0xFF101C16).withValues(alpha: 0.7),
                //         size: 20.sp,
                //       ),
                //       suffixIcon: _searchQuery.isNotEmpty
                //           ? IconButton(
                //               icon: Icon(
                //                 Icons.clear,
                //                 size: 18.sp,
                //                 color: const Color(0xFF6F7672),
                //               ),
                //               onPressed: () {
                //                 _searchController.clear();
                //                 setState(() {
                //                   _searchQuery = "";
                //                 });
                //               },
                //             )
                //           : null,
                //       border: InputBorder.none,
                //       contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                //     ),
                //   ),
                // ),

                // SizedBox(height: 12.h),

                // // -------------------------------------------------------------
                // // FILTER TABS (All, Pinned, Maintenance, Residents)
                // // -------------------------------------------------------------
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       _filterChip(
                //         key: "ALL",
                //         label: "All (${rawItems.length})",
                //       ),
                //       SizedBox(width: 8.w),
                //       _filterChip(
                //         key: "PINNED",
                //         label: "Pinned",
                //         icon: Icons.push_pin_outlined,
                //       ),
                //       SizedBox(width: 8.w),
                //       _filterChip(
                //         key: "MAINTENANCE",
                //         label: "Maintenance",
                //         icon: Icons.build_outlined,
                //       ),
                //       SizedBox(width: 8.w),
                //       _filterChip(
                //         key: "RESIDENTS",
                //         label: "Residents",
                //         icon: Icons.home_outlined,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 16.h),

                // -------------------------------------------------------------
                // ANNOUNCEMENT CARDS LIST
                // -------------------------------------------------------------
                if (filteredItems.isEmpty)
                  _buildEmptyState(
                    hasQuery:
                        _searchQuery.isNotEmpty || _selectedFilter != "ALL",
                  )
                else
                  ...filteredItems.map((item) => _buildAnnouncementCard(item)),

                SizedBox(height: 70.h), // Space for FAB
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filterChip({
    required String key,
    required String label,
    IconData? icon,
  }) {
    final bool isSelected = _selectedFilter == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = key;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF101C16) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF101C16)
                : const Color.fromRGBO(16, 28, 22, 0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13.sp,
                color: isSelected
                    ? const Color(0xFFE8B900)
                    : const Color(0xFF101C16),
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF101C16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementItemData item) {
    final bool isPinned = item.pinned == true;
    final String type = (item.type ?? "Notice").toUpperCase();
    final String priority = (item.priority ?? "Normal").toUpperCase();
    final String date =
        item.dateHuman ?? item.createdAtFormatted ?? item.createdAt ?? "";

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isPinned
              ? const Color(0xFF101C16)
              : const Color.fromRGBO(16, 28, 22, 0.25),
          width: isPinned ? 1.5 : 1.2,
        ),
        boxShadow: isPinned
            ? [
                BoxShadow(
                  color: const Color(0xFF101C16).withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: () {
            _showAnnouncementDetailSheet(item);
          },
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Badges & Pinned Tag
                // Row(
                //   children: [
                //     // Type Badge
                //     Container(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 8.w,
                //         vertical: 3.h,
                //       ),
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF101C16),
                //         borderRadius: BorderRadius.circular(4.r),
                //       ),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Icon(
                //             item.typeIcon,
                //             size: 11.sp,
                //             color: const Color(0xFFE8B900),
                //           ),
                //           SizedBox(width: 4.w),
                //           Text(
                //             type,
                //             style: GoogleFonts.outfit(
                //               fontSize: 10.5.sp,
                //               fontWeight: FontWeight.w700,
                //               color: Colors.white,
                //               letterSpacing: 0.2,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),

                //     SizedBox(width: 6.w),

                //     // Priority Badge
                //     Container(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 7.w,
                //         vertical: 3.h,
                //       ),
                //       decoration: BoxDecoration(
                //         color: item.priorityColor.withValues(alpha: 0.12),
                //         borderRadius: BorderRadius.circular(4.r),
                //         border: Border.all(
                //           color: item.priorityColor.withValues(alpha: 0.4),
                //           width: 0.8,
                //         ),
                //       ),
                //       child: Text(
                //         priority,
                //         style: GoogleFonts.outfit(
                //           fontSize: 10.sp,
                //           fontWeight: FontWeight.w700,
                //           color: item.priorityColor,
                //         ),
                //       ),
                //     ),

                //     if (isPinned) ...[
                //       SizedBox(width: 6.w),
                //       Container(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: 6.w,
                //           vertical: 3.h,
                //         ),
                //         decoration: BoxDecoration(
                //           color: const Color(0xFFE8B900).withValues(alpha: 0.2),
                //           borderRadius: BorderRadius.circular(4.r),
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Icon(
                //               Icons.push_pin,
                //               size: 10.sp,
                //               color: const Color(0xFF996500),
                //             ),
                //             SizedBox(width: 3.w),
                //             Text(
                //               "Pinned",
                //               style: GoogleFonts.outfit(
                //                 fontSize: 10.sp,
                //                 fontWeight: FontWeight.w700,
                //                 color: const Color(0xFF996500),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],

                //     const Spacer(),

                //     // Date
                //     if (date.isNotEmpty)
                //       Text(
                //         date,
                //         style: GoogleFonts.outfit(
                //           fontSize: 11.5.sp,
                //           fontWeight: FontWeight.w500,
                //           color: const Color(0xFF6F7672),
                //         ),
                //       ),
                //   ],
                // ),
                // SizedBox(height: 10.h),

                // Title
                Text(
                  item.title ?? "Announcement",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 6.h),

                // Message snippet
                Text(
                  item.message ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 12.h),

                // Bottom row: Target audience / Created by & Details link
                Row(
                  children: [
                    if (item.targetAudience != null &&
                        item.targetAudience!.isNotEmpty) ...[
                      Icon(
                        Icons.people_outline,
                        size: 14.sp,
                        color: const Color(0xFF6F7672),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "For: ${item.targetAudience}",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6F7672),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      "View Details",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11.sp,
                      color: AppColors.heading,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required bool hasQuery}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color.fromRGBO(16, 28, 22, 0.25),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            hasQuery ? Icons.search_off_rounded : Icons.campaign_outlined,
            size: 46.sp,
            color: const Color(0xFF6F7672),
          ),
          SizedBox(height: 12.h),
          Text(
            hasQuery
                ? "No matching announcements"
                : "No announcements published yet",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            hasQuery
                ? "Try searching with different keywords or reset filters."
                : "Create and broadcast notices to keep residents and staff updated.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6F7672),
            ),
          ),
          if (!hasQuery) ...[
            SizedBox(height: 18.h),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF101C16),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              onPressed: _navigateToAddAnnouncement,
              icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
              label: Text(
                "Create Announcement",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAnnouncementDetailSheet(AnnouncementItemData item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            border: Border.all(color: const Color(0xFF101C16), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101C16).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF101C16),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              (item.type ?? "Notice").toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: item.priorityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "Priority: ${(item.priority ?? 'Normal').toUpperCase()}",
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: item.priorityColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Title
                      Text(
                        item.title ?? "Announcement",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Date & Target Audience Info
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14.sp,
                            color: const Color(0xFF6F7672),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            item.dateHuman ??
                                item.createdAtFormatted ??
                                item.createdAt ??
                                "",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFF6F7672),
                            ),
                          ),
                          if (item.targetAudience != null) ...[
                            SizedBox(width: 14.w),
                            Icon(
                              Icons.groups_outlined,
                              size: 15.sp,
                              color: const Color(0xFF6F7672),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Target: ${item.targetAudience}",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color(0xFF6F7672),
                              ),
                            ),
                          ],
                        ],
                      ),

                      Divider(
                        height: 28.h,
                        color: const Color.fromRGBO(16, 28, 22, 0.2),
                      ),

                      // Message content
                      Text(
                        "Message Details",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6F7672),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        item.message ?? "",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.heading,
                          height: 1.5,
                        ),
                      ),

                      if (item.createdBy != null) ...[
                        Divider(
                          height: 28.h,
                          color: const Color.fromRGBO(16, 28, 22, 0.2),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: const Color(0xFF101C16),
                              child: Text(
                                (item.createdBy?.name ?? "C")[0].toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.createdBy?.name ?? "Committee Member",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                                Text(
                                  item.createdBy?.role ?? "Committee",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF6F7672),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

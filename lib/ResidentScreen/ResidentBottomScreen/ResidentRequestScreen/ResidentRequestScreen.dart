import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthService.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getComplaintListModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentBottomScreen/ResidentRequestScreen/provider/getComplaintListProvider.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentComplaintScreen/ResidentComplantStatus.dart';
import 'package:property_association_or_resident/ResidentScreen/Common/markCompletedFlow.dart';
import 'package:property_association_or_resident/ResidentScreen/RaiseComplaintScreen/RaiseComplaint.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentServiceRequest/ResidentServiceRequestScreen.dart';

class Residentrequestscreen extends ConsumerStatefulWidget {
  final bool showBackButton;
  const Residentrequestscreen({super.key, this.showBackButton = false});

  @override
  ConsumerState<Residentrequestscreen> createState() =>
      _ResidentrequestscreenState();
}

class _ResidentrequestscreenState extends ConsumerState<Residentrequestscreen> {
  String selectedFilter = "all";
  // 'complaint' | 'service_request' - dono ki list alag dikhti hai
  String selectedType = "complaint";

  Color? _parseHexColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return null;
    String cleanHex = hexString.replaceFirst('#', '').trim();
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    if (cleanHex.length == 8) {
      final val = int.tryParse(cleanHex, radix: 16);
      if (val != null) return Color(val);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(getComplaintListProvider(selectedFilter));

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
              if (widget.showBackButton)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 41.w,
                    height: 41.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(16, 28, 22, 0.3),
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: const Color(0xff101C16),
                      size: 16.sp,
                    ),
                  ),
                ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Requests",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Track your complaints & service requests",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.65),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff071811),
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => selectedType == 'service_request'
                  ? const ResidentServiceRequestScreen()
                  : const Raisecomplaint(),
            ),
          );
          ref.invalidate(getComplaintListProvider);
        },
        icon: const Icon(Icons.add),
        label: Text(
          selectedType == 'service_request' ? "New Service Request" : "New Complaint",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: requestState.when(
        data: (data) {
          final filterTabs =
              (data.data?.filterTabs != null &&
                  data.data!.filterTabs!.isNotEmpty)
              ? data.data!.filterTabs!
              : [
                  FilterTab(key: "all", label: "All"),
                  FilterTab(key: "open", label: "Open"),
                  FilterTab(key: "in_progress", label: "Under Review"),
                  FilterTab(key: "resolved", label: "Resolved"),
                ];

          final allRequests = data.data?.requests ?? <Request>[];
          final visibleRequests = allRequests
              .where((r) => (r.type ?? 'complaint') == selectedType)
              .toList();
          final isServiceTab = selectedType == 'service_request';

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(184, 134, 11, 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(184, 134, 11, 0.3),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.description,
                          size: 20.sp,
                          color: const Color(0xffB8860B),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.data?.registeredApartment?.label ??
                                  "REGISTERED APARTMENT",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              data.data?.registeredApartment?.text ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
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
                SizedBox(height: 16.h),
                _typeSwitcher(allRequests),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: filterTabs.map((tab) {
                      final tabKey = tab.key ?? "all";
                      final isSelected = selectedFilter == tabKey;
                      final String tabLabel = tab.label ?? tabKey;
                      return _tab(tabLabel, tabKey, isSelected);
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20.h),
                if (visibleRequests.isEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text(
                        isServiceTab
                            ? "No service requests found"
                            : "No complaints found",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: visibleRequests.length,
                    itemBuilder: (context, index) {
                      final request = visibleRequests[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Residentcomplantstatus(
                                complainID: request.id.toString(),
                              ),
                            ),
                          );
                        },
                        child: Builder(
                          builder: (context) {
                            final isEmergency =
                                request.isEmergency == true ||
                                (request.status ?? "").toLowerCase().contains(
                                  "emergency",
                                ) ||
                                (request.status ?? "").toLowerCase().contains(
                                  "overdue",
                                ) ||
                                request.isOverdue == true;

                            final Color? apiStatusColor = _parseHexColor(
                              request.statusColor,
                            );

                            Color badgeBg;
                            Color badgeText;
                            Border? badgeBorder;
                            String statusLabel;

                            final rawStatusLower = (request.status ?? "")
                                .toLowerCase()
                                .trim();
                            final isInProgress =
                                rawStatusLower == "in progress" ||
                                rawStatusLower == "in_progress";

                            if (isEmergency) {
                              badgeBg = const Color(0xFFFFEBEE);
                              badgeText = const Color(0xFFEF4444);
                              badgeBorder = Border.all(
                                color: const Color(0xFFEF4444),
                                width: 1,
                              );
                              statusLabel =
                                  request.status ?? "Emergency (Overdue)";
                            } else if (apiStatusColor != null) {
                              badgeBg = apiStatusColor.withOpacity(0.12);
                              badgeText = apiStatusColor;
                              badgeBorder = Border.all(
                                color: apiStatusColor.withOpacity(0.35),
                                width: 1,
                              );
                              statusLabel = request.status ?? "";
                            } else {
                              final isResolved =
                                  rawStatusLower == "resolved" ||
                                  rawStatusLower == "completed" ||
                                  rawStatusLower == "closed";

                              if (isResolved) {
                                badgeBg = const Color(0xFFE8F5E9);
                                badgeText = const Color(0xFF22C55E);
                                badgeBorder = Border.all(
                                  color: const Color(0xFFA5D6A7),
                                  width: 1,
                                );
                                statusLabel = request.status ?? "Resolved";
                              } else if (isInProgress) {
                                badgeBg = const Color.fromRGBO(
                                  184,
                                  134,
                                  11,
                                  0.15,
                                );
                                badgeText = const Color(0xFFEAB308);
                                badgeBorder = Border.all(
                                  color: const Color(
                                    0xFFEAB308,
                                  ).withOpacity(0.3),
                                  width: 1,
                                );
                                statusLabel = request.status ?? "In Progress";
                              } else {
                                badgeBg = const Color(0xFFECEFF1);
                                badgeText = const Color(0xFF455A64);
                                badgeBorder = null;
                                statusLabel = request.status ?? "Submitted";
                              }
                            }

                            final areaType =
                                request.areaType ?? request.issueScope;
                            final areaLabel =
                                request.areaTypeLabel ??
                                (areaType == "common_area"
                                    ? "Common Area"
                                    : (areaType == "inside_house"
                                          ? "Inside House"
                                          : null));
                            final bool isCommonArea =
                                (areaType == "common_area") ||
                                (areaLabel ?? "").toLowerCase().contains(
                                  "common",
                                );

                            return Container(
                              padding: EdgeInsets.all(14.w),
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: request.isServiceRequest
                                    ? const Color(0xFFF5F9FF)
                                    : null,
                                border: Border.all(
                                  color: request.isServiceRequest
                                      ? const Color(0xFFBFDBFE)
                                      : const Color.fromRGBO(16, 28, 22, 0.15),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              request.isServiceRequest
                                                  ? Icons.build_circle_outlined
                                                  : Icons.report_problem_outlined,
                                              size: 18.sp,
                                              color: request.isServiceRequest
                                                  ? const Color(0xFF1D4ED8)
                                                  : const Color(0xFFB8860B),
                                            ),
                                            SizedBox(width: 6.w),
                                            Flexible(
                                              child: Text(
                                                request.tokenLabel ??
                                                    request.tokenNumber ??
                                                    "N/A",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.heading,
                                                  letterSpacing: -0.2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: badgeBg,
                                          border: badgeBorder,
                                          borderRadius: BorderRadius.circular(
                                            50.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isEmergency) ...[
                                              Text(
                                                "🔴 ",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                            Text(
                                              statusLabel,
                                              style: GoogleFonts.outfit(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: badgeText,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.title ?? "N/A",
                                          style: GoogleFonts.outfit(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                      if (areaLabel != null) ...[
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isCommonArea
                                                ? const Color(0xFFEFF6FF)
                                                : const Color(0xFFFBF4E6),
                                            border: Border.all(
                                              color: isCommonArea
                                                  ? const Color(0xFFBFDBFE)
                                                  : const Color(0xFFE6D2A8),
                                              width: 0.8,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                          ),
                                          child: Text(
                                            "${isCommonArea ? '🏢 ' : '🏠 '}$areaLabel",
                                            style: GoogleFonts.outfit(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: isCommonArea
                                                  ? const Color(0xFF1D4ED8)
                                                  : const Color(0xFFB8860B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: const Color(0xffB8860B),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          request.location ?? "N/A",
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ),
                                      if (request.canMarkCompleted) ...[
                                        GestureDetector(
                                          onTap: () => showMarkCompletedFlow(
                                            context: context,
                                            ref: ref,
                                            id: request.id.toString(),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff16B364),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.white,
                                                  size: 13.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  "Mark Completed",
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
                                      if (request.status == 'Resolved') ...[
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (dialogContext) {
                                                bool isDialogLoading = false;
                                                return StatefulBuilder(
                                                  builder: (context, setDialogState) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Close Request",
                                                      ),
                                                      content: Text(
                                                        "Are you sure you want to close this request?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              isDialogLoading
                                                              ? null
                                                              : () => Navigator.pop(
                                                                  dialogContext,
                                                                ),
                                                          child: Text("Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed:
                                                              isDialogLoading
                                                              ? null
                                                              : () async {
                                                                  setDialogState(
                                                                    () {
                                                                      isDialogLoading =
                                                                          true;
                                                                    },
                                                                  );
                                                                  try {
                                                                    final service =
                                                                        ref.read(
                                                                          authServiceProvider,
                                                                        );
                                                                    final res = await service.closeComplant(
                                                                      id: request!
                                                                          .id
                                                                          .toString(),
                                                                    );
                                                                    if (res.status ==
                                                                        true) {
                                                                      ref.invalidate(
                                                                        getComplaintListProvider,
                                                                      );
                                                                      if (dialogContext
                                                                          .mounted) {
                                                                        Navigator.pop(
                                                                          dialogContext,
                                                                        );
                                                                      }
                                                                      showSuccessSnackBar(
                                                                        res.message ??
                                                                            "Request closed successfully",
                                                                      );
                                                                    } else {
                                                                      showSuccessSnackBar(
                                                                        res.message ??
                                                                            "Failed to close request",
                                                                      );
                                                                    }
                                                                  } catch (e) {
                                                                    showSuccessSnackBar(
                                                                      "Failed to close request",
                                                                    );
                                                                  } finally {
                                                                    if (dialogContext
                                                                        .mounted) {
                                                                      setDialogState(() {
                                                                        isDialogLoading =
                                                                            false;
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                          child: isDialogLoading
                                                              ? SizedBox(
                                                                  width: 18.w,
                                                                  height: 18.h,
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2.w,
                                                                    color: AppColors
                                                                        .heading,
                                                                  ),
                                                                )
                                                              : Text("Close"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff071811),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 13.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  "Close",
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
                                      SizedBox(width: 10.w),
                                      Text(
                                        "View Details  →",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffB8860B),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  /// Complaints aur Service Requests ke alag-alag cards/lists.
  Widget _typeSwitcher(List<Request> all) {
    final complaintCount = all
        .where((r) => (r.type ?? 'complaint') == 'complaint')
        .length;
    final serviceCount = all.where((r) => r.isServiceRequest).length;
    return Row(
      children: [
        Expanded(
          child: _typeCard(
            key: 'complaint',
            label: "Complaints",
            count: complaintCount,
            icon: Icons.report_problem_outlined,
            color: const Color(0xFFB8860B),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _typeCard(
            key: 'service_request',
            label: "Service Requests",
            count: serviceCount,
            icon: Icons.build_circle_outlined,
            color: const Color(0xFF1D4ED8),
          ),
        ),
      ],
    );
  }

  Widget _typeCard({
    required String key,
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    final selected = selectedType == key;
    return GestureDetector(
      onTap: () {
        if (!selected) setState(() => selectedType = key);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? color : const Color.fromRGBO(16, 28, 22, 0.2),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "$count",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, String key, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedFilter != key) {
            setState(() {
              selectedFilter = key;
            });
          }
        },
        child: Container(
          height: 35.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xffC28A00) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: selected
                  ? Colors.white
                  : const Color.fromRGBO(16, 28, 22, 0.6),
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}

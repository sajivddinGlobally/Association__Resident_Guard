import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/Provider/HistoryRecordsProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardBottomScreen/GuardHistoryScreen/Provider/historyGuardProvider.dart';
import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/GuardHomeScreen.dart';
import 'package:property_association_or_resident/GuardScreen/Model/historyRecordsModel.dart';
import 'package:property_association_or_resident/GuardScreen/Model/markOutResModel.dart'
    as mark_out_model;

class Guaredhistoryscreen extends StatefulWidget {
  final bool? isBackButtonShow;
  const Guaredhistoryscreen({super.key, this.isBackButtonShow = false});

  @override
  State<Guaredhistoryscreen> createState() => _GuaredhistoryscreenState();
}

class _GuaredhistoryscreenState extends State<Guaredhistoryscreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToGuardHome() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => const GuardBottomNavState()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isBackButtonShow == true) {
          _navigateToGuardHome();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          automaticallyImplyLeading: false,
          titleSpacing: 20.w,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (widget.isBackButtonShow == true) ...[
                  GestureDetector(
                    onTap: _navigateToGuardHome,
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
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "History & Communication",
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Visits, parcels & guard communication",
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
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: const Color(0xffDDDDDD),
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              //   child: Row(
              //     children: [
              //       Expanded(child: _tabButton(title: "History", index: 0)),

              //       Expanded(child: _tabButton(title: "Guards", index: 1)),
              //     ],
              //   ),
              // ),
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xff0B211A),
                    borderRadius: BorderRadius.circular(10.r),
                  ),

                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.heading,

                  labelStyle: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w500,
                  ),

                  unselectedLabelStyle: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w600,
                  ),

                  tabs: [
                    Tab(text: "History"),
                    Tab(text: "Guards"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [HistoryTab(), GuardsTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _tabButton({required String title, required int index}) {
  //   final bool isSelected = selectedIndex == index;

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedIndex = index;
  //       });
  //     },
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 200),
  //       height: 36.h,
  //       margin: const EdgeInsets.symmetric(horizontal: 11),
  //       decoration: BoxDecoration(
  //         color: isSelected ? const Color(0xff0B1C15) : Colors.transparent,
  //         borderRadius: BorderRadius.circular(10.r),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 17.sp,
  //           fontWeight: FontWeight.w500,
  //           letterSpacing: -0.2,
  //           color: isSelected ? Colors.white : const Color(0xff101C16),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class HistoryTab extends ConsumerStatefulWidget {
  const HistoryTab({super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  int index = 0;
  String? _markingOutId;

  Future<void> _handleMarkOut(Record? item) async {
    final id = item?.rawId != null
        ? item!.rawId.toString()
        : (item?.id != null ? item!.id.toString() : null);

    if (id == null || id.isEmpty) {
      showErrorSnackBar("ID not found to mark exit");
      return;
    }

    setState(() {
      _markingOutId = id;
    });

    try {
      final res = await ref.read(authServiceProvider).markOutData(id);
      if (res.status == true) {
        showSuccessSnackBar(res.message ?? "Exit recorded successfully");
        if (mounted) {
          showExitRecordedPopup(context, res.data);
        }
        ref.invalidate(historyRecordsProvider);
      } else {
        showErrorSnackBar(res.message ?? "Failed to mark exit");
      }
    } catch (e) {
      // showErrorSnackBar(e.toString());
      log(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _markingOutId = null;
        });
      }
    }
  }

  final TextEditingController otpController = TextEditingController();
  bool isverify = false;

  /// Server se aaya hex colour ("#10b981"); na ho / galat ho to purana green.
  Color _badgeTint(String? hex) {
    try {
      if (hex != null && hex.startsWith('#') && hex.length == 7) {
        return Color(int.parse('FF${hex.substring(1)}', radix: 16));
      }
    } catch (_) {}
    return const Color(0xff24B06A);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _showReleaseParcelDialog(dynamic parcel) {
    otpController.clear();

    final String company = parcel is Record
        ? (parcel.title ?? parcel.vendorName ?? "Parcel")
        : (parcel is Map
              ? (parcel['company']?.toString() ?? "Parcel")
              : "Parcel");
    final String flatOrCategory = parcel is Record
        ? (parcel.categoryLabel ?? "Flat")
        : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
    final String rawParcelId = parcel is Record
        ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
        : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
    final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericId.isEmpty) {
      showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
      return;
    }
    final effectiveId = numericId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.lock_open_rounded,
                      color: AppColors.heading,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Release Parcel",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify resident's 4-digit pickup code or scan QR to release parcel for $flatOrCategory.",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F4),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xFFE5E0D5)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          company,
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Enter 4-Digit Pickup OTP",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 8,
                      color: AppColors.heading,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "••••",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        color: Colors.grey,
                        letterSpacing: 8,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.heading,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isverify
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF666666),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isverify
                      ? null
                      : () async {
                          final otp = otpController.text.trim();
                          if (otp.length != 4) {
                            showErrorSnackBar(
                              "Please enter the resident's 4-digit pickup code.",
                            );
                            return;
                          }
                          setDialogState(() {
                            isverify = true;
                          });
                          try {
                            final res = await ref
                                .read(authServiceProvider)
                                .verifyParcelHandoverData(
                                  id: effectiveId,
                                  pickupCode: otp,
                                );
                            if (res.status == true) {
                              ref.invalidate(historyRecordsProvider("parcel"));
                              ref.invalidate(historyRecordsProvider("all"));
                              showSuccessSnackBar(
                                res.message ?? "Parcel released successfully.",
                              );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            } else {
                              otpController.clear();
                              showErrorSnackBar(
                                res.message ??
                                    "Incorrect pickup code. Please try again.",
                              );
                            }
                          } catch (e) {
                            log(e.toString());
                            otpController.clear();
                          } finally {
                            if (dialogContext.mounted) {
                              setDialogState(() {
                                isverify = false;
                              });
                            }
                          }
                        },
                  child: isverify
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          "Verify & Hand Over",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.sp,
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

  void _showMarkExitDialog(dynamic parcel) {
    final String company = parcel is Record
        ? (parcel.title ?? parcel.vendorName ?? "Parcel Delivery")
        : (parcel is Map
              ? (parcel['company']?.toString() ?? "Parcel Delivery")
              : "Parcel Delivery");
    final String flatOrCategory = parcel is Record
        ? (parcel.categoryLabel ?? "Flat")
        : (parcel is Map ? ("Flat ${parcel['flatNumber'] ?? ''}") : "Flat");
    final String rawParcelId = parcel is Record
        ? (parcel.rawId?.toString() ?? parcel.id ?? "1")
        : (parcel is Map ? (parcel['id']?.toString() ?? "1") : "1");
    final numericId = rawParcelId.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericId.isEmpty) {
      showErrorSnackBar("Parcel ID not found. Please refresh and try again.");
      return;
    }
    final effectiveId = numericId;

    bool isExiting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.scaffoldBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: AppColors.heading,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      "Mark Delivery Exit",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery agent for $company has finished delivery at $flatOrCategory. Confirm mark exit?",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isExiting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF666666),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isExiting
                      ? null
                      : () async {
                          setDialogState(() {
                            isExiting = true;
                          });

                          try {
                            final res = await ref
                                .read(authServiceProvider)
                                .parcelHandoverData(effectiveId);
                            ref.invalidate(historyRecordsProvider("parcel"));
                            ref.invalidate(historyRecordsProvider("all"));
                            if (res.status == true) {
                              showSuccessSnackBar(
                                res.message ?? "Delivery exit marked.",
                              );
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                            } else {
                              showErrorSnackBar(
                                res.message ?? "Could not mark delivery exit.",
                              );
                            }
                          } catch (e) {
                            // Server ka asli error Dio interceptor already dikha deta hai.
                            log(e.toString());
                          } finally {
                            if (dialogContext.mounted) {
                              setDialogState(() {
                                isExiting = false;
                              });
                            }
                          }
                        },
                  child: isExiting
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          "Confirm Exit",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14.sp,
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

  void showExitRecordedPopup(
    BuildContext context, [
    mark_out_model.Data? exitData,
  ]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 40.w),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xff101C16),
                width: 1.w,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffD1F4DE),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 25.sp,
                    color: const Color(0xff16B866),
                  ),
                ),

                SizedBox(height: 12.h),
                Text(
                  exitData?.modalTitle ?? 'EXIT RECORDED',
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 8.h),
                Text(
                  exitData?.modalSubtitle ??
                      'Visitor exit has been successfully recorded for future history and reporting.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IN-TIME
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'IN-TIME',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff777777),
                              letterSpacing: -0.2,
                            ),
                          ),

                          SizedBox(height: 1.h),

                          Text(
                            exitData?.inTime ?? '10:32 AM',
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'OUT-TIME',
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff777777),
                              letterSpacing: -0.2,
                            ),
                          ),

                          SizedBox(height: 1.h),

                          Text(
                            exitData?.outTime ?? '9:55 AM',
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
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

                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      exitData?.buttonLabel ?? 'Done',
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterMap = {0: "all", 1: "visitor", 2: "parcel"};

    final selectedFilter = filterMap[index] ?? "all";

    final historyRecords = ref.watch(historyRecordsProvider(selectedFilter));

    // final records = historyRecords.valueOrNull?.data?.records;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xff101C16), width: 1.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? const Color(0xffE7F8ED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == 0
                              ? Colors.black
                              : const Color(0xffE1E1E1),
                          width: index == 0 ? 1.2 : 1,
                        ),
                      ),
                      child: Text(
                        "All",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff101C16),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == 1
                            ? const Color(0xffE7F8ED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == 1
                              ? Colors.black
                              : const Color(0xffE1E1E1),
                          width: index == 1 ? 1.2 : 1,
                        ),
                      ),
                      child: Text(
                        "Visitor",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff101C16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == 2
                            ? const Color(0xffE7F8ED)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: index == 2
                              ? Colors.black
                              : const Color(0xffE1E1E1),
                          width: index == 2 ? 1.2 : 1,
                        ),
                      ),
                      child: Text(
                        "Parcel",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff101C16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          historyRecords.when(
            data: (data) {
              return ListView.builder(
                itemCount: data.data?.records?.length ?? 0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, itemIndex) {
                  final item = data.data?.records?[itemIndex];
                  if (item?.type == 'parcel' || index == 2) {
                    return _buildParcelCard(item);
                  }
                  return _buildVisitorCard(item);
                },
              );
            },
            error: (error, stackTrace) {
              return const Center(child: Text("Something went wrong"));
            },
            loading: () {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.heading),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorCard(Record? item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xff101C16), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  item?.avatarUrl ?? "",
                  height: 60.h,
                  width: 60.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item?.visitorName ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item?.categoryLabel ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.65),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              if (item?.badge != null && item!.badge!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _badgeTint(item.badgeColor).withOpacity(0.18),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: Text(
                      item.badge ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: _badgeTint(item.badgeColor),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _visitInfoCard(
                  title: 'IN-TIME',
                  value: item?.inTime ?? "",
                ),
              ),
              SizedBox(width: 22.w),
              Expanded(
                child: _visitInfoCard(
                  title: 'OUT-TIME',
                  value: item?.outTime ?? "",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _visitInfoCard(title: 'DATE', value: item?.date ?? ""),
              ),
              SizedBox(width: 22.w),
              Expanded(
                child: _visitInfoCard(
                  title: 'APPROVAL',
                  value: item?.statusNote ?? "",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Builder(
            builder: (context) {
              final String currentId = item?.rawId != null
                  ? item!.rawId.toString()
                  : (item?.id ?? "");
              final bool isAlreadyOut = item?.canMarkExit == false;
              final bool isMarking = _markingOutId == currentId;

              return SizedBox(
                height: 45.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isAlreadyOut || _markingOutId != null)
                      ? null
                      : () => _handleMarkOut(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAlreadyOut
                        ? const Color(0xFF888888)
                        : const Color(0xFF0D1C16),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: isMarking
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isAlreadyOut
                              ? 'EXIT RECORDED'
                              : (item?.actionButton?.label ?? 'MARK EXIT'),
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParcelCard(Record? item) {
    final badgeUpper = (item?.badge ?? "").toUpperCase().trim();
    final handoverLower = (item?.handoverTime ?? "").toLowerCase().trim();

    // Status Checks:
    final isAtGate = handoverLower == "left at gate" || badgeUpper == "GATE";
    final isPending = badgeUpper == "PENDING" || handoverLower == "--";

    // Badge styling
    String badgeText = "DELIVERED";
    Color badgeBg = const Color(0xFFD4F5E1);
    Color badgeColor = const Color(0xFF16A765);

    if (isAtGate) {
      badgeText = "AT GATE";
      badgeBg = const Color(0xFFFFF4D1);
      badgeColor = const Color(0xFFB8860B);
    } else if (isPending) {
      badgeText = "PENDING";
      badgeBg = const Color(0xFFFEF3C7);
      badgeColor = const Color(0xFFD97706);
    } else {
      badgeText = item?.badge ?? "DELIVERED";
      badgeBg = const Color(0xFFD4F5E1);
      badgeColor = const Color(0xFF16A765);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xff101C16), width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  item?.avatarUrl ?? "",
                  height: 60.h,
                  width: 60.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item?.title ??
                          item?.vendorName ??
                          item?.name ??
                          "Amazon / Parcel",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item?.categoryLabel ?? "Parcel / Delivery",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.65),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _visitInfoCard(
                  title: 'RECEIVED-TIME',
                  value: item?.receivedTime ?? "",
                ),
              ),
              SizedBox(width: 22.w),
              Expanded(
                child: _visitInfoCard(
                  title: 'HANDOVER-TIME',
                  value: item?.handoverTime ?? "",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _visitInfoCard(title: 'DATE', value: item?.date ?? ""),
              ),
              SizedBox(width: 22.w),
              Expanded(
                child: _visitInfoCard(
                  title: 'APPROVAL',
                  value: item?.statusNote ?? "",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (isAtGate)
            SizedBox(
              height: 38.h,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.heading,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                onPressed: () {
                  _showReleaseParcelDialog(item);
                },
                icon: Icon(Icons.qr_code_2, size: 16.sp),
                label: Text(
                  "Verify & Release",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else if (isPending)
            SizedBox(
              height: 38.h,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1C16),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                onPressed: () {
                  _showMarkExitDialog(item);
                },
                icon: Icon(Icons.logout_rounded, size: 15.sp),
                label: Text(
                  item?.actionButton?.label ?? "Mark Exit",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16.sp,
                  color: const Color(0xFF16A765),
                ),
                SizedBox(width: 6.w),
                Text(
                  "Handed Over: ${item?.handoverTime ?? "N/A"}",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF16A765),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _visitInfoCard({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0E9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD8D6D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
              letterSpacing: -0.2,
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class GuardsTab extends ConsumerStatefulWidget {
  const GuardsTab({super.key});

  @override
  ConsumerState<GuardsTab> createState() => _GuardsTabState();
}

class _GuardsTabState extends ConsumerState<GuardsTab> {
  @override
  Widget build(BuildContext context) {
    final guard = ref.watch(historyGuardProvider);
    return guard.when(
      data: (data) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guards on Duty",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.data?.guards?.length,
                itemBuilder: (context, index) {
                  final guard = data.data?.guards?[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.network(
                            guard?.avatarUrl ?? "",
                            height: 40.h,
                            width: 40.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                guard?.name ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              SizedBox(height: 2.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${guard?.post ?? ''} ",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff555555),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    TextSpan(
                                      text: guard?.status ?? '',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff555555),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return const Center(child: Text("Something went wrong"));
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.heading),
        );
      },
    );
  }
}

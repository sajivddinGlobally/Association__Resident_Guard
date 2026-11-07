import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/ResidentScreen/Model/getResidentParcelModel.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentGateApproval/provider/getResidentParcelProvider.dart';

class ResidentGateApprovalScreen extends ConsumerStatefulWidget {
  const ResidentGateApprovalScreen({super.key});

  @override
  ConsumerState<ResidentGateApprovalScreen> createState() =>
      _ResidentGateApprovalScreenState();
}

class _ResidentGateApprovalScreenState
    extends ConsumerState<ResidentGateApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> dismissedParcelIds = {};
  final Set<int> receivedParcelIds = {};
  int? _respondingParcelId;
  String? _respondingAction;

  final List<Map<String, dynamic>> pendingRequests = [];

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

  void _showHomeDeliveryDialog(dynamic request) {
    final String company = request is ResidentParcelItem
        ? (request.vendorName ?? "Delivery")
        : (request['company'] ?? "Delivery");
    final String otp = request is ResidentParcelItem
        ? (request.pickupCode ?? "")
        : (request['pickup_code'] ?? "").toString();
    final dynamic id = request is ResidentParcelItem
        ? request.id
        : request['id'];

    showDialog(
      context: context,
      builder: (context) {
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
                  color: const Color(0xFFD4F5E1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.door_front_door_outlined,
                  color: const Color(0xFF16A765),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Home Delivery Approved",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Guard has allowed $company delivery person to your door. Share this validation OTP at handover:",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF0),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xFFE8B900),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Delivery Handover OTP",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      otp.isEmpty ? "Not available" : otp,
                      style: GoogleFonts.outfit(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                if (id != null) {
                  setState(() {
                    if (request is! ResidentParcelItem) {
                      pendingRequests.removeWhere((r) => r['id'] == id);
                    } else {
                      dismissedParcelIds.add(id as int);
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: Text(
                "Got it",
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLeaveAtGateDialog(dynamic request) {
    final String company = request is ResidentParcelItem
        ? (request.vendorName ?? "Delivery")
        : (request['company'] ?? "Delivery");
    final String otp = request is ResidentParcelItem
        ? (request.pickupCode ?? "")
        : (request['pickup_code'] ?? request['pickupOtp'] ?? "").toString();
    final String? qrUrl = request is ResidentParcelItem
        ? request.qrCodeUrl
        : null;
    final dynamic id = request is ResidentParcelItem
        ? request.id
        : request['id'];

    showDialog(
      context: context,
      builder: (context) {
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
                  color: const Color(0xFFFFF0D4),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: const Color(0xFFB8860B),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Leave at Gate Confirmed",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Guard is holding your $company parcel at the gate locker. Share this Pickup Code with anyone collecting it:",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5EE),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFE0DDD5)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Gate Pickup OTP",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      otp.isEmpty ? "Not available" : otp,
                      style: GoogleFonts.outfit(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 6,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Tell this 4-digit code to the guard",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                    if (qrUrl != null && qrUrl.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          qrUrl,
                          height: 110.h,
                          width: 110.h,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF16A765)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: otp.isEmpty
                  ? null
                  : () async {
                      try {
                        await SharePlus.instance.share(
                          ShareParams(
                            text:
                                "Pickup code for the $company parcel at the gate: $otp",
                            subject: "Parcel pickup code",
                          ),
                        );
                      } catch (_) {
                        showErrorSnackBar("Could not open share options.");
                      }
                    },
              icon: Icon(
                Icons.share,
                size: 16.sp,
                color: const Color(0xFF16A765),
              ),
              label: Text(
                "Share",
                style: GoogleFonts.outfit(
                  color: const Color(0xFF16A765),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
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
              onPressed: () {
                // if (id != null) {
                //   setState(() {
                //     if (request is! ResidentParcelItem) {
                //       pendingRequests.removeWhere((r) => r['id'] == id);
                //     } else {
                //       dismissedParcelIds.add(id as int);
                //     }
                //   });
                // }
                Navigator.pop(context);
              },
              child: Text(
                "Done",
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _respondToParcel({
    required ResidentParcelItem parcel,
    required String action,
    String? deliveryMode,
    String? remarks,
  }) async {
    if (parcel.id == null) return;

    setState(() {
      _respondingParcelId = parcel.id;
      _respondingAction = deliveryMode ?? action;
    });

    try {
      final response = await ref
          .read(authServiceProvider)
          .respondResidentParcelData(
            parcelId: parcel.id.toString(),
            action: action,
            deliveryMode: deliveryMode,
            remarks: remarks,
          );

      if (response.status == true) {
        showSuccessSnackBar(
          response.message ?? "Response recorded successfully",
        );

        if (action == "approved" && deliveryMode == "home_delivery") {
          if (mounted) _showHomeDeliveryDialog(parcel);
        } else if (action == "approved" && deliveryMode == "leave_at_gate") {
          if (mounted) _showLeaveAtGateDialog(parcel);
        }

        // Refresh provider to get updated status and pickup codes
        ref.invalidate(getResidentParcelProvider);
      } else {
        showErrorSnackBar(response.message ?? "Failed to respond to parcel");
      }
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
    } finally {
      if (mounted) {
        setState(() {
          _respondingParcelId = null;
          _respondingAction = null;
        });
      }
    }
  }

  Future<void> _respondToVisitor({
    required String visitorId,
    required String action,
    String? remarks,
  }) async {
    setState(() {
      _respondingParcelId = int.tryParse(visitorId) ?? 999;
      _respondingAction = action;
    });

    try {
      final response = await ref
          .read(authServiceProvider)
          .respondResidentVisitorData(
            id: visitorId,
            action: action,
            remarks: remarks,
          );

      if (response.status == true) {
        showSuccessSnackBar(
          response.message ?? "Visitor entry $action successfully",
        );
        setState(() {
          pendingRequests.removeWhere((r) => r['id'].toString() == visitorId);
        });
      } else {
        showErrorSnackBar(response.message ?? "Failed to respond to visitor");
      }
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
      // Request list se tab hi hatate hain jab server ne sach me accept kiya ho.
    } finally {
      if (mounted) {
        setState(() {
          _respondingParcelId = null;
          _respondingAction = null;
        });
      }
    }
  }

  Widget _buildVisitorCard(Map<String, dynamic> req) {
    final id = req['id']?.toString() ?? '';
    final name = req['name'] ?? 'Visitor';
    final phone = req['phone'] ?? '';
    final purpose = req['purpose'] ?? 'Personal Visit';
    final time = req['time'] ?? 'Just now';
    final vehicle = req['vehicle'] ?? 'None';
    final isRespondingThis = _respondingParcelId == (int.tryParse(id) ?? 999);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8B900), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0E9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.person_pin_rounded,
                  color: AppColors.heading,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    Text(
                      "$purpose · $time",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D4),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "WALK-IN",
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB8860B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14.sp,
                color: const Color(0xFF666666),
              ),
              SizedBox(width: 4.w),
              Text(
                phone,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: const Color(0xFF666666),
                ),
              ),
              if (vehicle != 'None') ...[
                SizedBox(width: 12.w),
                Icon(
                  Icons.directions_car_outlined,
                  size: 14.sp,
                  color: const Color(0xFF666666),
                ),
                SizedBox(width: 4.w),
                Text(
                  vehicle,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A765),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isRespondingThis
                      ? null
                      : () => _respondToVisitor(
                          visitorId: id,
                          action: "approved",
                        ),
                  icon: (isRespondingThis && _respondingAction == "approved")
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.check, size: 16.sp, color: Colors.white),
                  label: Text(
                    "Approve Entry",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD22424)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: isRespondingThis
                      ? null
                      : () => _respondToVisitor(
                          visitorId: id,
                          action: "rejected",
                        ),
                  icon: (isRespondingThis && _respondingAction == "rejected")
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFD22424),
                          ),
                        )
                      : Icon(
                          Icons.close,
                          size: 16.sp,
                          color: const Color(0xFFD22424),
                        ),
                  label: Text(
                    "Reject",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD22424),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _markParcelReceived(ResidentParcelItem parcel) async {
    if (parcel.id == null) return;

    setState(() {
      _respondingParcelId = parcel.id;
      _respondingAction = "received";
    });

    try {
      final response = await ref
          .read(authServiceProvider)
          .respondResidentParcelData(
            parcelId: parcel.id.toString(),
            action: "received",
            deliveryMode: "home_delivery",
            remarks: "Parcel received by resident at door",
          );

      if (mounted) {
        if (response.status == true) {
          setState(() {
            receivedParcelIds.add(parcel.id!);
          });
          showSuccessSnackBar(
            response.message ?? "Parcel confirmed as received.",
          );
          ref.invalidate(getResidentParcelProvider);
        } else {
          showErrorSnackBar(
            response.message ?? "Could not confirm the parcel.",
          );
        }
      }
    } catch (e) {
      // Server ka asli error Dio interceptor already dikha deta hai.
    } finally {
      if (mounted) {
        setState(() {
          _respondingParcelId = null;
          _respondingAction = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(getResidentParcelProvider);
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
                    "Gate Approvals",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Incoming visitor & delivery approval requests",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
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
      body: asyncState.when(
        data: (data) {
          final parcels = (data.data ?? [])
              .where((p) => p.id == null || !dismissedParcelIds.contains(p.id))
              .toList();

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              return ref.refresh(getResidentParcelProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Gate Guard Direct Call Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE8B900),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFDF0),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE8B900),
                              ),
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              color: const Color(0xFFB8860B),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Security Gate Desk (Gate 1)",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                                Text(
                                  "Need to speak with gate guard on duty?",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.heading,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.heading,
                                  content: Text(
                                    "Calling Security Guard Desk (+91 98765 00001)...",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.call,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Call Guard",
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // Pending Requests Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pending Approvals (${parcels.length + pendingRequests.length})",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                        ),
                        Text(
                          "Auto-expires in 60s",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFB8860B),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    if (parcels.isEmpty && pendingRequests.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 48.sp,
                              color: const Color(0xFF16A765),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "No Pending Requests",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.heading,
                              ),
                            ),
                            Text(
                              "All visitor & delivery requests are processed.",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Pending Walk-in Visitor Requests
                      ...pendingRequests.map((r) => _buildVisitorCard(r)),
                      // Pending Delivery / Parcel Requests
                      if (parcels.isNotEmpty)
                        ListView.builder(
                          itemCount: parcels.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _buildParcelCard(parcels[index]);
                          },
                        ),
                    ],

                    // SizedBox(height: 20.h),
                    // Recent Approved History Preview
                    // Text(
                    //   "Recent Gate Activity",
                    //   style: GoogleFonts.outfit(
                    //     fontSize: 16.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.heading,
                    //   ),
                    // ),
                    // SizedBox(height: 12.h),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.all(16.w),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(14.r),
                    //     border: Border.all(color: const Color(0xFFE0E0E0)),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       _historyItem(
                    //         name: "Swiggy Food Delivery",
                    //         time: "Today, 01:15 PM",
                    //         type: "Home Delivery Approved",
                    //         statusColor: const Color(0xFF16A765),
                    //       ),
                    //       const Divider(height: 18, color: Color(0xFFEEEEEE)),
                    //       _historyItem(
                    //         name: "Blinkit Groceries",
                    //         time: "Today, 10:30 AM",
                    //         type: "Left at Gate (Picked Up)",
                    //         statusColor: const Color(0xFFB8860B),
                    //       ),
                    //       const Divider(height: 18, color: Color(0xFFEEEEEE)),
                    //       _historyItem(
                    //         name: "Suresh (AC Repair)",
                    //         time: "Yesterday, 04:00 PM",
                    //         type: "Visitor Pass Approved",
                    //         statusColor: const Color(0xFF16A765),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "Something went wrong. Please try again.",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildParcelCard(ResidentParcelItem parcel) {
    final photo = parcel.parcelPhoto;
    final statusStr = (parcel.status ?? "").toUpperCase();

    final bool isDelivered =
        statusStr == "DELIVERED" ||
        statusStr == "RECEIVED" ||
        (parcel.id != null && receivedParcelIds.contains(parcel.id)) ||
        (parcel.handoverAt != null && parcel.handoverAt!.isNotEmpty);

    final bool isRejected = statusStr == "REJECTED";

    // Jab tak resident ne jawab nahi diya (PENDING), delivery_mode ko ignore karo,
    // taaki Home Delivery / Leave at Gate buttons dikhein.
    final bool isPendingReply = statusStr == "PENDING" || statusStr.isEmpty;

    final bool isLeftAtGate =
        statusStr == "LEFT_AT_GATE" ||
        (!isPendingReply && parcel.deliveryMode == "leave_at_gate");

    final bool isHomeDelivery =
        statusStr == "HOME_DELIVERY" ||
        statusStr == "APPROVED" ||
        (!isPendingReply && parcel.deliveryMode == "home_delivery");

    // Badge styling and text
    String badgeText = "GATE 1";
    Color badgeBg = const Color(0xFFFFF4D1);
    Color badgeColor = const Color(0xFFB8860B);
    Color borderColor = const Color(0xFFE8B900);

    if (isDelivered) {
      badgeText = "DELIVERED";
      badgeBg = const Color(0xFFE7F8ED);
      badgeColor = const Color(0xFF16A765);
      borderColor = const Color(0xFF16A765);
    } else if (isRejected) {
      badgeText = "REJECTED";
      badgeBg = const Color(0xFFFDEDED);
      badgeColor = const Color(0xFFD22424);
      borderColor = const Color(0xFFD22424);
    } else if (isLeftAtGate) {
      badgeText = "AT GATE";
      badgeBg = const Color(0xFFFFF4D1);
      badgeColor = const Color(0xFFB8860B);
      borderColor = const Color(0xFFE8B900);
    } else if (isHomeDelivery) {
      badgeText = "HOME DELIVERY";
      badgeBg = const Color(0xFFEAF5FF);
      badgeColor = const Color(0xFF1976D2);
      borderColor = const Color(0xFF2196F3);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0E9),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: (photo != null && photo.isNotEmpty)
                      ? Image.network(
                          photo,
                          width: 44.w,
                          height: 44.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.heading,
                            size: 22.sp,
                          ),
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.heading,
                          size: 22.sp,
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (parcel.vendorName != null &&
                              parcel.vendorName!.isNotEmpty)
                          ? parcel.vendorName!
                          : "Parcel Delivery",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Parcel · ${parcel.parcelType ?? 'Box'}${parcel.flatNumber != null ? ' (${parcel.flatNumber})' : ''}",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          SizedBox(height: 12.h),

          // 1. DELIVERED STATE: Handed over to resident
          if (isDelivered) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8ED),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF16A765).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF16A765),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Parcel Collected & Delivered",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF16A765),
                          ),
                        ),
                        if (parcel.handoverAt != null &&
                            parcel.handoverAt!.isNotEmpty)
                          Text(
                            "Handed over on ${parcel.handoverAt}",
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              color: const Color(
                                0xFF16A765,
                              ).withValues(alpha: 0.8),
                            ),
                          )
                        else if (parcel.id != null &&
                            receivedParcelIds.contains(parcel.id))
                          Text(
                            "Confirmed received by you",
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              color: const Color(
                                0xFF16A765,
                              ).withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
          // 2. LEFT_AT_GATE STATE: Kept at gate locker/desk
          else if (isLeftAtGate) ...[
            if (parcel.pickupCode != null && parcel.pickupCode!.isNotEmpty)
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF0),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFE8B900).withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      size: 20.sp,
                      color: const Color(0xFFB8860B),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup OTP: ${parcel.pickupCode}",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                            ),
                          ),
                          Text(
                            "At gate security desk",
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showLeaveAtGateDialog(parcel),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8B900),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "View QR",
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF0),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFFE8B900).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: const Color(0xFFB8860B),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Held at Gate Desk · Waiting for Pickup",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
          // 3. HOME_DELIVERY STATE: Door delivery approved
          else if (isHomeDelivery) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FF),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.door_front_door_outlined,
                    color: const Color(0xFF1976D2),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      parcel.pickupCode != null
                          ? "Door Delivery Approved · Handover OTP: ${parcel.pickupCode}"
                          : "Home Delivery Approved · Delivery at your door",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 38.h,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A765),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _respondingParcelId != null
                    ? null
                    : () => _markParcelReceived(parcel),
                icon:
                    (_respondingParcelId == parcel.id &&
                        _respondingAction == "received")
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.check_circle_outline, size: 18.sp),
                label: Text(
                  "Mark as Received (Handover Done)",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]
          // 4. REJECTED STATE: Delivery rejected
          else if (isRejected) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEDED),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: const Color(0xFFD22424).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    color: const Color(0xFFD22424),
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Delivery Rejected by Resident",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFD22424),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
          // 5. PENDING STATE: Delivery waiting at gate, show Action Buttons
          else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _respondingParcelId != null
                        ? null
                        : () => _respondToParcel(
                            parcel: parcel,
                            action: "approved",
                            deliveryMode: "home_delivery",
                            remarks: "Home delivery requested",
                          ),
                    child:
                        (_respondingParcelId == parcel.id &&
                            _respondingAction == "home_delivery")
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Home Delivery",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8B900),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _respondingParcelId != null
                        ? null
                        : () => _respondToParcel(
                            parcel: parcel,
                            action: "approved",
                            deliveryMode: "leave_at_gate",
                            remarks: "Please keep at gate safely",
                          ),
                    child:
                        (_respondingParcelId == parcel.id &&
                            _respondingAction == "leave_at_gate")
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Leave at Gate",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  height: 38.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD22424)),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: _respondingParcelId != null
                        ? null
                        : () => _respondToParcel(
                            parcel: parcel,
                            action: "rejected",
                            remarks: "Delivery rejected by resident",
                          ),
                    child:
                        (_respondingParcelId == parcel.id &&
                            _respondingAction == "rejected")
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFD22424),
                            ),
                          )
                        : Text(
                            "Reject",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color(0xFFD22424),
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
}

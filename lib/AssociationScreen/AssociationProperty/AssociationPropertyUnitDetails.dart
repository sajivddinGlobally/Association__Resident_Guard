import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart' hide Banner;
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/Provider/getPropertyUnitDetailsProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociatoinComplaint/Complaint.dart';
import 'package:property_association_or_resident/AssociationScreen/Mantenance&Service/MantenanceService.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyUnitDetailsModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AssociationDocument/AssociationDocument.dart';

class AssociationPropertyUnitDetails extends ConsumerStatefulWidget {
  final String id;
  const AssociationPropertyUnitDetails({super.key, required this.id});

  @override
  ConsumerState<AssociationPropertyUnitDetails> createState() =>
      _AssociationPropertyUnitDetailsState();
}

class _AssociationPropertyUnitDetailsState
    extends ConsumerState<AssociationPropertyUnitDetails> {
  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(getPropertyUnitDetailsProvider(widget.id));
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Property / Unit Details",
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
                      "Complete information for this unit",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(42, 41, 51, 0.7),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: detailState.when(
        data: (detailsModel) {
          final data = detailsModel.data;
          final banner = data?.banner;
          final statsCards = data?.statsCards;
          final infoList = data?.propertyInformation ?? [];
          final owner = data?.assignedPropertyOwner;
          final activities = data?.recentPropertyActivity ?? [];
          final records = data?.propertyRecords ?? [];

          // final scoreVal =
          //     double.tryParse(
          //       statsCards?.propertyScore?.value?.toString() ?? "86",
          //     ) ??
          //     86.0;
          // final scoreInt = scoreVal.toInt();

          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(
                getPropertyUnitDetailsProvider(widget.id).future,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _propertyImageCard(banner),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            icon: _mapIcon(
                              statsCards?.unitNumber?.icon,
                              Icons.grid_view_rounded,
                            ),
                            value: statsCards?.unitNumber?.value ?? "N/A",
                            title:
                                statsCards?.unitNumber?.label ?? "Unit Number",
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: _statCard(
                            icon: _mapIcon(
                              statsCards?.propertyType?.icon,
                              Icons.home_outlined,
                            ),
                            value: statsCards?.propertyType?.value ?? "N/A",
                            title:
                                statsCards?.propertyType?.label ??
                                "Property Type",
                          ),
                        ),
                        SizedBox(width: 11.w),
                        Expanded(
                          child: _statCard(
                            icon: _mapIcon(
                              statsCards?.occupancyStatus?.icon ??
                                  statsCards?.maintenanceStatus?.icon,
                              Icons.verified_user_outlined,
                            ),
                            value:
                                statsCards?.occupancyStatus?.value ??
                                statsCards?.maintenanceStatus?.value ??
                                (owner != null ? "Occupied" : "Vacant"),
                            title:
                                statsCards?.occupancyStatus?.label ??
                                statsCards?.maintenanceStatus?.label ??
                                "Occupancy Status",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Property Information",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          if (infoList.isNotEmpty) ...[
                            for (int i = 0; i < infoList.length; i++) ...[
                              if (i > 0) _divider(),
                              _informationRow(
                                icon: _mapIcon(
                                  infoList[i].icon,
                                  Icons.info_outline,
                                ),
                                label: infoList[i].title ?? "",
                                value: infoList[i].value ?? "",
                                // action: infoList[i].actionText,
                                bottomPadding: i == infoList.length - 1
                                    ? 10
                                    : 8,
                              ),
                            ],
                          ] else
                            ...[],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      data?.assignedPropertyOwner?.roleLabel ??
                          "Assigned Owner",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 44.h,
                                width: 44.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD9D9D9),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child:
                                    (owner?.avatar != null &&
                                        owner!.avatar!.isNotEmpty)
                                    ? Image.network(
                                        owner.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      owner?.name ?? "Arjun Sharma",
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    Text(
                                      owner?.propertyOwnership ??
                                          owner?.roleLabel ??
                                          "Registered Property Owner",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(
                                          42,
                                          41,
                                          51,
                                          0.75,
                                        ),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (owner?.isVerified == true)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF24B06A),
                                      width: 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    "Verified",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF24B06A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          const Divider(height: 1, color: Color(0xFF101C16)),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: _ownerInfo(
                                  title: "CONTACT",
                                  value:
                                      owner?.contact ??
                                      owner?.fullContact ??
                                      "",
                                ),
                              ),
                              Expanded(
                                child: _ownerInfo(
                                  title: "OWNERSHIP",
                                  value:
                                      owner?.propertyOwnership ??
                                      owner?.tag ??
                                      "Registered Owner",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (data?.currentOccupant != null) ...[
                      SizedBox(height: 20.h),
                      Text(
                        data?.currentOccupant?.roleLabel ??
                            "Current Tenant / Occupant Details",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF0),
                          border: Border.all(
                            color: const Color(0xFFD5A52C),
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 44.h,
                                  width: 44.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFEBD9A5),
                                  ),
                                  child:
                                      (data
                                              ?.currentOccupant
                                              ?.avatar
                                              ?.isNotEmpty ==
                                          true)
                                      ? Image.network(
                                          data!.currentOccupant!.avatar!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.person,
                                                    color: Color(0xFFB8860B),
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Color(0xFFB8860B),
                                        ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.currentOccupant?.name ?? "Tenant",
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      Text(
                                        data?.currentOccupant?.roleLabel ??
                                            "Current Occupant (Tenant)",
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            42,
                                            41,
                                            51,
                                            0.75,
                                          ),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    border: Border.all(
                                      color: const Color(0xFFFFB74D),
                                      width: 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    "Tenant",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFE65100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            const Divider(height: 1, color: Color(0xFFE0D5B8)),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _ownerInfo(
                                    title: "CONTACT",
                                    value:
                                        data?.currentOccupant?.contact ??
                                        data?.currentOccupant?.fullContact ??
                                        "N/A",
                                  ),
                                ),
                                Expanded(
                                  child: _ownerInfo(
                                    title: "OCCUPANCY",
                                    value:
                                        data
                                            ?.currentOccupant
                                            ?.propertyOwnership ??
                                        "Rented / Tenant",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(
                          "Recent Property Activity",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (activities.isNotEmpty) ...[
                            for (int i = 0; i < activities.length; i++) ...[
                              if (i > 0) _divider(),
                              _activityItem(
                                activity: activities[i],
                                icon: _mapActivitySymbol(activities[i].icon),
                                title: activities[i].title ?? "",
                                subtitle: activities[i].subtitle ?? "",
                                date: activities[i].date ?? "",
                                onTap: () =>
                                    _showActivityDetails(activities[i]),
                              ),
                            ],
                          ] else
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                "No recent property activity recorded.",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.6),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Property Records",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (records.isNotEmpty)
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: records.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final rec = records[index];
                          return _recordCard(
                            icon: _mapRecordSymbol(rec.icon, rec.id),
                            title: rec.title ?? "",
                            description: rec.subtitle ?? "",
                            buttonText: rec.actionText ?? "View Records →",
                            onTap: () {
                              if (rec.id == "inspection" ||
                                  (rec.title?.toLowerCase().contains(
                                        "inspection",
                                      ) ??
                                      false)) {
                              } else if (rec.id == "maintenance" ||
                                  (rec.title?.toLowerCase().contains(
                                        "maintenance",
                                      ) ??
                                      false)) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const MantenanceService(),
                                  ),
                                );
                              } else if (rec.id == "documents" ||
                                  (rec.title?.toLowerCase().contains(
                                        "documents",
                                      ) ??
                                      false)) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const AssociationDocument(
                                          isShowIcons: true,
                                        ),
                                  ),
                                );
                              } else if (rec.id == "complaints" ||
                                  (rec.title?.toLowerCase().contains(
                                        "complaints",
                                      ) ??
                                      false)) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const Complaint(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Something went wrong",
                style: GoogleFonts.outfit(color: AppColors.heading),
              ),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(getPropertyUnitDetailsProvider(widget.id)),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _propertyImageCard(Banner? banner) {
    final imageUrl = banner?.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF17221D), width: 1.w),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasImage
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/property_img (2).png",
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset("assets/property_img (2).png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 17.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner?.tag ?? "PROPERTY UNIT",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        banner?.title ?? "Apartment A-204",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        banner?.subtitle ??
                            "Block A · Green Valley Residency · Jaipur",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(
                      color: const Color(0xFF24B06A),
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    banner?.status ?? "Active",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF24B06A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _mapIcon(String? iconKey, IconData defaultIcon) {
    if (iconKey == null) return defaultIcon;
    switch (iconKey.toLowerCase()) {
      case "door_sliding":
      case "grid_view":
        return Icons.grid_view_rounded;
      case "home":
        return Icons.home_outlined;
      case "verified_star":
      case "diamond":
        return Icons.diamond_outlined;
      case "domain":
        return Icons.receipt_long_outlined;
      case "location_city":
        return Icons.home_outlined;
      case "location_on":
      case "location":
        return Icons.location_on_outlined;
      case "apartment":
        return Icons.apartment;
      case "check_circle":
        return Icons.radio_button_checked;
      default:
        return defaultIcon;
    }
  }

  String _mapActivitySymbol(String? iconKey) {
    if (iconKey == null) return "▣";
    switch (iconKey.toLowerCase()) {
      case "build_wrench":
      case "maintenance":
        return "⚒";
      case "description_file":
      case "document":
        return "▤";
      case "inspection":
        return "!";
      case "payment":
        return "₹";
      default:
        return "▣";
    }
  }

  String _mapRecordSymbol(String? iconKey, String? id) {
    final key = (iconKey ?? id ?? "").toLowerCase();
    if (key.contains("inspection")) return "✓";
    if (key.contains("wrench") || key.contains("maintenance")) return "⚒";
    if (key.contains("chat") || key.contains("complaint")) return "◌";
    if (key.contains("file") || key.contains("doc")) return "▤";
    return "▤";
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF000000), width: 1.w),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF000000), width: 1.w),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(icon, size: 15.sp, color: Colors.black),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              letterSpacing: -0.2,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationRow({
    required IconData icon,
    required String label,
    required String value,
    String? action,
    double bottomPadding = 8,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 38.h,
          width: 38.w,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF000000), width: 1.w),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Icon(icon, size: 16.sp, color: Colors.black),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: Text(
              action,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2A2933),
                letterSpacing: -0.2,
              ),
            ),
          ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(top: 14.h, bottom: 10.h),
      child: Divider(height: 1.h, color: const Color.fromRGBO(41, 42, 51, 0.4)),
    );
  }

  Widget _ownerInfo({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(42, 41, 51, 0.75),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Future<void> _viewDocument(String? url) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Document URL not available.");
      return;
    }
    try {
      final uri = Uri.parse(url.trim());
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await _downloadAndOpenDocument(url, openAfter: true);
      }
    } catch (_) {
      await _downloadAndOpenDocument(url, openAfter: true);
    }
  }

  Future<void> _downloadAndOpenDocument(
    String url, {
    bool openAfter = false,
  }) async {
    try {
      showSuccessSnackBar(
        openAfter ? "Opening document..." : "Downloading document...",
      );

      final Directory? dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (dir == null) {
        showErrorSnackBar("Unable to access storage directory.");
        return;
      }

      String fileName = url.split('/').last.split('?').first;
      if (fileName.isEmpty || !fileName.contains('.')) {
        fileName = "document_${DateTime.now().millisecondsSinceEpoch}.pdf";
      }

      final savePath = "${dir.path}/$fileName";

      final dio = Dio();
      try {
        final box = Hive.isBoxOpen("associationdata")
            ? Hive.box("associationdata")
            : await Hive.openBox("associationdata");
        final token = box.get("token");
        if (token != null && token.toString().isNotEmpty) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }
      } catch (_) {}

      await dio.download(url, savePath);

      if (openAfter) {
        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done) {
          showSuccessSnackBar("Downloaded to $savePath");
        }
      } else {
        showSuccessSnackBar("Downloaded successfully to $savePath");
      }
    } catch (e) {
      showErrorSnackBar("Failed to download document.");
    }
  }

  void _showActivityDetails(RecentPropertyActivity activity) {
    final attachments = activity.attachments ?? [];
    final hasAttachment = attachments.isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 14.h,
            bottom: MediaQuery.of(ctx).padding.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  if (activity.category != null &&
                      activity.category!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3F1),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFF101C16),
                          width: 0.8.w,
                        ),
                      ),
                      child: Text(
                        activity.category!.replaceAll('_', ' ').toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF101C16),
                        ),
                      ),
                    ),
                  if (activity.status != null &&
                      activity.status!.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFF2E7D32),
                          width: 0.8.w,
                        ),
                      ),
                      child: Text(
                        activity.status!,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (activity.date != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.sp,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          activity.date!,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2A2933),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                activity.title ?? "Property Activity",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              if (activity.subtitle != null &&
                  activity.subtitle!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  activity.subtitle!,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              if (activity.resolutionNotes != null &&
                  activity.resolutionNotes!.isNotEmpty) ...[
                Text(
                  "Activity Notes",
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    activity.resolutionNotes!,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2A2933),
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                "Attached Document",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(height: 8.h),
              if (hasAttachment) ...[
                for (final att in attachments) ...[
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF2),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFF101C16),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 38.w,
                              width: 38.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: const Color(0xFF101C16),
                                  width: 0.8.w,
                                ),
                              ),
                              child: Icon(
                                Icons.picture_as_pdf_outlined,
                                color: const Color(0xFFD32F2F),
                                size: 22.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    att.title ?? "Document File",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF101C16),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    att.type ?? "PDF Document",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _viewDocument(att.url);
                                },
                                icon: Icon(
                                  Icons.visibility_outlined,
                                  size: 16.sp,
                                  color: const Color(0xFF101C16),
                                ),
                                label: Text(
                                  "View File",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF101C16),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF101C16),
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  if (att.url != null) {
                                    _downloadAndOpenDocument(
                                      att.url!,
                                      openAfter: false,
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.download_outlined,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Download",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF101C16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "No file attachment linked to this activity.",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _activityItem({
    required RecentPropertyActivity activity,
    required String icon,
    required String title,
    required String subtitle,
    required String date,
    required VoidCallback onTap,
  }) {
    final hasAttachment =
        activity.attachments != null && activity.attachments!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 38.h,
              width: 38.w,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF171717), width: 1.w),
                borderRadius: BorderRadius.circular(5.r),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2A2933),
                  ),
                ),
                if (hasAttachment)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 13.sp,
                          color: const Color(0xFF2A2933),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Doc",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2A2933),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right,
              size: 18.sp,
              color: const Color(0xFF2A2933),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordCard({
    required String icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF171717), width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 32.h,
              width: 32.w,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF000000), width: 1.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
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
            Expanded(
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              buttonText,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/ResidentScreen/RaiseComplaintScreen/RaiseComplaint.dart';

import '../ResidentRequestScreen/ResidentRequestScreen.dart';
import 'Provider/ResidentPropertyDetailsProvider.dart';

class Apartmentscreen extends ConsumerStatefulWidget {
  final bool isShowBackButton;
  const Apartmentscreen({super.key, this.isShowBackButton = true});

  @override
  ConsumerState<Apartmentscreen> createState() => _ApartmentscreenState();
}

class _ApartmentscreenState extends ConsumerState<Apartmentscreen> {
  @override
  Widget build(BuildContext context) {
    final popertyDetailsState = ref.watch(residentPropertyDetailsProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: AppColors.scaffoldBg,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Row(
                children: [
                  if (widget.isShowBackButton)
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
                        "PROPERTY DETAILS",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Text(
                        "Complete information about your property",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
        ),
      ),
      body: popertyDetailsState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          data.data.myProperty.image,
                          width: double.infinity,
                          height: 183.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 305.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.r),
                                  bottomRight: Radius.circular(30.r),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff101C16).withOpacity(0.0),
                                    Color(0xff101C16).withOpacity(0.4),
                                    Color(0xff101C16).withOpacity(0.9),
                                    Color(0xff101C16),
                                  ],
                                  stops: const [0.0, 0.4, 0.75, 1.0],
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.broken_image, size: 20.w),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff101C16).withOpacity(0.0),
                                Color(0xff101C16).withOpacity(0.0),
                                Color(0xff101C16),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16.w,
                        bottom: 17.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data.data.myProperty.tag,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xffFFFFFF),
                                    fontSize: 15.sp,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                _buildOccupancyBadge(
                                  data.data.myProperty.occupancyType,
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              data.data.myProperty.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: Color(0xffFFFFFF),
                                fontSize: 19.sp,
                                letterSpacing: -0.54,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              data.data.myProperty.subtitle,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(255, 255, 255, 0.6),
                                fontSize: 16.sp,
                                letterSpacing: -0.34,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Property Overview",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 19.sp,
                          letterSpacing: -0.34,
                        ),
                      ),
                      // Spacer(),
                      // Text(
                      //   "View All",
                      //   style: GoogleFonts.outfit(
                      //     fontWeight: FontWeight.w500,
                      //     color: AppColors.heading,
                      //     fontSize: 16.sp,
                      //     letterSpacing: -0.34,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount:
                          data.data.propertyOverview.specifications.length,
                      itemBuilder: (context, index) {
                        final item =
                            data.data.propertyOverview.specifications[index];
                        return _documentRow(
                          title: item.label,
                          value: item.value,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Property Information",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 19.sp,
                      letterSpacing: -0.34,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 28.w,
                    mainAxisSpacing: 22.h,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5.h,
                    children: [
                      _infoCard(
                        icon: Icons.home_outlined,
                        title: data
                            .data
                            .propertyInformation
                            .cards
                            .associatedComplex
                            .name,
                        subtitle: data
                            .data
                            .propertyInformation
                            .cards
                            .associatedComplex
                            .label,
                      ),

                      _infoCard(
                        icon: Icons.circle,
                        title: data
                            .data
                            .propertyInformation
                            .cards
                            .assignedCaretaker
                            .name,
                        subtitle: data
                            .data
                            .propertyInformation
                            .cards
                            .assignedCaretaker
                            .label,
                        iconSize: 19,
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Raisecomplaint(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color(0xFF101C16),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            fixedSize: Size(double.infinity, 44.h),
                            side: BorderSide(
                              color: const Color(0xFF777777),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                          child: Text(
                            "Post Complaint",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.39,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    Residentrequestscreen(showBackButton: true),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF101C16),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            fixedSize: Size(double.infinity, 44.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                          child: Text(
                            "Complain Track Status  →",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.39,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
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
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    // Color valueColor = const Color(0xFF171A18),
    bool showBottomBorder = true,
  }) {
    return SizedBox(
      height: 40.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: showBottomBorder
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                      )
                    : null,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(42, 41, 51, 0.6),
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: showBottomBorder
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                    )
                  : null,
            ),
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    double iconSize = 20,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 15.w,
        right: 12.w,
        top: 10.h,
        bottom: 10.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: iconSize.sp, color: AppColors.heading),

          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
              letterSpacing: -0.3,
            ),
          ),

          SizedBox(height: 6.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(41, 42, 51, 0.6),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyBadge(String? type) {
    if (type == null || type.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final isTenant = type.toLowerCase() == "tenant";
    final isOwner = type.toLowerCase() == "owner";
    if (!isTenant && !isOwner) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isOwner ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isOwner ? const Color(0xFF81C784) : const Color(0xFFFFB74D),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isOwner ? "👑" : "📄", style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 4.w),
          Text(
            isOwner ? "Owner" : "Tenant",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isOwner
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFE65100),
            ),
          ),
        ],
      ),
    );
  }
}

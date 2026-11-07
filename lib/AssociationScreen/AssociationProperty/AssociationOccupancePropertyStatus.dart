import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class AssociationOccupancePropertyStatus extends StatefulWidget {
  const AssociationOccupancePropertyStatus({super.key});

  @override
  State<AssociationOccupancePropertyStatus> createState() =>
      _AssociationOccupancePropertyStatusState();
}

class _AssociationOccupancePropertyStatusState
    extends State<AssociationOccupancePropertyStatus> {
  int selectedFilter = 0;

  final List<String> filters = ["All", "Occupied", "Vacant", "Attention"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
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
                    "Occupancy / Property Status",
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
                    "Complex-wide occupancy and property status",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading, width: 1.w),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 38.h,
                          width: 38.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.home_outlined,
                              color: AppColors.heading,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Complex",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.2,
                                  height: 1.h,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Green Valley Residency",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            "Active",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading, width: 1.w),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 38.h,
                          width: 38.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.radio_button_checked,
                              color: const Color(0xFFB8860B),
                              size: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Overall Occupancy",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Current complex occupancy status",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "91%",
                              style: GoogleFonts.outfit(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            Text(
                              "116 / 128 units",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(42, 41, 51, 0.75),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: 0.91,
                        minHeight: 5.h,
                        backgroundColor: const Color(0xFFA8A8A8),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF101C16),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "116 Occupied",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          "12 Vacant",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      icon: Icons.circle,
                      value: "116",
                      title: "Occupied",
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _statCard(
                      icon: Icons.circle_outlined,
                      value: "12",
                      title: "Vacant",
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _statCard(
                      icon: Icons.priority_high,
                      value: "03",
                      title: "Attention",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Unit Status',
                    style: GoogleFonts.outfit(
                      color: AppColors.heading,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    '128 UNITS',
                    style: GoogleFonts.outfit(
                      color: AppColors.heading,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(filters.length, (index) {
                    final bool isSelected = selectedFilter == index;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.heading
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filters[index],
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'BLOCK A',
                style: GoogleFonts.outfit(
                  color: AppColors.heading,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 12.h),
              _buildBlock(),
              _buildBlock(),
              SizedBox(height: 16.h),
              Text(
                'BLOCK B',
                style: GoogleFonts.outfit(
                  color: AppColors.heading,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 12.h),
              _buildBlock(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1.w),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.heading, width: 1.w),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(icon, size: 14.sp, color: AppColors.heading),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset("assets/associationImage/bed.png"),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apartment A-204",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Block A · 3 BHK",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.heading,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Occupied",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const Divider(color: Color(0xFFC6C6C6)),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _associationInfoItem(
                  title: "OWNER",
                  value: "Arjun Sharma",
                ),
              ),
              Expanded(
                child: _associationInfoItem(title: "PROPERTY", value: "Active"),
              ),
              Expanded(
                child: _associationInfoItem(title: "SCORE", value: "8.6 / 10"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _associationInfoItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(42, 41, 51, 0.75),
            letterSpacing: -0.2,
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
}

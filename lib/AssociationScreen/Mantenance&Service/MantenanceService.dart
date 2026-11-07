import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceMagagement/AssociationServiceManagement.dart';
import 'package:property_association_or_resident/AssociationScreen/Mantenance&Service/PendingMantenaceService.dart';
import 'package:property_association_or_resident/AssociationScreen/Mantenance&Service/Provider/maintenanceOverviewProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class MantenanceService extends ConsumerStatefulWidget {
  const MantenanceService({super.key});

  @override
  ConsumerState<MantenanceService> createState() => _MantenanceServiceState();
}

class _MantenanceServiceState extends ConsumerState<MantenanceService> {
  final services = [
    {
      'icon': Icons.cleaning_services_outlined,
      'title': 'Housekeeping',
      'subtitle': 'Daily common area service',
    },
    {
      'icon': Icons.shield_outlined,
      'title': 'Housekeeping',
      'subtitle': 'Daily common area service',
    },
    {
      'icon': Icons.access_time,
      'title': 'OEM / Equipment',
      'subtitle': 'Scheduled equipment servicing',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getMaintenanceOverviewProvider);
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
                      "Maintenance & Services",
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
                      "Residential/Commercial management Issue Operations",
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
      body: state.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "PROPERTY OPERATIONS",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
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
                                  color: const Color(0xFFB8860B),
                                  width: 1.2.w,
                                ),
                              ),
                              child: Text(
                                data.data?.propertyOperations?.badge ?? "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB8860B),
                                  letterSpacing: -0.2,
                                  height: 1.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          data.data?.propertyOperations?.headline ?? "N/A",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          data.data?.propertyOperations?.description ?? "N/A",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.75),
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromRGBO(16, 28, 22, 0.15),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: _serviceStat(
                                label: "Pending",
                                value:
                                    data
                                        .data
                                        ?.propertyOperations
                                        ?.metrics
                                        ?.pending
                                        ?.count ??
                                    "N/A",
                                status: "maintenance",
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label: "Services",
                                value:
                                    data
                                        .data
                                        ?.propertyOperations
                                        ?.metrics
                                        ?.services
                                        ?.count ??
                                    "N/A",
                                status: "active",
                              ),
                            ),

                            Expanded(
                              child: _serviceStat(
                                label: "Resolved",
                                value:
                                    data
                                        .data
                                        ?.propertyOperations
                                        ?.metrics
                                        ?.resolved
                                        ?.count ??
                                    "N/A",
                                status: "this month",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 22.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Maintenance",
                  //       style: GoogleFonts.outfit(
                  //         fontSize: 18.sp,
                  //         fontWeight: FontWeight.w700,
                  //         color: AppColors.heading,
                  //         letterSpacing: -0.2,
                  //       ),
                  //     ),
                  //     Text(
                  //       "Manage & Track",
                  //       style: GoogleFonts.outfit(
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w500,
                  //         color: const Color.fromRGBO(42, 41, 51, 0.75),
                  //         letterSpacing: -0.2,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 14.h),
                  // ServiceCard(
                  //   icon: Icons.pie_chart_outline,
                  //   title: "Pending Maintenance",
                  //   description:
                  //       "View and manage maintenance work that is currently\npending or in progress.",
                  //   bottomLeft: "Requires attention",
                  //   bottomRight:
                  //       "${data.data?.maintenanceSection?.pendingMaintenance?.count ?? "0"} Requests",
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (context) => PendingMantenaceService(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Services",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        "Complex Services",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.75),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  ServiceCard(
                    icon: Icons.gps_fixed,
                    title: "Service Management",
                    description:
                        "Manage housekeeping, security, OEM and equipment-\nrelated services.",
                    bottomLeft: "All services operational",
                    bottomRight:
                        "${data.data?.servicesSection?.serviceManagement?.count ?? "0"} Active",
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AssociationServiceManagement(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 22.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8860B),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data?.data?.serviceSnapshot?.title ??
                                  'Service Snapshot',
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // View all
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Text(
                            //         'VIEW ALL',
                            //         style: GoogleFonts.outfit(
                            //           fontSize: 14.sp,
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.white,
                            //           letterSpacing: -0.2,
                            //         ),
                            //       ),
                            //       SizedBox(width: 4.w),
                            //       Text(
                            //         '→',
                            //         style: GoogleFonts.outfit(
                            //           fontSize: 18.sp,
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              data.data?.serviceSnapshot?.items?.length ?? 0,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 14.h);
                          },
                          itemBuilder: (context, index) {
                            final service =
                                data.data?.serviceSnapshot?.items?[index];
                            return _serviceSnapShotItem(
                              icon: _getServiceIcon(service?.icon),
                              title: service?.title ?? "N/A",
                              subtitle: service?.subtitle ?? "N/A",
                              status: service?.status ?? "Active",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          return Center(child: Text("Someting went wrong"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _serviceStat({
    required String label,
    required String value,
    required String status,
  }) {
    return Column(
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
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          status,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFB8860B),
            height: 1,
          ),
        ),
      ],
    );
  }

  IconData _getServiceIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'cleaning_services':
      case 'cleaning_services_outlined':
      case 'cleaning':
      case 'housekeeping':
        return Icons.cleaning_services_outlined;
      case 'security':
      case 'shield':
      case 'shield_outlined':
        return Icons.shield_outlined;
      case 'settings':
      case 'oem_equipment':
      case 'oem':
      case 'equipment':
        return Icons.settings_outlined;
      case 'access_time':
      case 'time':
        return Icons.access_time;
      case 'build':
      case 'repair':
      case 'maintenance':
        return Icons.build_outlined;
      default:
        return Icons.miscellaneous_services_outlined;
    }
  }

  Widget _serviceSnapShotItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF101C16),
          ),
          child: Icon(icon, size: 20.sp, color: const Color(0xFFB8860B)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 8.w),
        Text(
          status,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String bottomLeft;
  final String bottomRight;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.bottomLeft,
    required this.bottomRight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.heading, width: 1.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.heading, width: 1.2),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(icon, size: 20.sp, color: AppColors.heading),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.75),
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20.sp,
                    color: AppColors.heading,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color.fromRGBO(16, 28, 22, 0.15),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bottomLeft,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Text(
                  bottomRight,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

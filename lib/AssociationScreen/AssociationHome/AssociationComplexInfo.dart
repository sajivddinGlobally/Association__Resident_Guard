import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationDocument/AssociationDocument.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationHome/Provider/getComplexDetailsProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationProperty/AssociationProperty.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/apiErrorWidget.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/complexDetailsModel.dart';

class AssociationComplexInfo extends ConsumerStatefulWidget {
  const AssociationComplexInfo({super.key});

  @override
  ConsumerState<AssociationComplexInfo> createState() =>
      _AssociationComplexInfoState();
}

class _AssociationComplexInfoState
    extends ConsumerState<AssociationComplexInfo> {
  final buildings = [
    {"block": "A", "name": "Block A", "units": "32 Units"},
    {"block": "B", "name": "Block B", "units": "32 Units"},
    {"block": "C", "name": "Block C", "units": "32 Units"},
    {"block": "D", "name": "Block D", "units": "32 Units"},
  ];

  final documents = [
    {
      'icon': Icons.description_outlined,
      'title': 'Association Documents',
      'subtitle': 'Complex records',
    },
    {
      'icon': Icons.check,
      'title': 'Safety Certificates',
      'subtitle': 'Important certificates',
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Service Documents',
      'subtitle': 'Service related records',
    },
    {
      'icon': Icons.stop,
      'title': 'Other Records',
      'subtitle': 'Relevant documents',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final complexDetailState = ref.watch(getComplextDetailsProvider);
    final headerData = complexDetailState.valueOrNull?.data?.header;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  headerData?.title ?? "Complex Information",
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff292832),
                    letterSpacing: -0.64,
                  ),
                ),
                Text(
                  headerData?.subtitle ??
                      "Complete information about your complex",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2A2933),
                    letterSpacing: -0.24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: complexDetailState.when(
        data: (data) {
          final complex = data.data;
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(getComplextDetailsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildPropertyHeader(complex),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: _getStatsIcon(
                              complex?.statsCards?.totalUnits?.icon,
                              Icons.home_outlined,
                            ),
                            value:
                                "${complex?.statsCards?.totalUnits?.value ?? complex?.totalUnits ?? 0}",
                            title:
                                complex?.statsCards?.totalUnits?.label ??
                                "Total Units",
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: _buildStatCard(
                            icon: _getStatsIcon(
                              complex?.statsCards?.buildingsBlocks?.icon,
                              Icons.grid_view_outlined,
                            ),
                            value:
                                "${complex?.statsCards?.buildingsBlocks?.value ?? complex?.totalBlocks ?? complex?.blocks ?? complex?.propertiesCount ?? buildings.length}",
                            title:
                                complex?.statsCards?.buildingsBlocks?.label ??
                                "Buildings / Blocks",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                    Text(
                      "Complex Details",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.w),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        children:
                            (complex?.complexDetails != null &&
                                complex!.complexDetails!.isNotEmpty)
                            ? [
                                for (
                                  int i = 0;
                                  i < complex.complexDetails!.length;
                                  i++
                                ) ...[
                                  if (i > 0) _buildDivider(),
                                  _buildDetailRow(
                                    icon: _getDetailIcon(
                                      complex.complexDetails![i].icon,
                                      complex.complexDetails![i].key,
                                    ),
                                    label:
                                        complex.complexDetails![i].title ?? "",
                                    value:
                                        complex.complexDetails![i].value ?? "",
                                  ),
                                ],
                              ]
                            : [],
                      ),
                    ),
                    SizedBox(height: 18.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Buildings / Blocks",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const AssociationProperty(isShowBack: true),
                              ),
                            );
                          },
                          child: Text(
                            "View All",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Builder(
                      builder: (context) {
                        final bBlocks = complex?.buildingsBlocks;
                        final count = (bBlocks != null && bBlocks.isNotEmpty)
                            ? bBlocks.length
                            : buildings.length;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: count,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 190.w / 94.h,
                              ),
                          itemBuilder: (context, index) {
                            if (bBlocks != null && bBlocks.isNotEmpty) {
                              final b = bBlocks[index];
                              return _buildBuildingCard(
                                block:
                                    b.blockCode ??
                                    (b.name != null && b.name!.isNotEmpty
                                        ? b.name!.split(' ').last
                                        : "A"),
                                name: b.name ?? "Block",
                                units:
                                    b.unitsText ?? "${b.totalUnits ?? 0} Units",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const AssociationProperty(
                                            isShowBack: true,
                                          ),
                                    ),
                                  );
                                },
                              );
                            }
                            final building = buildings[index];
                            return _buildBuildingCard(
                              block: building["block"]!,
                              name: building["name"]!,
                              units: building["units"]!,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const AssociationProperty(
                                          isShowBack: true,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Common Facilities",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        // Text(
                        //   "View All",
                        //   style: GoogleFonts.outfit(
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: Color(0xFF000000),
                        //     letterSpacing: -0.2,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (complex?.facilities != null &&
                        complex!.facilities!.isNotEmpty) ...[
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: complex.facilities!.map((facility) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEA),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color(0xFF101C16),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 14.sp,
                                  color: const Color(0xffD5A52C),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  facility,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF101C16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            (complex?.commonFacilities != null &&
                                complex!.commonFacilities!.isNotEmpty)
                            ? [
                                for (
                                  int i = 0;
                                  i < complex.commonFacilities!.length;
                                  i++
                                ) ...[
                                  if (i > 0) _buildDivider(),
                                  _serviceItem(
                                    icon: _getServiceCategoryIcon(
                                      complex.commonFacilities![i].category,
                                    ),
                                    title: _formatCategoryName(
                                      complex.commonFacilities![i].title,
                                    ),
                                    subtitle:
                                        complex.commonFacilities![i].subtitle ??
                                        "Assigned service provider",
                                    status:
                                        complex.commonFacilities![i].status ??
                                        (complex
                                                    .commonFacilities![i]
                                                    .isActive ==
                                                true
                                            ? "Active"
                                            : "Inactive"),
                                  ),
                                ],
                              ]
                            : (complex?.serviceProviders != null &&
                                  complex!.serviceProviders!.isNotEmpty)
                            ? [
                                for (
                                  int i = 0;
                                  i < complex.serviceProviders!.length;
                                  i++
                                ) ...[
                                  if (i > 0) _buildDivider(),
                                  _serviceItem(
                                    icon: _getServiceCategoryIcon(
                                      complex
                                          .serviceProviders![i]
                                          .serviceCategory,
                                    ),
                                    title:
                                        complex
                                            .serviceProviders![i]
                                            .vendorName ??
                                        _formatCategoryName(
                                          complex
                                              .serviceProviders![i]
                                              .serviceCategory,
                                        ),
                                    subtitle:
                                        complex
                                            .serviceProviders![i]
                                            .contractDetails ??
                                        complex
                                            .serviceProviders![i]
                                            .contactInfo ??
                                        "Assigned service provider",
                                    status:
                                        complex.serviceProviders![i].status ??
                                        "Active",
                                  ),
                                ],
                              ]
                            : [
                                // _serviceItem(
                                //   icon: Icons.home_outlined,
                                //   title: 'Housekeeping Services',
                                //   subtitle: 'Assigned service provider',
                                // ),
                                // _buildDivider(),
                                // _serviceItem(
                                //   icon: Icons.person_outline,
                                //   title: 'Security Services',
                                //   subtitle: 'Security service provider',
                                // ),
                                // _buildDivider(),
                                // _serviceItem(
                                //   icon: Icons.electrical_services_outlined,
                                //   title: 'Electrical Services',
                                //   subtitle: 'Maintenance service provider',
                                // ),
                              ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Important Documents",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const AssociationDocument(
                                  isShowIcons: true,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "View All",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Builder(
                      builder: (context) {
                        final docs = complex?.importantDocuments;
                        final docCount = (docs != null && docs.isNotEmpty)
                            ? docs.length
                            : documents.length;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: docCount,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 1.5,
                              ),
                          itemBuilder: (context, index) {
                            if (docs != null && docs.isNotEmpty) {
                              final doc = docs[index];
                              return _documentCard(
                                icon: _getDocumentIcon(doc.categoryCode),
                                title: doc.title ?? "",
                                subtitle: doc.subtitle ?? "",
                                actionText: doc.actionText ?? "View Document",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const AssociationDocument(
                                            isShowIcons: true,
                                          ),
                                    ),
                                  );
                                },
                              );
                            }
                            return _documentCard(
                              icon: documents[index]['icon'] as IconData,
                              title: documents[index]['title'] as String,
                              subtitle: documents[index]['subtitle'] as String,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const AssociationDocument(
                                          isShowIcons: true,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEA),
                        border: Border.all(
                          color: Color(0xFF000000),
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 36.w,
                            height: 38.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF000000),
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                'i',
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  complex?.disclaimer?.title ??
                                      'Complex Information',
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF000000),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  complex?.disclaimer?.message ??
                                      'This information is maintained by the administration and\n'
                                          'reflects the current registered complex details.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(41, 41, 51, 0.7),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              return ref.refresh(getComplextDetailsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 0.75.sh,
                child: ApiErrorWidget(
                  error: error,
                  onRetry: () => ref.refresh(getComplextDetailsProvider),
                  defaultTitle: "Complex Not Found",
                  defaultSubtitle:
                      "No complex details are associated with this account or found at the moment.",
                  icon: Icons.apartment_outlined,
                ),
              ),
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _buildPropertyHeader(Data? complex) {
    final banner = complex?.banner;
    final bannerTag = banner?.tag ?? "RESIDENTIAL COMPLEX";
    final bannerName = banner?.name ?? complex?.name ?? "N/A";
    final bannerAddress = banner?.address ?? complex?.address ?? "N/A";
    final bannerImage = banner?.image;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: double.infinity,
        height: 260.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (bannerImage != null && bannerImage.isNotEmpty)
              Image.network(
                bannerImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/document_img.png", fit: BoxFit.cover),
              )
            else
              Image.asset("assets/document_img.png", fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromRGBO(16, 28, 22, 0), Color(0xFF101C16)],
                ),
              ),
            ),
            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bannerTag,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    bannerName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12.sp,
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          bannerAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFF000000), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              border: Border.all(color: const Color(0xFFD5A52C), width: 1.w),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 14.sp, color: const Color(0xFFB8860B)),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
              letterSpacing: -0.2,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return SizedBox(
      height: 60.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                border: Border.all(color: const Color(0xFFD5A52C), width: 1.w),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(icon, size: 16.sp, color: const Color(0xFFB8860B)),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      letterSpacing: -0.2,
                      height: 1.h,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0.8.h,
      thickness: 0.7.w,
      color: Color.fromRGBO(41, 41, 51, 0.7),
    );
  }

  Widget _buildBuildingCard({
    required String block,
    required String name,
    required String units,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Color(0xFF000000), width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    border: Border.all(
                      color: const Color(0xFFD5A52C),
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Text(
                      block,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: Color(0xFF2A2933),
                ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000000),
                letterSpacing: -0.2,
              ),
            ),
            Text(
              units,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatsIcon(String? iconName, IconData defaultIcon) {
    switch (iconName?.toLowerCase()) {
      case 'home_work':
        return Icons.home_work_outlined;
      case 'domain':
        return Icons.domain_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'grid_view':
        return Icons.grid_view_outlined;
      default:
        return defaultIcon;
    }
  }

  IconData _getDetailIcon(String? iconName, String? key) {
    switch (iconName?.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'location_on':
        return Icons.my_location_sharp;
      case 'domain':
        return Icons.apartment_outlined;
      case 'grid_view':
        return Icons.grid_view_outlined;
    }
    switch (key?.toLowerCase()) {
      case 'complex_name':
        return Icons.home_outlined;
      case 'address':
        return Icons.my_location_sharp;
      case 'blocks_info':
        return Icons.apartment_outlined;
      case 'total_units_info':
        return Icons.grid_view_outlined;
      default:
        return Icons.info_outline;
    }
  }

  IconData _getDocumentIcon(String? categoryCode) {
    switch (categoryCode?.toLowerCase()) {
      case 'management_documents':
      case 'association_documents':
        return Icons.description_outlined;
      case 'safety_certificates':
        return Icons.verified_outlined;
      case 'service_documents':
        return Icons.settings_outlined;
      case 'other_records':
        return Icons.folder_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  IconData _getServiceCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'housekeeping':
        return Icons.cleaning_services_outlined;
      case 'security':
        return Icons.shield_outlined;
      case 'oem_equipment':
      case 'electrical':
        return Icons.electrical_services_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  String _formatCategoryName(String? category) {
    if (category == null || category.isEmpty) return "Service Provider";
    return category
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  Widget _serviceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String status = 'Active',
  }) {
    final displayStatus = status.isNotEmpty
        ? status[0].toUpperCase() +
              (status.length > 1 ? status.substring(1).toLowerCase() : '')
        : 'Active';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 12.h),
      constraints: BoxConstraints(minHeight: 65.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.w),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: Colors.black),
          ),
          SizedBox(width: 8.w),
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
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    height: 1.1,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            height: 26.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF24B06A), width: 1.w),
              borderRadius: BorderRadius.circular(21.r),
            ),
            child: Center(
              child: Text(
                displayStatus,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF24B06A),
                  height: 1.1,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    String actionText = 'View Document',
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 14.w,
          right: 14.w,
          top: 8.h,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEA),
          border: Border.all(color: Color(0xFF000000), width: 1.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Box
            Container(
              width: 30.w,
              height: 30.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF000000), width: 1.w),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(icon, size: 18.sp, color: Color(0xFF000000)),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(42, 41, 51, 0.7),
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            Text(
              '$actionText ›',
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000000),
                height: 1.1,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

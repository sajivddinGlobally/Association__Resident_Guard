import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationDocument/AssociationDocumentDetails.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationDocument/provider/getDocumentListProvider.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';

class AssociationDocument extends ConsumerStatefulWidget {
  final bool isShowIcons;
  const AssociationDocument({super.key, this.isShowIcons = false});

  @override
  ConsumerState<AssociationDocument> createState() =>
      _AssociationDocumentState();
}

class _AssociationDocumentState extends ConsumerState<AssociationDocument> {
  int selectedFilter = 0;
  String search = "";

  final List<String> filters = [
    "All",
    "Residential/Commercial management team",
    "Financial",
    "Reports",
    "Policies",
  ];
  @override
  Widget build(BuildContext context) {
    final selectedCategory = filters[selectedFilter].toLowerCase();
    final documentState = ref.watch(
      getDocumentListProvider((category: selectedCategory, search: search)),
    );
    final documentCenter = documentState.valueOrNull?.data?.documentCentre;
    final isLoading = documentState.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              widget.isShowIcons
                  ? GestureDetector(
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
                    )
                  : SizedBox(width: 10.w),
              // SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DOCUMENTS",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Residential/Commercial management team",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              isLoading
                  ? Container(
                      width: double.infinity,
                      height: 150.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.heading,
                          strokeWidth: 1.5.w,
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DOCUMENT CENTRE",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.1,
                            ),
                          ),
                          SizedBox(height: 13.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(184, 134, 11, 0.3),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.description_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFFB8860B),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // "Association Documents",
                                      documentCenter?.title ?? "N/A",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                        height: 1.1,
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      // "Important records & files in one place",
                                      documentCenter?.subtitle ?? "N/A",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromRGBO(0, 0, 0, 0.75),
                                        letterSpacing: -0.2,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            width: double.infinity,
                            height: 1.h,
                            color: const Color(0xFFC6C6C6),
                          ),
                          SizedBox(height: 13.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _documentStat(
                                  value:
                                      documentCenter?.totalFiles.toString() ??
                                      "N/A",
                                  title: "Total Files",
                                ),
                              ),
                              Expanded(
                                child: _documentStat(
                                  value:
                                      documentCenter?.activeFiles.toString() ??
                                      "N/A",
                                  title: "Active",
                                ),
                              ),
                              Expanded(
                                child: _documentStat(
                                  value:
                                      documentCenter?.categoriesCount
                                          .toString() ??
                                      "N/A",
                                  title: "Categories",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 16.h),
              Container(
                height: 52.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: const Color.fromRGBO(16, 28, 22, 0.6),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 24.sp,
                      color: AppColors.heading,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Search service or provider...",
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(16, 28, 22, 0.6),
                            letterSpacing: -0.2,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
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
                                ? const Color(0xff101C16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(40.r),
                            border: Border.all(
                              color: const Color(0xff101C16),
                              width: 1.w,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            filters[index],
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xff101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Featured Document",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              documentState.when(
                data: (data) {
                  if (data.data!.featuredDocuments!.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.6,
                      child: Center(
                        child: Text(
                          "No data found",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.data?.featuredDocuments?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data.data!.featuredDocuments![index];
                      return _buildFeatureDocument(
                        title: item.title ?? 'N/A',
                        subtitle: item.subtitle ?? 'N/A',
                        budget: item.badge ?? 'N/A',
                        id: item.id.toString(),
                        fileType: item.fileType ?? 'N/A',
                        filteSize: item.fileSize ?? 'N/A',
                      );
                    },
                  );
                },
                error: (e, st) {
                  return Center(child: Text(e.toString()));
                },
                loading: () {
                  return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.heading,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _documentStat({required String value, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
            letterSpacing: -0.2,
            height: 1.1,
          ),
        ),
        SizedBox(height: 4.h),
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
    );
  }

  Widget _buildFeatureDocument({
    required String title,
    required String subtitle,
    required String budget,
    required String id,
    required String fileType,
    required String filteSize,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AssociationDocumentDetails(id: id),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Color.fromRGBO(16, 28, 22, 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 89, 147, 0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.description_outlined,
                      size: 20.sp,
                      color: const Color(0xFF1E5993),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // "Property Ownership Document",
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        // "Association · Updated 18 Aug 2026",
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(0, 0, 0, 0.75),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(color: Color(0xFFE0E0E0)),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  // "PDF",
                  fileType,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 42.w),
                Text(
                  // "3.8 MB",
                  filteSize,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(color: Color(0xFF1E5993)),
                  ),
                  child: Text(
                    // "REPORT",
                    budget,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E5993),
                      letterSpacing: -0.2,
                    ),
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

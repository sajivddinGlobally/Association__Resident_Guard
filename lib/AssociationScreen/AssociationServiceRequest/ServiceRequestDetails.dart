import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/Provider/getServiceRequestDetailsProvider.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationServiceRequest/ServiceRequestStatus.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getServiceRequestDetailsModel.dart';

class ServiceRequestDetails extends ConsumerStatefulWidget {
  final String id;
  const ServiceRequestDetails({super.key, required this.id});

  @override
  ConsumerState<ServiceRequestDetails> createState() =>
      _ServiceRequestDetailsState();
}

class _ServiceRequestDetailsState extends ConsumerState<ServiceRequestDetails> {
  @override
  Widget build(BuildContext context) {
    final serviceDetailState = ref.watch(
      getServiceRequestDetailsProvider(widget.id),
    );
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
                    "Request Details",
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
                    "Service Request",
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
      body: serviceDetailState.when(
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
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.black, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.data?.ticketBanner?.tag ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFB8860B),
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                data.data?.ticketBanner?.status ?? "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFB8860B),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 242, 165, 0.3),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Icon(
                                Icons.trending_up,
                                color: const Color(0xFFB8860B),
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.data?.ticketBanner?.title ?? "N/A",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data.data?.ticketBanner?.subtitle ?? "N/A",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          height: 1.h,
                          width: double.infinity,
                          color: const Color(0xFFC6C6C6),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Raised On",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data.data?.ticketBanner?.raisedOn ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last Updated",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(42, 41, 51, 0.75),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    data.data?.ticketBanner?.lastUpdated ??
                                        "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Raised By",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: AppColors.heading,
                              width: 1.w,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: Image.network(
                              data.data?.raisedBy?.avatar ?? "N/A",
                              width: 38.w,
                              height: 38.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 20.sp,
                                  color: Colors.black87,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.data?.raisedBy?.name ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                data.data?.raisedBy?.role ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFB8860B),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            data.data?.raisedBy?.unitBadge ?? "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFB8860B),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Request Information",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Request Type",
                          value:
                              data.data?.requestInformation?.requestType ??
                              "N/A",
                        ),
                        _documentRow(
                          title: "Category",
                          value:
                              data.data?.requestInformation?.category ?? "N/A",
                        ),
                        _documentRow(
                          title: "Location",
                          value:
                              data.data?.requestInformation?.location ?? "N/A",
                        ),
                        _documentRow(
                          title: "Preferred Visit",
                          value:
                              data.data?.requestInformation?.preferredVisit ??
                              "N/A",
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Issue Description",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 14.w,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      data.data?.issueDescription?.description ?? "N/A",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Priority",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_checked,
                          color: const Color(0xFFB8860B),
                          size: 22.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.data?.priority?.title ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                data.data?.priority?.subtitle ?? "N/A",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE3240F),
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            data.data?.priority?.level ?? "N/A",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE3240F),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),
                  Text(
                    "Assigned Service",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      _showAssignedServiceBottomSheet(
                        context,
                        data.data?.assignedService,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 242, 165, 0.3),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.push_pin_outlined,
                              color: const Color(0xFFB8860B),
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data?.assignedService?.providerName ??
                                      "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.heading,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  data.data?.assignedService?.subtitle ?? "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(42, 41, 51, 0.75),
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF1E5993),
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: Text(
                              data.data?.assignedService?.actionText ?? "View",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E5993),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "Current Status",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading, width: 1.w),
                    ),
                    child: Column(
                      children:
                          (data.data?.currentStatus != null &&
                              data.data!.currentStatus!.isNotEmpty)
                          ? List.generate(data.data!.currentStatus!.length, (
                              index,
                            ) {
                              final item = data.data!.currentStatus![index];
                              return _StatusItem(
                                title: item.title ?? "N/A",
                                subtitle: item.dateTime ?? "N/A",
                                isCompleted: item.isCompleted ?? false,
                                isLast:
                                    index ==
                                        data.data!.currentStatus!.length - 1
                                    ? true
                                    : false,
                              );
                            })
                          : [
                              Text(
                                "No status available",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                ),
                              ),
                            ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                ServiceRequestStatus(id: widget.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: Text(
                        "VIEW FULL TICKET STATUS",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(
            "Error loading service request",
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromRGBO(42, 41, 51, 0.75),
              letterSpacing: -0.2,
            ),
          ),
        ),
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    bool showBottomBorder = true,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 44.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
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
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignedServiceBottomSheet(
    BuildContext context,
    AssignedService? service,
  ) {
    if (service == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Service Provider Details",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 242, 165, 0.6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.business_outlined,
                          color: const Color(0xFFB8860B),
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.providerName ?? "N/A",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              service.subtitle ?? "Assigned Service Provider",
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
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.heading),
                  ),
                  child: Column(
                    children: [
                      _documentRow(
                        title: "Category",
                        value: service.category ?? "N/A",
                      ),
                      _documentRow(
                        title: "Status",
                        value: service.status ?? "N/A",
                        showBottomBorder:
                            service.contact != null &&
                            service.contact!.trim().isNotEmpty,
                      ),
                      if (service.contact != null &&
                          service.contact!.trim().isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Contact",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.75),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                service.contact!,
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: service.contact!),
                                  );
                                  showSuccessSnackBar(
                                    "Contact number copied to clipboard",
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      184,
                                      134,
                                      11,
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    size: 15.sp,
                                    color: AppColors.heading,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isLast;

  const _StatusItem({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? const Color.fromRGBO(36, 176, 106, 0.12)
                      : const Color.fromRGBO(184, 134, 11, 0.12),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: const Color(0xFF24B06A),
                          size: 18.sp,
                        )
                      : Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFB8860B),
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.w,
                    color: const Color.fromRGBO(16, 28, 22, 0.35),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, bottom: isLast ? 0 : 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
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
          ),
        ],
      ),
    );
  }
}

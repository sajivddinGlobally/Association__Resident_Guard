import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_association_or_resident/Core/Constant/appColor.dart';
import 'package:property_association_or_resident/Core/Utils/showMessage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Provider/ResidentCommunityContactProvider.dart';

class Communitycontactsscreen extends ConsumerStatefulWidget {
  const Communitycontactsscreen({super.key});

  @override
  ConsumerState<Communitycontactsscreen> createState() =>
      _CommunitycontactsscreenState();
}

class _CommunitycontactsscreenState
    extends ConsumerState<Communitycontactsscreen> {
  Future<void> _makeCall(String telUriOrPhone) async {
    try {
      final String cleanPhone = telUriOrPhone
          .replaceFirst('tel:', '')
          .replaceAll(RegExp(r'\s+'), '');

      final Uri uri = Uri(scheme: 'tel', path: cleanPhone);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          showErrorSnackBar("Could not open dialer for $cleanPhone");
        }
      }
    } catch (e) {
      showErrorSnackBar("Unable to make call: $e");
      log("Error making call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final communityContactState = ref.watch(residentCommunityContactProvider);

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
                    "Community Contacts",
                    style: GoogleFonts.outfit(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Contact your community support team",
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
      body: communityContactState.when(
        data: (data) {
          final sections = data.data.sections;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sections.isNotEmpty) ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sections.length,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (context, index) {
                        final sec = sections[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: index == 0 ? 20.h : 0),
                            Text(
                              sec.sectionTitle,
                              style: GoogleFonts.outfit(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            personCard(
                              name: sec.name,
                              role: sec.subtitle,
                              phone: sec.phone,
                              badge: sec.badge,
                              icon: sec.icon == "users"
                                  ? Icons.group
                                  : Icons.person_outline,
                              telUri: sec.callAction.telUri,
                            ),
                          ],
                        );
                      },
                    ),
                  ] else ...[
                    SizedBox(height: 20.h),
                    Text(
                      data.data.caretaker.sectionTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    personCard(
                      name: data.data.caretaker.name,
                      role: data.data.caretaker.subtitle,
                      phone: data.data.caretaker.phone,
                      badge: data.data.caretaker.badge,
                      icon: Icons.person_outline,
                      telUri: data.data.caretaker.callAction.telUri,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      data.data.associationRepresentative.sectionTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    personCard(
                      name: data.data.associationRepresentative.name,
                      role: data.data.associationRepresentative.subtitle,
                      phone: data.data.associationRepresentative.phone,
                      badge: data.data.associationRepresentative.badge,
                      icon: Icons.group,
                      telUri:
                          data.data.associationRepresentative.callAction.telUri,
                    ),
                  ],
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

  Widget personCard({
    required String name,
    required String role,
    required String phone,
    required String badge,
    required IconData icon,
    String? telUri,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 11.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(184, 134, 11, 0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 20.sp, color: const Color(0xffB8860B)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                      ),
                    ),
                    Text(
                      role,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        color: const Color.fromRGBO(16, 28, 22, 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(184, 134, 11, 0.3),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffB8860B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(thickness: 1, color: AppColors.heading),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phone,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _makeCall(
                    telUri != null && telUri.isNotEmpty ? telUri : phone,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.heading,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Call",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

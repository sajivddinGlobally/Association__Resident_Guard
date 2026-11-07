import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationHome/AssociationHome.dart';
import 'package:property_association_or_resident/AssociationScreen/Auth/AssociationLogin.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentHomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      var box = Hive.box("associationdata");
      var token = box.get("token");
      var role = box.get("role");

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                (role != null &&
                    role.toString().toLowerCase().contains("resident"))
                ? const ResidentBottomNavBar()
                : const AssociationBottomNavBar(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AssociationLogin()),
        );
      }
    });

    // Future.delayed(const Duration(seconds: 3), () {
    //   if (!mounted) return;
    //   Navigator.pushReplacement(
    //     context,

    //     /// Associations
    //     MaterialPageRoute(builder: (context) => const RegisterScreen()),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 119.h),
            Expanded(
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    // "assets/logo.png",
                    "assets/updatelogo.jpeg",
                    width: 223.w,
                    height: 223.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  "assets/splash.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// Loading Circle
                Positioned(
                  top: -50.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.2.w,
                        backgroundColor: const Color(0xff101C16),
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ),

                /// Loading Text
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "LOADING...",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFFFFF),
                        letterSpacing: 1.04,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                /// Version
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "VERSION 1.0.0",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFFFFF),
                        letterSpacing: 1.04,
                        height: 1.0,
                      ),
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

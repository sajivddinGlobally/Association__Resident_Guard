import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:property_association_or_resident/AssociationScreen/AssociationHome/AssociationHome.dart';
import 'package:property_association_or_resident/Core/Utils/key.dart';
import 'package:property_association_or_resident/GuardScreen/GuardHomeScreen/GuardHomeScreen.dart';
import 'package:property_association_or_resident/ResidentScreen/ResidentHomeScreen/ResidentHomeScreen.dart';
import 'package:property_association_or_resident/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("associationdata");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("associationdata");
    var token = box.get("token");
    var role = box.get("role");
    log("Bearer Token :- ${token ?? "No Token Found"}");
    log("Saved Role :- ${role ?? "No Role Found"}");
    return ScreenUtilInit(
      designSize: Size(440, 855),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            // statusBarColor: Color(0xFFF3F3F3),
            // statusBarIconBrightness: Brightness.dark,
            // statusBarBrightness: Brightness.light,
          ),
          child: SafeArea(
            top: false,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: snackBarKey,
              debugShowCheckedModeBanner: false,
              title: 'Property Care',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
            home: token == null
    ? const SplashScreen()
    : (role != null &&
            role.toString().toLowerCase().contains("resident")
        ? const ResidentBottomNavBar()
        : (role != null &&
                role.toString().toLowerCase().contains("security")
            ? GuardBottomNavState()
            : const AssociationBottomNavBar())),
            ),
          ),
        );
      },
    );
  }
}

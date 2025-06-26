

import 'package:novaed_app/core/utils/app_router.dart';
import 'package:novaed_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

import 'core/utils/app_transation.dart';


void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const EyeApp());
}

class EyeApp extends StatelessWidget {
  const EyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        pageTransitionsTheme:  const PageTransitionsTheme(
          // Disable animations on Android & iOS
          builders: {
            TargetPlatform.android:  FadeTransitionsBuilder(),
            TargetPlatform.iOS:  FadeTransitionsBuilder(),
          },
        ),
        brightness: Brightness.light,
        fontFamily: 'NotoSansArabic', 
        // fontFamily: GoogleFonts.notoSansArabic().fontFamily,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.white,
              fontFamily: 'NotoSansArabic',
              // fontFamily: GoogleFonts.notoSansArabic().fontFamily,
            ),
      ),
      themeMode: ThemeMode.light,
    );
  }
}

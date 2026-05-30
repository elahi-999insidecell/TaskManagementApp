import 'package:flutter/material.dart';
import 'package:taskmanager/ui/screens/loginpage.dart';
import 'package:taskmanager/ui/screens/mainnavholder.dart';
import 'package:taskmanager/ui/screens/sign_up.dart';
import 'package:taskmanager/ui/screens/splash_screen.dart';
import 'package:taskmanager/ui/screens/update_profile.dart';

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,

          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // home: SplashScreen(),
      initialRoute: "/splash",
      debugShowCheckedModeBanner: false,
      routes: {
        "/splash": (context) => SplashScreen(),
        "/login": (_) => LogInPage(),
        "/signup": (_) => SignUp(),
        "/navbar": (_) => Mainnavholder(),
        "/updateprofile": (_) => UpdateProfile(),
        
      },
    );
  }
}

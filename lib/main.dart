import 'package:flutter/material.dart';

import 'pages/loginscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          splash: Image.asset('images/logo_coin.gif'),
          splashIconSize: double.maxFinite,
          centered: true,
          backgroundColor: const Color.fromARGB(255, 248, 124, 124),
          duration: 5000,
          splashTransition: SplashTransition.fadeTransition,
          nextScreen: const LoginScreen()),
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF3177B1, <int, Color>{
          50: Color(0xFFD6E9F5),
          100: Color(0xFFB3D4EB),
          200: Color(0xFF8EBFDF),
          300: Color(0xFF69ABD3),
          400: Color(0xFF49A0CA),
          500: Color(0xFF3177B1),
          600: Color(0xFF2B6BA1),
          700: Color(0xFF256090),
          800: Color(0xFF1F547F),
          900: Color(0xFF17416C),
        }),
      ),
    );
  }
}

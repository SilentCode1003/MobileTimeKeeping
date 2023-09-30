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
    // Define your custom color
    const customColor = Color.fromARGB(255, 201, 62, 71);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('images/logo_coin.gif'),
        splashIconSize: double.maxFinite,
        centered: true,
        backgroundColor: customColor, // Use your custom color here
        duration: 5000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const LoginScreen(),
      ),
      theme: ThemeData(
        primarySwatch: MaterialColor(
          customColor.value,
          const <int, Color>{
            50: customColor,
            100: customColor,
            200: customColor,
            300: customColor,
            400: customColor,
            500: customColor,
            600: customColor,
            700: customColor,
            800: customColor,
            900: customColor,
          },
        ),
      ),
    );
  }
}

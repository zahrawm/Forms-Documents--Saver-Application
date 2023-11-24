import 'package:document_saver_application/screen/authentication_screen.dart';
import 'package:document_saver_application/screen/home_screen.dart';
import 'package:document_saver_application/screen/screen_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _navigate() async {
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      bool value = FirebaseAuth.instance.currentUser == null;
      if (value) {
        Navigator.of(context)
            .pushReplacementNamed(AuthenticationScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    _navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser == null);
    return Scaffold(
      body: ScreenBackgroundWidget(
          child: Center(child: Image.asset("assets/splash.png"))),
    );
  }
}

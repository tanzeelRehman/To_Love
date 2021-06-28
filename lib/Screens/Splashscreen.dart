import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:to_love/Screens/Homepage.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 14,
        navigateAfterSeconds: Homepage(),
        title: Text("To Love",
            style: GoogleFonts.lobsterTwo(fontSize: 60, color: Colors.pink)),
        image: new Image.asset('assets/images/heartlogo.png'),
        backgroundColor: Colors.white,
        loadingText: Text("Copy rights by Tanzeel ur Rehman"),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.pink);
  }
}

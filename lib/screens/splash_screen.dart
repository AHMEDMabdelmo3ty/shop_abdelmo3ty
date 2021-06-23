import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        body: Center(
          child: SizedBox(
            width: 250.0,
            child: DefaultTextStyle(
              style: GoogleFonts.lobsterTwo(
                color: Colors.blueAccent,
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText('wlecame,'),
                  TyperAnimatedText('the new app,'),
                  TyperAnimatedText('hobbiese ,art ,sports ,'),
                  TyperAnimatedText('let\'s goo '),
                ],
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ));
  }
}

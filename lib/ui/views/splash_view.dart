import 'package:flutter/material.dart';
import 'package:stuwise/ui/constants/text_styles.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        "StuWise",
        style: kHeading1TextStyle,
      ),
    ));
  }
}

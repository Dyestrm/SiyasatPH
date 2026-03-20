import 'package:flutter/material.dart';
import './theme/colors.dart';
import './screens/landing_screen.dart';

void main() {
  runApp(const SiyasatPH());
}

class SiyasatPH extends StatelessWidget {
  const SiyasatPH({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SiyasatPH",
      theme: ThemeData(
        primaryColor: AppColors.primaryTeal,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Poppins',
      ),
      home: LandingScreen(),
    );
  }
}
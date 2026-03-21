import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SetupChoiceScreen extends StatefulWidget {
  const SetupChoiceScreen({super.key});

  @override
  State<SetupChoiceScreen> createState() => _SetupChoiceScreenState();
}

class _SetupChoiceScreenState extends State<SetupChoiceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 
            ],
          ),
        ),
      ),
    );
  }
}
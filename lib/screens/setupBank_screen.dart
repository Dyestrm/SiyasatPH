import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SetupBankScreen extends StatefulWidget {
  final String configName;
  final String notifyName;
  final String notifyContact;
  final String language;

  const SetupBankScreen({
    super.key,
    required this.configName,
    required this.notifyName,
    required this.notifyContact,
    required this.language,
  });

  @override
  State<SetupBankScreen> createState() => _SetupBankScreenState();
}

class _SetupBankScreenState extends State<SetupBankScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Text('Anong bangko ang ginagamit mo? ' ),
        ),
      ),
    );
  }
}
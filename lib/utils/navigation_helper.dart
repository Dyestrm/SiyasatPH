import 'package:flutter/material.dart';

/// Helper function to navigate to a new screen.
///
/// [context]: The BuildContext from the current widget.
/// [screen]: The instance of the screen widget to navigate to (e.g., const LoginPage()).
void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

// Optional: Helper for replacing the current screen (e.g., after login)
void navigateAndReplace(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
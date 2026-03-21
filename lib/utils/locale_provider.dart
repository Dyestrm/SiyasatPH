import 'package:flutter/material.dart';
import '../l10n/strings.dart';

class LocaleProvider extends ChangeNotifier {
  String _lang = 'fil';

  String get lang => _lang;

  void setLang(String lang) {
    _lang = lang;
    notifyListeners();
  }

  String t(String key) => appStrings[_lang]?[key] ?? key;
}
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/scam_pattern.dart';

class PatternRepository {
  static final PatternRepository _instance = PatternRepository._internal();
  factory PatternRepository() => _instance;
  PatternRepository._internal();

  List<ScamPattern> _patterns = [];
  bool _loaded = false;

  List<ScamPattern> get patterns => _patterns;

  Future<void> loadPatterns() async {
    if (_loaded) return;
    final json = await rootBundle.loadString('assets/scam_patterns.json');
    final data = jsonDecode(json);
    _patterns = (data['patterns'] as List)
        .map((p) => ScamPattern.fromJson(p))
        .toList();
    _loaded = true;
  }
}
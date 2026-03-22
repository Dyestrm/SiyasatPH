import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/scam_pattern.dart';

class SpamPatternRepository {
  static final SpamPatternRepository _instance = SpamPatternRepository._internal();
  factory SpamPatternRepository() => _instance;
  SpamPatternRepository._internal();

  List<ScamPattern>? _patterns;

  Future<void> loadPatterns() async {
    if (_patterns != null) return;
    try {
      final String jsonString = await rootBundle.loadString('assets/spam_patterns.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      _patterns = (data['patterns'] as List)
          .map((json) => ScamPattern.fromJson(json))
          .toList();
    } catch (e) {
      _patterns = [];
      print('Failed to load spam_patterns.json: $e');
    }
  }

  List<ScamPattern> get patterns => _patterns ?? [];
}
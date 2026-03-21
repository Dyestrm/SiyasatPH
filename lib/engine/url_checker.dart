import 'dart:convert';
import 'package:flutter/services.dart';

class UrlChecker {
  static final UrlChecker _instance = UrlChecker._internal();
  factory UrlChecker() => _instance;
  UrlChecker._internal();

  List<dynamic> _domains = [];
  bool _loaded = false;

  // Exposed so BankChecker can reuse the loaded verified_domains.json (no duplication)
  List<dynamic> get domains => domains;

  Future<void> loadDomains() async {
    if (_loaded) return;
    final json = await rootBundle.loadString('assets/verified_domains.json');
    _domains = jsonDecode(json)['domains'];
    _loaded = true;
  }

  Future<UrlCheckResult> check(String message) async {
    await loadDomains();
    final lower = message.toLowerCase();
    final foundUrls = _extractUrls(lower);
    final suspiciousUrls = <String>[];
    final reasons = <String>[];

    for (final url in foundUrls) {
      for (final domain in _domains) {
        final institution = domain['institution'].toString().toLowerCase();
        final legitDomain = domain['domain'].toString().toLowerCase();
        final hasInstitutionName = url.contains(institution);
        final hasLegitDomain = url.contains(legitDomain);
        if (hasInstitutionName && !hasLegitDomain) {
          suspiciousUrls.add(url);
          reasons.add('Fake ${domain['institution']} link: "$url"');
          break;
        }
      }

      final suspiciousKeywords = [
        'verify', 'secure', 'update', 'login',
        'confirm', 'validate', 'suspended', 'unlock'
      ];
      for (final keyword in suspiciousKeywords) {
        if (url.contains(keyword) && !suspiciousUrls.contains(url)) {
          suspiciousUrls.add(url);
          reasons.add('Suspicious URL keyword "$keyword" in: "$url"');
          break;
        }
      }
    }

    return UrlCheckResult(
      foundUrls: foundUrls,
      suspiciousUrls: suspiciousUrls,
      reasons: reasons,
      isFlagged: suspiciousUrls.isNotEmpty,
    );
  }

  List<String> _extractUrls(String text) {
    final pattern = RegExp(
      r'https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9\-]+\.[a-zA-Z]{2,3}[^\s]*',
      caseSensitive: false,
    );
    return pattern.allMatches(text).map((m) => m.group(0)!).toList();
  }
}

class UrlCheckResult {
  final List<String> foundUrls;
  final List<String> suspiciousUrls;
  final List<String> reasons;
  final bool isFlagged;

  UrlCheckResult({
    required this.foundUrls,
    required this.suspiciousUrls,
    required this.reasons,
    required this.isFlagged,
  });
}

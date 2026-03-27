import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';          
import 'package:path_provider/path_provider.dart';
import '../models/history_entry.dart';
import '../models/verdict.dart';

class HistoryRepository extends ChangeNotifier {
  static final HistoryRepository _instance = HistoryRepository._internal();
  factory HistoryRepository() => _instance;
  HistoryRepository._internal();

  List<HistoryEntry> _history = [];
  File? _file;

  Future<void> _initFile() async {
    if (_file != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/analysis_history.json');
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      if (await _file!.exists()) {
        final String content = await _file!.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> data = json.decode(content) as List<dynamic>;
          _history = data.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      _history = [];
      debugPrint('Failed to load history: $e');
    }
  }

  Future<void> _saveToFile() async {
    try {
      await _file!.writeAsString(
        json.encode(_history.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Failed to save history: $e');
    }
  }

  /// Save a new analysis
  Future<void> saveAnalysis(String originalMessage, Verdict result) async {
    await _initFile();
    final entry = HistoryEntry(
      timestamp: DateTime.now(),
      originalMessage: originalMessage,
      result: result,
    );
    _history.insert(0, entry);
    await _saveToFile();
    notifyListeners(); // notify all files using HistoryRepository
  }

  /// Clear all entries
  Future<void> clearAll() async {
    await _initFile();
    _history.clear();
    await _saveToFile();
    notifyListeners();
  }

  /// Get all entries (newest first)
  Future<List<HistoryEntry>> getAll() async {
    await _initFile();
    return _history;
  }

  /// Debug purposes
  Future<void> displayHistory() async {
    final entries = await getAll();
    if (entries.isEmpty) {
      print('📭 No analysis history yet.');
      return;
    }

    print('\n📜 ANALYSIS HISTORY (${entries.length} entries) 📜');
    for (var entry in entries) {
      print('\n📅 ${entry.timestamp}');
      print('💬 ${entry.originalMessage.length > 80 ? "${entry.originalMessage.substring(0, 80)}..." : entry.originalMessage}');
      print('✅ Verdict: ${entry.result.level.name.toUpperCase()}');
      print('📝 Explanation: ${entry.result.explanation}');
      //TODO: Need to adjust because Verdict.reasons is no longer List<String>
      if (entry.result.reasons.isNotEmpty) {
        print('🔍 Reasons: ${entry.result.reasons.join(" | ")}');
      }
    }
    print('📜 END OF HISTORY 📜\n');
  }
}
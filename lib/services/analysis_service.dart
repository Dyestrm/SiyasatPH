// lib/services/analysis_service.dart
import '../engine/rules_engine.dart';
import '../models/verdict.dart';
import '../repository/history_repository.dart';
import '../models/family_setup_model.dart';

class AnalysisService {
  static final AnalysisService _instance = AnalysisService._internal();
  factory AnalysisService() => _instance;
  AnalysisService._internal();

  Future<Verdict> analyzeMessage(
    String message,
    String senderNumber, {
    FamilySetupModel? setup,           // ← now optional!
  }) async {
    final engine = RulesEngine();

    // Use real setup when available, otherwise safe defaults for testing
    if (setup != null) {
      engine.selectedBanks = setup.selectedBanks;
      engine.language = setup.language;
    } else {
      engine.selectedBanks = ['BDO', 'GCash', 'Maya'];
      engine.language = 'fil';
    }

    final verdict = await engine.analyze(message.trim(), senderNumber);

    await HistoryRepository().saveAnalysis(message, verdict);

    return verdict;
  }
}
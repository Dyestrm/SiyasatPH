import 'verdict.dart';

class HistoryEntry {
  final String id;
  final DateTime timestamp;
  final String originalMessage;
  final Verdict result;

  HistoryEntry({
    String? id,
    required this.timestamp,
    required this.originalMessage,
    required this.result,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      originalMessage: json['originalMessage'] ?? '',
      result: Verdict.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'originalMessage': originalMessage,
    'result': result.toJson(),
  };
}
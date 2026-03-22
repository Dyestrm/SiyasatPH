import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../repository/history_repository.dart';
import '../models/history_entry.dart';
import '../models/verdict.dart';

//data model
enum MessageLabel { scam, ingat, ligtas }

Color labelColor(MessageLabel type) {
  switch (type) {
    case MessageLabel.scam: return AppColors.sunsetOrange;
    case MessageLabel.ingat: return AppColors.burntUmber;
    case MessageLabel.ligtas: return AppColors.primaryTeal;
  }
}

// Helper Methods
MessageLabel _mapToLabel(RiskLevel level) {
  if (level == RiskLevel.safe) return MessageLabel.ligtas;
  if (level == RiskLevel.suspicious) return MessageLabel.ingat;
  return MessageLabel.scam; // spam & likelyScam = same red color
}

String _getVerdictDisplayName(RiskLevel level) {
  switch (level) {
    case RiskLevel.safe: return 'Ligtas';
    case RiskLevel.suspicious: return 'Mag-ingat';
    case RiskLevel.spam: return 'Spam';
    case RiskLevel.likelyScam: return 'Scam';
  }
}

IconData _getVerdictIcon(RiskLevel level) {
  switch (level) {
    case RiskLevel.safe:
      return Icons.done_all_rounded;
    case RiskLevel.suspicious:
      return Icons.error_outline;
    default:
      return Icons.clear_rounded;
  }
}

Color _getVerdictColor(RiskLevel level) {
  if (level == RiskLevel.safe) return AppColors.primaryTeal;
  if (level == RiskLevel.suspicious) return AppColors.burntUmber;
  return AppColors.sunsetOrange;
}

String _formatTime(DateTime timestamp) {
  final diff = DateTime.now().difference(timestamp);
  if (diff.inDays >= 1) return '${diff.inDays}d ago';
  if (diff.inHours >= 1) return '${diff.inHours}h ago';
  return '${diff.inMinutes}m ago';
}

//history screen
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0; // 0=All, 1=Scam, 2=Kahina-hinala, 3=Ligtas

  final List<String> _filters = ['All', 'Scam', 'Kahina-hinala', 'Ligtas'];

  List<HistoryEntry> _entries = [];
  final HistoryRepository _repo = HistoryRepository();

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _repo.addListener(_loadHistory); // ← auto-refresh signal from AnalysisService
  }

  @override
  void dispose() {
    _repo.removeListener(_loadHistory);
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final data = await _repo.getAll();
    setState(() => _entries = data);
  }

  Future<void> _clearAll() async {
    await _repo.clearAll();
  }

  List<HistoryEntry> get _filteredEntries {
    if (_selectedFilter == 0) return _entries;
    if (_selectedFilter == 1) {
      return _entries.where((e) => e.result.level == RiskLevel.spam || e.result.level == RiskLevel.likelyScam).toList();
    }
    if (_selectedFilter == 2) {
      return _entries.where((e) => e.result.level == RiskLevel.suspicious).toList();
    }
    return _entries.where((e) => e.result.level == RiskLevel.safe).toList();
  }

// header
  AppBar _buildAppBar() => AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        titleSpacing: 30,
        title: const Text(
          'Kasaysayan',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 23),
        ],
        // line in header
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primaryTeal),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            //filter chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primaryTeal : AppColors.bgOffWhite,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.primaryTeal : const Color(0xFFE4E4E0),
                        ),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selected ? AppColors.white : AppColors.textGrey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            //message list
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('Walang history pa.', style: TextStyle(color: Colors.grey)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: _filteredEntries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final entry = _filteredEntries[index];
                        return _MessageCard(
                          entry: entry,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              isDismissible: true,
                              enableDrag: true,
                              builder: (_) => ResultSheet(entry: entry),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//message card

class _MessageCard extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onTap;

  const _MessageCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final labelType = _mapToLabel(entry.result.level);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Label badge
            Container(
              width: 64,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: labelColor(labelType).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                _getVerdictDisplayName(entry.result.level),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: labelColor(labelType),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Preview text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.originalMessage.length > 65
                        ? "${entry.originalMessage.substring(0, 65)}..."
                        : entry.originalMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatTime(entry.timestamp)} - ${entry.result.senderNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }
}

//result sheet
class ResultSheet extends StatelessWidget {
  final HistoryEntry entry;
  const ResultSheet({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final level = entry.result.level;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.72, 0.95],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.bgOffWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                //drag handle
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                //header row
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_back, size: 18, color: AppColors.primaryTeal),
                                SizedBox(width: 4),
                                Text(
                                  'Return',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.primaryTeal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 70),
                        ],
                      ),
                    ),
                    Container(height: 1, color: AppColors.primaryTeal),
                  ],
                ),
                const SizedBox(height: 30),

                //result summary/bagde
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getVerdictColor(level),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getVerdictIcon(level),
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getVerdictDisplayName(level),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _getVerdictColor(level),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatTime(entry.timestamp)}    ${entry.result.senderNumber}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                //original message box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORIHINAL NA MENSAHE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textGrey,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.originalMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                //why it was flagged box (only show if scam or ingat)
                if (entry.result.reasons.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3F3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.paleBlush),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BAKIT NA FLAG',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGrey,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...entry.result.reasons.map((r) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '• $r',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                    height: 1.6,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
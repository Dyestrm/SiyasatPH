import 'package:flutter/material.dart';
import 'package:siyasat_ph/theme/colors.dart';
import 'package:siyasat_ph/models/verdict.dart';
import 'package:flutter/services.dart';

enum VerdictType { safe, suspicious, scam, spam }

class FlagItem{
  final String label;
  final String title;
  final String body;

  const FlagItem({
    required this.label,
    required this.title,
    required this.body,
  });
}

  class ScanResult{
  final VerdictType verdict;
  final String message;
  final String sender;
  final List<FlagItem> flags;
  final List<String> tags;
  const ScanResult({
    required this.verdict,
    required this.message,
    this.sender = '',
    this.flags = const [],
    this.tags = const [],  });
  }

class VerdictScreen extends StatelessWidget {
  final ScanResult result;

  const VerdictScreen({super.key, required this.result});

//style per veridtc
_VStyle get _style {
    return switch (result.verdict) {
      VerdictType.safe => const _VStyle(
          cardBg: AppColors.lightTeal,
          iconBg: AppColors.primaryTeal,
          icon: Icons.check,
          label: 'Ligtas',
          labelColor: AppColors.darkTeal,
          desc: 'Walang natuklasang red flag.\nAng mensaheng ito ay mukhang ligtas.',
          flagBorder: AppColors.secondaryTeal,
          flagLabelColor: AppColors.midGrey,
        ),
      VerdictType.suspicious => const _VStyle(
          cardBg: AppColors.lightCream,
          iconBg: AppColors.burntUmber,
          icon: Icons.priority_high_rounded,
          label: 'Kahina-hinala',
          labelColor: AppColors.burntUmber,
          desc: 'Mag-ingat. May senyales ng scam.\nHuwag mag-click nang hindi sigurado.',
          flagBorder: AppColors.flaxenGold,
          flagLabelColor: AppColors.burntUmber,
        ),
      VerdictType.scam => const _VStyle(
          cardBg: AppColors.paleBlush,
          iconBg: AppColors.scamColor,
          icon: Icons.close,
          label: 'Posibleng Scam',
          labelColor: AppColors.textDarkRed,
          desc: 'Huwag sundin ang mga nakasaad.\nIto ay malamang na isang scam.',
          flagBorder: AppColors.sunsetOrange,
          flagLabelColor: AppColors.textDarkRed,
        ),
      VerdictType.spam => const _VStyle(
          cardBg: AppColors.lightCream,
          iconBg: AppColors.sunsetOrange,
          icon: Icons.clear_rounded,
          label: 'Spam',
          labelColor: AppColors.sunsetOrange,
          desc: 'Ito ay promotional spam.\nMaaari itong i-ignore nang ligtas.',
          flagBorder: AppColors.sunsetOrange,
          flagLabelColor: AppColors.sunsetOrange,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;

    return Scaffold(
      backgroundColor:AppColors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildVerdictCard(s),
            const SizedBox(height: 17),
            _buildFlagCards(s),
            const SizedBox(height: 10),
            const Text(
              'Kahit ligtas, ugaliing mag-ingat palagi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.midGrey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 17),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  // AppBar with back button and title
  AppBar _buildAppBar(BuildContext ctx) => AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 60,
      leadingWidth: 120, 
      leading: Padding(
        padding: const EdgeInsets.only(left: 26.0), 
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back,
                size: 28, 
                color: AppColors.primaryTeal,
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
            const SizedBox(width: 7),
            const Text(
              'Bumalik',
              style: TextStyle(
                color: AppColors.black, 
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      title: const Text(
        'Resulta',
        style: TextStyle(
          fontWeight: FontWeight.w600, 
          color: AppColors.black, 
          fontSize: 20,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Container(height: 1, color: AppColors.primaryTeal),
      ),
    );

  // verdict card
  Widget _buildVerdictCard(_VStyle s) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: s.cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: s.iconBg,
              child: Icon(s.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              s.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: s.labelColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.black),
            ),
          ],
        ),
      );

  //flag carsd
  Widget _buildFlagCards(_VStyle s) {
    if (result.flags.isEmpty) {
      //safe state
      return _flagCard(
        s,
        label: 'PAGSUSURI',
        title: '',
        body: 'Walang makitang kahina-hinalang link o mataas na presyur na pananalita.',
        tags: result.tags,
      );
    }
    //sus / scam state - show all flags
    return Column(
      children: result.flags
          .map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _flagCard(s, label: f.label, title: f.title, body: f.body),
              ))
          .toList(),
    );
  }

  //single flag card builder
  Widget _flagCard(
    _VStyle s, {
    required String label,
    required String title,
    required String body,
    List<String> tags = const [],
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: s.flagBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: s.flagLabelColor,
              ),
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              ),
            ],
            const SizedBox(height: 3),
            Text(
              body,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.midGrey,
              ),
            ),
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags
                    .map((t) => Text(
                          t,
                          style: const TextStyle(
                            color: AppColors.primaryTeal,
                            fontSize: 12,
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      );

  //buttons based on verdict
  Widget _buildButtons(BuildContext ctx) {
    switch (result.verdict) {
      case VerdictType.safe:
        return _outlinedBtn(
          label: 'Suriin ang iba pa',
          onTap: () => Navigator.pop(ctx),
        );

      case VerdictType.suspicious:
        return Column(
          children: [
            _filledBtn('Sabihan ang Pamilya', onTap: () {
              /* insert alert family logic */
            }),
            const SizedBox(height: 10),
            _outlinedBtn(
              label: 'Suriin ang iba pa',
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        );

      // Both scam and spam show the full danger buttons (NTC report + copy)
      case VerdictType.scam:
      case VerdictType.spam:
      return _buildDangerButtons(ctx);
    }
  }

  // Private helper to avoid duplication between scam and spam
  Widget _buildDangerButtons(BuildContext ctx) => Column(
    children: [
      _filledBtn('Sabihan ang Pamilya', onTap: () {
        /* insert alert family logic */
      }),
      const SizedBox(height: 10),
      _outlinedBtn(
        label: 'I-report sa NTC',
        color: AppColors.textDarkRed,
        backgroundColor: AppColors.paleBlush,
        onTap: () {
          /* insert NTC report logic */
        },
      ),
      const SizedBox(height: 10),
      _outlinedBtn(
        label: 'Kopyahin ang Detalye',
        onTap: () => Clipboard.setData(ClipboardData(text: result.message)),
      ),
    ],
  );

  //filled button builder
  Widget _filledBtn(String label, {required VoidCallback onTap}) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkTeal,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );

  Widget _outlinedBtn({
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.black,
    Color? backgroundColor, 
  }) =>
      SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            side: BorderSide(color: color.withOpacity(0.8)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: color),
          ),
        ),
      );
}

//private styles class
class _VStyle {
  final Color cardBg, iconBg, labelColor, flagBorder, flagLabelColor;
  final IconData icon;
  final String label, desc;

  const _VStyle({
    required this.cardBg,
    required this.iconBg,
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.desc,
    required this.flagBorder,
    required this.flagLabelColor,
  });
}
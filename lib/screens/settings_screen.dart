import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../utils/locale_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoDetectSMS = true;
  bool _vibrateOnScam = true;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgOffWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.bgOffWhite,
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 56,
        title: Text(
          locale.t('settings'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.secondaryTeal, height: 2),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── LANGUAGE ──────────────────────────────────────
          _sectionHeader(locale.t('section_language')),

          _buildTile(
            svgPath: 'assets/images/language.svg',
            iconBgColor: const Color(0xFFE0F4F1),
            iconColor: AppColors.secondaryTeal,
            title: locale.t('app_language'),
            subtitle: locale.t('app_language_sub'),
            trailing: _languageToggle(locale),
          ),

          // ── NOTIFICATIONS ─────────────────────────────
          _sectionHeader(locale.t('section_notifications')),

          _buildTile(
            svgPath: 'assets/images/autodetect.svg',
            iconBgColor: const Color(0xFFFFF3E0),
            iconColor: Colors.orange,
            title: locale.t('auto_detect'),
            subtitle: locale.t('auto_detect_sub'),
            trailing: Switch(
              value: _autoDetectSMS,
              onChanged: (val) => setState(() => _autoDetectSMS = val),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.darkTeal,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.lightGrey,
            ),
          ),

          _buildTile(
            svgPath: 'assets/images/vibrate.svg',
            iconBgColor: const Color(0xFFEDE7F6),
            iconColor: Colors.deepPurple,
            title: locale.t('vibrate_scam'),
            subtitle: locale.t('vibrate_scam_sub'),
            trailing: Switch(
              value: _vibrateOnScam,
              onChanged: (val) => setState(() => _vibrateOnScam = val),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.darkTeal,
              inactiveThumbColor: AppColors.white,
              inactiveTrackColor: AppColors.lightGrey,
            ),
          ),

          // ── DATA ────────────────────
          _sectionHeader(locale.t('section_data')),

          _buildTile(
            svgPath: 'assets/images/update.svg',
            iconBgColor: AppColors.white,
            iconColor: AppColors.secondaryTeal,
            title: locale.t('update_patterns'),
            subtitle: locale.t('last_update'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lightTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                locale.t('updated_badge'),
                style: TextStyle(
                  color: AppColors.darkTeal,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          // ── ABOUT ─────────────────────────────────────
          _sectionHeader(locale.t('section_about')),

          _buildTile(
            svgPath: 'assets/images/info.svg',
            iconBgColor: const Color(0xFFE8F5E9),
            iconColor: Colors.green,
            title: 'SiyasatPH',
            subtitle: locale.t('version'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'v1.0.0',
                style: TextStyle(color: AppColors.white, fontSize: 12),
              ),
            ),
          ),

          _buildTile(
            svgPath: 'assets/images/privacy.svg',
            iconBgColor: const Color(0xFFFCE4EC),
            iconColor: Colors.pink,
            title: locale.t('privacy_policy'),
            subtitle: locale.t('privacy_policy_sub'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),

          _buildTile(
            svgPath: 'assets/images/send_help.svg',
            iconBgColor: const Color(0xFFF3E5F5),
            iconColor: Colors.purple,
            title: locale.t('send_feedback'),
            subtitle: locale.t('send_feedback_sub'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTile({
    required String svgPath,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SvgPicture.asset(svgPath),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _languageToggle(LocaleProvider locale) {
    final isFil = locale.lang == 'fil';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _langChip('FIL', isFil, () => locale.setLang('fil')),
        const SizedBox(width: 8),
        _langChip('ENG', !isFil, () => locale.setLang('en')),
      ],
    );
  }

  Widget _langChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE0F4F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: active
              ? null
              : Border.all(color: AppColors.lightGrey, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF009B8D) : Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

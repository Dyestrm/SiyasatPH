import 'package:flutter/material.dart';
import '../theme/colors.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends State<NotificationPermissionScreen> {
  bool _notificationEnabled = false;
  bool _isLoading = false;

  Future<void> _enableNotificationAccess() async {
    setState(() => _isLoading = true);

    // Simulate delay for permission request
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _notificationEnabled = true;
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification access enabled successfully!'),
        backgroundColor: AppColors.safeColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _skipForNow() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You can enable notifications later in settings.'),
        backgroundColor: AppColors.suspiciousColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header text
                Text(
                  _getLocalizedText('permission_title'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColorDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  _getLocalizedText('permission_subtitle'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Bell icon with notification indicator
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 40,
                        color: AppColors.primaryTeal,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Notification access card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.lightTeal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          size: 24,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getLocalizedText('notification_access'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColorDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getLocalizedText('notification_access_sub'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColorGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: _notificationEnabled,
                        onChanged: (value) {
                          setState(() => _notificationEnabled = value);
                        },
                        activeColor: AppColors.primaryTeal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Info box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getLocalizedText('permission_info'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkTeal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                // Enable button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _enableNotificationAccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      disabledBackgroundColor: AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _getLocalizedText('enable_button'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Skip button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _skipForNow,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTeal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _getLocalizedText('skip_button'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Settings path info
                Text(
                  _getLocalizedText('settings_path'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedText(String key) {
    // Simple localization - can be replaced with provider/context
    final isFilipino = true; // You can use Locale context here
    final translations = {
      'permission_title': isFilipino ? 'Payagan ang SiyasatPH' : 'Allow SiyasatPH',
      'permission_subtitle': isFilipino
          ? 'Para suriin ang mga SMS, kailangan ng pahintulot na basahin ang notification.'
          : 'To scan SMS messages, SiyasatPH needs permission to read notifications.',
      'notification_access': isFilipino ? 'Notification Access' : 'Notification Access',
      'notification_access_sub': isFilipino ? 'Para mabasa ang SMS notifications' : 'To read SMS notifications',
      'permission_info': isFilipino
          ? 'Hindi namin binabasa ang iyong mga mensahe. Ang notification text lamang ang ginagamit - hindi ito isasave kailanman.'
          : 'We don\'t read your messages. Only the notification text is analyzed - never saved.',
      'enable_button': isFilipino ? 'I-enable ang Notification Access' : 'Enable Notification Access',
      'skip_button': isFilipino ? 'Gawin mamaya' : 'Do it Later',
      'settings_path': isFilipino
          ? 'Settings → Notifications → Notification Access → SiyasatPH'
          : 'Settings → Notifications → Notification Access → SiyasatPH',
    };
    return translations[key] ?? key;
  }
}

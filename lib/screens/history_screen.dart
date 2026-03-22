import 'package:flutter/material.dart';
import '../theme/colors.dart';

//data model
enum MessageLabel { scam, ingat, ligtas }

class SmsMessage {
  final String label;
  final MessageLabel labelType;
  final String preview;
  final String time;
  final String sender;

  const SmsMessage({
    required this.label,
    required this.labelType,
    required this.preview,
    required this.time,
    required this.sender,
  });
}

final List<SmsMessage> sampleMessages = [
  SmsMessage(
    label: 'Scam',
    labelType: MessageLabel.scam,
    preview: 'Your BDO account is suspended...',
    time: '9:59 pm',
    sender: '09123456789',
  ),
  SmsMessage(
    label: 'Ingat',
    labelType: MessageLabel.ingat,
    preview: 'Please verify you Gcash account...',
    time: 'kahapon',
    sender: 'unknown',
  ),
  SmsMessage(
    label: 'Ligtas',
    labelType: MessageLabel.ligtas,
    preview: 'Your OTP is 1234567...',
    time: 'March 17',
    sender: '09123456789',
  ),
  SmsMessage(
    label: 'Scam',
    labelType: MessageLabel.scam,
    preview: 'Congrats! You won 50,000...',
    time: 'March 16',
    sender: 'unknown',
  ),
];


Color labelColor(MessageLabel type) {
  switch (type) {
    case MessageLabel.scam:
      return AppColors.sunsetOrange;
    case MessageLabel.ingat:
      return AppColors.burntUmber;
    case MessageLabel.ligtas:
      return AppColors.primaryTeal;
  }
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
          onPressed: () {},
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

  List<SmsMessage> get _filteredMessages {
    if (_selectedFilter == 0) return sampleMessages;
    if (_selectedFilter == 1) {
      return sampleMessages.where((m) => m.labelType == MessageLabel.scam).toList();
    }
    if (_selectedFilter == 2) {
      return sampleMessages.where((m) => m.labelType == MessageLabel.ingat).toList();
    }
    return sampleMessages.where((m) => m.labelType == MessageLabel.ligtas).toList();
  }

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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: _filteredMessages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final msg = _filteredMessages[index];
                  return _MessageCard(
                    message: msg,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        enableDrag: true,
                        builder: (_) => ResultSheet(message: msg),
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
  final SmsMessage message;
  final VoidCallback onTap;

  const _MessageCard({required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                color: labelColor(message.labelType).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                message.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: labelColor(message.labelType),
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
                    message.preview,
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
                    '${message.time} - ${message.sender}',
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
  final SmsMessage message;
  const ResultSheet({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isScam = message.labelType == MessageLabel.scam;
    final screenHeight = MediaQuery.of(context).size.height;

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
                        color: switch (message.labelType) {
                          MessageLabel.scam => AppColors.scamColor,
                          MessageLabel.ingat => AppColors.burntUmber,
                          MessageLabel.ligtas => AppColors.primaryTeal,
                        },
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        switch (message.labelType) {
                          MessageLabel.scam => Icons.clear_rounded,
                          MessageLabel.ingat => Icons.error_outline,
                          MessageLabel.ligtas => Icons.done_all_rounded,
                        },
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      switch (message.labelType) {
                        MessageLabel.scam => 'Likely Scam',
                        MessageLabel.ingat => 'Suspicious',
                        MessageLabel.ligtas => 'Safe',
                      },
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: switch (message.labelType) {
                          MessageLabel.scam => AppColors.scamColor,
                          MessageLabel.ingat => AppColors.burntUmber,
                          MessageLabel.ligtas => AppColors.primaryTeal,
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${message.time}    ${message.sender}',
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
                            const Text(
                              '"Ang iyong BDO account ay suspended. I-verify ang iyong account ngayon para maiwasan ang deactivation: bdo-verify.com/secure"',
                              style: TextStyle(
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
                    children: const [
                      Text(
                        'BAKIT NA FLAG',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textGrey,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pekeng domain: "bdo-verify.com"',
                        style: TextStyle(
                          fontSize: 14,
                          color:  AppColors.black,
                          height: 1.6,
                        ),
                      ),
                      Text(
                        'Urgency Language: “ma-suspend”',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          height: 1.6,
                        ),
                      ),
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

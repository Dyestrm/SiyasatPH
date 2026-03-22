import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/bottom_nav.dart';

class ReportScreen extends StatefulWidget {
  final String senderNumber;
  final String scamType;
  final String messageExcerpt;
  final String dateTime;

  const ReportScreen({
    super.key,
    this.senderNumber = '09123456789',
    this.scamType = 'Bank Impersonation',
    this.messageExcerpt = '"Your BDO account is suspended. Verify at bdo-verify..."',
    this.dateTime = 'March 20, 2026 - 6:30 PM',
  });

  @override
  State<ReportScreen> createState() => _ReportNtcScreenState();
}

class _ReportNtcScreenState extends State<ReportScreen> {
  final _commentController = TextEditingController();
  String? _uploadedFileName;
  int _currentIndex = 3;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext ctx) => AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 60,
      leadingWidth: 120, 
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0), 
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
            const SizedBox(width: 10),
            const Text(
              'Bumalik',
              style: TextStyle(
                color: AppColors.black, 
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
        'I-report sa NTC',
        style: TextStyle(
          fontWeight: FontWeight.w600, 
          color: AppColors.black, 
          fontSize: 16,
        ),
      ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Container(height: 1, color: AppColors.primaryTeal),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Awtimatikong napuno ang mga detalye. I-review bago mag-submit.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.midGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              _FieldLabel(label: 'Numero ng nagpadala'),
              const SizedBox(height: 6),
              _AutoFilledField(value: '${widget.senderNumber} : Auto-filled'),
              const SizedBox(height: 16),

              _FieldLabel(label: 'Uri ng Scam'),
              const SizedBox(height: 6),
              _EditableDropdownField(value: widget.scamType),
              const SizedBox(height: 16),

              _FieldLabel(label: 'Bahagi ng Mensahe'),
              const SizedBox(height: 6),
              _AutoFilledField(
                value: '${widget.messageExcerpt} : Auto-filled',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              _FieldLabel(label: 'Petsa at Oras'),
              const SizedBox(height: 6),
              _AutoFilledField(value: '${widget.dateTime} : Auto-filled'),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Dagdag na komento (opsyonal)'),
              const SizedBox(height: 6),
              TextField(
                controller: _commentController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Ilagay dito...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.bgOffWhite,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF646464)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.secondaryTeal,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _FieldLabel(label: 'Mag-upload ng ID'),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  // implement file picker here
                  setState(() => _uploadedFileName = 'id_photo.jpg');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.bgOffWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF646464)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.upload,
                        size: 28,
                        color: AppColors.midGrey,
                      ),
                      if (_uploadedFileName != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          _uploadedFileName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // implement submit here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.paleBlush,
                    foregroundColor: AppColors.sunsetOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.sunsetOrange, width: 1),
                    ),
                  ),
                  child: const Text(
                    'I-report sa NTC',
                    style: TextStyle(
                      color: AppColors.textDarkRed,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () {
                    //open email client logic
                  },
                  child: const Text(
                    'Ipadala sa NTC via email',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.midGrey,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

//shared widgets
class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.midGrey,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

//read only field
class _AutoFilledField extends StatelessWidget {
  final String value;
  final int maxLines;

  const _AutoFilledField({required this.value, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightTeal,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.secondaryTeal),
      ),
      child: Text(
        value,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTeal,
          height: 1.5,
        ),
      ),
    );
  }
}

//for scam type
class _EditableDropdownField extends StatelessWidget {
  final String value;

  const _EditableDropdownField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgOffWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.midGrey),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}
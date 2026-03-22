import 'package:flutter/material.dart';
import 'package:siyasat_ph/widgets/main_navigation.dart';
import '../theme/colors.dart';
import '../screens/home_screen.dart';

class SetupBankScreen extends StatefulWidget {
  final String configName;
  final String notifyName;
  final String notifyContact;
  final String language;

  const SetupBankScreen({
    super.key,
    required this.configName,
    required this.notifyName,
    required this.notifyContact,
    required this.language,
  });

  @override
  State<SetupBankScreen> createState() => _SetupBankScreenState();
}

class _SetupBankScreenState extends State<SetupBankScreen> {

  // --- selected banks and government
  List<String> _selectedBanks = [];
  List<String> _selectedGovernments = [];

  // notification toggle
  bool _autoDetect = false;

  // available options
  final List<String> _banks = [
    'BDO', 'BPI', 'GCash', 'Maya',
    'Metrobank', 'Unionbank', 'Landbank', 'PNB'
  ];
  final List<String> _governments = [
    'SSS', 'GSIS', 'PhilHealth', 'Pag-IBIG'
  ];

  // --- chip widget — works for both banks and governments
  Widget _buildChip(String label, List<String> selectedList) {
    bool isSelected = selectedList.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedList.remove(label);
          } else {
            selectedList.add(label);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.textColorGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textColorWhite : AppColors.textColorDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryTeal),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Set-up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textColorDark,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '2 of 2',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColorGray,
                ),
              ),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.primaryTeal),
        ),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),

            // --- title 
            Text(
              'Anong bangko ang ginagamit mo?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Select all that apply.',
              style: TextStyle(fontSize: 13, color: AppColors.textColorGray),
            ),
            SizedBox(height: 20),

            // --- banks section
            Text(
              'BANKS',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textColorGray,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 8),
            Wrap(
              children: _banks
                  .map((bank) => _buildChip(bank, _selectedBanks))
                  .toList(),
            ),
            SizedBox(height: 16),

            // --- government section
            Text(
              'GOVERNMENT / BENEFITS',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textColorGray,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              children: _governments
                  .map((gov) => _buildChip(gov, _selectedGovernments))
                  .toList(),
            ),
            SizedBox(height: 16),

            Divider(color: AppColors.lightGrey),
            SizedBox(height: 16),

            // --- notification access 
            Text(
              'NOTIFICATION ACCESS',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textColorGray,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGrey),
              ),

              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.lightTeal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: AppColors.primaryTeal,
                    ),
                  ),

                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Auto-detect scam SMS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Automatic Scanning',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textColorGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _autoDetect,
                    onChanged: (value) {
                      setState(() {
                        _autoDetect = value;
                      });
                    },
                    activeTrackColor: AppColors.primaryTeal,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightTeal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Gumagamit kami ng rule-based matching. Walang data na naipadala sa labas ng iyong telepono.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
            SizedBox(height: 32),

            // --- 'tapos na button' - goes to HomeScreen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: AppColors.textColorWhite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Tapos Na',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
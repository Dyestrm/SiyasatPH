import 'package:flutter/material.dart';
import 'package:siyasat_ph/widgets/main_navigation.dart';
import '../theme/colors.dart';
import 'bank_setup_screen.dart';
import 'home_screen.dart';


class SetupChoiceScreen extends StatefulWidget {
  const SetupChoiceScreen({super.key});

  @override
  State<SetupChoiceScreen> createState() => _SetupChoiceScreenState();
}

class _SetupChoiceScreenState extends State<SetupChoiceScreen> {
  // user type selection
  String _selectedConfig = 'Para sa akin';

  // language selection
  String _selectedLanguage = 'Filipino';

  // for name & contact input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // for selecting user type (Para sa akin/pamilya)
  Widget _buildChoiceCard(String title, String subtitle, String value) {
    bool isSelected = _selectedConfig == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedConfig = value;
          });
        },
        child: Container(
          height: 120,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightTeal : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textColorDark,
                ),
              ),

              SizedBox(height: 4),
              
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textColorGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // text input field (name and contact)
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 12, color: AppColors.textColorGray),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        );
      }

  // selecting language 
  Widget _buildLanguageToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = 'Filipino';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedLanguage == 'Filipino'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Filipino',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: _selectedLanguage == 'Filipino'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.textColorDark,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedLanguage == 'English'
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'English',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: _selectedLanguage == 'English'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AppColors.textColorDark,
                  ),
                ),
              ),
            ),
          ),
        ],
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/siyasat_logo.png', height: 32),
            SizedBox(width: 8),
            Text(
              'SiyasatPH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textColorDark,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '1 of 2',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColorGray,
                ),
              ),
            ),
          ),
        ],

        // divider

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: AppColors.primaryTeal,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),

            // 'who is this app for?'
            Text( 
              'Sino ang gagamit?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Who is this app for?',
              style: TextStyle(fontSize: 14, color: AppColors.textColorGray),
            ),
            SizedBox(height: 16),

            // choice cards 
            Row(
              children: [
                _buildChoiceCard('Para sa akin', 'For myself', 'Para sa akin'),
                SizedBox(width: 12),
                _buildChoiceCard('Para sa pamilya', 'For a family member', 'Para sa pamilya'),
              ],
            ),
            SizedBox(height: 24),

            Divider(color: AppColors.lightGrey),
            SizedBox(height: 16),


            // personal info & language selection
            Text(
              'Pansariling Impormasyon',
              style: TextStyle(fontSize: 14, color: AppColors.textColorGray),
            ),
            SizedBox(height: 12),
            _buildTextField('Pangalan', _nameController),
            SizedBox(height: 12),
            _buildTextField(
              'Contact Number',
              _contactController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 24),

            Text(
              'WIKA / LANGUAGE',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textColorGray,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            _buildLanguageToggle(),
            SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)  => SetupBankScreen(
                      configName: _selectedConfig,
                      notifyName: _nameController.text,
                      notifyContact: _contactController.text,
                      language: _selectedLanguage,
                    ),
                  ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: AppColors.textColorWhite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Susunod',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 12),

            // note: skip setup - goes directly to HomeScreen without saving
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)  => MainNavigation()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textColorDark,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.textColorDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Skip setup',
                  style: TextStyle(fontSize: 16),
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
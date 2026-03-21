import 'package:flutter/material.dart';
import '../theme/colors.dart';
// import '../screens/setupChoice_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>{
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // dot indicator
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        double dotWidth;
        if (_currentPage == index) {
          dotWidth = 24;
        } else {
          dotWidth = 8;
        }

        Color dotColor;
        if (_currentPage == index) {
          dotColor = AppColors.primaryTeal;
        } else{
          dotColor = AppColors.lightGrey;
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: dotWidth,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );

  }
  
  // bullet points
  Widget _buildBullet(Color color, String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textColorGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ---- onboarding page 1
  Widget _buildPage1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // illustration 
          Container(
            width: 160,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Icon(
              Icons.smartphone,
              size: 80,
              color: AppColors.primaryTeal,
            ),
          ),

          SizedBox(height: 32),
        
          Text(
            'I paste, Suriin, at Malaman',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorDark,
            ),
          ),

          SizedBox(height: 16.7),

          Text(
            'Kopyahin ang kahina-hinalang TEXT at i-paste rito. Sasabihin ng SiyasatPH kung ligtas o hindi - kahit walang internet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColorGray,
            ),
          ),
        ],
      ),
    );
  }
  
  // ---- onboarding page 2
    Widget _buildPage2() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/onboarding2.png',
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 24),

            Text(
              'Sisipatin ang mga Red Flag',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorDark,
              ),
            ),

            SizedBox(height: 12),

            Text(
              'Hinahanap ng SiyasatPH ang mga palatandaan ng scam -- fake links, mataas na presyur na pananalita, at mga pekeng domain ng bangko.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textColorGray),
            ),

            SizedBox(height: 16),

            _buildBullet(AppColors.scamColor, 'Fake na link ng bangko', 'bdo.verify.com ≠ bdo.com.ph'),
            _buildBullet(AppColors.suspiciousColor, 'Mataas na Presyur na salita', '"verify now", "maso-suspend", "ngayon"'),
            _buildBullet(AppColors.safeColor, 'Paliwanag sa Filipino at English', 'Para maunawaan ng lahat'),
          ],
        ),
      );
    }


  // ---- page 3
  Widget _buildPage3() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/onboarding3.png', width: double.infinity, fit: BoxFit.contain),

          SizedBox(height: 24),

          Text(
            'Aabisuhan ang iyong pamilya',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColorDark),
          ),

          SizedBox(height: 13),

          Text(
            'Kapag may nakitang scam, awtomatikong maabisuhan ang iyong piling miyembro ng pamilya - kasama ang dahilan at timestamp.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textColorGray),
          ),

          SizedBox(height: 16),
          Image.asset('assets/images/onboarding3.1.png', width: double.infinity, fit: BoxFit.contain),
          SizedBox(height: 8),
          Image.asset('assets/images/onboarding3.2.png', width: double.infinity, fit: BoxFit.contain),
        ],
      ),
    );
  }

// ---- page 4
Widget _buildPage4() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/onboarding4.png', width: double.infinity, fit: BoxFit.contain),
        SizedBox(height: 24),
        
        Text(
          'Awtomatikong nag-aalerto',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColorDark),
        ),

        SizedBox(height: 12),

        Text(
          'Kapag may nakitang scam sa iyong SMS, mag-aabiso agad ang SiyasatPH -- kahit hindi pa nabubuksan ang app.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textColorGray),
        ),

      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // button label changes depending on current page number
    String buttonLabel;
    if (_currentPage < 3) {
      buttonLabel = 'Susunod';
    } else{
      buttonLabel = 'I-setup ang app';
    }
  
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            _buildDotIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                ],
              ),
            ),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 3) {
                          _pageController.animateToPage(_currentPage + 1, 
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,);
                        } else {
                          // ----- navigate to SetupChoiceScreen (not built yet)

                          /* Navigator.push(context,
                          MaterialPageRoute(builder: (context) => setupChoiceScreen()),
                          ); */
              
                        }
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
                        buttonLabel,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (_currentPage == 3) ...[
                    SizedBox(height: 8),
                    Text(
                      'Ilang segundo lang ang setup',
                      style: TextStyle(fontSize: 12, color: AppColors.textColorGray),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
      
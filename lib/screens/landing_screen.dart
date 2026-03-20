import 'package:flutter/material.dart';
import '../theme/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryTeal,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets2/Group 89.png',
                  height: 120,
                ),

                SizedBox(height: 24),
                Text(
                  'SiyasatPH',
                    style: TextStyle(
                    color: AppColors.textColorWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  'Suriin ang kahina-hinalang SMS. \n Protektahan ang iyong pamilya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColorWhite,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ( 

                    ) {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColorWhite,
                      foregroundColor: AppColors.textColorDark,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Magsimula',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: ( 

                    ) {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textColorWhite,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: AppColors.textColorWhite, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'May Setup na ako',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }


}
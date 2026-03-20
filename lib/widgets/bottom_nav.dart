import 'package:flutter/material.dart';
import '../theme/colors.dart';


class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar( 
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.primaryTeal,
      unselectedItemColor: AppColors.textColorGray,

      items: const [
        BottomNavigationBarItem( icon:Icon(Icons.home),
          label: 'Suriin' ),

        BottomNavigationBarItem(icon: Icon(Icons.find_in_page),
          label: 'Kasaysayan' ),

        BottomNavigationBarItem(icon: Icon(Icons.reorder),
          label: 'Setup' ),

        BottomNavigationBarItem(icon: Icon(Icons.settings),
          label: 'Settings' ),
      ]
    ); 
    
  }
}
import 'package:app/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex = 0;
  // final ValueChanged<int> onTap;

  BottomNavBar(currentIndex);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: GNav(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          activeColor: AppColors.pink,
          duration: Duration(milliseconds: 0),
          hoverColor: Colors.transparent,
          gap: 8,
          color: Colors.grey.shade600,
          onTabChange: (index) {
            setState(() {
              // currentIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
            ),
            GButton(
              icon: Icons.search,
            ),
            GButton(
              icon: Icons.add,
              iconActiveColor: Colors.white,
              backgroundColor: AppColors.pink,
            ),
            GButton(
              icon: Icons.notifications,
            ),
            GButton(
              icon: Icons.settings,
            ),
          ],
        ));
  }
}

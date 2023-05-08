import 'package:app/AppColors.dart';
import 'package:app/component/BottomNavBar.dart';
import 'package:app/services/auth/auth_service.dart';
import 'package:app/views/notes_view.dart';
import 'package:app/views/noti_view.dart';
import 'package:app/views/search_view.dart';
import 'package:app/views/verify_email_view.dart';
import 'package:app/views/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // Add your screen widgets here
    const NoteView(),
    const SearchView(),
    const NotiView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              print(user);
              if (user != null) {
                return _screens[_selectedIndex];
              } else {
                return const Welcome();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: Container(
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
                _selectedIndex = index;
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
          )),
    );
  }
}

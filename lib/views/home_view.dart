import 'package:app/AppColors.dart';
import 'package:app/component/AddTaskBottomSheet.dart';
import 'package:app/views/notes_view.dart';
import 'package:app/views/noti_view.dart';
import 'package:app/views/search_view.dart';
import 'package:app/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // bool isSidebarOpen = false;

  final List<Widget> _screens = [
    const NoteView(),
    const SearchView(),
    const SizedBox(),
    const NotiView(),
    const SettingView(),
  ];

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AddTaskBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
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
              if (index == 2) {
                // Index của tab "add"
                _showAddTaskBottomSheet(context);
              } else {
                setState(() {
                  // isSidebarOpen = false;
                  _selectedIndex = index;
                });
              }
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
                icon: Icons.menu,
              ),
            ],
          )),
    );
  }

  Drawer _buildSidebar() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Oflutter.com'),
            accountEmail: Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
        ],
      ),
    );
  }
}

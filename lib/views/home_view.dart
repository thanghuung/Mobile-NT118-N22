import 'package:app/AppColors.dart';
import 'package:app/component/AddTaskBottomSheet.dart';
import 'package:app/views/countdown/count_down_timer.dart';
import 'package:app/views/notes_view.dart';
import 'package:app/views/noti_view.dart';
import 'package:app/views/search_view.dart';
import 'package:app/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'countdown/TimeScreen.dart';

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
    const NotifierView(),
    const TimeScreen(),
    const SettingView(),
  ];

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const SingleChildScrollView(child: AddTaskBottomSheet())),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.pink,
          child: const Icon(Icons.add, color: Colors.white, size: 20),
          onPressed: () {
            _showAddTaskBottomSheet(context);
          },
        ),
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              activeColor: AppColors.pink,
              duration: const Duration(milliseconds: 0),
              hoverColor: Colors.transparent,
              gap: 8,
              color: Colors.grey.shade600,
              onTabChange: (index) {
                setState(() {
                  // isSidebarOpen = false;
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
                  icon: Icons.notifications,
                ),
                GButton(
                  icon: Icons.lock_clock,
                ),
                GButton(
                  icon: Icons.person_outline_sharp,
                ),

              ],
            )),
      ),
    );
  }

}

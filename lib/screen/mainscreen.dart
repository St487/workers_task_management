import 'package:flutter/material.dart';
import 'package:worker_task_management/screen/historyscreen.dart';
import 'package:worker_task_management/screen/profile.dart';
import 'package:worker_task_management/model/user.dart';
import 'package:worker_task_management/screen/tasklist.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String maintitle = "Tasks";
  int _currentIndex = 0;
  late List<Widget> tabchildren;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabchildren = [
      TaskListScreen(
        user: widget.user,
      ),
      HistoryScreen(
        user: widget.user
        ),
      ProfileScreen(
        user: widget.user,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue.shade200,
        selectedItemColor: Colors.white,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.task,
                size: MediaQuery.of(context).size.width * 0.07,
              ),
              label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history, 
                size: MediaQuery.of(context).size.width * 0.07
              ),
              label: "History"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person, 
                size: MediaQuery.of(context).size.width * 0.07
              ), 
              label: "Profile")
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Tasks";
      }
      if (_currentIndex == 1) {
        maintitle = "History";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
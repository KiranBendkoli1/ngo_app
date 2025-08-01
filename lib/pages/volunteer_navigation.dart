import 'package:flutter/material.dart';
import 'package:ngo_app_v2/pages/volunteer_category.dart';
import 'package:ngo_app_v2/pages/volunteer_profile.dart';
import 'package:ngo_app_v2/pages/volunteer_home.dart';

class VolunteerNavigation extends StatefulWidget {
  const VolunteerNavigation({super.key});
  @override
  State<VolunteerNavigation> createState() => _VolunteerNavigationState();
}

class _VolunteerNavigationState extends State<VolunteerNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = <Widget>[
      VolunteerHome(),
      VolunteerCategory(),
      VolunteerProfile()
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Color(0xFF0B5D0B),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Rewards",
            backgroundColor: Color(0xFF0B5D0B),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Color(0xFF0B5D0B),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

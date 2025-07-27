import 'package:flutter/material.dart';
import 'package:ngo_app_v2/screens/add_post_screen.dart';
import 'package:ngo_app_v2/screens/feed_screen.dart';

class ContentNavigation extends StatefulWidget {
  const ContentNavigation({super.key});

  @override
  State<ContentNavigation> createState() => _ContentNavigationState();
}

class _ContentNavigationState extends State<ContentNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = <Widget>[FeedScreen(), AddPostScreen()];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Feed",
            backgroundColor: Color(0xFF0B5D0B),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Add Post",
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

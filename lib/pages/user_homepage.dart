import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:ngo_app_v2/components/action_cards.dart';
import 'package:ngo_app_v2/pages/content_navigation.dart';
import 'package:ngo_app_v2/utils/authentication.dart';
import 'package:ngo_app_v2/pages/landing_page.dart';
import 'package:ngo_app_v2/pages/volunteer_navigation.dart';
import 'package:ngo_app_v2/pages/user_donation.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'NGO Nexus',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF024E04),
                    Color(0xFF0B5D0B),
                  ]),
            ),
          ),
          elevation: 0,
          toolbarHeight: screenHeight / 12,
          actions: [
            IconButton(
              icon: Icon(Icons.logout_outlined),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll<Color>(Color(0xFF0B4A0E)),
                iconColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              onPressed: () {
                AuthenticationHelper().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LandingPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ActionCardsPage()
        ));
  }
}

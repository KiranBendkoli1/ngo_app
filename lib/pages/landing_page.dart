// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ngo_app_v2/pages/login_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ngo_app_v2/pages/signup_screen.dart';
import 'package:ngo_app_v2/pages/user_homepage.dart';
import 'package:ngo_app_v2/pages/volunteer_navigation.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _position;
  @override
  void initState() {
    getGeoPermission();
  }

  void getGeoPermission() async {
    final Geolocator geolocator = Geolocator();
    LocationPermission permission = LocationPermission.denied;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _position = position;
      });
      return position;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: screenHeight / 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "NGO Nexus",
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Even the smallest contributions count",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  color: Color(0xff0b5d0b),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(16),
                  textColor: Color(0xffffffff),
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                  color: Color(0xff0b5d0b),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.all(16),
                  textColor: Color(0xffffffff),
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

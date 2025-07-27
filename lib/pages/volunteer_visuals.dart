// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VolunteerVisuals extends StatefulWidget {
  const VolunteerVisuals({super.key});

  @override
  State<VolunteerVisuals> createState() => _VolunteerVisualsState();
}

class _VolunteerVisualsState extends State<VolunteerVisuals> {
  var data,
      email,
      year2018,
      tc18,
      year2019,
      tc19,
      year2020,
      tc20,
      year2021,
      tc21,
      year2022,
      tc22;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getVolunteersData() {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore
        .collection("volunteer contribution")
        .doc(auth.currentUser?.email);
    docRef.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      year2018 = data['year'];
      tc18 = data['total cotributions'];

      setState(() {});
    });

    final docRef1 = firestore
        .collection("volunteer contribution 2019")
        .doc(auth.currentUser?.email);
    docRef1.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      year2019 = data['year'];
      tc19 = data['total cotributions'];

      setState(() {});
    });

    final docRef2 = firestore
        .collection("volunteer contribution 2020")
        .doc(auth.currentUser?.email);
    docRef2.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      year2020 = data['year'];
      tc20 = data['total cotributions'];

      setState(() {});
    });

    final docRef3 = firestore
        .collection("volunteer contribution 2021")
        .doc(auth.currentUser?.email);
    docRef3.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      year2021 = data['year'];
      tc21 = data['total cotributions'];

      setState(() {});
    });

    final docRef4 = firestore
        .collection("volunteer contribution 2022")
        .doc(auth.currentUser?.email);
    docRef4.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      year2022 = data['year'];
      tc22 = data['total cotributions'];

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visuals'),
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
        leading: Icon(
          Icons.arrow_back,
          size: 24,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getVolunteersData();
              },
              child: Text('Get Volunteer Data'),
            ),
            SizedBox(height: 20),
            if (year2018 != null && tc18 != null)
              Text('Year: $year2018, Total Contributions: $tc18'),
            if (year2019 != null && tc19 != null)
              Text('Year: $year2019, Total Contributions: $tc19'),
            if (year2020 != null && tc20 != null)
              Text('Year: $year2020, Total Contributions: $tc20'),
            if (year2021 != null && tc21 != null)
              Text('Year: $year2021, Total Contributions: $tc21'),
            if (year2022 != null && tc22 != null)
              Text('Year: $year2022, Total Contributions: $tc22'),
          ],
        ),
      ),
    );
  }
}

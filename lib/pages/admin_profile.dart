// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app_v2/pages/admin_rewardsmanagement.dart';
import 'package:ngo_app_v2/pages/update_schedule.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  var data, imageUrl, name, email, address;

  @override
  void initState() {
    // TODO: implement initState
    getAdminData();
    super.initState();
  }

  void getAdminData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef =
        firestore.collection("roles").doc("cA8bqfYEGTRojL5l00oQOvGHCcF3");
    docRef.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      imageUrl = data['imageUrl'];
      name = data['name'];
      email = data['email'];
      address = data['address'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Admin"),
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
      ),
      body: SingleChildScrollView(
        child: imageUrl == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            // ignore: prefer_const_literals_to_create_immutables
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3.0,
                                  offset: Offset(0, 4.0),
                                  color: Colors.black38),
                            ],
                            image: DecorationImage(
                              image: NetworkImage("$imageUrl"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "$name",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "$email",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            //SmallButton(btnText: "Edit"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      elevation: 3.0,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("$address"),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text("Age"),
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Schedule Training",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateSchedule()));
                                  },
                                  child: Text("Schedule",
                                      style: TextStyle(fontSize: 16.0)),
                                ),

                                // SizedBox(height: 10.0,),
                              ]),
                        ),
                      ),
                    ),
                    Text(
                      "Rewards Management",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManagementRewards()));
                                  },
                                  child: Text("Rewards",
                                      style: TextStyle(fontSize: 16.0)),
                                ),

                                // SizedBox(height: 10.0,),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

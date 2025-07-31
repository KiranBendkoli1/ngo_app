import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngo_app_v2/pages/admin_homepage.dart';

class ManagementRewards extends StatefulWidget {
  const ManagementRewards({super.key});

  @override
  State<ManagementRewards> createState() => _ManagementRewardsState();
}

class _ManagementRewardsState extends State<ManagementRewards> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var projectId;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
    setState(() {
      projectId = querySnapshot.docs.length;
    });
    print(projectId);
  }

  XFile? file;
  String email = '';
  int rewards = 0, rank = 0;

  TextEditingController emailController = TextEditingController();
  TextEditingController rewardsController = TextEditingController();
  TextEditingController rankController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      hintText: "Volunteer Email",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff9f9d9d),
                      ),
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                TextField(
                  controller: rewardsController,
                  minLines: 4,
                  maxLines: 20,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Color(0x00ffffff), width: 1),
                    ),
                    hintText: "Volunteer Rewards",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff9f9d9d),
                    ),
                    filled: true,
                    fillColor: Color(0xfff2f2f3),
                    isDense: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: TextField(
                    controller: rankController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Color(0x00ffffff), width: 1),
                      ),
                      hintText: "Volunteer Rank",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff9f9d9d),
                      ),
                      filled: true,
                      fillColor: Color(0xfff2f2f3),
                      isDense: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 16),
                  child: MaterialButton(
                    onPressed: () {
                      saveProjectData(context);
                    },
                    color: Color(0xff0a490d),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    textColor: Color(0xffffffff),
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveProjectData(BuildContext context) async {
    email = emailController.text;
    rewards = int.parse(rewardsController.text);
    rank = int.parse(rankController.text);

    setState(() {});
    try {
      await _firestore.collection('volunteers').doc(email).update({
        'rewards': rewards,
        'rank': rank,
      }).then((value) {
        Fluttertoast.showToast(
          msg: "Rewards and Rank added successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueGrey,
          fontSize: 12,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomePage(),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

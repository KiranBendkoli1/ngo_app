import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngo_app_v2/components/add_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngo_app_v2/model/project_model.dart';
import 'package:ngo_app_v2/pages/admin_project_info.dart';
import 'package:ngo_app_v2/pages/login_screen.dart';
import 'package:ngo_app_v2/pages/volunteer_info.dart';
import 'package:ngo_app_v2/pages/volunteer_registrationform.dart';
import 'package:ngo_app_v2/utils/authentication.dart';
import 'package:ngo_app_v2/pages/admin_projects.dart';
import 'package:ngo_app_v2/pages/payment_home.dart';
import 'package:ngo_app_v2/pages/transaction_details.dart';
import 'package:ngo_app_v2/pages/admin_volunteers.dart';
import 'package:ngo_app_v2/pages/admin_profile.dart';

class VolunteerSearch extends StatefulWidget {
  const VolunteerSearch({super.key});

  @override
  State<VolunteerSearch> createState() => _VolunteerSearchState();
}

class _VolunteerSearchState extends State<VolunteerSearch> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  var allProjects;
  String projectName = "";
  String projectLocation = "";
  var assignedProjectId;
  int difference = 0;
  @override
  void initState() {
    super.initState();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: const Text("Search Projects"),
          flexibleSpace: Container(
            // ignore: prefer_const_constructors
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
          leading: IconButton(
            onPressed: () {
              AuthenticationHelper().signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            icon: Icon(Icons.clear_all_rounded),
          )),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
            child: TextField(
              onChanged: ((value) {
                setState(() {
                  projectName = value;
                  searchController.text = value;
                });
              }),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                hintText: "Search by Category",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff9f9d9d),
                ),
                filled: true,
                fillColor: Color(0xfff2f2f3),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  color: Colors.grey,
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: TextField(
              onChanged: ((value) {
                setState(() {
                  projectLocation = value;
                  searchController.text = value;
                });
              }),
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Color(0x00ffffff), width: 1),
                ),
                hintText: "Search by Location",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff9f9d9d),
                ),
                filled: true,
                fillColor: Color(0xfff2f2f3),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  color: Colors.grey,
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15),
            child: Text("View Projects here"),
          ),
          // all project section
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
            child: SizedBox(
              height: screenHeight / 4,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('projects').snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              if (projectName.isEmpty &&
                                  projectLocation.isEmpty) {
                                ProjectModel currentProject = ProjectModel(
                                    projectId: data['projectId'],
                                    projectTitle: data['projectTitle'],
                                    projectDescription:
                                        data['projectDescription'],
                                    projectAddress: data['projectAddress'],
                                    imageUrl: data['imageUrl'],
                                    projectFunds: data['projectFunds'],
                                    projectTeamLeader:
                                        data['projectTeamLeader'],
                                    projectCategory: data['projectCategory'],
                                    startDate: data['startDate'],
                                    endDate: data['endDate']);
                                return (data['imageUrl'] == null)
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : TextButton(
                                        style: ButtonStyle(
                                          padding: WidgetStatePropertyAll(
                                              EdgeInsets.all(0)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminProjectInfo(
                                                          projectModel:
                                                              currentProject)));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          elevation: 5,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: Column(
                                            children: [
                                              data['imageUrl'] == null
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : Image.network(
                                                      data['imageUrl'],
                                                      height:
                                                          screenHeight / 6.5,
                                                      colorBlendMode:
                                                          BlendMode.colorBurn,
                                                    ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white),
                                                child:
                                                    Text(data['projectTitle']),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () async {
                                                    assignedProjectId =
                                                        data['projectId'];
                                                    await _firestore
                                                        .collection(
                                                            "volunteers")
                                                        .doc(currentUser!.email
                                                            .toString())
                                                        .update({
                                                      'assignedProject':
                                                          assignedProjectId
                                                    }).then(
                                                      (value) => Fluttertoast
                                                          .showToast(
                                                        msg:
                                                            "Project is Assigned $assignedProjectId",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        backgroundColor:
                                                            Colors.blueGrey,
                                                        fontSize: 12,
                                                      ),
                                                    );
                                                  },
                                                  child: Text("Volunteer"))
                                            ],
                                          ),
                                        ),
                                      );
                              }
                              if (data['projectCategory']
                                      .toString()
                                      .startsWith(projectName) &&
                                  data['projectAddress']
                                      .toString()
                                      .startsWith(projectLocation)) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Column(
                                    children: [
                                      data['imageUrl'] == null
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : Image.network(
                                              data['imageUrl'],
                                              height: screenHeight / 6,
                                              colorBlendMode:
                                                  BlendMode.colorBurn,
                                            ),
                                      Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: Text(data['projectTitle']),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                  }),
            ),
          ),

          // scheduled in this week
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15),
            child: Text("Future events of this month"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
            child: SingleChildScrollView(
              child: SizedBox(
                height: screenHeight / 2.35,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection("projects").snapshots(),
                    builder: (context, snapshot) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            print(data['startDate'].split('-')[0]);
                            if (daysBetween(
                                    DateTime.now(),
                                    DateTime(
                                      int.parse(
                                          data['startDate'].split('-')[2]),
                                      int.parse(
                                          data['startDate'].split('-')[1]),
                                      int.parse(
                                          data['startDate'].split('-')[0]),
                                    )) <
                                30) {
                              print(daysBetween(
                                  DateTime.now(),
                                  DateTime(
                                    int.parse(data['startDate'].split('-')[2]),
                                    int.parse(data['startDate'].split('-')[1]),
                                    int.parse(data['startDate'].split('-')[0]),
                                  )));
                              return (data['imageUrl'] == null)
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Row(
                                        children: [
                                          data['imageUrl'] == null
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Image.network(
                                                  data['imageUrl'],
                                                  height: screenHeight / 12,
                                                  colorBlendMode:
                                                      BlendMode.colorBurn,
                                                ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white),
                                            child: Text(data['projectTitle']),
                                          )
                                        ],
                                      ),
                                    );
                            } else {
                              return Container();
                            }
                          });
                    }),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VolunteerRegs()));
        },
        backgroundColor: Color(0xFF0B5D0B),
        child: Icon(Icons.app_registration),
      ),
    );
  }
}

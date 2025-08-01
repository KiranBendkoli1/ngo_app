import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngo_app_v2/models/project_model.dart';
import 'package:ngo_app_v2/pages/admin_project_info.dart';
import 'package:ngo_app_v2/pages/volunteer_registrationform.dart';
import 'dart:async';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  State<VolunteerHome> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  Timer? _debounce;
  String searchQuery = "";

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Volunteer",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF024E04), Color(0xFF0B5D0B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50, // approx. orange-50
              Colors.cyan.shade50, // approx. red-50
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              const Text("Explore Projects",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildProjectCards(screenHeight),
              const SizedBox(height: 20),
              const Text("Upcoming Events This Month",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildUpcomingEvents(screenHeight),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VolunteerRegs()));
        },
        splashColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0B5D0B),
        label: const Text("Register"),
        icon: const Icon(Icons.app_registration),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          setState(() => searchQuery = value.trim().toLowerCase());
        });
      },
      decoration: InputDecoration(
        hintText: "Search by Category or Location",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => setState(() => searchQuery = ""),
        ),
        filled: true,
        fillColor: const Color(0xfff2f2f3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProjectCards(double screenHeight) {
    return SizedBox(
      height: screenHeight / 2.8,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('projects').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredProjects = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return searchQuery.isEmpty ||
                data['projectCategory']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery) ||
                data['projectAddress']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery);
          }).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredProjects.length,
            itemBuilder: (context, index) {
              final data =
                  filteredProjects[index].data() as Map<String, dynamic>;

              final project = ProjectModel(
                projectId: data['projectId'],
                projectTitle: data['projectTitle'],
                projectDescription: data['projectDescription'],
                projectAddress: data['projectAddress'],
                imageUrl: data['imageUrl'],
                projectFunds: data['projectFunds'],
                projectTeamLeader: data['projectTeamLeader'],
                projectCategory: data['projectCategory'],
                startDate: data['startDate'],
                endDate: data['endDate'],
              );

              return Container(
                width: 230,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdminProjectInfo(projectModel: project),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              project.imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            project.projectTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Category: ${project.projectCategory}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final assignedProjectId = project.projectId;
                                await _firestore
                                    .collection("volunteers")
                                    .doc(currentUser!.email)
                                    .update({
                                  'assignedProject': assignedProjectId
                                }).then((_) {
                                  Fluttertoast.showToast(
                                    msg: "Project Assigned: $assignedProjectId",
                                    backgroundColor: Colors.green,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(36),
                                backgroundColor: const Color(0xFF0B5D0B),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Volunteer"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEvents(double screenHeight) {
    return SizedBox(
      height: screenHeight / 2.3,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("projects").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final upcomingProjects = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final startDate = DateTime(
              int.parse(data['startDate'].split('-')[2]),
              int.parse(data['startDate'].split('-')[1]),
              int.parse(data['startDate'].split('-')[0]),
            );
            return daysBetween(DateTime.now(), startDate) < 30;
          }).toList();

          return ListView.separated(
            itemCount: upcomingProjects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data =
                  upcomingProjects[index].data() as Map<String, dynamic>;

              return Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['imageUrl'],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['projectTitle'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Starts on: ${data['startDate']}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

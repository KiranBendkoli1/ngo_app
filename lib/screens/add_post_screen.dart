import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ngo_app_v2/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  final Uint8List file;
  final Function(String uid, String name, String profImage) postImage;
  final VoidCallback clearImage;

  const AddPostScreen({
    super.key,
    required this.file,
    required this.postImage,
    required this.clearImage,
  });
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? data;
  @override
  void initState() {
    super.initState();
    DocumentReference<Map<String, dynamic>> documentRef = FirebaseFirestore
        .instance
        .collection('volunteers')
        .doc(currentUser!.email);

    documentRef.get().then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        // Document data exists
        data = snapshot.data();
      } else {
        // Document data does not exist
        print('Document does not exist.');
      }
    }).catchError((error) {
      // Error handling
      print('Error retrieving document: $error');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('volunteers')
          .doc(currentUser!.email)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Volunteer data not found')),
          );
        }

        final data = snapshot.data!.data()!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            automaticallyImplyLeading: false,
            title: const Text(
              'Post to',
              style: TextStyle(color: Color(0xffffffff)),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => widget.postImage(
                  currentUser!.uid,
                  data['name'],
                  data['imageUrl'],
                ),
                child: const Text(
                  "Post",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0FDF4), // from-green-50
                  Color(0xFFECFDF5), // to-emerald-50
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['imageUrl']),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(widget.file),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

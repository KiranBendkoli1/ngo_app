import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:ngo_app_v2/screens/add_post_screen.dart';
import 'package:ngo_app_v2/screens/feed_screen.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngo_app_v2/resources/firestore_methods.dart';
import 'package:ngo_app_v2/utils/utils.dart';

class ContentNavigation extends StatefulWidget {
  const ContentNavigation({super.key});

  @override
  State<ContentNavigation> createState() => _ContentNavigationState();
}

class _ContentNavigationState extends State<ContentNavigation> {
  Uint8List? file;

  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  firebase_auth.User? currentUser =
      firebase_auth.FirebaseAuth.instance.currentUser;
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
      }
    }).catchError((error) {});
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    this.file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    this.file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String name, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        file!,
        uid,
        name,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                "Inspire",
                style: TextStyle(color: Color(0xffffffff)),
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
            ),
            body: FeedScreen(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _selectImage(context),
              backgroundColor: Colors.green,
              tooltip: 'Create a Post',
              child: const Icon(Icons.add_comment, color: Colors.white),
            ),
          )
        : AddPostScreen(
            key: UniqueKey(),
            file: file!,
            postImage: postImage,
            clearImage: clearImage,
          );
  }
}

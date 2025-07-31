import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngo_app_v2/models/user_model.dart';
import 'package:ngo_app_v2/pages/admin_homepage.dart';
import 'package:ngo_app_v2/pages/user_homepage.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  get user => _auth.currentUser;

  final bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  String? _uid;
  String get uid => _uid!;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  // Sign Up Method
  Future signUp(
      {required String email,
      required String password,
      required String phoneNumber,
      required String name}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final data = {
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "date": Timestamp.now(),
        "uid": _auth.currentUser!.uid,
      };
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set(data)
          .then((value) {
        Fluttertoast.showToast(
          msg: "Sign Up Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blueGrey,
          fontSize: 12,
        );
      });

      return null;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        fontSize: 12,
      );
      return e.message;
    }
  }

  // Sign In Method
  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Fluttertoast.showToast(
        msg: "Sign In Successful",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        fontSize: 12,
      );

      final docRef = _firestore.collection("roles").doc(_auth.currentUser!.uid);
      final DocumentSnapshot doc = await docRef.get();

      if (!doc.exists) {
        throw Exception("Role document does not exist.");
      }

      final data = doc.data() as Map<String, dynamic>;

      // Navigate based on role
      if (data['admin'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? "Authentication failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
        fontSize: 12,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        fontSize: 12,
      );
    }
  }

  // Sign Out Method
  Future signOut() async {
    String? email = _auth.currentUser!.email;
    await _auth.signOut();
    Fluttertoast.showToast(
      msg: "$email Signed Out",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blueGrey,
      fontSize: 12,
    );
  }

  Future resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then(
            (value) => Fluttertoast.showToast(
              msg: "Password reset link is sent on $email",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.blueGrey,
              fontSize: 12,
            ),
          );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueGrey,
        fontSize: 12,
      );
    }
  }
}

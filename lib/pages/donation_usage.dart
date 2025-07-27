import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationUsage {
  bool food;
  bool clothes;
  bool toys;
  bool books;
  bool other;

  DonationUsage({
    this.food = false,
    this.clothes = false,
    this.toys = false,
    this.books = false,
    this.other = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'food': food,
      'clothes': clothes,
      'toys': toys,
      'books': books,
      'other': other,
    };
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  File? _image;
  bool _food = false;
  bool _clothes = false;
  bool _toys = false;
  bool _books = false;
  bool _other = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image?.path != null) {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('donation_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      await ref.putFile(_image!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final downloadUrl = await _uploadImage();
      final usage = DonationUsage(
        food: _food,
        clothes: _clothes,
        toys: _toys,
        books: _books,
        other: _other,
      );

      await FirebaseFirestore.instance.collection('donation_usage').add({
        'usage': usage.toMap(),
        'image_url': downloadUrl,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Donation usage saved!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 200.0,
                  child: _image != null
                      ? Image.file(_image!, fit: BoxFit.cover)
                      : Center(
                          child: Icon(Icons.add_photo_alternate),
                        ),
                ),
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Food'),
                value: _food,
                onChanged: (value) {
                  setState(() {
                    _food = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Clothes'),
                value: _clothes,
                onChanged: (value) {
                  setState(() {
                    _clothes = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Toys'),
                value: _toys,
                onChanged: (value) {
                  setState(() {
                    _toys = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Books'),
                value: _books,
                onChanged: (value) {
                  setState(() {
                    _books = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Other'),
                value: _other,
                onChanged: (value) {
                  setState(() {
                    _other = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

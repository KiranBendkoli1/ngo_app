import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PickupScheduleForm extends StatefulWidget {
  const PickupScheduleForm({super.key});

  @override
  _PickupScheduleFormState createState() => _PickupScheduleFormState();
}

class _PickupScheduleFormState extends State<PickupScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pickupDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String? _item;
  final _items = [
    'Clothes',
    'Books',
    'Furniture',
    'Electronics',
    'Toys',
    'Other'
  ];
  final firestoreReference = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    user = _auth.currentUser!;
  }

  void _submitForm() async {
    // Validate the form data
    if (_formKey.currentState!.validate()) {
      // Save the form data
      _formKey.currentState?.save();

      final String name = _nameController.text;
      final String email = _emailController.text;
      final String phone = _phoneController.text;
      final String pickupDate = _pickupDateController.text;
      final String address = _addressController.text;
      final String city = _cityController.text;
      final String state = _stateController.text;
      final String zip = _zipController.text;

      try {
        // Get a reference to the Firestore collection
        final formref = FirebaseFirestore.instance.collection('pickups').doc();

        await formref.set({
          'name': name,
          'email': email,
          'phone': phone,
          'pickupDate': pickupDate,
          'address': address,
          'city': city,
          'state': state,
          'zip': zip,
          'item': _item,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Form data saved!'),
        ));

        // Show a success message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                  'Thank you for your donation. We will contact you soon.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Handle any errors that occur during the save operation
        print('Error saving data: $e');
      }
    }
  }

  void _sendEmailNotification(String email, String name) {
    final subject = "Successful pickup scheduled";
    final body = "Hi $name, your pickup has been scheduled successfully!";
  }

  /*void _sendSMSNotification(String phone) async {
    String message = "Your pickup has been scheduled successfully!";
    List<String> recipients = [phone];
    await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      print(onError);
    });
  }
  */

  void _showSuccessfulPickupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pickup in progress'),
          content: Text('We will contact you. Thank you for your donation.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false ,
        centerTitle: true,
        title: Text('Schedule a Pickup', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pickupDateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'Pickup Date (MM/DD/YYYY)',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Pickup date is required';
                  } else {
                    try {
                      var pickupDate =
                          DateFormat('MM/dd/yyyy').parseStrict(value);
                      if (pickupDate.isBefore(DateTime.now())) {
                        return 'Pickup date must be in the future';
                      }
                    } catch (e) {
                      return 'Please enter a valid pickup date (MM/DD/YYYY)';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ZIP Code',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'ZIP code is required';
                  } else if (value.length != 6) {
                    return 'ZIP code must be 6 digits';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _item,
                items: _items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _item = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select item',
                ),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Schedule Pickup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

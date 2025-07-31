import 'package:flutter/material.dart';
import 'package:ngo_app_v2/components/get_geotagged_image.dart';

class GeoTaggedButton extends StatelessWidget {
  const GeoTaggedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("Get Geo Tagged Photo"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GetGeoTaggedImage()));
        },
      )),
    );
  }
}

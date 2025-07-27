import 'package:flutter/material.dart';
import 'package:ngo_app_v2/pages/transaction_details.dart';
import 'package:ngo_app_v2/pages/view_donations.dart';

class Transactionalactivity extends StatelessWidget {
  const Transactionalactivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactional Activity'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(

            child: Center(
              child: GestureDetector(
                onTap: () {
                Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => PaymentDetailsPage(apiKey: 'rzp_test_1SzcPrcZbeMtiS', apiSecret: 'NTzmUZAjCwWcy0RS6s94Jxd6')),
                  );
                },
              child: Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue.shade800,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money,
                    size: 80.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Financial Transfer',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
          ),

          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationList()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.green.shade900,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 80.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Charitable Giving',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

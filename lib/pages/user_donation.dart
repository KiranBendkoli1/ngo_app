import 'package:flutter/material.dart';
import 'package:ngo_app_v2/components/donation_options_card.dart';
import 'package:ngo_app_v2/pages/otherthings_donation.dart';
import 'package:ngo_app_v2/pages/payment_home.dart';

class UserDonation extends StatefulWidget {
  const UserDonation({super.key});

  @override
  State<UserDonation> createState() => _UserDonationState();
}

class _UserDonationState extends State<UserDonation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0b3005),
        title: const Text(
          "Donate",
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
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF7ED), // approx. orange-50
              Color(0xFFFFEBEE), // approx. red-50
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_outline,
                  size: 32,
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Colors.deepOrange),
                  iconColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Make a Difference",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your generosity helps us continue our mission to serve the community",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              /// 💸 Donate Money Card
              DonationOptionCard(
                key: const Key("donate_money_card"),
                textColor: Colors.green,
                icon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.credit_card_rounded,
                    size: 32,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.green),
                    iconColor: WidgetStatePropertyAll<Color>(Colors.white),
                  ),
                ),
                title: "Donate Money",
                description:
                    "Make a monetary contribution to support our programs and operations",
                borderColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              /// 📦 Other Donations Card
              DonationOptionCard(
                key: const Key("other_donations_card"),
                icon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.wallet_giftcard_outlined,
                    size: 32,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                    iconColor: WidgetStatePropertyAll<Color>(Colors.white),
                  ),
                ),
                textColor: Colors.blue,
                title: "Other Donations",
                description:
                    "Donate clothes, food, books, or other essential items",
                borderColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PickupScheduleForm()),
                  );
                },
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

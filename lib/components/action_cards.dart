import 'package:flutter/material.dart';
import 'package:ngo_app_v2/pages/content_navigation.dart';
import 'package:ngo_app_v2/pages/user_donation.dart';
import 'package:ngo_app_v2/pages/volunteer_navigation.dart';

class ActionCardsPage extends StatelessWidget {
  const ActionCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ActionCard(
            title: "Donate",
            description:
                "Support our cause through monetary donations or contribute essential items",
            icon: IconButton(
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
            gradient:
                LinearGradient(colors: [Colors.orange.shade50, Colors.white]),
            textColor: Colors.deepOrange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDonation()),
              );
            },
          ),
          SizedBox(height: 20),
          ActionCard(
            title: "Volunteer",
            description:
                "Join our projects and make a direct impact in your community",
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.groups_2_outlined,
                size: 32,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                iconColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
            ),
            gradient:
                LinearGradient(colors: [Colors.blue.shade50, Colors.white]),
            textColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VolunteerNavigation()),
              );
            },
          ),
          SizedBox(height: 20),
          ActionCard(
            title: "Posts",
            description:
                "Stay updated with our latest activities and share your experiences",
            icon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble_outline,
                size: 32,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
                iconColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
            ),
            gradient:
                LinearGradient(colors: [Colors.green.shade50, Colors.white]),
            textColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ContentNavigation()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconButton icon;
  final Gradient gradient;
  final Color textColor;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              icon,
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
              SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

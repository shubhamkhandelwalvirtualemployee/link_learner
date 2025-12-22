import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: ColorConstants.whiteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _helpTile(
            title: "How to book a session?",
            description:
                "Go to Instructor list, select a teacher and choose a slot.",
          ),
          _helpTile(
            title: "Payment issues",
            description: "If payment fails, retry from Booking Details screen.",
          ),
          _helpTile(
            title: "Contact Support",
            description: "Email us at support@linklearner.com",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _helpTile({required String title, required String description}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
      ),
    );
  }
}

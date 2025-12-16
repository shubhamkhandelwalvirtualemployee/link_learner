import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
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
            description:
            "If payment fails, retry from Booking Details screen.",
          ),
          _helpTile(
            title: "Contact Support",
            description: "Email us at support@linklearner.com",
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Contact Support"),
          )
        ],
      ),
    );
  }

  Widget _helpTile({
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BookLessonScreen extends StatefulWidget {
  const BookLessonScreen({Key? key}) : super(key: key);

  @override
  State<BookLessonScreen> createState() => _BookLessonScreenState();
}

class _BookLessonScreenState extends State<BookLessonScreen> {
  int selectedPackage = 0;

  final List<Map<String, dynamic>> packages = [
    {
      "title": "Beginner Package - 10 Lessons",
      "desc":
      "Perfect for complete beginners. Covers all the basics from car controls to basic maneuvers.",
      "lessons": 10,
      "duration": "60 min",
      "pricePerLesson": "€41.00",
      "validity": "90 days",
      "total": "€369.00",
      "discount": "10% OFF",
    },
    {
      "title": "Standard Package - 15 Lessons",
      "desc":
      "Comprehensive package for learner drivers. Prepares you thoroughly for your driving test.",
      "lessons": 15,
      "duration": "60 min",
      "pricePerLesson": "€41.00",
      "validity": "120 days",
      "total": "€541.00",
      "discount": "12.03% OFF",
    },
    {
      "title": "Intensive Package - 20 Lessons",
      "desc":
      "Intensive course for faster learners or those with test date approaching.",
      "lessons": 20,
      "duration": "60 min",
      "pricePerLesson": "€41.00",
      "validity": "120 days",
      "total": "€697.00",
      "discount": "15% OFF",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Lesson"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructorCard(),
            const SizedBox(height: 20),
            const Text(
              "Packages",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPackageGrid(),
            _buildPaymentMethod(),
            const SizedBox(height: 10),
            _buildBookingSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Itunuoluwa Abidoye",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Therapist",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.black54),
                    SizedBox(width: 4),
                    Text("0 (0 reviews)",
                        style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8)),
            child: const Text("\$170/session",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 1.6, mainAxisSpacing: 16),
      itemBuilder: (context, index) {
        final package = packages[index];
        final isSelected = selectedPackage == index;

        return GestureDetector(
          onTap: () => setState(() => selectedPackage = index),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey.shade300,
                  width: isSelected ? 2 : 1),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(package["title"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(package["discount"],
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(package["desc"],
                    style: const TextStyle(color: Colors.black54, fontSize: 13)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoBox("Lessons", package["lessons"].toString()),
                    _infoBox("Duration", package["duration"]),
                    _infoBox("Price / lesson", package["pricePerLesson"]),
                    _infoBox("Validity", package["validity"]),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: ${package["total"]}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text("Book package",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _sectionBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoBox("5 Sessions", "3 of 5 remaining"),
              _infoBox("Pay per session", "%70 per session"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _sectionBox(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Booking Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _summaryRow("Date", "Not Selected"),
          _summaryRow("Time", "Not Selected"),
          _summaryRow("Duration", "Not Selected"),
          _summaryRow("Payment", "Not Selected"),
        ],
      ),
    );
  }

  BoxDecoration _sectionBox() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
          color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2))
    ],
  );
}

class _summaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _summaryRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black54)),
          Text(value, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

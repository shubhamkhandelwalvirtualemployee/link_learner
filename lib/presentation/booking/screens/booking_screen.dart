import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/presentation/booking_and_search/widgets/search_bottom_sheet.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override

  final List<Map<String, dynamic>> bookings = [
    {
      'title': 'Product Design v1.0',
      'person': 'Robertson Connie',
      'price': 190,
      'hours': 16,
    },
    {
      'title': 'Java Development',
      'person': 'Nguyen Shane',
      'price': 190,
      'hours': 16,
    },
    {
      'title': 'Visual Design',
      'person': 'Bert Pullman',
      'price': 250,
      'hours': 14,
    },
  ];

  final List<String> filterChips = ['All Bookings', 'Upcoming', 'Completed','Cancelled'];

  int selectedIndex = 0; // 0 = All Booking

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),

          /// ✅ FILTER CHIPS (SCROLLABLE & EXACT UI)
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 20),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filterChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD7263D) // red pill
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      filterChips[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// ✅ BOOKING LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _bookingCard("upcoming"),
                const SizedBox(height: 20),
                _bookingCard("completed"),
                const SizedBox(height: 20),
                _bookingCard("cancelled"),
              ],
            ),
          ),
        ],
      ),
    );
  }


  /// ✅ TOP TABS (Active, Completed, Cancelled)
  Widget _tabButton(String text, bool selected) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  /// ✅ BOOKING CARD UI
  Widget _bookingCard(String status) {
    Color chipColor;
    Color chipTextColor;

    if (status == "upcoming") {
      chipColor = const Color(0xFFDEE8FF);
      chipTextColor = const Color(0xFF4A73FF);
    } else if (status == "completed") {
      chipColor = const Color(0xFFE0FFE4);
      chipTextColor = const Color(0xFF00A84A);
    } else {
      chipColor = const Color(0xFFFFE4E4);
      chipTextColor = const Color(0xFFDD3A3A);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ✅ IMAGE PLACEHOLDER
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 16),

          /// ✅ TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    const Text(
                      "John Smith",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    /// ✅ STATUS CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: chipTextColor,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Sunday 19 October 2025",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: const [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "14:00 (60 minutes)",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: const [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Dublin City Center",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _button("Reschedule", false),
                    const SizedBox(width: 10),
                    _button("Cancel", true),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// ✅ Buttons
  Widget _button(String text, bool danger) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: danger ? Colors.red : Colors.grey.shade400,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: danger ? Colors.red : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

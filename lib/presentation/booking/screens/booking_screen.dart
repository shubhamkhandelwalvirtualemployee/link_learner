import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking/model/booking_list_response.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  final List<String> filterChips = [
    'All Bookings',
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'REJECTED'
  ];

  final List<String> filterApiValues = [
    "",            // All Bookings → empty status
    "PENDING",
    "CONFIRMED",
    "CANCELLED",
    "COMPLETED",
    "REJECTED",
  ];


  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Fetch ALL bookings initially
    Future.microtask(() {
      Provider.of<BookingProvider>(context, listen: false)
          .fetchBookings(status: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// FILTER CHIPS
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
                    setState(() => selectedIndex = index);

                    provider.fetchBookings(
                      status: filterApiValues[index],
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFD7263D) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                        isSelected ? Colors.transparent : Colors.grey.shade400,
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

          /// BOOKING LIST
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.bookings.isEmpty
                ? const Center(child: Text("No bookings found"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: provider.bookings.length,
              itemBuilder: (context, index) {
                final booking = provider.bookings[index];
                return Column(
                  children: [
                    _bookingCard(booking),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// BOOKING CARD (Dynamic)
  Widget _bookingCard(Booking booking) {
    final status = booking.status.toLowerCase();

    // ---------------- STATUS COLOR HANDLING ----------------
    Color statusBg;
    Color statusText;

    if (status == "pending" || status == "upcoming") {
      statusBg = const Color(0xFFDEE8FF);
      statusText = const Color(0xFF4A73FF);
    } else if (status == "completed") {
      statusBg = const Color(0xFFE0FFE4);
      statusText = const Color(0xFF00A84A);
    } else {
      statusBg = const Color(0xFFFFE4E4);
      statusText = const Color(0xFFDD3A3A);
    }

    // ---------------- PAYMENT CHIP COLORS ----------------
    final Color paymentBg = _getPaymentColor(booking.paymentStatus);
    final Color paymentText = Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructor Name
              Expanded(
                child: Text(
                  "${booking.instructor.user.firstName} ${booking.instructor.user.lastName}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Payment Status Chip
              _chip(paymentBg, paymentText, booking.paymentStatus.toUpperCase(),
                  isPayment: true, booking: booking),

              const SizedBox(width: 10),

              // Booking Status Chip
              _chip(statusBg, statusText, booking.status.toUpperCase()),
            ],
          ),

          const SizedBox(height: 16),

          // ---------------- DATE ----------------
          _iconText(
            Icons.calendar_today,
            booking.scheduledAt.split("T")[0],
          ),

          const SizedBox(height: 10),

          // ---------------- TIME ----------------
          _iconText(
            Icons.access_time_rounded,
            "${booking.duration} min",
          ),

          const SizedBox(height: 10),

          // ---------------- LOCATION ----------------
          _iconText(
            Icons.location_on_rounded,
            booking.location ?? "No location",
          ),
        ],
      ),
    );
  }

// ---------------- REUSABLE CHIP ----------------
  Widget _chip(Color bg, Color textColor, String label, {bool isPayment = false, Booking? booking}) {
    return GestureDetector(
      onTap: () async {
        if (!isPayment) return; // Not a payment chip → Just display status

        // ✔ Allow retry only if payment is pending
        if (booking!.paymentStatus.toUpperCase() != "PENDING") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment is already ${booking.paymentStatus}")),
          );
          return;
        }

        final provider = Provider.of<BookingProvider>(context, listen: false);

        // 1️⃣ Create Payment Intent
        bool intentOK = await provider.createPaymentIntent(booking.id);
        if (!intentOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.paymentIntentError ?? "Failed to create payment intent")),
          );
          return;
        }

        // 2️⃣ Show Stripe Payment Sheet
        bool paid = await provider.makePayment();
        if (!paid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Failed")),
          );
          return;
        }

        // 3️⃣ Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Completed Successfully!")),
        );

        // Reload booking list
        provider.fetchBookings(status: filterApiValues[selectedIndex]);

        },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

// ---------------- REUSABLE ICON + TEXT ROW ----------------
  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPaymentColor(String? status) {
    switch (status?.toUpperCase()) {
      case "COMPLETED":
        return Colors.green;
      case "PENDING":
        return Colors.orange;
      case "FAILED":
        return Colors.red;
      default:
        return Colors.black54;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking/model/booking_list_response.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/presentation/booking/screens/review_screen.dart';
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
  ];

  final List<String> filterApiValues = [
    "",
    "PENDING",
    "CONFIRMED",
    "CANCELLED",
    "COMPLETED",
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Fetch ALL bookings initially
    Future.microtask(() {
      Provider.of<BookingProvider>(
        context,
        listen: false,
      ).fetchBookings(status: "");
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

                    provider.fetchBookings(status: filterApiValues[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFD7263D) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected
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

          /// BOOKING LIST
          Expanded(
            child:
                provider.isLoading
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

  Widget initialsAvatar(String first, String last) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFFD7263D),
      child: Text(
        "${first[0]}${last[0]}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String formatDate(String isoDate) {
    return DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(isoDate));
  }

  String formatTime(String isoDate, int duration) {
    final time = DateFormat('HH:mm').format(DateTime.parse(isoDate));
    return "$time ($duration min)";
  }

  Widget _bookingCard(Booking booking) {
    final status = booking.status.toLowerCase();
    Color statusBg;
    Color statusText;
    switch (status.toLowerCase()) {
      case "pending":
        statusBg = const Color(0xFFFFF4CC); // light yellow
        statusText = const Color(0xFFB8860B); // dark yellow
        break;

      case "confirmed":
        statusBg = const Color(0xFFE6ECFF); // light blue
        statusText = const Color(0xFF2F54EB); // dark blue
        break;

      case "completed":
        statusBg = const Color(0xFFE6FFF1); // light green
        statusText = const Color(0xFF008A45); // dark green
        break;

      case "cancelled":
        statusBg = const Color(0xFFFFE4E4); // light red
        statusText = const Color(0xFFB42318); // dark red
        break;

      default:
        statusBg = Colors.grey.shade200;
        statusText = Colors.black87;
    }
    final isCompleted = booking.status.toUpperCase() == "COMPLETED";
    final hasReview = booking.review != null && booking.review!.id.isNotEmpty;
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ✅ CENTER vertically
            children: [
              initialsAvatar(
                booking.instructor.user.firstName,
                booking.instructor.user.lastName,
              ),

              const SizedBox(width: 12), // spacing after avatar

              Expanded(
                child: Text(
                  "${booking.instructor.user.firstName} ${booking.instructor.user.lastName}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              _chip(statusBg, statusText, booking.status.toUpperCase()),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // 📅 DATE
              Icon(
                Icons.calendar_today,
                size: 16,
                color: ColorConstants.iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                formatDate(booking.scheduledAt),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
              Spacer(),
              Text(
                formatTime(booking.scheduledAt, booking.duration),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---------------- LOCATION ----------------
          Row(
            children: [
              // 📅 DATE
              Icon(
                Icons.location_on,
                size: 16,
                color: ColorConstants.iconColor,
              ),
              const SizedBox(width: 6),
              Text.rich(
                TextSpan(
                  children: [
                    if (booking.location == null ||
                        booking.location!.trim().isEmpty) ...[
                      const TextSpan(
                        text: "Location: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // heading
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                      const TextSpan(
                        text: "TBD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                    ] else ...[
                      const TextSpan(
                        text: "Location: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500, // heading
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                      TextSpan(
                        text: booking.location!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCompleted)
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewScreen(
                          instructorName: "${booking.instructor.user.firstName} ${booking.instructor.user.lastName}",
                          bookingId:booking.id,
                          lessonDate: booking.scheduledAt,
                          review: booking.review, // 👈 YOUR Review MODEL
                        ),
                      ),
                    );
                  },
                  child: _actionButton(hasReview ? "View Review" : "Review"),
                ),
              SizedBox(width: 10),
              GestureDetector(onTap: () async {
                 AppRoutes.push(
                  context,
                  RouteNames.bookingDetailsScreen,
                  arguments: booking.id,
                );
              }, child: _actionButton("View")),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- REUSABLE CHIP ----------------
  Widget _chip(
    Color bg,
    Color textColor,
    String label, {
    bool isPayment = false,
    Booking? booking,
  }) {
    return GestureDetector(
      onTap: () async {
        if (!isPayment) return; // Not a payment chip → Just display status

        // ✔ Allow retry only if payment is pending
        if (booking!.paymentStatus.toUpperCase() != "PENDING") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Payment is already ${booking.paymentStatus}"),
            ),
          );
          return;
        }

        final provider = Provider.of<BookingProvider>(context, listen: false);

        // 1️⃣ Create Payment Intent
        bool intentOK = await provider.createPaymentIntent(booking.id);
        if (!intentOK) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                provider.paymentIntentError ??
                    "Failed to create payment intent",
              ),
            ),
          );
          return;
        }

        // 2️⃣ Show Stripe Payment Sheet
        bool paid = await provider.makePayment();
        if (!paid) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Payment Failed")));
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

  Widget _actionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

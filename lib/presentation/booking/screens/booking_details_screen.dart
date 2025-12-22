import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/booking/model/booking_Detail_response.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BookingProvider>().fetchBookingDetail(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Booking Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: ColorConstants.whiteColor,
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.bookingDetail == null
              ? const Center(child: Text("Booking not found"))
              : _buildContent(provider.bookingDetail!),
    );
  }

  Widget _buildContent(BookingDetail booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _header(booking),
          const SizedBox(height: 16),
          _lessonDetails(booking),
          const SizedBox(height: 16),
          _paymentSection(booking),
          const SizedBox(height: 16),
          _instructorCard(booking),
          const SizedBox(height: 16),
          _notesCard(booking),
          const SizedBox(height: 16),
          _timelineCard(booking),
        ],
      ),
    );
  }

  Widget _header(BookingDetail booking) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Booking #${booking.id}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Created on ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(booking.createdAt))}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
        _statusChip(booking.status),
      ],
    );
  }

  Widget _statusChip(String status) {
    late Color bg;
    late Color text;

    switch (status.toLowerCase()) {
      case "pending":
        bg = const Color(0xFFFFF4CC); // light yellow
        text = const Color(0xFFB8860B); // dark yellow
        break;

      case "confirmed":
        bg = const Color(0xFFE6ECFF); // light blue
        text = const Color(0xFF2F54EB); // dark blue
        break;

      case "completed":
        bg = const Color(0xFFE6FFF1); // light green
        text = const Color(0xFF008A45); // dark green
        break;

      case "cancelled":
        bg = const Color(0xFFFFE4E4); // light red
        text = const Color(0xFFB42318); // dark red
        break;

      default:
        bg = Colors.grey.shade200;
        text = Colors.black87;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  Widget _lessonDetails(BookingDetail booking) {
    final date = DateTime.parse(booking.scheduledAt);

    return _card(
      title: "Lesson Details",
      child: Column(
        children: [
          _infoRow(
            Icons.calendar_today,
            "Date",
            DateFormat('EEEE, dd MMM yyyy').format(date),
          ),
          _infoRow(Icons.access_time, "Time", DateFormat('HH:mm').format(date)),
          _infoRow(Icons.timelapse, "Duration", "${booking.duration} min"),
          const Divider(height: 24),

          // ✅ PACKAGE vs SINGLE
          booking.type == "PACKAGE" ? _packageChip() : _singleLessonChip(),
        ],
      ),
    );
  }

  Widget _packageChip() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: const Text("Package Credit"),
        backgroundColor: Colors.purple.shade50,
        labelStyle: const TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _singleLessonChip() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Chip(
        label: const Text("Single Lesson"),
        backgroundColor: Colors.grey.shade200,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _paymentSection(BookingDetail booking) {
    // Package booking
    if (booking.type == "PACKAGE") {
      return _card(
        title: "Payment Method",
        child: Column(
          children: const [
            Icon(Icons.inventory_2, size: 36, color: Colors.purple),
            SizedBox(height: 8),
            Text(
              "Package Credit",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              "Prepaid lesson from package",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Single lesson (paid)
    return _card(
      title: "Payment",
      child: Column(
        children: [
          Text(
            "€${booking.finalPrice}",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text("Total Price"),
        ],
      ),
    );
  }

  Widget _instructorCard(BookingDetail booking) {
    final instructor = booking.instructor.user;

    return _card(
      title: "Instructor",
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: ColorConstants.primaryColor,
                child: Text(
                  instructor.firstName[0] + instructor.lastName[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${instructor.firstName} ${instructor.lastName}",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${booking.instructor.rating} (${booking.instructor.totalReviews} reviews)",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          /* OutlinedButton(
            onPressed: () {},
            child: const Text("View Profile"),
          ),*/
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _notesCard(BookingDetail booking) {
    return _card(
      title: "Your Notes",
      child: Text(
        "${booking.notes}"
        "No notes added",
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }

  Widget _timelineCard(BookingDetail booking) {
    return _card(
      title: "Timeline",
      child: Column(
        children: [
          _timelineRow(
            "Created",
            DateFormat('dd MMM yyyy').format(DateTime.parse(booking.createdAt)),
          ),
          _timelineRow(
            "Last Updated",
            DateFormat('dd MMM yyyy').format(DateTime.parse(booking.updatedAt)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _timelineRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}

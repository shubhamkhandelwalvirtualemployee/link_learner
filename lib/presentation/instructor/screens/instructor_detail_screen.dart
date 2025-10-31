import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_learner/presentation/instructor/provider/instructor_provider.dart';

class InstructorDetailScreen extends StatefulWidget {
  final String instructorId;

  const InstructorDetailScreen({super.key, required this.instructorId});

  @override
  State<InstructorDetailScreen> createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  int selectedDayIndex = -1;
  String? selectedTime;
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InstructorProvider>(context, listen: false);

      provider.getInstructorDetailProvider(widget.instructorId);
      provider.getWeeklyAvailabilityProvider(widget.instructorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstructorProvider>(
      builder: (context, provider, _) {
        final detail = provider.instructorDetailResponse?.data;
        final weekly = provider.weeklyAvailability?.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: Colors.white,
            elevation: 0,
          ),

          body: provider.instructorDetailResponse == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // ✅ Instructor Card
                _buildInstructorCard(detail),

                const SizedBox(height: 20),

                // ✅ Day Selector
                _buildDaySelector(provider),

                const SizedBox(height: 20),

                // ✅ Time Slots
                if (weekly != null && selectedDayIndex != -1)
                  _buildTimeSlots(weekly),

                const SizedBox(height: 20),

                // ✅ Notes Box
                _buildNotes(),

                const SizedBox(height: 20),

                // ✅ Payment Section
                _buildPaymentSection(),

                const SizedBox(height: 20),

                // ✅ Booking Summary
                _buildBookingSummary(),

                const SizedBox(height: 25),

                // ✅ Payment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {},
                    child: const Text("Payment", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Instructor Card
  // ---------------------------------------------------------------------------

  Widget _buildInstructorCard(detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: detail?.avatar != null
                ? NetworkImage(detail!.avatar!)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail?.fullName ?? "N/A",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(detail?.subject ?? "Instructor"),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18),
                    Text(" ${detail?.rating ?? 0}"),
                    const SizedBox(width: 10),
                    Text("₹ ${detail?.pricePerSession ?? 0}/session",
                        style: const TextStyle(color: Colors.red)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Day Selector Horizontal
  // ---------------------------------------------------------------------------

  Widget _buildDaySelector(InstructorProvider provider) {
    final List<String> days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Date & Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),
              const Text("November 2025"),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (_, index) {
                bool active = provider.weeklyAvailability?.data["$index"] != null &&
                    provider.weeklyAvailability!.data["$index"]!.isNotEmpty;

                return GestureDetector(
                  onTap: active
                      ? () => setState(() {
                    selectedDayIndex = index;
                    selectedTime = null;
                  })
                      : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedDayIndex == index
                          ? Colors.red
                          : active
                          ? Colors.black
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(days[index],
                            style: const TextStyle(color: Colors.white)),
                        Text("28",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Time Slots from Weekly Availability
  // ---------------------------------------------------------------------------

  Widget _buildTimeSlots(Map weekly) {
    List slots = weekly["$selectedDayIndex"] ?? [];

    List<String> generatedSlots = [];

    for (var slot in slots) {
      final start = int.parse(slot.startTime.split(":")[0]);
      final end = int.parse(slot.endTime.split(":")[0]);

      for (int h = start; h < end; h++) {
        generatedSlots.add("${h.toString().padLeft(2, '0')}:00");
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: generatedSlots.map((time) {
          bool selected = selectedTime == time;
          return GestureDetector(
            onTap: () => setState(() => selectedTime = time),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                time,
                style: TextStyle(
                    color: selected ? Colors.white : Colors.red,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Notes Box
  // ---------------------------------------------------------------------------

  Widget _buildNotes() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Session Notes (Optional)"),
          const SizedBox(height: 10),
          TextField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Write your notes...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Payment Section
  // ---------------------------------------------------------------------------

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _paymentCard("Credits", "5 sessions"),
          _paymentCard("Pay for Session", "₹270"),
        ],
      ),
    );
  }

  Widget _paymentCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(subtitle),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Booking Summary
  // ---------------------------------------------------------------------------

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Booking Summary",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          _summaryRow("Date", selectedDayIndex == -1 ? "Not Selected" : "Day $selectedDayIndex"),
          _summaryRow("Time", selectedTime ?? "Not Selected"),
          _summaryRow("Duration", "60 minutes"),
          _summaryRow("Payment", "Use Credit"),
        ],
      ),
    );
  }

  Widget _summaryRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ✅ Box Decoration
  // ---------------------------------------------------------------------------

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.1),
        )
      ],
    );
  }
}

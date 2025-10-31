import 'package:flutter/material.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBookingScreen extends StatefulWidget {
  final WeeklyAvailabilityResponse availability;

  const CalendarBookingScreen({required this.availability, super.key});

  @override
  _CalendarBookingScreenState createState() => _CalendarBookingScreenState();
}

class _CalendarBookingScreenState extends State<CalendarBookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Map<String, dynamic>> availableSlotsForDay(DateTime date) {
    int weekday = date.weekday; // Monday=1 ... Sunday=7

    // Your API: 0=Sunday, 1=Monday, ... 6=Saturday
    int apiDay = weekday % 7;

    var slots = widget.availability.data[apiDay] ?? [];

    return slots
        .map((s) => {
      "start": s.startTime,
      "end": s.endTime,
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Session")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("Select a date"))
                : buildSlots(),
          ),
        ],
      ),
    );
  }

  Widget buildSlots() {
    final slots = availableSlotsForDay(_selectedDay!);

    if (slots.isEmpty) {
      return const Center(
        child: Text(
          "No slots available",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: slots.length,
      itemBuilder: (_, i) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text("${slots[i]["start"]} - ${slots[i]["end"]}"),
            trailing: ElevatedButton(
              onPressed: () {
                // ✅ BOOK SLOT BUTTON
              },
              child: const Text("Book"),
            ),
          ),
        );
      },
    );
  }
}

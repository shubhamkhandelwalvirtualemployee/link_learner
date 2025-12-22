class CheckAvailabilityResponse {
  final bool success;
  final String message;
  final AvailabilityData data;

  CheckAvailabilityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CheckAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return CheckAvailabilityResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: AvailabilityData.fromJson(json["data"]),
    );
  }
}

class AvailabilityData {
  final bool isAvailable;
  final List<ConflictingBooking> conflictingBookings;
  final String message;

  AvailabilityData({
    required this.isAvailable,
    required this.conflictingBookings,
    required this.message,
  });

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    final rawList = json["conflictingBookings"];

    List<ConflictingBooking> parsedList = [];

    if (rawList is List) {
      for (final item in rawList) {
        // ✅ NEW FORMAT (object)
        if (item is Map<String, dynamic>) {
          parsedList.add(ConflictingBooking.fromJson(item));
        }
        // ✅ OLD FORMAT (string)
        else if (item is String) {
          parsedList.add(
            ConflictingBooking(
              bookingId: '',
              scheduledAt: DateTime.now(),
              duration: 0,
              bookedBy: item,
            ),
          );
        }
      }
    }

    return AvailabilityData(
      isAvailable: json["isAvailable"] ?? false,
      conflictingBookings: parsedList,
      message: json["message"] ?? "",
    );
  }
}
class ConflictingBooking {
  final String bookingId;
  final DateTime scheduledAt;
  final int duration;
  final String bookedBy;

  ConflictingBooking({
    required this.bookingId,
    required this.scheduledAt,
    required this.duration,
    required this.bookedBy,
  });

  factory ConflictingBooking.fromJson(Map<String, dynamic> json) {
    return ConflictingBooking(
      bookingId: json['bookingId'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      duration: json['duration'] ?? 0,
      bookedBy: json['bookedBy'] ?? '',
    );
  }

  /// 🔥 For UI display
  String get displayText {
    final start = scheduledAt.toLocal();
    final end = start.add(Duration(minutes: duration));

    String format(DateTime t) =>
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    return "${format(start)}-${format(end)} ($bookedBy)";
  }
}


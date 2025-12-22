class WeeklyAvailabilityResponse {
  final bool success;
  final String message;
  final Map<int, List<AvailabilitySlot>> data;

  WeeklyAvailabilityResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WeeklyAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"] ?? {};
    final Map<int, List<AvailabilitySlot>> parsed = {};

    rawData.forEach((key, value) {
      parsed[int.parse(key)] =
          (value as List<dynamic>)
              .map((item) => AvailabilitySlot.fromJson(item))
              .toList();
    });

    return WeeklyAvailabilityResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: parsed,
    );
  }
}

class AvailabilitySlot {
  final String id;
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  AvailabilitySlot({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json["id"],
      dayOfWeek: json["dayOfWeek"],
      startTime: json["startTime"],
      endTime: json["endTime"],
    );
  }
}

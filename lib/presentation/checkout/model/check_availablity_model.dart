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
  final List<String> conflictingBookings;
  final String message;

  AvailabilityData({
    required this.isAvailable,
    required this.conflictingBookings,
    required this.message,
  });

  factory AvailabilityData.fromJson(Map<String, dynamic> json) {
    return AvailabilityData(
      isAvailable: json["isAvailable"] ?? false,
      conflictingBookings:
          json["conflictingBookings"] != null
              ? List<String>.from(json["conflictingBookings"])
              : [],
      message: json["message"] ?? "",
    );
  }
}

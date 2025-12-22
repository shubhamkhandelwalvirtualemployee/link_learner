class AvailableSlotsResponse {
  final bool success;
  final String message;
  final SlotData data;

  AvailableSlotsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SlotData.fromJson(json['data']),
    );
  }
}

class SlotData {
  final String instructorId;
  final String date;
  final String timezone;
  final int totalSlots;
  final int availableSlots;
  final List<Slot> slots;

  SlotData({
    required this.instructorId,
    required this.date,
    required this.timezone,
    required this.totalSlots,
    required this.availableSlots,
    required this.slots,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      instructorId: json['instructorId'],
      date: json['date'],
      timezone: json['timezone'],
      totalSlots: json['totalSlots'],
      availableSlots: json['availableSlots'],
      slots:
          (json['slots'] as List<dynamic>)
              .map((e) => Slot.fromJson(e))
              .toList(),
    );
  }
}

class Slot {
  final String startTime;
  final String endTime;
  final bool available;
  final String slotType;

  Slot({
    required this.startTime,
    required this.endTime,
    required this.available,
    required this.slotType,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      startTime: json['startTime'],
      endTime: json['endTime'],
      available: json['available'] ?? false,
      slotType: json['slotType'],
    );
  }
}

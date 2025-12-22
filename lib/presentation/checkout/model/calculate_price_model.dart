class CalculatePriceResponse {
  final bool success;
  final String message;
  final PriceData data;

  CalculatePriceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CalculatePriceResponse.fromJson(Map<String, dynamic> json) {
    return CalculatePriceResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: PriceData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "data": data.toJson()};
  }
}

class PriceData {
  final double basePrice;
  final double peakSurcharge;
  final double weekendSurcharge;
  final double demandSurcharge;
  final double finalPrice;
  final List<String> breakdown;

  PriceData({
    required this.basePrice,
    required this.peakSurcharge,
    required this.weekendSurcharge,
    required this.demandSurcharge,
    required this.finalPrice,
    required this.breakdown,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      basePrice: (json["basePrice"] ?? 0).toDouble(),
      peakSurcharge: (json["peakSurcharge"] ?? 0).toDouble(),
      weekendSurcharge: (json["weekendSurcharge"] ?? 0).toDouble(),
      demandSurcharge: (json["demandSurcharge"] ?? 0).toDouble(),
      finalPrice: (json["finalPrice"] ?? 0).toDouble(),
      breakdown: List<String>.from(json["breakdown"] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "basePrice": basePrice,
      "peakSurcharge": peakSurcharge,
      "weekendSurcharge": weekendSurcharge,
      "demandSurcharge": demandSurcharge,
      "finalPrice": finalPrice,
      "breakdown": breakdown,
    };
  }
}

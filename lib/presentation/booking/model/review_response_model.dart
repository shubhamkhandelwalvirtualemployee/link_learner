class ReviewResponse {
  final bool success;
  final String message;
  final Review data;

  ReviewResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Review.fromJson(json['data']),
    );
  }
}
class Review {
  final String id;
  final String bookingId;
  final String learnerId;
  final String instructorId;

  final int punctualityRating;
  final int communicationRating;
  final int teachingQualityRating;
  final int patienceRating;
  final int vehicleConditionRating;

  final double overallRating;
  final String? comment;
  final bool isPublic;
  final String status;
  final String createdAt;
  final String updatedAt;

  Review({
    required this.id,
    required this.bookingId,
    required this.learnerId,
    required this.instructorId,
    required this.punctualityRating,
    required this.communicationRating,
    required this.teachingQualityRating,
    required this.patienceRating,
    required this.vehicleConditionRating,
    required this.overallRating,
    this.comment,
    required this.isPublic,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      learnerId: json['learnerId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      punctualityRating: json['punctualityRating'] ?? 0,
      communicationRating: json['communicationRating'] ?? 0,
      teachingQualityRating: json['teachingQualityRating'] ?? 0,
      patienceRating: json['patienceRating'] ?? 0,
      vehicleConditionRating: json['vehicleConditionRating'] ?? 0,
      overallRating: (json['overallRating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'],
      isPublic: json['isPublic'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

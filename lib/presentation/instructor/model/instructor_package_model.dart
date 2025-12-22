class InstructorPackagesResponse {
  final bool success;
  final String message;
  final List<InstructorPackage> data;

  InstructorPackagesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorPackagesResponse.fromJson(Map<String, dynamic> json) {
    return InstructorPackagesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => InstructorPackage.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class InstructorPackage {
  final String id;
  final String instructorId;
  final String name;
  final String description;
  final int lessonCount;
  final double pricePerLesson;
  final double totalPrice;
  final int duration;
  final int validityDays;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double discountPercentage;

  InstructorPackage({
    required this.id,
    required this.instructorId,
    required this.name,
    required this.description,
    required this.lessonCount,
    required this.pricePerLesson,
    required this.totalPrice,
    required this.duration,
    required this.validityDays,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.discountPercentage,
  });

  factory InstructorPackage.fromJson(Map<String, dynamic> json) {
    return InstructorPackage(
      id: json['id'] ?? '',
      instructorId: json['instructorId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      lessonCount: json['lessonCount'] ?? 0,
      pricePerLesson: (json['pricePerLesson'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] ?? 0,
      validityDays: json['validityDays'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instructorId': instructorId,
      'name': name,
      'description': description,
      'lessonCount': lessonCount,
      'pricePerLesson': pricePerLesson,
      'totalPrice': totalPrice,
      'duration': duration,
      'validityDays': validityDays,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'discountPercentage': discountPercentage,
    };
  }
}

// Root Response Model
class PackageCreditListResponse {
  final bool success;
  final String message;
  final List<PackageCredit> data;

  PackageCreditListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackageCreditListResponse.fromJson(Map<String, dynamic> json) {
    return PackageCreditListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<PackageCredit>.from(
          json['data'].map((e) => PackageCredit.fromJson(e)))
          : [],
    );
  }
}

// Single Credit Item
class PackageCredit {
  final String id;
  final String learnerId;
  final String packageId;
  final String instructorId;
  final int purchasePrice;
  final int lessonsIncluded;
  final int lessonsUsed;
  final int lessonsRemaining;
  final DateTime purchasedAt;
  final DateTime expiresAt;
  final bool isActive;
  final String paymentIntentId;
  final String paymentStatus;

  final PackageData package;
  final InstructorData instructor;

  PackageCredit({
    required this.id,
    required this.learnerId,
    required this.packageId,
    required this.instructorId,
    required this.purchasePrice,
    required this.lessonsIncluded,
    required this.lessonsUsed,
    required this.lessonsRemaining,
    required this.purchasedAt,
    required this.expiresAt,
    required this.isActive,
    required this.paymentIntentId,
    required this.paymentStatus,
    required this.package,
    required this.instructor,
  });

  factory PackageCredit.fromJson(Map<String, dynamic> json) {
    return PackageCredit(
      id: json['id'] ?? '',
      learnerId: json['learnerId'] ?? '',
      packageId: json['packageId'] ?? '',
      instructorId: json['instructorId'] ?? '',
      purchasePrice: json['purchasePrice'] ?? 0,
      lessonsIncluded: json['lessonsIncluded'] ?? 0,
      lessonsUsed: json['lessonsUsed'] ?? 0,
      lessonsRemaining: json['lessonsRemaining'] ?? 0,
      purchasedAt: DateTime.parse(json['purchasedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      isActive: json['isActive'] ?? false,
      paymentIntentId: json['paymentIntentId'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      package: PackageData.fromJson(json['package'] ?? {}),
      instructor: InstructorData.fromJson(json['instructor'] ?? {}),
    );
  }
}

// ------------------ PACKAGE MODEL ------------------

class PackageData {
  final String id;
  final String instructorId;
  final String name;
  final String description;
  final int lessonCount;
  final int pricePerLesson;
  final int totalPrice;
  final int duration;
  final int validityDays;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PackageData({
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
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      id: json['id'] ?? '',
      instructorId: json['instructorId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      lessonCount: json['lessonCount'] ?? 0,
      pricePerLesson: json['pricePerLesson'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      duration: json['duration'] ?? 0,
      validityDays: json['validityDays'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// ------------------ INSTRUCTOR MODEL ------------------

class InstructorData {
  final String id;
  final String userId;
  final String rsaLicenseNumber;
  final String licenseExpiryDate;
  final String bio;
  final int experience;
  final List<String> specializations;

  final VehicleDetails? vehicleDetails;
  final int hourlyRate;
  final String address;
  final String city;
  final String county;
  final String postcode;
  final double latitude;
  final double longitude;
  final int radius;
  final String status;
  final String? agencyId;
  final bool isActive;
  final double rating;
  final int totalReviews;
  final bool documentsUploaded;
  final int defaultLessonDuration;
  final int bufferTimeAfter;
  final int maxLessonsPerDay;

  final UserData user;

  InstructorData({
    required this.id,
    required this.userId,
    required this.rsaLicenseNumber,
    required this.licenseExpiryDate,
    required this.bio,
    required this.experience,
    required this.specializations,
    required this.vehicleDetails,
    required this.hourlyRate,
    required this.address,
    required this.city,
    required this.county,
    required this.postcode,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.status,
    required this.agencyId,
    required this.isActive,
    required this.rating,
    required this.totalReviews,
    required this.documentsUploaded,
    required this.defaultLessonDuration,
    required this.bufferTimeAfter,
    required this.maxLessonsPerDay,
    required this.user,
  });

  factory InstructorData.fromJson(Map<String, dynamic> json) {
    return InstructorData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      rsaLicenseNumber: json['rsaLicenseNumber'] ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] ?? '',
      bio: json['bio'] ?? '',
      experience: json['experience'] ?? 0,
      specializations: List<String>.from(json['specializations'] ?? []),
      vehicleDetails: json['vehicleDetails'] != null
          ? VehicleDetails.fromJson(json['vehicleDetails'])
          : null,
      hourlyRate: json['hourlyRate'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      county: json['county'] ?? '',
      postcode: json['postcode'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      radius: json['radius'] ?? 0,
      status: json['status'] ?? '',
      agencyId: json['agencyId'],
      isActive: json['isActive'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      documentsUploaded: json['documentsUploaded'] ?? false,
      defaultLessonDuration: json['defaultLessonDuration'] ?? 60,
      bufferTimeAfter: json['bufferTimeAfter'] ?? 15,
      maxLessonsPerDay: json['maxLessonsPerDay'] ?? 8,
      user: UserData.fromJson(json['user'] ?? {}),
    );
  }
}

// ------------------ VEHICLE DETAILS ------------------

class VehicleDetails {
  final String make;
  final int year;
  final String model;
  final String transmission;

  VehicleDetails({
    required this.make,
    required this.year,
    required this.model,
    required this.transmission,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      make: json['make'] ?? '',
      year: json['year'] ?? 0,
      model: json['model'] ?? '',
      transmission: json['transmission'] ?? '',
    );
  }
}

// ------------------ USER MODEL ------------------

class UserData {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String phone;
  final String? avatar;

  UserData({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
    );
  }
}

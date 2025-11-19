class InstructorDetailResponse {
  final bool success;
  final String message;
  final InstructorData data;

  InstructorDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorDetailResponse.fromJson(Map<String, dynamic> json) {
    return InstructorDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: InstructorData.fromJson(json['data'] ?? {}),
    );
  }
}

class InstructorData {
  final InstructorDetails instructor;

  InstructorData({required this.instructor});

  factory InstructorData.fromJson(Map<String, dynamic> json) {
    return InstructorData(
      instructor: InstructorDetails.fromJson(json['instructor'] ?? {}),
    );
  }
}

class InstructorDetails {
  final String id;
  final String userId;
  final String rsaLicenseNumber;
  final String licenseExpiryDate;
  final String bio;
  final int experience;
  final List<String> specializations;
  final VehicleDetails vehicleDetails;
  final int hourlyRate;
  final String address;
  final String city;
  final String county;
  final String postcode;
  final double latitude;
  final double longitude;
  final int radius;
  final String status;
  final String? verifiedAt;
  final String? agencyId;
  final bool isActive;
  final double rating;
  final int totalReviews;
  final bool documentsUploaded;
  final String createdAt;
  final String updatedAt;
  final InstructorDetailUser user;
  final List<dynamic> documents;

  InstructorDetails({
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
    required this.verifiedAt,
    required this.agencyId,
    required this.isActive,
    required this.rating,
    required this.totalReviews,
    required this.documentsUploaded,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.documents,
  });

  factory InstructorDetails.fromJson(Map<String, dynamic> json) {
    return InstructorDetails(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      rsaLicenseNumber: json['rsaLicenseNumber'] ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] ?? '',
      bio: json['bio'] ?? '',
      experience: json['experience'] ?? 0,
      specializations: List<String>.from(json['specializations'] ?? []),
      vehicleDetails:
      VehicleDetails.fromJson(json['vehicleDetails'] ?? {}),
      hourlyRate: json['hourlyRate'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      county: json['county'] ?? '',
      postcode: json['postcode'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      radius: json['radius'] ?? 0,
      status: json['status'] ?? '',
      verifiedAt: json['verifiedAt'],
      agencyId: json['agencyId'],
      isActive: json['isActive'] ?? false,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      documentsUploaded: json['documentsUploaded'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      user: InstructorDetailUser.fromJson(json['user'] ?? {}),
      documents: json['documents'] ?? [],
    );
  }
}

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

class InstructorDetailUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;
  final String createdAt;

  InstructorDetailUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
    required this.createdAt,
  });

  factory InstructorDetailUser.fromJson(Map<String, dynamic> json) {
    return InstructorDetailUser(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}

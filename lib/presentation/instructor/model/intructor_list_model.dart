class InstructorListResponse {
  final bool success;
  final String message;
  final InstructorData data;

  InstructorListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorListResponse.fromJson(Map<String, dynamic> json) {
    return InstructorListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: InstructorData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class InstructorData {
  final List<Instructor> instructors;

  InstructorData({required this.instructors});

  factory InstructorData.fromJson(Map<String, dynamic> json) {
    return InstructorData(
      instructors: (json['instructors'] as List<dynamic>)
          .map((e) => Instructor.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "instructors": instructors.map((e) => e.toJson()).toList(),
  };
}

class Instructor {
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
  final InstructorUser user;

  Instructor({
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
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      userId: json['userId'],
      rsaLicenseNumber: json['rsaLicenseNumber'],
      licenseExpiryDate: json['licenseExpiryDate'],
      bio: json['bio'],
      experience: json['experience'],
      specializations: List<String>.from(json['specializations']),
      vehicleDetails: VehicleDetails.fromJson(json['vehicleDetails']),
      hourlyRate: json['hourlyRate'],
      address: json['address'],
      city: json['city'],
      county: json['county'],
      postcode: json['postcode'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: json['radius'],
      status: json['status'],
      verifiedAt: json['verifiedAt'],
      agencyId: json['agencyId'],
      isActive: json['isActive'],
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      documentsUploaded: json['documentsUploaded'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: InstructorUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "rsaLicenseNumber": rsaLicenseNumber,
    "licenseExpiryDate": licenseExpiryDate,
    "bio": bio,
    "experience": experience,
    "specializations": specializations,
    "vehicleDetails": vehicleDetails.toJson(),
    "hourlyRate": hourlyRate,
    "address": address,
    "city": city,
    "county": county,
    "postcode": postcode,
    "latitude": latitude,
    "longitude": longitude,
    "radius": radius,
    "status": status,
    "verifiedAt": verifiedAt,
    "agencyId": agencyId,
    "isActive": isActive,
    "rating": rating,
    "totalReviews": totalReviews,
    "documentsUploaded": documentsUploaded,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "user": user.toJson(),
  };
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
      make: json['make'],
      year: json['year'],
      model: json['model'],
      transmission: json['transmission'],
    );
  }

  Map<String, dynamic> toJson() => {
    "make": make,
    "year": year,
    "model": model,
    "transmission": transmission,
  };
}

class InstructorUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;

  InstructorUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatar,
  });

  factory InstructorUser.fromJson(Map<String, dynamic> json) {
    return InstructorUser(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "avatar": avatar,
  };
}

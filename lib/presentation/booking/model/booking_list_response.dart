import 'dart:convert';

class BookingListResponse {
  final bool success;
  final String message;
  final List<Booking> bookings;

  BookingListResponse({
    required this.success,
    required this.message,
    required this.bookings,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      bookings:
          (json['bookings'] as List<dynamic>)
              .map((e) => Booking.fromJson(e))
              .toList(),
    );
  }
}

class Booking {
  final String id;
  final String learnerId;
  final String instructorId;
  final String? packageId;
  final String? packagePurchaseId;
  final String type;
  final String status;
  final String scheduledAt;
  final int duration;
  final double basePrice;
  final double peakSurcharge;
  final double weekendSurcharge;
  final double demandSurcharge;
  final double finalPrice;
  final String? paymentIntentId;
  final String paymentStatus;
  final String? paidAt;
  final bool usedCredit;
  final String? location;
  final String? notes;
  final String? lessonNotes;
  final String? cancelledAt;
  final String? cancelReason;
  final String? cancelledBy;
  final String createdAt;
  final String updatedAt;
  final Review? review;
  final Learner learner;
  final Instructor? instructor;
  final PackagePurchase? packagePurchase;

  Booking({
    required this.id,
    required this.learnerId,
    required this.instructorId,
    this.packageId,
    this.packagePurchaseId,
    required this.type,
    required this.status,
    required this.scheduledAt,
    required this.duration,
    required this.basePrice,
    required this.peakSurcharge,
    required this.weekendSurcharge,
    required this.demandSurcharge,
    required this.finalPrice,
    this.paymentIntentId,
    required this.paymentStatus,
    this.paidAt,
    required this.usedCredit,
    required this.location,
    required this.notes,
    this.lessonNotes,
    this.cancelledAt,
    this.cancelReason,
    this.cancelledBy,
    required this.createdAt,
    required this.updatedAt,
    required this.learner,
    this.instructor,
    this.packagePurchase,
    this.review,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      learnerId: json['learnerId'],
      instructorId: json['instructorId'],
      packageId: json['packageId'],
      packagePurchaseId: json['packagePurchaseId'],
      type: json['type'],
      status: json['status'],
      scheduledAt: json['scheduledAt'],
      duration: json['duration'],
      basePrice: (json['basePrice'] as num).toDouble(),
      peakSurcharge: (json['peakSurcharge'] as num).toDouble(),
      weekendSurcharge: (json['weekendSurcharge'] as num).toDouble(),
      demandSurcharge: (json['demandSurcharge'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      paymentIntentId: json['paymentIntentId'],
      paymentStatus: json['paymentStatus'],
      paidAt: json['paidAt'],
      usedCredit: json['usedCredit'],
      location: json['location'] ?? "",
      notes: json['notes'] ?? "",
      lessonNotes: json['lessonNotes'] ?? "",
      cancelledAt: json['cancelledAt'] ?? "",
      cancelReason: json['cancelReason'] ?? "",
      cancelledBy: json['cancelledBy'] ?? "",
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      learner: Learner.fromJson(json['learner']),
      instructor: Instructor.fromJson(json['instructor']),
      packagePurchase:
          json['packagePurchase'] != null
              ? PackagePurchase.fromJson(json['packagePurchase'])
              : null,
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}

class Learner {
  final String id;
  final String userId;
  final String? dateOfBirth;
  final String? address;
  final String? city;
  final String? county;
  final String? postcode;
  final String? licenseNumber;
  final String? emergencyContact;
  final String? goals;
  final String? experience;
  final Preferences? preferences;
  final String createdAt;
  final String updatedAt;
  final UserModel user;

  Learner({
    required this.id,
    required this.userId,
    this.dateOfBirth,
    this.address,
    this.city,
    this.county,
    this.postcode,
    this.licenseNumber,
    this.emergencyContact,
    this.goals,
    this.experience,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Learner.fromJson(Map<String, dynamic> json) {
    Preferences? prefs;

    if (json['preferences'] != null) {
      if (json['preferences'] is String) {
        prefs = Preferences.fromJson(jsonDecode(json['preferences']));
      } else if (json['preferences'] is Map<String, dynamic>) {
        prefs = Preferences.fromJson(json['preferences']);
      }
    }

    return Learner(
      id: json['id'],
      userId: json['userId'],
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      city: json['city'],
      county: json['county'],
      postcode: json['postcode'],
      licenseNumber: json['licenseNumber'],
      emergencyContact: json['emergencyContact'],
      goals: json['goals'],
      experience: json['experience'],
      preferences: prefs,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class Preferences {
  final String? preferredTime;
  final String? transmissionType;

  Preferences({this.preferredTime, this.transmissionType});

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      preferredTime: json['preferredTime'],
      transmissionType: json['transmissionType'],
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
      id: json['id'],
      bookingId: json['bookingId'],
      learnerId: json['learnerId'],
      instructorId: json['instructorId'],
      punctualityRating: json['punctualityRating'] ?? 0,
      communicationRating: json['communicationRating'] ?? 0,
      teachingQualityRating: json['teachingQualityRating'] ?? 0,
      patienceRating: json['patienceRating'] ?? 0,
      vehicleConditionRating: json['vehicleConditionRating'] ?? 0,
      overallRating: (json['overallRating'] as num).toDouble(),
      comment: json['comment'],
      isPublic: json['isPublic'] ?? false,
      status: json['status'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String phone;
  final bool isActive;
  final bool emailVerified;
  final bool profileComplete;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.isActive,
    required this.emailVerified,
    required this.profileComplete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      isActive: json['isActive'],
      emailVerified: json['emailVerified'],
      profileComplete: json['profileComplete'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Instructor {
  final String id;
  final String userId;
  final String rsaLicenseNumber;
  final String licenseExpiryDate;
  final String? bio;
  final int? experience;
  final List<String> specializations;
  final VehicleDetails vehicleDetails;
  final double hourlyRate;
  final String address;
  final String city;
  final String county;
  final String postcode;
  final double? latitude;
  final double? longitude;
  final int radius;
  final String status;
  final String? agencyId;
  final bool isActive;
  final double? rating;
  final int totalReviews;
  final bool documentsUploaded;
  final int defaultLessonDuration;
  final int bufferTimeAfter;
  final int maxLessonsPerDay;
  final String? lunchBreakStart;
  final String? lunchBreakEnd;
  final String createdAt;
  final String updatedAt;
  final UserModel user;

  Instructor({
    required this.id,
    required this.userId,
    required this.rsaLicenseNumber,
    required this.licenseExpiryDate,
    this.bio,
    this.experience,
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
    this.agencyId,
    required this.isActive,
    required this.rating,
    required this.totalReviews,
    required this.documentsUploaded,
    required this.defaultLessonDuration,
    required this.bufferTimeAfter,
    required this.maxLessonsPerDay,
    this.lunchBreakStart,
    this.lunchBreakEnd,
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
      bio: json['bio'] ?? "",
      experience: json['experience'] ?? 0,
      specializations: List<String>.from(
        json['specializations'].map((e) => e.toString()),
      ),
      vehicleDetails: VehicleDetails.fromJson(json['vehicleDetails']),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      address: json['address'],
      city: json['city'],
      county: json['county'],
      postcode: json['postcode'],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      radius: json['radius'],
      status: json['status'],
      agencyId: json['agencyId'],
      isActive: json['isActive'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'],
      documentsUploaded: json['documentsUploaded'],
      defaultLessonDuration: json['defaultLessonDuration'],
      bufferTimeAfter: json['bufferTimeAfter'],
      maxLessonsPerDay: json['maxLessonsPerDay'],
      lunchBreakStart: json['lunchBreakStart'],
      lunchBreakEnd: json['lunchBreakEnd'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromJson(json['user']),
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
      make: json['make'],
      year: json['year'],
      model: json['model'],
      transmission: json['transmission'],
    );
  }
}

class PackagePurchase {
  final String id;
  final String learnerId;
  final String packageId;
  final String instructorId;
  final double purchasePrice;
  final int lessonsIncluded;
  final int lessonsUsed;
  final int lessonsRemaining;
  final String purchasedAt;
  final String expiresAt;
  final bool isActive;
  final String? paymentIntentId;
  final String paymentStatus;
  final PackageModel package;

  PackagePurchase({
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
    this.paymentIntentId,
    required this.paymentStatus,
    required this.package,
  });

  factory PackagePurchase.fromJson(Map<String, dynamic> json) {
    return PackagePurchase(
      id: json['id'],
      learnerId: json['learnerId'],
      packageId: json['packageId'],
      instructorId: json['instructorId'],
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
      lessonsIncluded: json['lessonsIncluded'] ?? 0,
      lessonsUsed: json['lessonsUsed'] ?? 0,
      lessonsRemaining: json['lessonsRemaining'] ?? 0,
      purchasedAt: json['purchasedAt'] ?? "",
      expiresAt: json['expiresAt'] ?? "",
      isActive: json['isActive'] ?? false,
      paymentIntentId: json['paymentIntentId'],
      paymentStatus: json['paymentStatus'] ?? "",
      package: PackageModel.fromJson(json['package']),
    );
  }
}

class PackageModel {
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

  PackageModel({
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
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      instructorId: json['instructorId'],
      name: json['name'],
      description: json['description'],
      lessonCount: json['lessonCount'],
      pricePerLesson: (json['pricePerLesson'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      duration: json['duration'],
      validityDays: json['validityDays'],
      isActive: json['isActive'],
    );
  }
}

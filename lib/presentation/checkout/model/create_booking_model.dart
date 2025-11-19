class CreateBookingResponse {
  final bool success;
  final String message;
  final CreateBookingData data;

  CreateBookingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponse(
      success: json['success'],
      message: json['message'],
      data: CreateBookingData.fromJson(json['data']),
    );
  }
}

class CreateBookingData {
  final String id;
  final String learnerId;
  final String instructorId;
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

  final String location;
  final String? notes;
  final String? lessonNotes;

  final String? cancelledAt;
  final String? cancelReason;
  final String? cancelledBy;

  final String createdAt;
  final String updatedAt;

  final Learner learner;
  final Instructor instructor;

  CreateBookingData({
    required this.id,
    required this.learnerId,
    required this.instructorId,
    required this.packagePurchaseId,
    required this.type,
    required this.status,
    required this.scheduledAt,
    required this.duration,
    required this.basePrice,
    required this.peakSurcharge,
    required this.weekendSurcharge,
    required this.demandSurcharge,
    required this.finalPrice,
    required this.paymentIntentId,
    required this.paymentStatus,
    required this.paidAt,
    required this.usedCredit,
    required this.location,
    required this.notes,
    required this.lessonNotes,
    required this.cancelledAt,
    required this.cancelReason,
    required this.cancelledBy,
    required this.createdAt,
    required this.updatedAt,
    required this.learner,
    required this.instructor,
  });

  factory CreateBookingData.fromJson(Map<String, dynamic> json) {
    return CreateBookingData(
      id: json['id'],
      learnerId: json['learnerId'],
      instructorId: json['instructorId'],
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

      location: json['location'],
      notes: json['notes'],
      lessonNotes: json['lessonNotes'],

      cancelledAt: json['cancelledAt'],
      cancelReason: json['cancelReason'],
      cancelledBy: json['cancelledBy'],

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      learner: Learner.fromJson(json['learner']),
      instructor: Instructor.fromJson(json['instructor']),
    );
  }
}

class Learner {
  final String id;
  final String userId;
  final User user;

  Learner({required this.id, required this.userId, required this.user});

  factory Learner.fromJson(Map<String, dynamic> json) {
    return Learner(
      id: json['id'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
    );
  }
}

class Instructor {
  final String id;
  final String userId;
  final User user;
  final double hourlyRate;
  final String city;
  final double rating;

  Instructor({
    required this.id,
    required this.userId,
    required this.user,
    required this.hourlyRate,
    required this.city,
    required this.rating,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      userId: json['userId'],
      user: User.fromJson(json['user']),
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      city: json['city'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

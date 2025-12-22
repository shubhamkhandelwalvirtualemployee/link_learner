class BookingDetailResponse {
  final bool success;
  final String message;
  final BookingDetail data;

  BookingDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      success: json['success'],
      message: json['message'],
      data: BookingDetail.fromJson(json['data']),
    );
  }
}
class BookingDetail {
  final String id;
  final String type;
  final String status;
  final String scheduledAt;
  final int duration;
  final int basePrice;
  final int finalPrice;
  final String paymentStatus;
  final bool usedCredit;
  final String? location;
  final String? notes;
  final String? cancelReason;
  final String createdAt;
  final String updatedAt;

  final Learner learner;
  final Instructor instructor;
  final PackagePurchase? packagePurchase;
  final Review? review;

  BookingDetail({
    required this.id,
    required this.type,
    required this.status,
    required this.scheduledAt,
    required this.duration,
    required this.basePrice,
    required this.finalPrice,
    required this.paymentStatus,
    required this.usedCredit,
    this.location,
    this.notes,
    this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
    required this.learner,
    required this.instructor,
    this.packagePurchase,
    this.review,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      scheduledAt: json['scheduledAt'],
      duration: json['duration'],
      basePrice: json['basePrice'],
      finalPrice: json['finalPrice'],
      paymentStatus: json['paymentStatus'],
      usedCredit: json['usedCredit'],
      location: json['location'],
      notes: json['notes'],
      cancelReason: json['cancelReason'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      learner: Learner.fromJson(json['learner']),
      instructor: Instructor.fromJson(json['instructor']),
      packagePurchase: json['packagePurchase'] != null
          ? PackagePurchase.fromJson(json['packagePurchase'])
          : null,
      review:
      json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}
class Learner {
  final String id;
  final String city;
  final String county;
  final String postcode;
  final User user;

  Learner({
    required this.id,
    required this.city,
    required this.county,
    required this.postcode,
    required this.user,
  });

  factory Learner.fromJson(Map<String, dynamic> json) {
    return Learner(
      id: json['id'],
      city: json['city'],
      county: json['county'],
      postcode: json['postcode'],
      user: User.fromJson(json['user']),
    );
  }
}
class Instructor {
  final String id;
  final double rating;
  final int totalReviews;
  final User user;

  Instructor({
    required this.id,
    required this.rating,
    required this.totalReviews,
    required this.user,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['totalReviews'],
      user: User.fromJson(json['user']),
    );
  }
}
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
    );
  }
}
class PackagePurchase {
  final String id;
  final int lessonsIncluded;
  final int lessonsUsed;
  final int lessonsRemaining;
  final String expiresAt;

  PackagePurchase({
    required this.id,
    required this.lessonsIncluded,
    required this.lessonsUsed,
    required this.lessonsRemaining,
    required this.expiresAt,
  });

  factory PackagePurchase.fromJson(Map<String, dynamic> json) {
    return PackagePurchase(
      id: json['id'],
      lessonsIncluded: json['lessonsIncluded'],
      lessonsUsed: json['lessonsUsed'],
      lessonsRemaining: json['lessonsRemaining'],
      expiresAt: json['expiresAt'],
    );
  }
}
class Review {
  final String id;
  final double overallRating;
  final String? comment;

  Review({
    required this.id,
    required this.overallRating,
    this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      overallRating: (json['overallRating'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}

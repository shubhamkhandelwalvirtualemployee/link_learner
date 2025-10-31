class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ProfileData {
  final User user;

  ProfileData({required this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
  };
}

class User {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final bool emailVerified;
  final bool profileComplete;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Learner? learner;
  final dynamic instructor;
  final dynamic agency;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatar,
    required this.isActive,
    required this.emailVerified,
    required this.profileComplete,
    required this.createdAt,
    required this.updatedAt,
    this.learner,
    this.instructor,
    this.agency,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      isActive: json['isActive'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      profileComplete: json['profileComplete'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      learner:
      json['learner'] != null ? Learner.fromJson(json['learner']) : null,
      instructor: json['instructor'],
      agency: json['agency'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'role': role,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'avatar': avatar,
    'isActive': isActive,
    'emailVerified': emailVerified,
    'profileComplete': profileComplete,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'learner': learner?.toJson(),
    'instructor': instructor,
    'agency': agency,
  };
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
  final DateTime createdAt;
  final DateTime updatedAt;

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
  });

  factory Learner.fromJson(Map<String, dynamic> json) {
    return Learner(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      address: json['address'],
      city: json['city'],
      county: json['county'],
      postcode: json['postcode'],
      licenseNumber: json['licenseNumber'],
      emergencyContact: json['emergencyContact'],
      goals: json['goals'],
      experience: json['experience'],
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'dateOfBirth': dateOfBirth,
    'address': address,
    'city': city,
    'county': county,
    'postcode': postcode,
    'licenseNumber': licenseNumber,
    'emergencyContact': emergencyContact,
    'goals': goals,
    'experience': experience,
    'preferences': preferences?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
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

  Map<String, dynamic> toJson() => {
    'preferredTime': preferredTime,
    'transmissionType': transmissionType,
  };
}

class LoginResponseModel {
  final bool? success;
  final String? message;
  LoginData? data;

  LoginResponseModel({
     this.success,
     this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    if (data != null) "data": data!.toJson(),
  };
}

class LoginData {
  final User? user;
  final String? accessToken;
  final String? refreshToken;

  LoginData({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
    if (user != null) "user": user!.toJson(),
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}

class User {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? avatar;
  final String? role;
  final bool? isActive;
  final bool? emailVerified;
  final bool? profileComplete;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.avatar,
    this.role,
    this.isActive,
    this.emailVerified,
    this.profileComplete,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phone: json["phone"],
      avatar: json["avatar"],
      role: json["role"],
      isActive: json["isActive"],
      emailVerified: json["emailVerified"],
      profileComplete: json["profileComplete"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "avatar": avatar,
    "role": role,
    "isActive": isActive,
    "emailVerified": emailVerified,
    "profileComplete": profileComplete,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}



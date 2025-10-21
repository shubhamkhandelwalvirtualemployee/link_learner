class LoginResponseModel {
  bool? success;
  String? message;
  Data? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  static List<LoginResponseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(LoginResponseModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  User? user;
  String? accessToken;
  String? refreshToken;

  Data({this.user, this.accessToken, this.refreshToken});

  Data.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    accessToken = json["accessToken"];
    refreshToken = json["refreshToken"];
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    _data["accessToken"] = accessToken;
    _data["refreshToken"] = refreshToken;
    return _data;
  }
}

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  dynamic avatar;
  String? role;
  bool? isActive;
  bool? emailVerified;
  bool? profileComplete;
  String? createdAt;
  String? updatedAt;
  Learner? learner;

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
    this.learner,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    email = json["email"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    phone = json["phone"];
    avatar = json["avatar"];
    role = json["role"];
    isActive = json["isActive"];
    emailVerified = json["emailVerified"];
    profileComplete = json["profileComplete"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    learner =
        json["learner"] == null ? null : Learner.fromJson(json["learner"]);
  }

  static List<User> fromList(List<Map<String, dynamic>> list) {
    return list.map(User.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["email"] = email;
    _data["firstName"] = firstName;
    _data["lastName"] = lastName;
    _data["phone"] = phone;
    _data["avatar"] = avatar;
    _data["role"] = role;
    _data["isActive"] = isActive;
    _data["emailVerified"] = emailVerified;
    _data["profileComplete"] = profileComplete;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    if (learner != null) {
      _data["learner"] = learner?.toJson();
    }
    return _data;
  }
}

class Learner {
  String? id;
  String? userId;
  dynamic dateOfBirth;
  dynamic address;
  dynamic city;
  dynamic county;
  dynamic postcode;
  dynamic licenseNumber;
  dynamic emergencyContact;
  dynamic goals;
  dynamic experience;
  dynamic preferences;
  String? createdAt;
  String? updatedAt;

  Learner({
    this.id,
    this.userId,
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
    this.createdAt,
    this.updatedAt,
  });

  Learner.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["userId"];
    dateOfBirth = json["dateOfBirth"];
    address = json["address"];
    city = json["city"];
    county = json["county"];
    postcode = json["postcode"];
    licenseNumber = json["licenseNumber"];
    emergencyContact = json["emergencyContact"];
    goals = json["goals"];
    experience = json["experience"];
    preferences = json["preferences"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  static List<Learner> fromList(List<Map<String, dynamic>> list) {
    return list.map(Learner.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["userId"] = userId;
    _data["dateOfBirth"] = dateOfBirth;
    _data["address"] = address;
    _data["city"] = city;
    _data["county"] = county;
    _data["postcode"] = postcode;
    _data["licenseNumber"] = licenseNumber;
    _data["emergencyContact"] = emergencyContact;
    _data["goals"] = goals;
    _data["experience"] = experience;
    _data["preferences"] = preferences;
    _data["createdAt"] = createdAt;
    _data["updatedAt"] = updatedAt;
    return _data;
  }
}

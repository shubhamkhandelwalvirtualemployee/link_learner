class SignUpResponseModel {
  bool? success;
  String? message;
  Data? data;

  SignUpResponseModel({this.success, this.message, this.data});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  static List<SignUpResponseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(SignUpResponseModel.fromJson).toList();
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
  Profiles? profiles;

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
    this.profiles,
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
    profiles =
        json["profiles"] == null ? null : Profiles.fromJson(json["profiles"]);
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
    if (profiles != null) {
      _data["profiles"] = profiles?.toJson();
    }
    return _data;
  }
}

class Profiles {
  dynamic learner;
  dynamic instructor;
  dynamic agency;

  Profiles({this.learner, this.instructor, this.agency});

  Profiles.fromJson(Map<String, dynamic> json) {
    learner = json["learner"];
    instructor = json["instructor"];
    agency = json["agency"];
  }

  static List<Profiles> fromList(List<Map<String, dynamic>> list) {
    return list.map(Profiles.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["learner"] = learner;
    _data["instructor"] = instructor;
    _data["agency"] = agency;
    return _data;
  }
}

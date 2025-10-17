class SignUpRequestModel {
  String? role;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? phone;
  String? callbackUrl;

  SignUpRequestModel({
    this.role,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.callbackUrl,
  });

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    role = json["role"];
    email = json["email"];
    password = json["password"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    phone = json["phone"];
    callbackUrl = json["callbackUrl"];
  }

  static List<SignUpRequestModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(SignUpRequestModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["role"] = role;
    _data["email"] = email;
    _data["password"] = password;
    _data["firstName"] = firstName;
    _data["lastName"] = lastName;
    _data["phone"] = phone;
    _data["callbackUrl"] = callbackUrl;
    return _data;
  }
}

class ChangePasswordRequest {
  ChangePasswordRequest({
    this.email,
    this.password,
    this.current_password,
  });

  String? email;
  String? password;
  String? current_password;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequest(
          email: json["email"],
          password: json["password"],
          current_password: json['current_password']);

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "current_password": current_password,
      };
}

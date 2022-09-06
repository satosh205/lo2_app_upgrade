class SwayamLoginRequest {
  String? deviceType;
  String? deviceToken;
  String? device_id;
  String? userName;
  String? password;

  SwayamLoginRequest(
      {this.password,
      this.userName,
      this.device_id,
      this.deviceType,
      this.deviceToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = userName;
    data['password'] = password;
    data['device_id'] = device_id;
    data['device_type'] = deviceType;
    data['device_token'] = deviceToken;
    return data;
  }
}

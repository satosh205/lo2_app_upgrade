class EmailRequest {
  String email;
  String optKey;
  String? deviceId;
  int? deviceType;
  String? deviceToken;
  String? locale;

  String mobileNo;

  EmailRequest(
      {this.email = "",
      this.optKey = "",
      this.mobileNo = "",
      this.deviceId,
      this.deviceToken,
      this.deviceType,
      this.locale});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otp_key'] = this.optKey;
    data['mobile_no'] = this.mobileNo;
    data['device_token'] = this.deviceToken;
    data['device_id'] = this.deviceId;
    data['device_type'] = this.deviceType;
    data['locale'] = this.locale;
    return data;
  }
}

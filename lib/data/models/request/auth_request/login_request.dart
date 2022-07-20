class LoginRequest {
  String? mobileNo;
  String device_id;
  String? mobile_exist_skip;

  LoginRequest(
      {this.mobileNo,
      this.device_id = "123456789098765432112",
      this.mobile_exist_skip});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_no'] = mobileNo;
    data['mobile_exist_skip'] = mobile_exist_skip;
    return data;
  }
}

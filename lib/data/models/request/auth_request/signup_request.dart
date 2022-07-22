class SignUpRequest {
  String? firmName;
  String? firstName;
  String? lastName;
  String? gender;
  String? mobileNo;
  String? alternateMobileNo;
  String? emailAddress;
  String? dateOfBirth;
  String? profilePic;
  String? dbCode;
  String? username;

  SignUpRequest(
      {this.firmName,
      this.firstName,
      this.lastName,
      this.gender,
      this.mobileNo,
      this.alternateMobileNo,
      this.dbCode,
      this.emailAddress,
      this.dateOfBirth,
      this.profilePic,
      this.username});

  SignUpRequest.fromJson(Map<String, dynamic> json) {
    firmName = json['firm_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    alternateMobileNo = json['alternate_mobile_no'];
    emailAddress = json['email_address'];
    dateOfBirth = json['date_of_birth'];
    profilePic = json['profile_pic'];
    dbCode = json['db_code'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firm_name'] = this.firmName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['mobile_no'] = this.mobileNo;
    data['alternate_mobile_no'] = this.alternateMobileNo;
    data['email_address'] = this.emailAddress;
    data['date_of_birth'] = this.dateOfBirth;
    data['profile_pic'] = this.profilePic;
    data['db_code'] = this.dbCode;
    data['username'] = this.username;
    return data;
  }
}

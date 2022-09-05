class SwayamLoginResponse {
  int? status;
  Data? data;
  List<String>? error;
  String? message;

  SwayamLoginResponse({this.status, this.data, this.error, this.message});

  SwayamLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    final user = this.user;
    if (user != null) {
      data['user'] = user.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? department;
  String? designation;
  String? mobileNo;
  String? profileImage;
  int? isTrainer;

  User(
      {this.id,
      this.name,
      this.isTrainer,
      this.email,
      this.department,
      this.designation,
      this.mobileNo,
      this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    department = json['department'];
    designation = json['designation'];
    mobileNo = json['mobile_no'] is String
        ? json['mobile_no']
        : json['mobile_no'].toString();
    profileImage = json['profile_image'];
    isTrainer = json['is_trainer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['mobile_no'] = this.mobileNo;
    data['profile_image'] = this.profileImage;
    data['is_trainer'] = this.isTrainer;
    return data;
  }
}

import 'package:masterg/utils/utility.dart';

class UserInfoResponse {
  int? status;
  Data? data;
  List<String>? error;

  UserInfoResponse({this.status, this.data, this.error});

  UserInfoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  UserData? userData;

  Data({this.userData});

  Data.fromJson(Map<String, dynamic> json) {
    userData =
        json['list'] != null ? new UserData.fromJson(json['list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['list'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? username;
  String? profileImage;
  int? dateOfBirth;
  String? email;
  String? mobileNo;
  String? firmName;
  String? alternateMobileNo;
  String? whatsappId;
  String? instagram;
  String? facebookId;
  String? twitter;
  String? spouseOccupation;
  String? spouseDob;
  String? spouseLastName;
  String? spouseFirstName;
  int? isAgree;
  int? isChildren;
  String? gender;
  String? educationQualification;
  String? address1;
  String? address2;
  String? landmark;
  String? postOffice;
  String? state;
  int? city;
  int? maritalStatus;
  int? totalCoins;

  String? department;

  String? designation;

  String? senior;

  String? langauge;

  String? location;

  String? branch;

  String? area;

  String? territory;

  UserData(
      {this.id,
      this.name,
      this.profileImage,
      this.dateOfBirth,
      this.email,
      this.mobileNo,
      this.firmName,
      this.alternateMobileNo,
      this.whatsappId,
      this.instagram,
      this.facebookId,
      this.twitter,
      this.username,
      this.spouseOccupation,
      this.spouseDob,
      this.spouseLastName,
      this.spouseFirstName,
      this.isAgree,
      this.isChildren,
      this.gender,
      this.educationQualification,
      this.address1,
      this.address2,
      this.landmark,
      this.postOffice,
      this.state,
      this.city,
      this.maritalStatus,
      this.designation,
      this.department,
      this.senior,
      this.totalCoins,
      this.langauge,
      this.location,
      this.branch,
      this.area,
      this.territory});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['user_id'];
    name = json['name'];
    username = json['username'];
    profileImage = json['profile_image'] != null ? json['profile_image'] : "";
    dateOfBirth = json['date_of_birth'] == null ? 0 : json['date_of_birth'];
    email = json['email'] != null ? json['email'] : "";
    mobileNo = json['mobile_no'] is String ? json['mobile_no'] : "";
    firmName = json['firm_name'] != null ? json['firm_name'] : "";
    alternateMobileNo = json['alternate_mobile_no'];
    whatsappId = json['whatsapp_id'];
    instagram = json['instagram'];
    facebookId = json['facebook_id'];
    twitter = json['twitter'];
    spouseOccupation = json['spouse_occupation'];
    spouseDob = json['spouse_dob'];
    spouseLastName = json['spouse_last_name'];
    spouseFirstName = json['spouse_first_name'];
    isAgree = json['is_agree'];
    isChildren = json['is_children'];
    gender = json['gender'];
    educationQualification = json['education_qualification'];
    address1 = json['Address1'];
    address2 = json['Address2'];
    landmark = json['landmark'];
    postOffice = json['post_office'];
    state = json['state'] is int ? json['state'].toString() : "";
    department = json['department'];
    totalCoins = json['total_coins'] != null ? json['total_coins'] : 0;
    designation = json['designation'];

    senior = json['senior'];

    langauge = json['mother_tongue'];

    location = json['base_location'];

    branch = json['branch'];

    area = json['asm_area'];

    territory = json['dse_territory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    data['date_of_birth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['firm_name'] = this.firmName;
    data['alternate_mobile_no'] = this.alternateMobileNo;
    data['whatsapp_id'] = this.whatsappId;
    data['instagram'] = this.instagram;
    data['facebook_id'] = this.facebookId;
    data['twitter'] = this.twitter;
    data['spouse_occupation'] = this.spouseOccupation;
    data['spouse_dob'] = this.spouseDob;
    data['spouse_last_name'] = this.spouseLastName;
    data['spouse_first_name'] = this.spouseFirstName;
    data['is_agree'] = this.isAgree;
    data['is_children'] = this.isChildren;
    data['gender'] = this.gender;
    data['education_qualification'] = this.educationQualification;
    data['Address1'] = this.address1;
    data['Address2'] = this.address2;
    data['landmark'] = this.landmark;
    data['post_office'] = this.postOffice;
    data['state'] = this.state;
    data['city'] = this.city;
    data['marital_status'] = this.maritalStatus;
    data['total_coins'] = this.totalCoins;
    data['department'] = this.department;
    data['designation'] = this.designation;
    data['branch'] = this.branch;
    data['asm_area'] = this.area;
    data['dse_territory'] = this.territory;
    data['base_location'] = this.location;
    data['mother_tongue'] = this.langauge;
    data['senior'] = this.senior;

    return data;
  }
}

class RelationData {
  String? relation;
  String? firstName;
  String? lastName;
  String? dob;
  String? mobileNo;
  String? occupation;
  String? email;

  RelationData(
      {this.relation,
      this.firstName,
      this.lastName,
      this.dob,
      this.mobileNo,
      this.email,
      this.occupation});

  RelationData.fromJson(Map<String, dynamic> json) {
    relation = json['relation'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'] is String
        ? json['dob']
        : Utility.convertDateFromMillis(json['dob'], "MM/dd/yyyy");
    mobileNo = json['mobile_no'];
    occupation = json['occupation'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relation'] = this.relation;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['mobile_no'] = this.mobileNo;
    data['occupation'] = this.occupation;
    data['email'] = this.email;
    return data;
  }
}

import 'dart:convert';

UserProfileResp userProfileRespFromJson(String str) =>
    UserProfileResp.fromJson(json.decode(str));

String userProfileRespToJson(UserProfileResp data) =>
    json.encode(data.toJson());

class UserProfileResp {
  UserProfileResp({
    this.status,
    this.data,
    this.error,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  Data? data;
  List<dynamic>? error;
  String? name;
  int? founded;
  List<String>? members;

  factory UserProfileResp.fromJson(Map<String, dynamic> json) =>
      UserProfileResp(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
        "error": error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  UserProfileData? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: UserProfileData.fromJson(json["list"]),
      );

  Map<String, dynamic> toJson() => {
        "list": list!.toJson(),
      };
}

class UserProfileData {
  UserProfileData({
    this.userId,
    this.name,
    this.profileImage,
    this.organizationId,
    this.dateOfBirth,
    this.email,
    this.username,
    this.gender,
    this.state,
    this.city,
    this.educationQualification,
    this.department,
    this.designation,
    this.dateOfJoining,
    this.mobileNo,
    this.alternateMobileNo,
    this.address1,
    this.address2,
    this.landmark,
    this.postOffice,
    this.organization,
  });

  int? userId;
  String? name;
  String? profileImage;
  int? organizationId;
  int? dateOfBirth;
  String? email;
  String? username;
  String? gender;
  String? state;
  String? city;
  String? educationQualification;
  String? department;
  String? designation;
  int? dateOfJoining;
  String? mobileNo;
  String? alternateMobileNo;
  String? address1;
  String? address2;
  String? landmark;
  String? postOffice;
  String? organization;

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      UserProfileData(
        userId: json["user_id"],
        name: json["name"],
        profileImage: json["profile_image"],
        organizationId: json["organization_id"],
        dateOfBirth: json["date_of_birth"],
        email: json["email"],
        username: json["username"],
        gender: json["gender"],
        state: json["state"],
        city: json["city"],
        educationQualification: json["education_qualification"],
        department: json["department"],
        designation: json["designation"],
        dateOfJoining: json["date_of_joining"],
        mobileNo: json["mobile_no"],
        alternateMobileNo: json["alternate_mobile_no"],
        address1: json["Address1"],
        address2: json["Address2"],
        landmark: json["landmark"],
        postOffice: json["post_office"],
        organization: json["organization"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "profile_image": profileImage,
        "organization_id": organizationId,
        "date_of_birth": dateOfBirth,
        "email": email,
        "username": username,
        "gender": gender,
        "state": state,
        "city": city,
        "education_qualification": educationQualification,
        "department": department,
        "designation": designation,
        "date_of_joining": dateOfJoining,
        "mobile_no": mobileNo,
        "alternate_mobile_no": alternateMobileNo,
        "Address1": address1,
        "Address2": address2,
        "landmark": landmark,
        "post_office": postOffice,
        "organization": organization,
      };
}

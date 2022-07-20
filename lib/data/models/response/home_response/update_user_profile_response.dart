// To parse this JSON data, do
//
//     final updateProfileImageResponse = updateProfileImageResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

UpdateProfileImageResponse updateProfileImageResponseFromJson(String str) =>
    UpdateProfileImageResponse.fromJson(json.decode(str));

String updateProfileImageResponseToJson(UpdateProfileImageResponse data) =>
    json.encode(data.toJson());

class UpdateProfileImageResponse {
  UpdateProfileImageResponse({
    this.status,
    this.data,
    this.message,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  Data? data;
  String? message;
  String? name;
  int? founded;
  List<String>? members;

  factory UpdateProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileImageResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
        "message": message == null ? null : message,
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.department,
    this.designation,
    this.mobileNo,
    this.profileImage,
    this.showInterest,
    this.categoryIds,
  });

  int? id;
  String? name;
  String? email;
  String? department;
  String? designation;
  String? mobileNo;
  String? profileImage;
  int? showInterest;
  String? categoryIds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        department: json["department"],
        designation: json["designation"],
        mobileNo: json["mobile_no"],
        profileImage: json["profile_image"],
        showInterest: json["show_interest"],
        categoryIds: json["category_ids"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "department": department,
        "designation": designation,
        "mobile_no": mobileNo,
        "profile_image": profileImage,
        "show_interest": showInterest,
        "category_ids": categoryIds,
      };
}

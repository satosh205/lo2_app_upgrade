// To parse this JSON data, do
//
//     final createPostResponse = createPostResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

CreatePostResponse createPostResponseFromJson(String str) =>
    CreatePostResponse.fromJson(json.decode(str));

String createPostResponseToJson(CreatePostResponse data) =>
    json.encode(data.toJson());

class CreatePostResponse {
  CreatePostResponse({
    this.status,
    this.message,
    this.data,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  String? message;
  Data? data;
  String? name;
  int? founded;
  List<String>? members;

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      CreatePostResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.id,
  });

  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

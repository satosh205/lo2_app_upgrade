// To parse this JSON data, do
//
//     final commentListResponse = commentListResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

CommentListResponse commentListResponseFromJson(String str) =>
    CommentListResponse.fromJson(json.decode(str));

String commentListResponseToJson(CommentListResponse data) =>
    json.encode(data.toJson());

class CommentListResponse {
  CommentListResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  List<CommentListElement>? data;
  List<dynamic>? error;

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      CommentListResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<CommentListElement>.from(json["data"].map((x) => CommentListElement.fromJson(x))),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "error": error == null ? null : List<dynamic>.from(error!.map((x) => x)),
      };
}

class CommentListElement {
  CommentListElement({
    this.id,
    this.joyContentId,
    this.userId,
    this.parentId,
    this.content,
    this.submitDate,
    this.createdAt,
    this.updatedAt,
    this.level,
    this.name,
    this.email,
    this.role,
    this.mobileNo,
    this.profileImage,
    this.organizationId,
    this.reply,
  });

  int? id;
  int? joyContentId;
  int? userId;
  dynamic parentId;
  String? content;
  int? submitDate;
  int? createdAt;
  int? updatedAt;
  int? level;
  String? name;
  String? email;
  String? role;
  String? mobileNo;
  String? profileImage;
  int? organizationId;
  List<dynamic>? reply;

  factory CommentListElement.fromJson(Map<String, dynamic> json) => CommentListElement(
        id: json["id"],
        joyContentId: json["joy_content_id"],
        userId: json["user_id"],
        parentId: json["parent_id"],
        content: json["content"],
        submitDate: json["submit_date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        level: json["level"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        mobileNo: json["mobile_no"],
        profileImage: json["profile_image"],
        organizationId: json["organization_id"],
        reply: List<dynamic>.from(json["reply"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "joy_content_id": joyContentId,
        "user_id": userId,
        "parent_id": parentId,
        "content": content,
        "submit_date": submitDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "level": level,
        "name": name,
        "email": email,
        "role": role,
        "mobile_no": mobileNo,
        "profile_image": profileImage,
        "organization_id": organizationId,
        "reply": List<dynamic>.from(reply!.map((x) => x)),
      };
}

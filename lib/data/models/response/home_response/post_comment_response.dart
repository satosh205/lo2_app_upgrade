import 'dart:convert';

PostCommentResponse postCommentResponseFromJson(String str) => PostCommentResponse.fromJson(json.decode(str));

String postCommentResponseToJson(PostCommentResponse data) => json.encode(data.toJson());

class PostCommentResponse {
    PostCommentResponse({
        this.status,
        this.message,
        this.name,
        this.founded,
        this.members,
    });

    int? status;
    String? message;
    String? name;
    int? founded;
    List<String>? members;

    factory PostCommentResponse.fromJson(Map<String, dynamic> json) => PostCommentResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null ? null : List<String>.from(json["members"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members": members == null ? null : List<dynamic>.from(members!.map((x) => x)),
    };
}




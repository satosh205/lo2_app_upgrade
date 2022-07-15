import 'dart:convert';

TopScoringUsersResponse topScoringUsersResponseFromJson(String str) =>
    TopScoringUsersResponse.fromJson(json.decode(str));

String topScoringUsersResponseToJson(TopScoringUsersResponse data) =>
    json.encode(data.toJson());

class TopScoringUsersResponse {
  TopScoringUsersResponse({
    this.status,
    this.data,
    this.message,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  List<TopScoringElement>? data;
  String? message;
  String? name;
  int? founded;
  List<String>? members;

  factory TopScoringUsersResponse.fromJson(Map<String, dynamic> json) =>
      TopScoringUsersResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<TopScoringElement>.from(
                json["data"].map((x) => TopScoringElement.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null ? null : message,
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class TopScoringElement {
  TopScoringElement({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.score,
  });

  int? id;
  String? name;
  String? email;
  String? profileImage;
  dynamic score;

  factory TopScoringElement.fromJson(Map<String, dynamic> json) =>
      TopScoringElement(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profile_image": profileImage,
        "score": score,
      };
}

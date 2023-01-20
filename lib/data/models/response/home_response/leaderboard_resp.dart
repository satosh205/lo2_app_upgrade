// To parse this JSON data, do
//
//     final leaderboardResponse = leaderboardResponseFromJson(jsonString);

import 'dart:convert';

LeaderboardResponse leaderboardResponseFromJson(String str) =>
    LeaderboardResponse.fromJson(json.decode(str));

String leaderboardResponseToJson(LeaderboardResponse data) =>
    json.encode(data.toJson());

class LeaderboardResponse {
  LeaderboardResponse({
    required this.status,
    required this.data,
    required this.error,
  });

  int status;
  List<Datum> data;
  List<dynamic> error;

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      LeaderboardResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": List<dynamic>.from(error.map((x) => x)),
      };
}

class Datum {
  Datum({
    required this.userId,
    this.gScore,
    required this.completionTime,
    required this.totalActivities,
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  int userId;
  dynamic gScore;
  String completionTime;
  int totalActivities;
  int id;
  String name;
  String email;
  String profileImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        gScore: json["g_score"],
        completionTime: json["completion_time"],
        totalActivities: json["total_activities"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "g_score": gScore,
        "completion_time": completionTime,
        "total_activities": totalActivities,
        "id": id,
        "name": name,
        "email": email,
        "profile_image": profileImage,
      };
}

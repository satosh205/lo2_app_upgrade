import 'dart:convert';

PortfolioCompetitionResponse portfolioCompetitionResponseFromJson(String str) =>
    PortfolioCompetitionResponse.fromJson(json.decode(str));

String portfolioCompetitionResponseToJson(PortfolioCompetitionResponse data) =>
    json.encode(data.toJson());

class PortfolioCompetitionResponse {
  PortfolioCompetitionResponse({
    required this.status,
    required this.data,
    required this.error,
  });

  int status;
  List<PortfolioCompetition> data;
  List<dynamic> error;

  factory PortfolioCompetitionResponse.fromJson(Map<String, dynamic> json) =>
      PortfolioCompetitionResponse(
        status: json["status"],
        data: List<PortfolioCompetition>.from(
            json["data"].map((x) => PortfolioCompetition.fromJson(x))),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": List<dynamic>.from(error.map((x) => x)),
      };
}

class PortfolioCompetition {
  PortfolioCompetition({
    required this.pId,
    required this.pName,
    required this.pImage,
    required this.uId,
    this.gScore,
    required this.completionTime,
    required this.totalActivities,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.rank,
    this.completedActivity,
    this.desc,
    this.startDate,
    this.competitionLevel,
    this.organizedBy,
  });

  int pId;
  String pName;
  String pImage;
  int uId;
  dynamic gScore;
  String completionTime;
  int totalActivities;
  String name;
  String email;
  String profileImage;
  int? rank;

  int? completedActivity;
  String? desc;
  String? startDate;
  String? competitionLevel;
  String? organizedBy;

  factory PortfolioCompetition.fromJson(Map<String, dynamic> json) =>
      PortfolioCompetition(
        pId: json["p_id"],
        pName: json["p_name"],
        pImage: json["p_image"],
        uId: json["u_id"],
        gScore: json["score"] ?? 0,
        completionTime: json["completion_time"],
        totalActivities: json["competition_contents"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        rank: json["rank"],
        completedActivity: json['total_activities'],
        desc: json['description'],
        startDate: json['start_date'],
        competitionLevel: json['competition_level'],
        organizedBy:
            json.containsKey('organized_by') ? json['organized_by'] : null,
      );

  Map<String, dynamic> toJson() => {
        "p_id": pId,
        "p_name": pName,
        "p_image": pImage,
        "u_id": uId,
        "score": gScore,
        "completion_time": completionTime,
        "total_activities": totalActivities,
        "name": name,
        "email": email,
        "profile_image": profileImage,
        "rank": rank,
        "competition_contents" : completedActivity,
"description" : desc,
"start_date" : startDate,
"competition_level" : competitionLevel,
"organized_by" :organizedBy ,
      };
}

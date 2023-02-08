import 'dart:convert';

CompetitionMyActivityResponse competitionMyActivityResponseFromJson(
        String str) =>
    CompetitionMyActivityResponse.fromJson(json.decode(str));

String competitionMyActivityResponseToJson(
        CompetitionMyActivityResponse data) =>
    json.encode(data.toJson());

class CompetitionMyActivityResponse {
  CompetitionMyActivityResponse({
    required this.status,
    required this.data,
    required this.error,
  });

  int status;
  List<CompetitionActivityElement> data;
  List<dynamic> error;

  factory CompetitionMyActivityResponse.fromJson(Map<String, dynamic> json) =>
      CompetitionMyActivityResponse(
        status: json["status"],
        data: List<CompetitionActivityElement>.from(
            json["data"].map((x) => CompetitionActivityElement.fromJson(x))),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error": List<dynamic>.from(error.map((x) => x)),
      };
}

class CompetitionActivityElement {
  CompetitionActivityElement(
      {required this.id,
      required this.name,
      required this.totalActivitiesCompleted,
      this.activityStatus,
      required this.pImage,
      required this.totalContents,
      this.desc,
      this.competitionLevel,
      this.organizedBy,
      this.starDate,
      this.endDate,
      this.gscore,
      this.totalCompeleted});

  int id;
  String name;
  int totalActivitiesCompleted;
  dynamic activityStatus;
  String pImage;
  int totalContents;
  String? desc;
  String? competitionLevel;
  String? organizedBy;
  String? starDate;
  String? endDate;
  int? gscore;
  int? totalCompeleted;

  factory CompetitionActivityElement.fromJson(Map<String, dynamic> json) =>
      CompetitionActivityElement(
          id: json["id"],
          name: json["name"],
          totalActivitiesCompleted: json["total_activities_completed"],
          activityStatus: json["activity_status"],
          pImage: json["p_image"],
          totalContents: json["total_contents"],
          desc: json['description'],
          competitionLevel: json['competition_level'],
          organizedBy: json['organized_by'],
          starDate: json['start_date'],
          endDate: json['end_date'],
          gscore: json['score'],
          totalCompeleted: json['total_activities_completed']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "total_activities_completed": totalActivitiesCompleted,
        "activity_status": activityStatus,
        "p_image": pImage,
        "total_contents": totalContents,
        "description" :desc ,
"competition_level" : competitionLevel,
"organized_by" : organizedBy,
"start_date" : starDate,
"end_date" : endDate,
"score" : gscore,

      };
}

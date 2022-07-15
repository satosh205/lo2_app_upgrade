// To parse this JSON data, do
//
//     final getCourseLeaderboardResp = getCourseLeaderboardRespFromJson(jsonString);

import 'dart:convert';

GetCourseLeaderboardResp getCourseLeaderboardRespFromJson(String str) =>
    GetCourseLeaderboardResp.fromJson(json.decode(str));

String getCourseLeaderboardRespToJson(GetCourseLeaderboardResp data) =>
    json.encode(data.toJson());

class GetCourseLeaderboardResp {
  GetCourseLeaderboardResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory GetCourseLeaderboardResp.fromJson(Map<String, dynamic> json) =>
      GetCourseLeaderboardResp(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "error": List<dynamic>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<ListElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.name,
    this.completion,
    this.score,
  });

  String? name;
  int? completion;
  String? score;

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      ListElement(
        name: json["name"],
        completion: json["completion"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "completion": completion,
        "score": score,
      };
}

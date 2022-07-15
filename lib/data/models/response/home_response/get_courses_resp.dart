// To parse this JSON data, do
//
//     final getCoursesResp = getCoursesRespFromJson(jsonString);

import 'dart:convert';

GetCoursesResp getCoursesRespFromJson(String str) =>
    GetCoursesResp.fromJson(json.decode(str));

String getCoursesRespToJson(GetCoursesResp data) => json.encode(data.toJson());

class GetCoursesResp {
  GetCoursesResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<String>? error;

  factory GetCoursesResp.fromJson(Map<String, dynamic> json) => GetCoursesResp(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<String>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "error": List<String>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<ListElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.id,
    this.name,
    this.level,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.completion,
  });

  int? id;
  String? name;
  String? level;
  String? description;
  String? image;
  int? startDate;
  int? endDate;
  int? completion;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        name: json["name"],
        level: json["level"],
        description: json["description"] == null ? null : json["description"],
        image: json["image"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        completion: json["completion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "level": level,
        "description": description == null ? null : description,
        "image": image,
        "start_date": startDate,
        "end_date": endDate,
        "completion": completion,
      };
}

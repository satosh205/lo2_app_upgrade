// To parse this JSON data, do
//
//     final getCourseModulesResp = getCourseModulesRespFromJson(jsonString);

import 'dart:convert';

GetCourseModulesResp getCourseModulesRespFromJson(String str) =>
    GetCourseModulesResp.fromJson(json.decode(str));

String getCourseModulesRespToJson(GetCourseModulesResp data) =>
    json.encode(data.toJson());

class GetCourseModulesResp {
  GetCourseModulesResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<String>? error;

  factory GetCourseModulesResp.fromJson(Map<String, dynamic> json) =>
      GetCourseModulesResp(
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
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.durationInDays,
    this.image,
    this.completion,
    this.score,
    this.modules,
    this.totalModules,
  });

  String? id;
  String? name;
  int? startDate;
  int? endDate;
  String? description;
  int? durationInDays;
  String? image;
  int? completion;
  String? score;
  List<Module>? modules;
  int? totalModules;

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      ListElement(
        id: json["id"].toString(),
        name: json["name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        description: json["description"],
        durationInDays: json["duration_in_days"],
        image: json["image"],
        completion: json["completion"],
        score: json["score"],
        modules:json["modules"]!=null? List<Module>.from(json["modules"].map((x) => Module.fromJson(x))):null,
        totalModules: json["total_modules"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "start_date": startDate,
        "end_date": endDate,
        "description": description,
        "duration_in_days": durationInDays,
        "image": image,
        "completion": completion,
        "score": score,
        "modules": List<dynamic>.from(modules!.map((x) => x.toJson())),
        "total_modules": totalModules,
      };
}

class Module {
  Module({
    this.id,
    this.name,
    this.image,
    this.startDate,
    this.endDate,
    this.description,
    this.durationInDays,
    this.completion,
    this.url,
  });

  int? id;
  String? name;
  String? image;
  int? startDate;
  int? endDate;
  String? description;
  int? durationInDays;
  dynamic completion;
  String? url;

  factory Module.fromJson(Map<String, dynamic> json) =>
      Module(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        description: json["description"],
        durationInDays: json["duration_in_days"],
        completion: json["completion"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "image": image,
        "start_date": startDate,
        "end_date": endDate,
        "description": description,
        "duration_in_days": durationInDays,
        "completion": completion,
        "url": url,
      };
}

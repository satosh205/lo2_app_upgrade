// To parse this JSON data, do
//
//     final liveClassResp = liveClassRespFromJson(jsonString);

import 'dart:convert';

GetLiveClassListResp liveClassRespFromJson(String str) =>
    GetLiveClassListResp.fromJson(json.decode(str));

String liveClassRespToJson(GetLiveClassListResp data) =>
    json.encode(data.toJson());

class GetLiveClassListResp {
  GetLiveClassListResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory GetLiveClassListResp.fromJson(Map<String, dynamic> json) =>
      GetLiveClassListResp(
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
  ListElement({this.programContentId,
    this.title,
    this.description,
    this.startDate,
    this.durationInMinutes,
    this.liveclassAction,
    this.liveclassUrl,
    this.startsInMinutes,
    this.liveclassDescription,
    this.isAttended,
    this.isLive,
    this.url,
    this.status});

  int? programContentId;
  String? title;
  String? description;
  int? startDate;
  int? durationInMinutes;
  String? liveclassAction;
  String? liveclassUrl;
  int? startsInMinutes;
  String? liveclassDescription;
  bool? isAttended;
  bool? isLive;
  String? status;
  String? url;

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      ListElement(
          programContentId: json["program_content_id"],
          title: json["title"],
          description: json["description"],
          startDate: json["start_date"],
          durationInMinutes: json["duration_in_minutes"],
          liveclassAction: json["liveclass_action"],
          liveclassUrl: json["liveclass_url"],
          startsInMinutes: json["starts_in_minutes"],
          liveclassDescription: json["liveclass_description"],
          isAttended: json["is_attended"],
          isLive: json["is_live"],
          url: json["url"],
          status: json['status']);

  Map<String, dynamic> toJson() =>
      {
        "program_content_id": programContentId,
        "title": title,
        "description": description,
        "start_date": startDate,
        "duration_in_minutes": durationInMinutes,
        "liveclass_action": liveclassAction,
        "liveclass_url": liveclassUrl,
        "starts_in_minutes": startsInMinutes,
        "liveclass_description": liveclassDescription,
        "is_attended": isAttended,
        "is_live": isLive,
        "url": url,
        'status': status
      };
}

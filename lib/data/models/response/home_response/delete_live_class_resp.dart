// To parse this JSON data, do
//
//     final deleteLiveClassResp = deleteLiveClassRespFromJson(jsonString);

import 'dart:convert';

DeleteLiveClassResp deleteLiveClassRespFromJson(String str) => DeleteLiveClassResp.fromJson(json.decode(str));

String deleteLiveClassRespToJson(DeleteLiveClassResp data) => json.encode(data.toJson());

class DeleteLiveClassResp {
  DeleteLiveClassResp({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory DeleteLiveClassResp.fromJson(Map<String, dynamic> json) => DeleteLiveClassResp(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}

// To parse this JSON data, do
//
//     final reportContentResp = reportContentRespFromJson(jsonString);

import 'dart:convert';

ReportContentResp reportContentRespFromJson(String str) =>
    ReportContentResp.fromJson(json.decode(str));

String reportContentRespToJson(ReportContentResp data) =>
    json.encode(data.toJson());

class ReportContentResp {
  ReportContentResp({
    this.status,
    this.data,
    this.message,
    this.error,
  });

  int? status;
  List<dynamic>? data;
  String? message;
  List<dynamic>? error;

  factory ReportContentResp.fromJson(Map<String, dynamic> json) =>
      ReportContentResp(
        status: json["status"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        message: json["message"],
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x)),
        "message": message,
        "error": List<dynamic>.from(error!.map((x) => x)),
      };
}

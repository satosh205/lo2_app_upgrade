import 'dart:convert';

ReportContentResp reportContentRespFromJson(String str) =>
    ReportContentResp.fromJson(json.decode(str));

String reportContentRespToJson(ReportContentResp data) =>
    json.encode(data.toJson());

class ReportContentResp {
  ReportContentResp({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory ReportContentResp.fromJson(Map<String, dynamic> json) =>
      ReportContentResp(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

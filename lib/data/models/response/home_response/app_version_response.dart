import 'dart:convert';

AppVersionResp appVersionRespFromJson(String str) =>
    AppVersionResp.fromJson(json.decode(str));

String appVersionRespToJson(AppVersionResp data) => json.encode(data.toJson());

class AppVersionResp {
  AppVersionResp({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory AppVersionResp.fromJson(Map<String, dynamic> json) => AppVersionResp(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "error": List<dynamic>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.deviceType,
    this.latestVersion,
    this.updateType,
  });

  int? deviceType;
  String? latestVersion;
  int? updateType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        deviceType: json["device_type"],
        latestVersion: json["latest_version"],
        updateType: json["update_type"],
      );

  Map<String, dynamic> toJson() => {
        "device_type": deviceType,
        "latest_version": latestVersion,
        "update_type": updateType,
      };
}

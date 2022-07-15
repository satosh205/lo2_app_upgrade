import 'dart:convert';

MapInterestResponse mapInterestResponseFromJson(String str) =>
    MapInterestResponse.fromJson(json.decode(str));

String mapInterestResponseToJson(MapInterestResponse data) =>
    json.encode(data.toJson());

class MapInterestResponse {
  MapInterestResponse({
    this.status,
    this.data,
    this.error,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  List<String>? data;
  List<dynamic>? error;
  String? name;
  int? founded;
  List<String>? members;

  factory MapInterestResponse.fromJson(Map<String, dynamic> json) =>
      MapInterestResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<String>.from(json["data"].map((x) => x)),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        founded: json["founded"] == null ? null : json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
        "error": error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

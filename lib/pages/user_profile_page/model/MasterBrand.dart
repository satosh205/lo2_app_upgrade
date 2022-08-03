/*class MasterBrand {
  String? id;

  MasterBrand({
    this.id
  });

  factory MasterBrand.fromJson(Map<String, dynamic> parsedJson) {
    return MasterBrand(
      id: parsedJson['id'] as String,
    );
  }
}*/

// To parse this JSON data, do
//
//     final masterBrand = masterBrandFromJson(jsonString);

import 'dart:convert';

MasterBrandResponse masterBrandFromJson(String str) => MasterBrandResponse.fromJson(json.decode(str));

String masterBrandToJson(MasterBrandResponse data) => json.encode(data.toJson());

class MasterBrandResponse {
  MasterBrandResponse({
    this.status,
    this.data,
    this.message,
    this.error,
  });

  int? status;
  Data? data;
  String? message;
  List<dynamic>? error;

  factory MasterBrandResponse.fromJson(Map<String, dynamic> json) => MasterBrandResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
    error: List<dynamic>.from(json["error"].map((x) => x)),
  );

  /*factory CreatePortfolioResponse.fromJson(Map<String, dynamic> json) => CreatePortfolioResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),

  );*/

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
    "message": message,
    "error": List<dynamic>.from(error!.map((x) => x)),
  };
}

class Data {
  Data({
    this.id,
  });

  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}

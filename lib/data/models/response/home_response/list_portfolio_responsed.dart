

import 'dart:convert';


ListPortfolioResponse listPortfolioResponseFromJson(String str) =>
    ListPortfolioResponse.fromJson(json.decode(str));

String listPortfolioResponseToJson(ListPortfolioResponse data) =>
    json.encode(data.toJson());

class ListPortfolioResponse {
  ListPortfolioResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;


  factory ListPortfolioResponse.fromJson(Map<String, dynamic> json) =>
      ListPortfolioResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data!.toJson(),
        "error": error == null ? null : List<dynamic>.from(error!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<PortfolioElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<PortfolioElement>.from(
            json["list"].map((x) => PortfolioElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class PortfolioElement {
  PortfolioElement({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  int? id;
  int? userId;
  String? title;
  String? description;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;

  factory PortfolioElement.fromJson(Map<String, dynamic> json) =>
      PortfolioElement(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "image": image,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "type": type,
      };
}

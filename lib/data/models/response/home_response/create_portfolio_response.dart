import 'dart:convert';

CreatePortfolioResponse createPortfolioResponseFromJson(String str) => CreatePortfolioResponse.fromJson(json.decode(str));

String createPortfolioResponseToJson(CreatePortfolioResponse data) => json.encode(data.toJson());



class CreatePortfolioResponse {
  CreatePortfolioResponse({
    this.status,
    this.message,
    this.data,

  });

  int? status;
  String? message;
  Data? data;


  factory CreatePortfolioResponse.fromJson(Map<String, dynamic> json) => CreatePortfolioResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),

  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),

  };
}

class Data {
  Data({
    this.title,
    this.description,
    this.image,
    this.userId,
    this.type,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? title;
  String? description;
  String? image;
  int? userId;
  String? type;
  String? updatedAt;
  String? createdAt;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    description: json["description"],
    image: json["image"],
    userId: json["user_id"],
    type: json["type"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
    "user_id": userId,
    "type": type,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
}
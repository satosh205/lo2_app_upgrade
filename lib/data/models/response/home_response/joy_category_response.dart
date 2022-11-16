import 'dart:convert';

JoyCategoryResponse joyCategoryResponseFromJson(String str) =>
    JoyCategoryResponse.fromJson(json.decode(str));

String joyCategoryResponseToJson(JoyCategoryResponse data) =>
    json.encode(data.toJson());

class JoyCategoryResponse {
  JoyCategoryResponse({
    this.status,
    this.data,
    this.error,
    this.name,
    this.founded,
    this.members,
  });

  int? status;
  Data? data;
  List<dynamic>? error;
  String? name;
  int? founded;
  List<String>? members;

  factory JoyCategoryResponse.fromJson(Map<String, dynamic> json) =>
      JoyCategoryResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
        "data": data == null ? null : data!.toJson(),
        "error": error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name == null ? null : name,
        "founded": founded == null ? null : founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.list,
  });

  List<ListElement>? list;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  ListElement({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.status,
    this.sectionType,
    this.image,
    this.isSelected,
    this.video,
    this.parentId,
  });

  int? id;
  String? title;
  String? description;
  int? createdAt;
  int? createdBy;
  int? updatedAt;
  int? updatedBy;
  String? status;
  int? sectionType;
  String? image;
  int? isSelected;
  String? video;
  int? parentId;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      createdAt: json["created_at"],
      createdBy: json["created_by"],
      updatedAt: json["updated_at"],
      updatedBy: json["updated_by"],
      status: json["status"],
      sectionType: json["section_type"],
      image: json["image"],
      isSelected: json["is_selected"],
      video: json['video'],
      parentId: json['parent_id']
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt,
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "status": status,
        "section_type": sectionType,
        "image": image,
        "is_selected": isSelected,
        "video": video,
        "parent_id" : parentId
      };
}

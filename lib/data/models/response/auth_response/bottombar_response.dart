import 'dart:convert';

BottomBarResponse bottomBarResponseFromJson(String str) =>
    BottomBarResponse.fromJson(json.decode(str));

String bottomBarResponseToJson(BottomBarResponse data) =>
    json.encode(data.toJson());

class BottomBarResponse {
  BottomBarResponse({
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

  factory BottomBarResponse.fromJson(Map<String, dynamic> json) =>
      BottomBarResponse(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
        name: json["name"],
        founded: json["founded"],
        members: json["members"] == null
            ? null
            : List<String>.from(json["members"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "error":
            error == null ? null : List<dynamic>.from(error!.map((x) => x)),
        "name": name,
        "founded": founded,
        "members":
            members == null ? null : List<dynamic>.from(members!.map((x) => x)),
      };
}

class Data {
  Data({
    this.menu,
  });

  List<Menu>? menu;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu": List<dynamic>.from(menu!.map((x) => x.toJson())),
      };
}

class Menu {
  Menu({
    this.order,
    this.url,
    this.linkType,
    this.image,
    this.isChecked,
    this.isCheckedMobile,
    this.label,
    this.role,
  });

  String? order;
  String? url;
  int? linkType;
  String? image;
  int? isChecked;
  int? isCheckedMobile;
  String? label;
  String? role;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        order: json["order"],
        url: json["url"],
        linkType: json["link_type"],
        image: json["image"],
        isChecked: json["is_checked"],
        isCheckedMobile: json["is_checked_mobile"],
        label: json["label"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "order": order,
        "url": url,
        "link_type": linkType,
        "image": image,
        "is_checked": isChecked,
        "is_checked_mobile": isCheckedMobile,
        "label": label,
        "role": role,
      };
}

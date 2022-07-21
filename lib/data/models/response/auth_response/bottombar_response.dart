import 'dart:convert';

import 'package:flutter/foundation.dart';

BottomBarResponse bottomBarResponseFromJson(String str) =>
    BottomBarResponse.fromJson(json.decode(str));

String bottomBarResponseToJson(BottomBarResponse data) =>
    json.encode(data.toJson());

class BottomBarResponse {
  BottomBarResponse({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Data? data;
  List<dynamic>? error;

  factory BottomBarResponse.fromJson(Map<String, dynamic> json) =>
      BottomBarResponse(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : List<dynamic>.from(json["error"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "error":
            error == null ? null : List<dynamic>.from(error!.map((x) => x)),
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
  Menu(
      {this.order,
      this.url,
      this.linkType,
      this.image,
      this.isChecked,
      this.isCheckedMobile,
      this.label,
      this.role,
      this.inAppOrder});

  String? order;
  String? url;
  int? linkType;
  String? image;
  int? isChecked;
  int? isCheckedMobile;
  String? label;
  String? role;
  String? inAppOrder;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        order: json["order"],
        url: json["url"],
        linkType: json["link_type"],
        image: json["image"],
        isChecked: json["is_checked"],
        isCheckedMobile: json["is_checked_mobile"],
        label: json["label"],
        role: json["role"],
        inAppOrder: json["in_app_order"],
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
        "order_in_app": inAppOrder,
      };
}

class MenuListProvider extends ChangeNotifier {
  List<Menu>? _list = [];
  List<Menu>? get list => _list;
  MenuListProvider(List<Menu> list) {
    if (list.length > 0) this._list = list;
    notifyListeners();
  }

  void updateList(List<Menu> newData) {
    this._list!.addAll(newData);
    notifyListeners();
  }

  void refreshList(List<Menu> list) {
    this._list = list;
    notifyListeners();
  }

  List<Menu>? getList() {
    return this._list;
  }
}

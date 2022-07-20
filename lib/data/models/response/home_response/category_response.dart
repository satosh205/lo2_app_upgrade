import 'dart:convert' as converter;

class CategoryResp {
  int? status;
  Data? data;
  List<String>? error;

  CategoryResp({this.status, this.data, this.error});

  CategoryResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? new Data.fromJson((json['data'] is String)
            ? converter.json.decode(json['data'])
            : json['data'])
        : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = converter.json.encode(this.data!.toJson()).toString();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  List<CategoryData>? listData;

  Data({this.listData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listData = <CategoryData>[];
      json['list'].forEach((v) {
        listData!.add(new CategoryData.fromJson(
            (v is String) ? converter.json.decode(v) : v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listData != null) {
      data['list'] = this
          .listData!
          .map((v) => converter.json.encode(v.toJson()).toString())
          .toList();
    }
    return data;
  }
}

class CategoryData {
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

  CategoryData(
      {this.id,
      this.title,
      this.description,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.sectionType,
      this.image});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    status = json['status'];
    sectionType = json['section_type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['section_type'] = this.sectionType;
    data['image'] = this.image;
    return data;
  }
}

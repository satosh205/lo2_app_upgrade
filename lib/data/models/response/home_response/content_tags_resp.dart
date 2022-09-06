class ContentTagsResp {
  int? status;
  Data? data;
  List<String>? error;

  ContentTagsResp({this.status, this.data, this.error});

  ContentTagsResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  List<ListTags>? listTags;

  Data({this.listTags});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listTags = <ListTags>[];
      json['list'].forEach((v) {
        listTags?.add(new ListTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listTags != null) {
      data['list'] = this.listTags?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTags {
  int? id;
  String? name;
  int? organizationId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  ListTags(
      {this.id,
      this.name,
      this.organizationId,
      this.categoryId,
      this.createdAt,
      this.updatedAt});

  ListTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    organizationId = json['organization_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['organization_id'] = this.organizationId;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class NotificationResp {
  int? status;
  Data? data;
  List<String>? error;

  NotificationResp({this.status, this.data, this.error});

  NotificationResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['error'] != null) {
      error = <String>[];
      json['error'].forEach((v) {
        error!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v).toList();
    }
    return data;
  }
}

class Data {
  List<ListData>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListData>[];
      json['list'].forEach((v) {
        list!.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? id;
  String? title;
  String? description;
  String? contentType;
  String? contentTypeId;
  int? categoryId;
  String? category;
  String? createdAt;

  ListData(
      {this.id,
      this.title,
      this.description,
      this.contentType,
      this.contentTypeId,
      this.categoryId,
      this.category,
      this.createdAt});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    contentType = json['content_type'];
    contentTypeId = json['content_type_id'];
    categoryId = json['category_id'];
    category = json['category'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content_type'] = this.contentType;
    data['content_type_id'] = this.contentTypeId;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['created_at'] = this.createdAt;
    return data;
  }
}


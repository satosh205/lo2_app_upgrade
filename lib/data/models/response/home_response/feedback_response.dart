class FeedbackResp {
  int? status;
  Data? data;
  List<String>? error;

  FeedbackResp({this.status, this.data, this.error});

  FeedbackResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['error'] != null) {
      error = <String>[];
      json['error'].forEach((v) {
        error?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
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
        list?.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? id;
  String? title;
  String? description;
  int? organizationId;
  String? file;
  String? topic;
  int? createdAt;
  int? updatedAt;
  String? type;

  ListData(
      {this.id,
      this.title,
      this.description,
      this.organizationId,
      this.file,
      this.topic,
      this.createdAt,
      this.updatedAt,
      this.type});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    organizationId = json['organization_id'];
    file = json['file'];
    topic = json['topic'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['organization_id'] = this.organizationId;
    data['file'] = this.file;
    data['topic'] = this.topic;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    return data;
  }
}

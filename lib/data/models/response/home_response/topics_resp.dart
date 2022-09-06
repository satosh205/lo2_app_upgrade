class TopicsResp {
  int? status;
  Data? data;
  List<String>? error;

  TopicsResp({this.status, this.data, this.error});

  TopicsResp.fromJson(Map<String, dynamic> json) {
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
  List<ListTopics>? listTopics;

  Data({this.listTopics});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listTopics = <ListTopics>[];
      json['list'].forEach((v) {
        listTopics?.add(new ListTopics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listTopics != null) {
      data['list'] = this.listTopics?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListTopics {
  int? id;
  String? title;
  String? description;

  ListTopics({this.id, this.title, this.description});

  ListTopics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

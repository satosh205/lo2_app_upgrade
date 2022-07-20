class LanguageResponse {
  int? status;
  Data? data;
  List<String>? error;

  LanguageResponse({this.status, this.data, this.error});

  LanguageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  List<ListData>? listData;

  Data({this.listData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listData = <ListData>[];
      json['list'].forEach((v) {
        listData!.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listData != null) {
      data['list'] = this.listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? id;
  int? organizationId;
  String? name;
  String? englishName;
  int? languageId;
  String? createdAt;
  String? updatedAt;

  ListData(
      {this.id,
      this.organizationId,
      this.name,
      this.languageId,
      this.createdAt,
      this.englishName,
      this.updatedAt});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    name = json['name'];
    englishName = json['english_name'];
    languageId = json['language_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['english_name'] = this.englishName;
    data['language_id'] = this.languageId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class MasterLanguageResponse {
  int? status;
  Data? data;
  List<String>? error;

  MasterLanguageResponse({this.status, this.data, this.error});

  MasterLanguageResponse.fromJson(Map<String, dynamic> json) {
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
  List<ListLanguage>? listData;

  Data({this.listData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listData = <ListLanguage>[];
      json['list'].forEach((v) {
        listData!.add(new ListLanguage.fromJson(v));
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

class ListLanguage {
  int? id;
  int? languageId;
  int? organizationId;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? englishName;
  String? languageCode;

  ListLanguage(
      {this.id,
      this.languageId,
      this.organizationId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.englishName,
      this.languageCode});

  ListLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageId = json['language_id'];
    organizationId = json['organization_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    englishName = json['english_name'];
    languageCode = json['language_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_id'] = this.languageId;
    data['organization_id'] = this.organizationId;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['english_name'] = this.englishName;
    data['language_code'] = this.languageCode;
    return data;
  }
}

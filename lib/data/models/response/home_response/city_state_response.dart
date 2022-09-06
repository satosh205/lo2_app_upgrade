import 'dart:convert' as converter;

class CityStateResp {
  int? status;
  Data? data;
  List<String>? error;

  CityStateResp({this.status, this.data, this.error});

  CityStateResp.fromJson(Map<String, dynamic> json) {
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
      data['data'] = converter.json.encode(this.data?.toJson()).toString();
    }
    data['error'] = this.error;
    return data;
  }
}

class Data {
  List<CityStateData>? listData;

  Data({this.listData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      listData = <CityStateData>[];
      json['list'].forEach((v) {
        listData?.add(new CityStateData.fromJson(
            (v is String) ? converter.json.decode(v) : v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listData != null) {
      data['list'] = this
          .listData
          ?.map((v) => converter.json.encode(v.toJson()).toString())
          .toList();
    }
    return data;
  }
}

class CityStateData {
  int? id;
  String? label;

  CityStateData({this.id, this.label});

  CityStateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class UserAnalyticsResp {
  int? status;
  List<UserAnalyticsData>? data;
  List<String>? error;

  UserAnalyticsResp({this.status, this.data, this.error});

  UserAnalyticsResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UserAnalyticsData>[];
      json['data'].forEach((v) {
        data!.add(new UserAnalyticsData.fromJson(v));
      });
    }
    if (json['error'] != null) {
      error = <Null>[] as List<String>?;
      json['error'].forEach((v) {
        error!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v).toList();
    }
    return data;
  }
}

class UserAnalyticsData {
  int? order;
  String? label;
  String? value;

  UserAnalyticsData({this.order, this.label, this.value});

  UserAnalyticsData.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

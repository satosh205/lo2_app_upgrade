class CoinHistoryResponse {
  int? status;
  Data? data;
  List<String>? error;

  CoinHistoryResponse({this.status, this.data, this.error});

  CoinHistoryResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? balance;
  int? activityId;
  String? activityCode;
  int? coins;
  String? activityType;
  String? reasons;
  int? createdAt;
  int? updatedAt;

  ListData(
      {this.id,
      this.userId,
      this.balance,
      this.activityId,
      this.activityCode,
      this.coins,
      this.activityType,
      this.reasons,
      this.createdAt,
      this.updatedAt});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    activityId = json['activity_id'];
    activityCode = json['activity_code'];
    coins = json['coins'];
    activityType = json['activity_type'];
    reasons = json['reasons'];
    createdAt = json['created_at'] is int ? json['created_at'] : 0;
    updatedAt = json['updated_at'] is int ? json['updated_at'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['balance'] = this.balance;
    data['activity_id'] = this.activityId;
    data['activity_code'] = this.activityCode;
    data['coins'] = this.coins;
    data['activity_type'] = this.activityType;
    data['reasons'] = this.reasons;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

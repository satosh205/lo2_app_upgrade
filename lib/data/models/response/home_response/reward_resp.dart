class GetRewardsResponse {
  int? status;
  Data? data;
  List<String>? error;

  GetRewardsResponse({this.status, this.data, this.error});

  GetRewardsResponse.fromJson(Map<String, dynamic> json) {
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
  int? coins;
  String? startDate;
  String? endDate;
  int? visibility;
  int? visibilityValue;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? redeemStatus;

  String? rewardIcon;
  String? rewardImage;

  ListData(
      {this.id,
      this.title,
      this.description,
      this.coins,
      this.startDate,
      this.rewardIcon,
      this.rewardImage,
      this.endDate,
      this.visibility,
      this.visibilityValue,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.redeemStatus});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coins = json['coins'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    visibility = json['visibility'];
    visibilityValue = json['visibility_value'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    redeemStatus = json['redeem_status'];
    rewardImage = json['reward_image'];
    rewardIcon = json['reward_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coins'] = this.coins;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['visibility'] = this.visibility;
    data['visibility_value'] = this.visibilityValue;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['redeem_status'] = this.redeemStatus;

    return data;
  }
}

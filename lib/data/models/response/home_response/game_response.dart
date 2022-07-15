class GameResponse {
  int? status;
  Data? data;
  List<String>? error;

  GameResponse({this.status, this.data, this.error});

  GameResponse.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  int? coins;
  String? image;
  String? startDate;
  String? endDate;
  String? visibility;
  String? visibilityValue;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? gameUrl;

  ListData(
      {this.id,
      this.title,
      this.description,
      this.coins,
      this.image,
      this.startDate,
      this.endDate,
      this.visibility,
      this.visibilityValue,
      this.status,
      this.gameUrl,
      this.createdAt,
      this.updatedAt});

  ListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coins = json['coins'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    visibility = json['visibility'];
    visibilityValue = json['visibility_value'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gameUrl = json['game_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['coins'] = this.coins;
    data['image'] = this.image;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['visibility'] = this.visibility;
    data['visibility_value'] = this.visibilityValue;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['game_url'] = this.gameUrl;
    return data;
  }
}

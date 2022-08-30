class TrainingProgramsResponse {
  int? status;
  Data? data;
  List<String>? error;

  TrainingProgramsResponse({this.status, this.data, this.error});

  TrainingProgramsResponse.fromJson(Map<String, dynamic> json) {
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
  List<Program>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Program>[];
      json['list'].forEach((v) {
        list?.add(new Program.fromJson(v));
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

class Program {
  int? id;
  String? name;
  String? level;
  String? description;
  String? image;
  int? startDate;
  int? endDate;
  String? url;
  int? completion;

  Program(
      {this.id,
      this.name,
      this.level,
      this.description,
      this.image,
      this.startDate,
      this.endDate,
      this.url,
      this.completion});

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    description = json['description'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    url = json['url'];
    completion = json['completion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['level'] = this.level;
    data['description'] = this.description;
    data['image'] = this.image;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['url'] = this.url;
    data['completion'] = this.completion;
    return data;
  }
}

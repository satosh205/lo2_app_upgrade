class TrainingDetailResponse {
  int? status;
  Data? data;
  List<String>? error;

  TrainingDetailResponse({this.status, this.data, this.error});

  TrainingDetailResponse.fromJson(Map<String, dynamic> json) {
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
  List<DetailProgram>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <DetailProgram>[];
      json['list'].forEach((v) {
        list!.add(new DetailProgram.fromJson(v));
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

class DetailProgram {
  Object? id;
  String? name;
  int? startDate;
  int? endDate;
  String? description;
  int? durationInDays;
  String? image;
  Object? completion;
  List<Modules>? modules;
  int? totalModules;

  DetailProgram(
      {this.id,
      this.name,
      this.startDate,
      this.endDate,
      this.description,
      this.durationInDays,
      this.image,
      this.completion,
      this.modules,
      this.totalModules});

  DetailProgram.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    durationInDays = json['duration_in_days'];
    image = json['image'];
    completion = json['completion'];
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add(new Modules.fromJson(v));
      });
    }
    totalModules = json['total_modules'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['duration_in_days'] = this.durationInDays;
    data['image'] = this.image;
    data['completion'] = this.completion;
    if (this.modules != null) {
      data['modules'] = this.modules!.map((v) => v.toJson()).toList();
    }
    data['total_modules'] = this.totalModules;
    return data;
  }
}

class Modules {
  int? id;
  String? name;
  String? image;
  int? startDate;
  int? endDate;
  String? description;
  int? durationInDays;
  Object? completion;
  String? url;

  Modules(
      {this.id,
      this.name,
      this.image,
      this.startDate,
      this.endDate,
      this.description,
      this.durationInDays,
      this.completion,
      this.url});

  Modules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    durationInDays = json['duration_in_days'];
    completion = json['completion'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['duration_in_days'] = this.durationInDays;
    data['completion'] = this.completion;
    data['url'] = this.url;
    return data;
  }
}

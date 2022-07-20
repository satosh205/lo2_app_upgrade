import 'package:flutter/material.dart';

class onBoardSessions {
  int? status;
  Data? data;
  List<dynamic>? error;

  onBoardSessions({this.status, this.data, this.error});

  onBoardSessions.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['error'] != null) {
      error = List<dynamic>.from(json["error"].map((x) => x));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.error != null) {
      data['error'] = List<dynamic>.from(error!.map((x) => x));
    }
    return data;
  }
}

class Data {
  Modules? modules;

  Data({this.modules});

  Data.fromJson(Map<String, dynamic> json) {
    modules =
        json['modules'] != null ? new Modules.fromJson(json['modules']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.modules != null) {
      data['modules'] = this.modules!.toJson();
    }
    return data;
  }
}

class Modules {
  List<Liveclass>? liveclass;

  Modules({this.liveclass});

  Modules.fromJson(Map<String, dynamic> json) {
    if (json['liveclass'] != null) {
      liveclass = <Liveclass>[];
      json['liveclass'].forEach((v) {
        liveclass!.add(new Liveclass.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.liveclass != null) {
      data['liveclass'] = this.liveclass!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Liveclass extends ChangeNotifier {
  int? id;
  String? contentType;
  String? name;
  String? description;
  int? duration;
  int? fromDate;
  String? zoomUrl;
  String? zoomPasskey;
  String? url;
  String? callToAction;
  int? endDate;
  String? liveclassStatus;
  String? startTime;
  String? endTime;
  String? passkey;
  String? trainerName;

  Liveclass(
      {this.id,
      this.contentType,
      this.name,
      this.description,
      this.duration,
      this.fromDate,
      this.zoomUrl,
      this.zoomPasskey,
      this.url,
      this.callToAction,
      this.endDate,
      this.liveclassStatus,
      this.startTime,
      this.endTime,
      this.passkey,
      this.trainerName});

  Liveclass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentType = json['content_type'];
    name = json['name'];
    description = json['description'];
    duration = json['duration'];
    fromDate = json['from_date'];
    zoomUrl = json['zoom_url'];
    zoomPasskey = json['zoom_passkey'];
    url = json['url'];
    callToAction = json['call_to_action'];
    endDate = json['end_date'];
    liveclassStatus = json['liveclass_status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    passkey = json['passkey'];
    trainerName = json['trainer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_type'] = this.contentType;
    data['name'] = this.name;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['from_date'] = this.fromDate;
    data['zoom_url'] = this.zoomUrl;
    data['zoom_passkey'] = this.zoomPasskey;
    data['url'] = this.url;
    data['call_to_action'] = this.callToAction;
    data['end_date'] = this.endDate;
    data['liveclass_status'] = this.liveclassStatus;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['passkey'] = this.passkey;
    data['trainer_name'] = this.trainerName;
    return data;
  }
}

class LiveclassModel extends ChangeNotifier {
  List<Liveclass>? liveclass = [];
  List<Liveclass>? get list => liveclass;

  LiveclassModel(List<Liveclass>? liveclass) {
    this.liveclass = liveclass;
    notifyListeners();
  }

 

  void refreshList(List<Liveclass>? list) {
    this.liveclass = list;
    notifyListeners();
  }
}

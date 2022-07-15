class AppVersionResp {
  int? status;
  Data? data;
  List<String>? error;

  AppVersionResp({this.status, this.data, this.error});

  AppVersionResp.fromJson(Map<String, dynamic> json) {
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
  int? deviceType;
  String? latestVersion;
  int? updateType;

  Data({this.deviceType, this.latestVersion, this.updateType});

  Data.fromJson(Map<String, dynamic> json) {
    deviceType = json['device_type'];
    latestVersion = json['latest_version'];
    updateType = json['update_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_type'] = this.deviceType;
    data['latest_version'] = this.latestVersion;
    data['update_type'] = this.updateType;
    return data;
  }
}

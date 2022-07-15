class UserTrackingActivity {
  String? activityType;
  String? context;
  DateTime? activityTime;
  int? device;

  UserTrackingActivity(
      {this.activityType, this.context, this.activityTime, this.device});

  UserTrackingActivity.fromJson(Map<String, dynamic> json) {
    activityType = json['activity_type'];
    context = json['context'];
    activityTime = DateTime.parse(json['activity_time']);
    device = json['device'];
    //activityTime = json['activity_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_type'] = this.activityType;
    data['context'] = this.context;
    data['activity_time'] = this.activityTime!.toIso8601String();
    data['device'] = this.device;
    return data;
  }
}

class LearningSpaceResponse {
  int? status;
  Data? data;
  String? datetime;
  List<String?>? error;

  LearningSpaceResponse({this.status, this.data, this.datetime, this.error});

  LearningSpaceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    datetime = json['datetime'];
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
      data['data'] = this.data!.toJson();
    }
    data['datetime'] = this.datetime;
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v).toList();
    }
    return data;
  }
}

class Data {
  List<LearningSpace>? learningSpace;

  Data({this.learningSpace});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['learning_space'] != null) {
      learningSpace = <LearningSpace>[];
      json['learning_space'].forEach((v) {
        learningSpace!.add(new LearningSpace.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (learningSpace != null) {
      data['learning_space'] = learningSpace!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LearningSpace {
  int? type;
  int? userId;
  int? createdAt;
  LearningData? data;

  LearningSpace({this.type, this.userId, this.createdAt, this.data});

  LearningSpace.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    data =
        json['data'] != null ? new LearningData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LearningData {
  int? id;
  String? name;
  String? description;
  int? durationInDays;
  int? durationInMinutes;
  int? startDate;
  int? endDate;
  String? categoryLevel;
  int? organizationId;
  String? level;
  String? message;
  String? actionUrl;
  String? presenter;
  String? liveclassAction;
  String? liveclassStatus;
  String? mode;
  String? categoryName;
  String? resources;
  int? totalSessions;
  int? totalEnrolled;
  List<Trainers>? trainers;
  int? totalSkills;
  String? status;
  String? readByMonths;
  int? pageCount;

  LearningData(
      {this.id,
      this.name,
      this.description,
      this.durationInDays,
      this.durationInMinutes,
      this.startDate,
      this.endDate,
      this.categoryLevel,
      this.organizationId,
      this.level,
      this.message,
      this.actionUrl,
      this.presenter,
      this.liveclassAction,
      this.liveclassStatus,
      this.mode,
      this.categoryName,
      this.resources,
      this.totalSessions,
      this.totalEnrolled,
      this.trainers,
      this.totalSkills,
      this.status,
      this.readByMonths,
      this.pageCount});

  LearningData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    durationInDays = json['duration_in_days'];
    durationInMinutes = json['duration_in_minutes'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    categoryLevel = json['category_level'];
    organizationId = json['organization_id'];
    level = json['level'];
    message = json['message'];
    actionUrl = json['action_url'];
    presenter = json['presenter'];
    liveclassAction = json['liveclass_action'];
    liveclassStatus = json['liveclass_status'];
    mode = json['mode'];
    categoryName = json['category_name'];
    resources = json['resources'];
    totalSessions = json['total_sessions'];
    totalEnrolled = json['total_enrolled'];
    if (json['trainers'] != null) {
      trainers = <Trainers>[];
      json['trainers'].forEach((v) {
        trainers!.add(new Trainers.fromJson(v));
      });
    }
    totalSkills = json['total_skills'];
    status = json['status'];
    readByMonths = json['read_by_months'];
    pageCount = json['page_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['duration_in_days'] = this.durationInDays;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['category_level'] = this.categoryLevel;
    data['organization_id'] = this.organizationId;
    data['level'] = this.level;
    data['message'] = this.message;
    data['action_url'] = this.actionUrl;
    data['presenter'] = this.presenter;
    data['liveclass_action'] = this.liveclassAction;
    data['liveclass_status'] = this.liveclassStatus;
    data['mode'] = this.mode;
    data['category_name'] = this.categoryName;
    data['resources'] = this.resources;
    data['total_sessions'] = this.totalSessions;
    data['total_enrolled'] = this.totalEnrolled;
    if (this.trainers != null) {
      data['trainers'] = this.trainers!.map((v) => v.toJson()).toList();
    }
    data['total_skills'] = this.totalSkills;
    data['status'] = this.status;
    data['read_by_months'] = this.readByMonths;
    data['page_count'] = this.pageCount;
    return data;
  }
}

class Trainers {
  String? name;

  Trainers({this.name});

  Trainers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

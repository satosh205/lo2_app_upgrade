class TrainingModuleResponse {
  int? status;
  Data? data;
  List<String>? error;

  TrainingModuleResponse({this.status, this.data, this.error});

  TrainingModuleResponse.fromJson(Map<String, dynamic> json) {
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
  List<Module>? module;

  Data({this.module});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      module = <Module>[];
      json['list'].forEach((v) {
        module!.add(new Module.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.module != null) {
      data['module'] = this.module!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Module {
  int? id;
  String? name;
  String? image;
  int? startDate;
  int? endDate;
  String? description;
  int? durationInDays;
  Object? completion;
  Content? content;

  Module(
      {this.id,
      this.name,
      this.image,
      this.startDate,
      this.endDate,
      this.description,
      this.durationInDays,
      this.completion,
      this.content});

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    durationInDays = json['duration_in_days'];
    completion = json['completion'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
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
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  List<Sessions>? sessions;
  List<LearningShots>? learningShots;
  List<Assessments>? assessments;
  List<Assignments>? assignments;
  List<Polls>? polls;
  List<Polls>? survey;
  List<Scorm>? scorm;

  Content(
      {this.sessions,
      this.learningShots,
      this.assessments,
      this.assignments,
      this.polls,
      this.survey,
      this.scorm});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['sessions'] != null) {
      sessions = <Sessions>[];
      json['sessions'].forEach((v) {
        sessions!.add(new Sessions.fromJson(v));
      });
    }
    if (json['learning_shots'] != null) {
      learningShots = <LearningShots>[];
      json['learning_shots'].forEach((v) {
        learningShots!.add(new LearningShots.fromJson(v));
      });
    }
    if (json['assessments'] != null) {
      assessments = <Assessments>[];
      json['assessments'].forEach((v) {
        assessments!.add(new Assessments.fromJson(v));
      });
    }
    if (json['assignments'] != null) {
      assignments = <Assignments>[];
      json['assignments'].forEach((v) {
        assignments!.add(new Assignments.fromJson(v));
      });
    }
    if (json['polls'] != null) {
      polls = <Polls>[];
      json['polls'].forEach((v) {
        polls!.add(new Polls.fromJson(v));
      });
    }
    if (json['survey'] != null) {
      survey = <Polls>[];
      json['survey'].forEach((v) {
        survey!.add(new Polls.fromJson(v));
      });
    }
    // scorm = json['scorm'] != null ? new Scorm.fromJson(json['scorm']) : null;
    if (json['scorm'] != null) {
      scorm = <Scorm>[];
      json['scorm'].forEach((v) {
        scorm!.add(new Scorm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sessions != null) {
      data['sessions'] = this.sessions!.map((v) => v.toJson()).toList();
    }
    if (this.learningShots != null) {
      data['learning_shots'] =
          this.learningShots!.map((v) => v.toJson()).toList();
    }
    if (this.assessments != null) {
      data['assessments'] = this.assessments!.map((v) => v.toJson()).toList();
    }
    if (this.assignments != null) {
      data['assignments'] = this.assignments!.map((v) => v.toJson()).toList();
    }
    if (this.polls != null) {
      data['polls'] = this.polls!.map((v) => v.toJson()).toList();
    }
    if (this.survey != null) {
      data['survey'] = this.survey!.map((v) => v.toJson()).toList();
    }
    if (this.scorm != null) {
      // data['scorm'] = this.scorm.toJson();
      data['scorm'] = this.scorm!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sessions {
  int? programContentId;
  String? title;
  String? description;
  String? image;
  int? startDate;
  int? endDate;
  int? durationInMinutes;
  String? liveclassAction;
  String? liveclassUrl;
  int? startsInMinutes;
  String? liveclassSubHeading;
  String? liveclassStatus;
  String? liveclassDescription;
  bool? isAttended;
  bool? isLive;
  String? url;
  String? status;
  String? trainerName;
  String? trainerProfilePic;
  String? contentType;

  Sessions(
      {this.programContentId,
      this.title,
      this.description,
      this.image,
      this.startDate,
      this.endDate,
      this.durationInMinutes,
      this.liveclassAction,
      this.liveclassUrl,
      this.startsInMinutes,
      this.liveclassSubHeading,
      this.liveclassDescription,
      this.isAttended,
      this.isLive,
      this.status,
      this.url,
      this.trainerName,
      this.trainerProfilePic,
      this.contentType,
      this.liveclassStatus});

  Sessions.fromJson(Map<String, dynamic> json) {
    programContentId = json['program_content_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    durationInMinutes = json['duration_in_minutes'];
    liveclassAction = json['liveclass_action'];
    liveclassStatus = json['liveclass_status'];
    liveclassUrl = json['liveclass_url'];
    startsInMinutes = json['starts_in_minutes'];
    liveclassSubHeading = json['liveclass_sub_heading'];
    liveclassDescription = json['liveclass_description'];
    isAttended = json['is_attended'];
    isLive = json['is_live'];
    url = json['url'];
    status = json['status'];
    trainerName = json['trainer_name'];
    trainerProfilePic = json['trainer_profile_pic'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_content_id'] = this.programContentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['liveclass_action'] = this.liveclassAction;
    data['liveclass_status'] = this.liveclassStatus;
    data['liveclass_url'] = this.liveclassUrl;
    data['starts_in_minutes'] = this.startsInMinutes;
    data['liveclass_sub_heading'] = this.liveclassSubHeading;
    data['liveclass_description'] = this.liveclassDescription;
    data['is_attended'] = this.isAttended;
    data['is_live'] = this.isLive;
    data['url'] = this.url;
    data['status'] = this.status;
    data['trainer_name'] = this.trainerName;
    data['trainer_profile_pic'] = this.trainerProfilePic;
    data['content_type'] = this.contentType;
    return data;
  }
}

class LearningShots {
  int? programContentId;
  String? title;
  String? image;
  int? createdAt;
  String? description;
  int? dueDate;
  Object? completion;
  String? contentType;
  String? url;
  int? noPages;
  int? durationInMinutes;

  LearningShots(
      {this.programContentId,
      this.title,
      this.image,
      this.createdAt,
      this.description,
      this.dueDate,
      this.completion,
      this.contentType,
      this.url,
      this.noPages,
      this.durationInMinutes});

  LearningShots.fromJson(Map<String, dynamic> json) {
    programContentId = json['program_content_id'];
    title = json['title'];
    image = json['image'];
    createdAt = json['created_at'];
    description = json['description'];
    dueDate = json['due_date'];
    completion = json['completion'];
    contentType = json['content_type'];
    url = json['url'];
    noPages = json['no_pages'];
    durationInMinutes = json['duration_in_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_content_id'] = this.programContentId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['due_date'] = this.dueDate;
    data['completion'] = this.completion;
    data['content_type'] = this.contentType;
    data['url'] = this.url;
    data['no_pages'] = this.noPages;
    data['duration_in_minutes'] = this.durationInMinutes;
    return data;
  }
}

class Assessments {
  int? programContentId;
  int? questionsAttempted;
  bool? isCompleted;
  int? score;
  int? attemptDate;
  String? action;
  String? actionTitle;
  int? attemptsRemaining;
  int? programId;
  String? title;
  String? description;
  String? status;
  String? contentType;
  int? assessmentId;
  int? durationInMinutes;
  int? negativeMarks;
  int? attemptAllowed;
  int? maximumMarks;
  int? queCount;
  Object? completion;
  int? startDate;
  int? endDate;
  int? overallScore;
  String? overallResult;
  String? url;
  String? assesStatus;

  Assessments(
      {this.programContentId,
      this.questionsAttempted,
      this.isCompleted,
      this.score,
      this.attemptDate,
      this.action,
      this.actionTitle,
      this.attemptsRemaining,
      this.programId,
      this.title,
      this.description,
      this.status,
      this.contentType,
      this.assessmentId,
      this.durationInMinutes,
      this.negativeMarks,
      this.attemptAllowed,
      this.maximumMarks,
      this.queCount,
      this.completion,
      this.startDate,
      this.endDate,
      this.overallScore,
      this.overallResult,
      this.url,
      this.assesStatus});

  Assessments.fromJson(Map<String, dynamic> json) {
    programContentId = json['program_content_id'];
    questionsAttempted = json['questions_attempted'];
    isCompleted = json['is_completed'];
    score = json['score'];
    attemptDate = json['attempt_date'];
    action = json['action'];
    actionTitle = json['action_title'];
    attemptsRemaining = json['attempts_remaining'];
    programId = json['program_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    contentType = json['content_type'];
    assessmentId = json['assessment_id'];
    durationInMinutes = json['duration_in_minutes'];
    negativeMarks = json['negative_marks'];
    attemptAllowed = json['attempt_allowed'];
    maximumMarks = json['maximum_marks'];
    queCount = json['que_count'];
    completion = json['completion'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    overallScore = json['overall_score'];
    overallResult = json['overall_result'];
    url = json['url'];
    assesStatus = json['asses_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_content_id'] = this.programContentId;
    data['questions_attempted'] = this.questionsAttempted;
    data['is_completed'] = this.isCompleted;
    data['score'] = this.score;
    data['attempt_date'] = this.attemptDate;
    data['action'] = this.action;
    data['action_title'] = this.actionTitle;
    data['attempts_remaining'] = this.attemptsRemaining;
    data['program_id'] = this.programId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['content_type'] = this.contentType;
    data['assessment_id'] = this.assessmentId;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['negative_marks'] = this.negativeMarks;
    data['attempt_allowed'] = this.attemptAllowed;
    data['maximum_marks'] = this.maximumMarks;
    data['que_count'] = this.queCount;
    data['completion'] = this.completion;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['overall_score'] = this.overallScore;
    data['overall_result'] = this.overallResult;
    data['url'] = this.url;
    data['asses_status'] = this.assesStatus;
    return data;
  }
}

class Assignments {
  int? programId;
  int? programContentId;
  String? title;
  String? description;
  String? status;
  String? contentType;
  int? maximumMarks;
  int? allowMultiple;
  Object? completion;
  int? startDate;
  int? endDate;
  int? completionTime;
  int? overallScore;
  String? overallResult;
  int? totalAttempts;
  int? isGraded;
  String? url;

  Assignments(
      {this.programId,
      this.programContentId,
      this.title,
      this.description,
      this.status,
      this.contentType,
      this.maximumMarks,
      this.completion,
      this.startDate,
      this.endDate,
      this.completionTime,
      this.overallScore,
      this.overallResult,
      this.url,
      this.allowMultiple,
      this.isGraded,
      this.totalAttempts});

  Assignments.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
    programContentId = json['program_content_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    contentType = json['content_type'];
    maximumMarks = json['maximum_marks'];
    completion = json['completion'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    completionTime = json['completion_time'];
    overallScore = json['overall_score'];
    overallResult = json['overall_result'];
    url = json['url'];
    allowMultiple = json['allow_multiple'];
    totalAttempts = json['total_attempts'];
    isGraded = json['is_graded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    data['program_content_id'] = this.programContentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['content_type'] = this.contentType;
    data['maximum_marks'] = this.maximumMarks;
    data['completion'] = this.completion;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['completion_time'] = this.completionTime;
    data['overall_score'] = this.overallScore;
    data['overall_result'] = this.overallResult;
    data['url'] = this.url;
    data['allow_multiple'] = this.allowMultiple;
    data['total_attempts'] = this.totalAttempts;
    data['is_graded'] = this.isGraded;
    return data;
  }
}

class Polls {
  int? programId;
  int? programContentId;
  String? title;
  String? description;
  String? status;
  String? contentType;
  Object? completion;
  int? startDate;
  int? endDate;
  String? url;

  Polls(
      {this.programId,
      this.programContentId,
      this.title,
      this.description,
      this.status,
      this.contentType,
      this.completion,
      this.startDate,
      this.endDate,
      this.url});

  Polls.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
    programContentId = json['program_content_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    contentType = json['content_type'];
    completion = json['completion'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    data['program_content_id'] = this.programContentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['content_type'] = this.contentType;
    data['completion'] = this.completion;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['url'] = this.url;
    return data;
  }
}

class Scorm {
  int? programContentId;
  int? programId;
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  String? contentType;
  String? url;

  Scorm(
      {this.programContentId,
      this.programId,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.contentType,
      this.url});

  Scorm.fromJson(Map<String, dynamic> json) {
    programContentId = json['program_content_id'];
    programId = json['program_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    contentType = json['content_type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_content_id'] = this.programContentId;
    data['program_id'] = this.programId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['content_type'] = this.contentType;
    data['url'] = this.url;
    return data;
  }
}

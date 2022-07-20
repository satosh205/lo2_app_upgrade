class AssessmentInstructionResponse {
  int? status;
  Data? data;
  List<String>? error;

  AssessmentInstructionResponse({this.status, this.data, this.error});

  AssessmentInstructionResponse.fromJson(Map<String, dynamic> json) {
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
  Instruction? instruction;

  Data({this.instruction});

  Data.fromJson(Map<String, dynamic> json) {
    instruction = json['instruction'] != null
        ? new Instruction.fromJson(json['instruction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.instruction != null) {
      data['instruction'] = this.instruction!.toJson();
    }
    return data;
  }
}

class Instruction {
  List<String>? statement;
  Details? details;

  Instruction({this.statement, this.details});

  Instruction.fromJson(Map<String, dynamic> json) {
    statement = json['statement'].cast<String>();
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statement'] = this.statement;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  String? contentId;
  String? title;
  String? description;
  int? startDate;
  int? endDate;
  int? maximumMarks;
  int? passingMarks;
  int? questionCount;
  int? attemptAllowed;
  int? durationInMinutes;
  String? difficultyLevel;
  int? attemptCount;
  int? isAttempted;
  int? score;
  int? isReviewAllowed;
  int? submittedOnDate;
  int? isPassed;

  Details(
      {this.contentId,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.maximumMarks,
      this.passingMarks,
      this.questionCount,
      this.attemptAllowed,
      this.durationInMinutes,
      this.difficultyLevel,
      this.attemptCount,
      this.isAttempted,
      this.score,
      this.isReviewAllowed,
      this.submittedOnDate,
      this.isPassed});

  Details.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    maximumMarks = json['maximum_marks'];
    passingMarks = json['passing_marks'];
    questionCount = json['question_count'];
    attemptAllowed = json['attempt_allowed'];
    durationInMinutes = json['duration_in_minutes'];
    difficultyLevel = json['difficulty_level'];
    attemptCount = json['attempt_count'];
    isAttempted = json['is_attempted'];
    score = json['score'];
    isReviewAllowed = json['is_review_allowed'];
    submittedOnDate = json['submitted_on_date'];
    isPassed = json['is_passed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['maximum_marks'] = this.maximumMarks;
    data['passing_marks'] = this.passingMarks;
    data['question_count'] = this.questionCount;
    data['attempt_allowed'] = this.attemptAllowed;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['difficulty_level'] = this.difficultyLevel;
    data['attempt_count'] = this.attemptCount;
    data['is_attempted'] = this.isAttempted;
    data['score'] = this.score;
    data['is_review_allowed'] = this.isReviewAllowed;
    data['submitted_on_date'] = this.submittedOnDate;
    data['is_passed'] = this.isPassed;
    return data;
  }
}

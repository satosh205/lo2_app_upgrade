import 'package:flutter/material.dart';

class TestReviewResponse {
  int? status;
  Data? data;
  List<String?>? error;

  TestReviewResponse({this.status, this.data, this.error});

  TestReviewResponse.fromJson(Map<String, dynamic> json) {
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
  AssessmentReview? assessmentReview;

  Data({this.assessmentReview});

  Data.fromJson(Map<String, dynamic> json) {
    assessmentReview = json['assessment_review'] != null
        ? new AssessmentReview.fromJson(json['assessment_review'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assessmentReview != null) {
      data['assessment_review'] = this.assessmentReview!.toJson();
    }
    return data;
  }
}

class AssessmentReview {
  String? contentId;
  String? certificateUrl;
  int? startDate;
  int? endDate;
  int? questionCount;
  int? negativeMarking;
  int? negativeMarks;
  int? durationInMinutes;
  int? totalAttempts;
  int? attemptCount;
  List<Questions>? questions;

  AssessmentReview(
      {this.contentId,
      this.certificateUrl,
      this.startDate,
      this.endDate,
      this.questionCount,
      this.negativeMarking,
      this.negativeMarks,
      this.durationInMinutes,
      this.totalAttempts,
      this.attemptCount,
      this.questions});

  AssessmentReview.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    certificateUrl = json['certificate_url'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    questionCount = json['question_count'];
    negativeMarking = json['negative_marking'];
    negativeMarks = json['negative_marks'];
    durationInMinutes = json['duration_in_minutes'];
    totalAttempts = json['total_attempts'];
    attemptCount = json['attempt_count'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['certificate_url'] = this.certificateUrl;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['question_count'] = this.questionCount;
    data['negative_marking'] = this.negativeMarking;
    data['negative_marks'] = this.negativeMarks;
    data['duration_in_minutes'] = this.durationInMinutes;
    data['total_attempts'] = this.totalAttempts;
    data['attempt_count'] = this.attemptCount;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? questionId;
  String? question;
  int? questionTypeId;
  int? marks;
  List<String>? correctOptions;
  List<QuestionOptions>? questionOptions;
  String? questionType;
  int? isCorrect;
  int? marksObtained;
  int? attemptState;
  List<dynamic>? questionImage = [];

  Questions(
      {this.questionId,
      this.question,
      this.questionTypeId,
      this.marks,
      this.correctOptions,
      this.questionOptions,
      this.questionType,
      this.isCorrect,
      this.marksObtained,
      this.attemptState,
      this.questionImage});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    question = json['question'];
    questionTypeId = json['question_type_id'];
    marks = json['marks'];
    correctOptions = json['correct_options'].cast<String>();
    questionImage = json['question_image'];
    if (json['question_options'] != null) {
      questionOptions = <QuestionOptions>[];
      json['question_options'].forEach((v) {
        questionOptions!.add(new QuestionOptions.fromJson(v));
      });
    }
    if (json['question_image'] != null) {
      questionImage = <String>[];
      json['question_image'].forEach((v) {
        questionImage!.add(v);
      });
    }
    questionType = json['question_type'];
    isCorrect = json['is_correct'];
    marksObtained = json['marks_obtained'];
    attemptState = json['attempt_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['question'] = this.question;
    data['question_type_id'] = this.questionTypeId;
    data['marks'] = this.marks;
    data['correct_options'] = this.correctOptions;
    if (this.questionImage != null) {
      data['question_image'] = this.questionImage!.map((v) => v).toList();
    }
    if (this.questionOptions != null) {
      data['question_options'] =
          this.questionOptions!.map((v) => v.toJson()).toList();
    }
    data['question_type'] = this.questionType;
    data['is_correct'] = this.isCorrect;
    data['marks_obtained'] = this.marksObtained;
    data['attempt_state'] = this.attemptState;
    return data;
  }
}

class QuestionOptions {
  int? optionId;
  String? optionStatement;
  int? userAnswer;

  QuestionOptions({this.optionId, this.optionStatement, this.userAnswer});

  QuestionOptions.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    optionStatement = json['option_statement'];
    userAnswer = json['user_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['option_statement'] = this.optionStatement;
    data['user_answer'] = this.userAnswer;
    return data;
  }
}

class TestReviewBean {
  Questions? question;
  int? id;
  String? title;
  Color color = Colors.white;

  TestReviewBean({
    this.color = Colors.white,
    this.question,
    this.id,
    this.title,
  });
}

class SubmitSurveyReq {
  int? contentId;
  bool? isSubmitted;
  List<QuestionSubmitted>? questionSubmitted;

  SubmitSurveyReq({this.contentId, this.questionSubmitted, this.isSubmitted});

  SubmitSurveyReq.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    isSubmitted = json['is_submitted'];
    if (json['question_submitted'] != null) {
      questionSubmitted = <QuestionSubmitted>[];
      json['question_submitted'].forEach((v) {
        questionSubmitted?.add(new QuestionSubmitted.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['is_submitted'] = this.isSubmitted;
    if (this.questionSubmitted != null) {
      data['question_submitted'] =
          this.questionSubmitted?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionSubmitted {
  List<int>? optionId;
  int? questionId;

  QuestionSubmitted({this.optionId, this.questionId});

  QuestionSubmitted.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'].cast<int>();
    questionId = json['question_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['question_id'] = this.questionId;
    return data;
  }
}

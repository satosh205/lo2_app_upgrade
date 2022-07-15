class SaveAnswerRequest {
  String? contentId;
  String? questionId;
  List<int?>? optionId;
  int? markReview = 1;
  String? durationSec;

  SaveAnswerRequest(
      {this.contentId,
      this.questionId,
      this.optionId,
      this.markReview = 1,
      this.durationSec});

  SaveAnswerRequest.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    questionId = json['question_id'];
    optionId = json['option_id'].cast<int>();
    markReview = json['mark_review'];
    durationSec = json['durationSec'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_id'] = this.contentId;
    data['question_id'] = this.questionId;
    data['option_id'] = this.optionId;
    data['mark_review'] = this.markReview;
    data['durationSec'] = this.durationSec;
    return data;
  }
}

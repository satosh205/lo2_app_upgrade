class SubmitRewardReq {
  int? rewardId;

  SubmitRewardReq({this.rewardId});

  SubmitRewardReq.fromJson(Map<String, dynamic> json) {
    rewardId = json['reward_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reward_id'] = this.rewardId;
    return data;
  }
}

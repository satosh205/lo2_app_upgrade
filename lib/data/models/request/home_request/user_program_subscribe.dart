class UserProgramSubscribeReq {
  int? programId;

  UserProgramSubscribeReq({this.programId});

  UserProgramSubscribeReq.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    return data;
  }
}

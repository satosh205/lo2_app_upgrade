class CreateLiveClassRequest {
  int? programModuleId;
  String? contentType;
  String? title;
  String? description;
  String? status;
  String? startDate;
  int? expectedDuration;
  List<int>? users;

  CreateLiveClassRequest({
    this.programModuleId,
    this.contentType,
    this.title,
    this.description,
    this.status,
    this.startDate,
    this.expectedDuration,
    this.users,
  });
}

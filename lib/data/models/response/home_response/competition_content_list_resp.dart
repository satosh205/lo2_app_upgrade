// To parse this JSON data, do
//
//     final competitionContentListResponse = competitionContentListResponseFromJson(jsonString);

import 'dart:convert';

CompetitionContentListResponse? competitionContentListResponseFromJson(String str) => CompetitionContentListResponse.fromJson(json.decode(str));

String competitionContentListResponseToJson(CompetitionContentListResponse? data) => json.encode(data!.toJson());

class CompetitionContentListResponse {
    CompetitionContentListResponse({
        this.status,
        this.data,
        this.error,
    });

    int? status;
    Data? data;
    List<dynamic>? error;

    factory CompetitionContentListResponse.fromJson(Map<String, dynamic> json) => CompetitionContentListResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        error: json["error"] == null ? [] : List<dynamic>.from(json["error"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
        "error": error == null ? [] : List<dynamic>.from(error!.map((x) => x)),
    };
}

class Data {
    Data({
        this.list,
        this.competitionInstructions,
    });

    List<CompetitionContent?>? list;
    CompetitionInstructions? competitionInstructions;
    

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: json["list"] == null ? [] : List<CompetitionContent?>.from(json["list"]!.map((x) => CompetitionContent.fromJson(x))),
        competitionInstructions: CompetitionInstructions.fromJson(json["competition_instructions"]),
    );

    Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x!.toJson())),
        "competition_instructions": competitionInstructions?.toJson(),
    };
}

class CompetitionContent {
    CompetitionContent({
        this.image,
        this.id,
        this.authorId,
        this.referenceId,
        this.referenceAuthorId,
        this.moduleId,
        this.title,
        this.content,
        this.description,
        this.createdAt,
        this.contentType,
        this.pageCount,
        this.expectedDuration,
        this.endDate,
        this.startDate,
        this.completionPercentage,
        this.userId,
        this.gScore,
        this.programId,
        this.skillId,
        this.skillName,
        this.programContentId,
        this.pcStatus,
        this.duration,
        this.status,
        this.assessmentId,
        this.negativeMarks,
        this.attemptAllowed,
        this.maximumMarks,
        this.queCount,
        this.overallScore,
        this.overallResult,
        this.completionTime,
        this.questionsAttempted,
        this.isCompleted,
        this.score,
        this.attemptDate,
        this.authorName,
        this.action,
        this.isToday,
        this.canReattempt,
        this.actionTitle,
        this.dueBy,
        this.assesStatus,
        this.attemptsRemaining,
        this.allowMultiple,
        this.isGraded,
        this.marks,
        this.passingMarks,
        this.mode,
        this.zoomUrl,
        this.zoomPasskey,
        this.venue,
        this.isJoined,
        this.classDuration,
        this.classStatus,
        this.presenter,
        this.liveclassAction,
        this.liveclassActionTitle,
        this.sessionStartingIn,
    });

    dynamic image;
    int? id;
    int? authorId;
    int? referenceId;
    int? referenceAuthorId;
    int? moduleId;
    String? title;
    String? content;
    String? description;
    String? createdAt;
    String? contentType;
    int? pageCount;
    int? expectedDuration;
    String? endDate;
    String? startDate;
    int? completionPercentage;
    int? userId;
    dynamic gScore;
    int? programId;
    int? skillId;
    String? skillName;
    int? programContentId;
    String? pcStatus;
    int? duration;
    dynamic status;
    int? assessmentId;
    int? negativeMarks;
    int? attemptAllowed;
    int? maximumMarks;
    int? queCount;
    int? overallScore;
    String? overallResult;
    String? completionTime;
    int? questionsAttempted;
    int? isCompleted;
    int? score;
    String? attemptDate;
    String? authorName;
    String? action;
    bool? isToday;
    bool? canReattempt;
    String? actionTitle;
    String? dueBy;
    String? assesStatus;
    int? attemptsRemaining;
    int? allowMultiple;
    int? isGraded;
    String? marks;
    String? passingMarks;
    String? mode;
    String? zoomUrl;
    String? zoomPasskey;
    dynamic venue;
    String? isJoined;
    dynamic classDuration;
    String? classStatus;
    String? presenter;
    String? liveclassAction;
    String? liveclassActionTitle;
    double? sessionStartingIn;

    factory CompetitionContent.fromJson(Map<String, dynamic> json) => CompetitionContent(
        image: json["image"],
        id: json["id"],
        authorId: json["author_id"],
        referenceId: json["reference_id"],
        referenceAuthorId: json["reference_author_id"],
        moduleId: json["module_id"],
        title: json["title"],
        content: json["content"],
        description: json["description"],
        createdAt: json["created_at"],
        contentType: json["content_type"],
        pageCount: json["page_count"],
        expectedDuration: json["expected_duration"],
        endDate: json["end_date"],
        startDate: json["start_date"],
        completionPercentage: json["completion_percentage"],
        userId: json["user_id"],
        gScore: json["g_score"],
        programId: json["program_id"],
        skillId: json["skill_id"],
        skillName: json["skill_name"],
        programContentId: json["program_content_id"],
        pcStatus: json["pc_status"],
        duration: json["duration"],
        status: json["status"],
        assessmentId: json["assessment_id"],
        negativeMarks: json["negative_marks"],
        attemptAllowed: json["attempt_allowed"],
        maximumMarks: json["maximum_marks"],
        queCount: json["que_count"],
        overallScore: json["overall_score"],
        overallResult: json["overall_result"],
        completionTime: json["completion_time"],
        questionsAttempted: json["questions_attempted"],
        isCompleted: json["is_completed"],
        score: json["score"],
        attemptDate: json["attempt_date"],
        authorName: json["author_name"],
        action: json["action"],
        isToday: json["is_today"],
        canReattempt: json["can_reattempt"],
        actionTitle: json["action_title"],
        dueBy: json["due_by"],
        assesStatus: json["asses_status"],
        attemptsRemaining: json["attempts_remaining"],
        allowMultiple: json["allow_multiple"],
        isGraded: json["is_graded"],
        marks: json["marks"],
        passingMarks: json["passing_marks"],
        mode: json["mode"],
        zoomUrl: json["zoom_url"],
        zoomPasskey: json["zoom_passkey"],
        venue: json["venue"],
        isJoined: json["is_joined"],
        classDuration: json["class_duration"],
        classStatus: json["class_status"],
        presenter: json["presenter"],
        liveclassAction: json["liveclass_action"],
        liveclassActionTitle: json["liveclass_action_title"],
        sessionStartingIn: json["session_starting_in"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "author_id": authorId,
        "reference_id": referenceId,
        "reference_author_id": referenceAuthorId,
        "module_id": moduleId,
        "title": title,
        "content": content,
        "description": description,
        "created_at": createdAt,
        "content_type": contentType,
        "page_count": pageCount,
        "expected_duration": expectedDuration,
        "end_date": endDate,
        "start_date": startDate,
        "completion_percentage": completionPercentage,
        "user_id": userId,
        "g_score": gScore,
        "program_id": programId,
        "skill_id": skillId,
        "skill_name": skillName,
        "program_content_id": programContentId,
        "pc_status": pcStatus,
        "duration": duration,
        "status": status,
        "assessment_id": assessmentId,
        "negative_marks": negativeMarks,
        "attempt_allowed": attemptAllowed,
        "maximum_marks": maximumMarks,
        "que_count": queCount,
        "overall_score": overallScore,
        "overall_result": overallResult,
        "completion_time": completionTime,
        "questions_attempted": questionsAttempted,
        "is_completed": isCompleted,
        "score": score,
        "attempt_date": attemptDate,
        "author_name": authorName,
        "action": action,
        "is_today": isToday,
        "can_reattempt": canReattempt,
        "action_title": actionTitle,
        "due_by": dueBy,
        "asses_status": assesStatus,
        "attempts_remaining": attemptsRemaining,
        "allow_multiple": allowMultiple,
        "is_graded": isGraded,
        "marks": marks,
        "passing_marks": passingMarks,
        "mode": mode,
        "zoom_url": zoomUrl,
        "zoom_passkey": zoomPasskey,
        "venue": venue,
        "is_joined": isJoined,
        "class_duration": classDuration,
        "class_status": classStatus,
        "presenter": presenter,
        "liveclass_action": liveclassAction,
        "liveclass_action_title": liveclassActionTitle,
        "session_starting_in": sessionStartingIn,
    };
}

class CompetitionInstructions {
    CompetitionInstructions({
        this.whatsIn,
        this.instructions,
        this.faq,
    });

    String? whatsIn;
    String? instructions;
    String? faq;

    factory CompetitionInstructions.fromJson(Map<String, dynamic> json) => CompetitionInstructions(
        whatsIn: json["whats_in"],
        instructions: json["instructions"],
        faq: json["faq"],
    );

    Map<String, dynamic> toJson() => {
        "whats_in": whatsIn,
        "instructions": instructions,
        "faq": faq,
    };
}

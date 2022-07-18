import 'dart:convert';

import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:hive/hive.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';

class TrainingContentProvier extends BaseState {
  TrainingService trainingService;

  Modules modules;

  ApiStatus apiStatus = ApiStatus.LOADING;
  Box box = Hive.box(DB.TRAININGS);

  late TrainingModuleResponse trainingModuleResponse = TrainingModuleResponse();

  List<Map<String, dynamic>>? content = [];

  TrainingContentProvier(this.trainingService, this.modules) {
    getTraningDetail();
  }

  void getTraningDetail() {
    Log.v(box.get(
        modules.id.toString() + "${UserSession.userContentLanguageId}RES"));
    Log.v("HEREE");
    if (box.get(modules.id.toString() +
            "${UserSession.userContentLanguageId}RES") !=
        null) {
      trainingModuleResponse = TrainingModuleResponse.fromJson(
          Map<String, dynamic>.from(json.decode(box.get(modules.id.toString() +
              "${UserSession.userContentLanguageId}RES"))));
    }
    if (box.get(modules.id.toString() +
            "${UserSession.userContentLanguageId}CONTENT") !=
        null) {
      content = json
          .decode(box.get(modules.id.toString() +
              "${UserSession.userContentLanguageId}CONTENT"))
          .map((e) => Map<String, dynamic>.from(e))
          .cast<Map<String, dynamic>>()
          .toList();
    }
    trainingService.getDetailContent(modules.id).then((response) {
      ApiResponse apiResponse = response;
      if (apiResponse.success) {
        apiStatus = ApiStatus.SUCCESS;
        trainingModuleResponse = TrainingModuleResponse.fromJson(response.body);
        box.put(
            modules.id.toString() + "${UserSession.userContentLanguageId}RES",
            json.encode(apiResponse.body));
        updateContentData();
      } else {
        Log.v('error --- ${apiResponse.body}');
        apiStatus = ApiStatus.ERROR;
        updateErrorWidget(apiResponse.body
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
      notifyListeners();
    });
  }

  void updateContentData() {
    content!.clear();
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .scorm!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse.data!.module!.elementAt(0).content!.scorm;
      data['type'] = 'scorm';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .sessions!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse.data!.module!.elementAt(0).content!.sessions;
      data['type'] = 'sessions';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .learningShots!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] = trainingModuleResponse.data!.module!
          .elementAt(0)
          .content!
          .learningShots;
      data['type'] = 'notes';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .assignments!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] = trainingModuleResponse.data!.module!
          .elementAt(0)
          .content!
          .assignments;
      data['type'] = 'assignments';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .assessments!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] = trainingModuleResponse.data!.module!
          .elementAt(0)
          .content!
          .assessments;
      data['type'] = 'assessments';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .survey!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse.data!.module!.elementAt(0).content!.survey;
      data['type'] = 'survey';
      content!.add(data);
    }
    if (trainingModuleResponse.data!.module!
            .elementAt(0)
            .content!
            .polls!
            .length >
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse.data!.module!.elementAt(0).content!.polls;
      data['type'] = 'polls';
      content!.add(data);
    }
    box.put(
        modules.id.toString() + "${UserSession.userContentLanguageId}CONTENT",
        json.encode(content));
    Log.v(box.get(
        modules.id.toString() + "${UserSession.userContentLanguageId}CONTENT"));
  }
}

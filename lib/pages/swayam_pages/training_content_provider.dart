import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:masterg/data/providers/base_state.dart';
// import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:hive/hive.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/swayam_pages/training_service.dart';
import 'package:masterg/utils/constant.dart';

class TrainingContentProvier extends BaseState {
  TrainingService? trainingService;

  Modules? modules;

  ApiStatus apiStatus = ApiStatus.LOADING;
  Box box = Hive.box(DB.TRAININGS);

  TrainingModuleResponse? trainingModuleResponse;

  List<Map<String, dynamic>>? content = [];

  TrainingContentProvier(this.trainingService, this.modules) {
    getTraningDetail();
  }

  void getTraningDetail() {
    // print(box.get(
    //     modules?.id.toString() + "${UserSession.userContentLanguageId}RES"));
    print("HEREE call");
    // if (box.get(modules.id.toString() +
    //         "${UserSession.userContentLanguageId}RES") !=
    //     null) {
var val = box.get('${modules?.id}${UserSession.userContentLanguageId}RES') ;
print('the value is $val');
          if(val != null){
      trainingModuleResponse = TrainingModuleResponse.fromJson(
          Map<String, dynamic>.from(json.decode(box.get( 
             val)) ?? "") );
    }
      print('i am here -1');
    if (box.get(
            "${modules?.id}${UserSession.userContentLanguageId}CONTENT") !=
        null) {
            print('i am here 0');
      content = json

      .decode('${box.get('${modules?.id}${UserSession.userContentLanguageId}CONTENT') ?? ""}')
          // .decode(box.get(modules?.id.toString() +
          //     "${UserSession.userContentLanguageId}CONTENT"))
          .map((e) => Map<String, dynamic>.from(e))
          .cast<Map<String, dynamic>>()
          .toList();
    }
    print('i am here 1');
    trainingService?.getDetailContent(modules!.id!).then((response) {
   
      ApiResponse apiResponse = response;
      if (apiResponse.success) {
        apiStatus = ApiStatus.SUCCESS;
        trainingModuleResponse = TrainingModuleResponse.fromJson(response.body);print('i am here 2');

        box.put(
              "${modules?.id}${UserSession.userContentLanguageId}RES",
            json.encode(apiResponse.body ?? ""));
            print('i am here 3');
        updateContentData();
        print('i am here 4');
      } else {
        debugPrint('error --- ${apiResponse.body}');
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
    content?.clear();
    if (trainingModuleResponse?.data?.module?.elementAt(0).content?.scorm?.length != 
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.scorm;
      data['type'] = 'scorm';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module
            ?.elementAt(0)
            .content
            ?.sessions
            ?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.sessions;
      data['type'] = 'sessions';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module
            ?.elementAt(0)
            .content
            ?.learningShots
            ?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.learningShots;
      data['type'] = 'notes';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module
            ?.elementAt(0)
            .content
            ?.assignments
            ?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.assignments;
      data['type'] = 'assignments';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module
            ?.elementAt(0)
            .content
            ?.assessments
            ?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.assessments;
      data['type'] = 'assessments';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module?.elementAt(0).content?.survey?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.survey;
      data['type'] = 'survey';
      content?.add(data);
    }
    if (trainingModuleResponse?.data?.module?.elementAt(0).content?.polls?.length !=
        0) {
      Map<String, dynamic> data = {};
      data['data'] =
          trainingModuleResponse?.data?.module?.elementAt(0).content?.polls;
      data['type'] = 'polls';
      content?.add(data);
    }
    box.put(
         "${modules?.id}${UserSession.userContentLanguageId}CONTENT",
        json.encode(content ?? ""));
    print(box.get(
        "${ modules?.id}${UserSession.userContentLanguageId}CONTENT"));
  }
}

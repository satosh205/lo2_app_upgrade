import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_programs_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/constant.dart';

class TrainingDetailProvider extends BaseState {
  TrainingService? trainingService;
  Program? program;
  Box? box;

  //TrainingDetailResponse trainingDetailResponse;
  String description = '';
  List<Modules>? modules = [];
  ApiStatus apiStatus = ApiStatus.LOADING;

  TrainingDetailProvider( this.trainingService, this.program) {
    getTraningDetail();
  }

  void getTraningDetail() {
    box = Hive.box(DB.TRAININGS);
    if (box?.get('${program?.id}MOD') != null) {
      modules = box
          ?.get("${program?.id}MOD")
          .map((e) => Modules.fromJson(Map<String, dynamic>.from(e)))
          .cast<Modules>()
          .toList();
    }
    if (box?.get("${program?.id}DESC") != null) {
      description = box?.get("${program?.id}DESC");
    }
    trainingService?.getTrainingDetail(program?.id).then((response) {
      ApiResponse apiResponse = response;
      if (apiResponse.success) {
        TrainingDetailResponse trainingDetailResponse =
            TrainingDetailResponse.fromJson(response.body);
        box?.put(
            '${program?.id}MOD',
            trainingDetailResponse.data?.list?.first.modules
                ?.map((e) => e.toJson())
                .toList());
        box?.put("${program?.id}DESC",
            trainingDetailResponse.data?.list?.first.description);
        description = '${trainingDetailResponse.data?.list?.first.description}';
        modules = trainingDetailResponse.data?.list?.first.modules;
        debugPrint(
            'sdf s sdf sd  ---- ${trainingDetailResponse.data?.list?.length}');
        apiStatus = ApiStatus.SUCCESS;
      } else {
        debugPrint(' error -=----- ${apiResponse.body}');
        apiStatus = ApiStatus.ERROR;
        updateErrorWidget(apiResponse.body
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
      notifyListeners();
    });
  }
}

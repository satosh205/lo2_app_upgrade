import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_programs_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/constant.dart';

class TrainingProvider extends BaseState {
  TrainingService? trainingService;
  List<Program>? trainingPrograms;

  ApiStatus apiStatus = ApiStatus.LOADING;

  TrainingProvider(@required this.trainingService) {
    getTraningData();
  }

  void getTraningData() {
    trainingService?.getTrainings().then((response) {
      ApiResponse apiResponse = response;
      if (apiResponse.success) {
        debugPrint('api sucess statis ---- ${apiResponse.success}');
        trainingPrograms =
            TrainingProgramsResponse.fromJson(response.body).data?.list;
        Box box = Hive.box(DB.TRAININGS);
        box.put("courses", trainingPrograms?.map((e) => e.toJson()).toList());
        apiStatus = ApiStatus.SUCCESS;
      } else {
        print("HEREEE");
        apiStatus = ApiStatus.ERROR;
        updateErrorWidget(apiResponse.body
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

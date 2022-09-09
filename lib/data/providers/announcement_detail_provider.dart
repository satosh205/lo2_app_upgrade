import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_constants.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/utility.dart';

class AnnouncementDetailProvider extends BaseState {
  TrainingService? trainingService;

  GetContentResp? announcementResponse;

  ApiStatus? apiStatus;

  int questionNumber = 0;

  get index => questionNumber;

  AnnouncementDetailProvider(this.trainingService) {
    Map<String, dynamic> data = {};
    data['id'] = Utility.getCategoryValue(ApiConstants.ANNOUNCEMENT_TYPE);
    data['category_id'] = 2;
    data['language'] = 1;
    
    trainingService?.getAnnouncemnets(data).then((response) {
      ApiResponse apiResponse = response;
      if (apiResponse.success) {
        debugPrint(' question api response -- ${apiResponse.body}');
        announcementResponse = GetContentResp.fromJson(response.body);
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
    }
    );
  }
}

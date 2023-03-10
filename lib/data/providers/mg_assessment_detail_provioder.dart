import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/models/response/home_response/assessment_response.dart';
import 'package:masterg/data/models/response/home_response/my_assessment_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';

class MgAssessmentDetailProvider extends BaseState {
  TrainingService trainingService;
  late AssessmentList assessments;
  AssessmentInstructionResponse? assessmentResponse;

  MgAssessmentDetailProvider(this.trainingService, assessments) {
    this.assessments = assessments as AssessmentList;
    getDetails();
  }

  void getDetails() {
    trainingService
        .getAssessmentInstructions(assessments.contentId)
        .then((value) {
      ApiResponse apiResponse = value;
      if (apiResponse.success) {
        assessmentResponse = AssessmentInstructionResponse.fromJson(value.body);
      } else {
        updateErrorWidget(apiResponse.body
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
      notifyListeners();
    });
  }
}

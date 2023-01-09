import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/models/response/home_response/assessment_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';

class AssessmentDetailProvider extends BaseState {
  TrainingService trainingService;
  late Assessments assessments;
  AssessmentInstructionResponse? assessmentResponse;

  AssessmentDetailProvider(this.trainingService, assessments) {
    this.assessments = assessments as Assessments;
    getDetails();
  }

  void getDetails() {
    trainingService
        .getAssessmentInstructions(assessments.programContentId)
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

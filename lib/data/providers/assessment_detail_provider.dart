import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/models/response/home_response/assessment_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';

class AssessmentDetailProvider extends BaseState {
  TrainingService trainingService;
  late Assessments assessments;
  AssessmentInstructionResponse? assessmentResponse;
  bool? fromCompletiton;
  int? id;

  AssessmentDetailProvider(this.trainingService, assessments, {fromCompletiton = false, id = 0}) {
  if(fromCompletiton)this.assessments = Assessments(programContentId: id) ;
  
  else  this.assessments = assessments as Assessments;
    getDetails();
  }

  void getDetails() {
    trainingService
        .getAssessmentInstructions(assessments.programContentId)
        .then((value) {
      ApiResponse apiResponse = value;
      if (apiResponse.success) {
        assessmentResponse = AssessmentInstructionResponse.fromJson(value.body);
        print('we got the data ${assessmentResponse?.data?.instruction?.details?.contentId}');

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

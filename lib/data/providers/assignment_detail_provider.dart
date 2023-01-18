import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/assignment_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';

class AssignmentDetailProvider extends BaseState {
  ApiStatus? apiStatus;
  TrainingService trainingService;
  dynamic assignments;
  Assignment? assignment;
  bool isLoading = false;
   bool? fromCompletiton;
  int? id;

  AssignmentDetailProvider(this.trainingService, this.assignments, {fromCompletiton = false, id = 0}) {
   
  if(fromCompletiton)this.assignments = Assignments(programContentId: id) ;
   
   
    else this.assignments = assignments as Assessments;
    _getDetails();
  }

  void _getDetails() {
    trainingService
        .getAssignmentDetails(assignments.programContentId)
        .then((value) {
      ApiResponse apiResponse = value;
      if (apiResponse.success) {
        assignment =
            AssignmentDetailsResponse.fromJson(value.body).data!.list!.first;
      } else {
        apiStatus = ApiStatus.ERROR;
        updateErrorWidget(apiResponse.body
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
      notifyListeners();
    });
  }

  Future<bool> uploadAssignment(
      {int? id, String? notes, required String path}) async {
    isLoading = true;
    notifyListeners();
    try {
      ApiResponse? res = await trainingService.submitAssignment(
          id: id, notes: notes, path: path);
      if (res!.success) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } on Exception {
      Log.v("EXCEPTIONN");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/assignment_detail_response.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Log.dart';

class MgAssignmentDetailProvider extends BaseState {
  ApiStatus? apiStatus;
  TrainingService trainingService;
  AssignmentList assignments;
  Assignment? assignment;
  bool isLoading = false;

  MgAssignmentDetailProvider(this.trainingService, this.assignments) {
    Log.v("GETT");
    _getDetails();
  }

  void _getDetails() {
    trainingService.getAssignmentDetails(assignments.contentId).then((value) {
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

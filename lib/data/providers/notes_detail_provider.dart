import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/base_state.dart';
import 'package:masterg/pages/training_pages/training_service.dart';

class NotesDetailProvider extends BaseState {
  TrainingService trainingService;

  List<LearningShots>? notes;

  ApiStatus apiStatus = ApiStatus.LOADING;

  NotesDetailProvider(this.trainingService, this.notes) {
    apiStatus = ApiStatus.SUCCESS;
    notifyListeners();
  }
}

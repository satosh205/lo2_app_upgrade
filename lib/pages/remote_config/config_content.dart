class ConfigContent {
  static const String BOOLEAN_VALUE = 'sample_bool_value';
  static const String INT_VALUE = 'sample_int_value';
  //static const String STRING_VALUE = 'signup_flag';
  static const String STRING_VALUE = 'signup_vector';
  static const String BOOLEAN_SIGNUP_NEW = 'signup_new';
  static const String JSON_MAINSCREEN = 'mainscreen';

  static String _signupVector = '';
  String get getSignupVector => _signupVector;
  set setSignupVector(String value) {
    _signupVector = value;
  }

  static bool? _signupNew;
  bool? get getSignupNew => _signupNew;
  set setSignupNew(bool value) {
    _signupNew = value;
  }

  static String _taskModelList = '';

  String get getTaskModelList => _taskModelList;

  set setTaskModelList(String taskModel) {
    _taskModelList = taskModel;
    //_taskModelList.add(taskModel);
  }
}

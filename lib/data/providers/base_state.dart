import 'package:flutter/material.dart';

/// base state which contains commons state changing
/// data handling
class BaseState extends ChangeNotifier {
  /// scaffold which is used for toast or context
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// form key
  final _formKey = GlobalKey<FormState>();

  ///  error status
  var _displayErrorStatus = false;

  String _errorMessage = '';

  bool _progressIndicator = false;

  /// UI is in build
  bool isMounted = false;

  /// method to get scaffold key which provider context
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  /// method to get form state
  GlobalKey<FormState> get formKey => _formKey;

  /// method to get error status
  bool get errorStatus => _displayErrorStatus;

  /// method to get error string
  String get error => _errorMessage;

  /// method to get progress status
  bool get progressIndicatorStatus => _progressIndicator;

  /// method to ui status
  bool get mountedStatus => isMounted;

  /// method set mounted status
  void setMountedStatus(bool status) {
    isMounted = status;
  }

  /// method to  update  error
  void updateErrorWidget(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// method to dismiss error
  void dismissErrorWidget() {
    _errorMessage = '';
    notifyListeners();
  }

  /// method to update progess status
  void updateProgressIndicatorStatus(bool status) {
    _progressIndicator = status;
    notifyListeners();
  }
}

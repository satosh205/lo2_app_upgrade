class Log {
  static bool _isLogEnable = true;

  static void v(dynamic data) {
    if (_isLogEnable) {
      print(data);
    }
  }
}

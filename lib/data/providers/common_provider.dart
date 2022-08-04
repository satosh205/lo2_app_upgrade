import 'package:flutter/material.dart';

class CommonProvider extends ChangeNotifier {
  late String brandLogo;
  late String jonningLetter;
  CommonProvider(String brandLogo, String jonningLetter) {
    this.brandLogo = brandLogo;
    this.jonningLetter = jonningLetter;
    notifyListeners();
  }

  void setBrandLogo(String brandLogo) {
    this.brandLogo = brandLogo;
    notifyListeners();
  }

  void setJoinningLetter(String jonningLetter) {
    this.jonningLetter = jonningLetter;
    notifyListeners();
  }
}

String? validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,3}))$';
  RegExp regExp = new RegExp(pattern);
  if (value == null || value.trim().isEmpty) {
    return "Email is required";
  } else if (!regExp.hasMatch(value)) {
    return "Email address you have entered is invalid";
  } else
    return null;
}

String? validatePassword(String value) {
  String pattern = r'^(?=.*[0-9])(?=.*[a-z]).{7,}$';
  RegExp regExp = RegExp(pattern);
  if (value == null || value.trim().isEmpty) {
    return "Password required";
  } else if (value.contains(" ")) {
    return "Space not allowed";
  } else
    return null;
}

String? validatePassword1(String value) {
  if (value == null || value.trim().isEmpty) {
    return "Password required";
  } else
    return null;
}

class Regex {
  static bool isEmail(String email) {
    RegExp regExp = new RegExp(r'\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*');
    return regExp.hasMatch(email);
  }

  static bool validateZipCode(String value) {
    RegExp zipCodeRegExp = new RegExp(r'^\d{5}(?:[-\s]\d{4})?$');
    return zipCodeRegExp.hasMatch(value);
  }

  static bool validateDate(String value) {
    final regex = r'^\d{4}-\d{2}-\d{2}$';
    final match = RegExp(regex).hasMatch(value);
    return match;
  }

  static String removeSpecialChars(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }
}

import 'package:flutter/material.dart';

import '../app/konstanta/colors.dart';

class Utils {
  static void showMySnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Color(AppColors.secondary),
      content: Text(message),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // controller
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  var isHidden = true.obs;
  var isLoading = false.obs;
  // validasi email
  bool validateEmail(String email) {
    // Ekspresi reguler untuk memeriksa apakah teks adalah format email yang benar
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // controller
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  var isHidden = true.obs;
  var isLoading = false.obs;
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

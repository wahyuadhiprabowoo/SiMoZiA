import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBalitaController extends GetxController {
  //TODO: Implement AddBalitaController
  TextEditingController namaC = TextEditingController();
  
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

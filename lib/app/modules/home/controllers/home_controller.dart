import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ta/app/models/puskesmas.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  var puskesmasId = 0;
  // print(puskesmasId);
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

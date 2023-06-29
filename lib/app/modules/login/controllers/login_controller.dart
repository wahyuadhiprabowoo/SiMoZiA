import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  // controller
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  // post login
  // Future loginWithEmail() async {
  //   var headers = {'Content-Type': 'application/json'};
  //   try {
  //     // end point api
  //     var url =
  //         Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.loginEmail);
  //     // body
  //     Map body = {'email': emailC.text.trim(), 'password': passC.text.trim()};
  //     // post method
  //     http.Response response =
  //         await http.post(url, body: jsonEncode(body), headers: headers);
  //     // if success login
  //     if (response.statusCode == 200) {
  //       // get token
  //       final json = jsonDecode(response.body);
  //       var token = json['token'];
  //       // save to variabel
  //       var name = json['user']['name'];
  //       // save token to variable
  //       ApiService.setToken(token);

  //       // clear text editing
  //       emailC.clear();
  //       passC.clear();
  //       Get.offAllNamed(Routes.HOME);
  //       // print terminal show bug
  //       print("url api: $url");
  //       print("token: $token");
  //       print("name: $name");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Peringatan", "Terjadi kesahalan $e");
  //   }
  // }
  @override
  void onInit() async {
    super.onInit();
    String token = await ApiService.token();
    print("ini token login $token");
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/models/user.dart';

import '../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
// variabel
  var nameUser = "".obs;
  var emailUser = "".obs;
// get user information
// get user
  Future user() async {
    String token = await ApiService.getToken();
    try {
      var response = await http.get(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.user),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      // try and catch
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // get user information
        User user = User.fromJson(responseData);
        nameUser.value = user.name;
        emailUser.value = user.email;
        print(nameUser.value);
        print(emailUser.value);
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Terjadi kesalahan',
        middleText: '$e',
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: Text('OK'),
        ),
      );
    }
  }

  // alert logout
  void showAlertLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('Alert'),
        content: Text('Apakah anda ingin keluar?'),
        actions: [
          OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Tidak',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await ApiService.clearToken();
                Get.offAllNamed(Routes.LOGIN);
              },
              child: Text("Ya"))
        ],
      ),
    );
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    user();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

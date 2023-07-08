import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/models/user.dart';
import 'package:ta/utils/main.dart';

import '../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
// variabel
  var nameUser = "".obs;
  var emailUser = "".obs;
  var isLoading = false.obs;
// get user information
// get user
  Future user() async {
    String token = await ApiService.getToken();
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.user),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      // try and catch
      await Future.delayed(Duration(seconds: 1));
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // get user information
        User user = User.fromJson(responseData);
        nameUser.value = user.name;
        emailUser.value = user.email;
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
    } finally {
      isLoading.value = false;
    }
  }

  // alert logout
  void showAlertLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('Peringatan'),
        content: Text('Apakah anda ingin keluar?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Tidak',
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Obx(() => ApiService.isLoading.value
                  ? LoadingScreen(
                      color: Colors.brown,
                      size: 25,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        ApiService.isLoading.value = true;
                        await Future.delayed(Duration(seconds: 2));
                        await ApiService.clearToken();
                        ApiService.isLoading.value = false;
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      child: Text("Ya"))),
            ],
          )
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

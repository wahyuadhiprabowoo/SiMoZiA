///url api: https://admin-puskesmas.000webhostapp.com/api/
//all data: /all
// all puskesmas: /puskesmas
// detail puskesmas: /puskesmas/{id}
// all posyandu: /posyandu
// detail posyandu: /posyandu/{id}
// detail balita dari puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-panjang/{klasifikasi_panjang_badan}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-berat/{klasifikasi_berat_badan}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-detak/{klasifikasi_detak_jantung}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-create-at
// filter create->at http://localhost:8000/api/puskesmas/1/posyandu/4/balita/filter-create-at?start_date=2023-06-11&end_date=2023-06-30
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';

class ApiService {
  // slobal token
  static Future<String> token() async {
    String token = await getToken();
    return token;
  }

  //isloading variabel
  static var isLoading = false.obs;

// get token
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // set token
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // clear token
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // login api
  static Future<void> login(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;
      print("ini nilai is loading ${isLoading.value}");
      var response = await http.post(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.loginEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        String token = responseData[
            'token']; // Ganti dengan properti token yang diberikan oleh API Anda
        await setToken(token);

        await Future.delayed(Duration(seconds: 3));
        Get.offAllNamed(Routes.HOME);
      }
      // akun tidak ditemukan
      if (response.statusCode == 401) {
        Get.dialog(
          AlertDialog(
            title: Text('Peringatan'),
            content: Text('Email atau password salah!'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: Text("Ya"))
            ],
          ),
        );
      }
      // hanya nakes yang boleh mengakses
      if (response.statusCode == 404) {
        Get.dialog(
          AlertDialog(
            title: Text('Peringatan'),
            content: Text('Hanya admin yang boleh mengakses!'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: Text("Ya"))
            ],
          ),
        );
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Terjadi kesalahan, yaitu: $e'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: Text("Ya"))
        ],
      ));
    } finally {
      isLoading.value = false;
      print("ini nilai is loading setelah sukses ${isLoading.value}");
    }
  }

  // register api
  static Future<void> register(Map<String, dynamic> register) async {
    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.registerEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(register),
      );
      // try and catch
      print("ini respon server ${response.statusCode}");
      await Future.delayed(Duration(seconds: 3));
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        String name = responseData["user"]["name"];
        Get.dialog(AlertDialog(
          title: Text('Berhasil'),
          content: Text('Akun dengan nama: $name berhasil dibuat'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: Text("Ya"))
          ],
        ));
        Get.offNamed(Routes.LOGIN);
      }
      // iff error
      if (response.statusCode == 400) {
        Get.dialog(AlertDialog(
          title: Text('Peringatan'),
          content: Text('Terjadi kesalahan, periksa data diri!'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                },
                child: Text("Ya"))
          ],
        ));
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Terjadi kesalahan, yaitu: $e'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: Text("Ya"))
        ],
      ));
    } finally {
      isLoading.value = false;
      print("ini nilai is loading setelah sukses ${isLoading.value}");
    }
  }

  // forget password api
  static Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse(
            ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      // delay
      await Future.delayed(Duration(seconds: 3));

      // try and catch
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newPassword = responseData["new_password"];
        Get.dialog(AlertDialog(
          title: Text('Password Baru'),
          content: Text('Password baru anda: $newPassword'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: Text("Ya"))
          ],
        ));
      }
      if (response.statusCode == 404) {
        Get.dialog(
          AlertDialog(
            title: Text('Peringatan'),
            content: Text('Email tidak ditemukan!'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  child: Text("Ya"))
            ],
          ),
        );
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Terjadi kesalahan, yaitu: $e'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: Text("Ya"))
        ],
      ));
    } finally {
      isLoading.value = false;
      print("ini nilai is loading setelah sukses ${isLoading.value}");
    }
  }

  //patch api user
  static Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      isLoading.value = true;
      String token = await ApiService.token();
      var response = await http.patch(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.user),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(userData),
      );
      // try and catch
      await Future.delayed(Duration(seconds: 3));
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        // do something
        var json = jsonDecode(response.body);
        print(json);
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Terjadi kesalahan, yaitu: $e'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: Text("Ya"))
        ],
      ));
    } finally {
      isLoading.value = false;
      print("ini nilai is loading setelah sukses ${isLoading.value}");
    }
  }
}

// end point api
class ApiEndPoint {
  static final String baseUrl = 'https://tw-demo.my.id/api/';
  static _AuthEndPoints authEndPoint = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerEmail = 'register';
  final String loginEmail = 'login';
  final String forgotPassword = 'forgotpassword';
  final String user = 'user';
  final String puskesmas = 'puskesmas';
}

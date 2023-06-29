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
import 'package:ta/app/models/user.dart';

import '../routes/app_pages.dart';

class ApiService {
  // slobal token
  static Future<String> token() async {
    String token = await getToken();
    return token;
  }

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
    var response = await http.post(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.loginEmail),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var name = responseData['user']['name'];
      String token = responseData[
          'token']; // Ganti dengan properti token yang diberikan oleh API Anda
      await setToken(token);
      print(token);
      print("name: $name");
      Get.offAllNamed(Routes.HOME);
    } else {
      throw Exception('Failed to login');
    }
  }

  // register api
  static Future<void> register(Map<String, dynamic> register) async {
    try {
      var response = await http.post(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.registerEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(register),
      );
      // try and catch
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        String token = responseData['token'];
        print(token);
        Get.offNamed(Routes.LOGIN);
      }
    } catch (e) {
      print(e);
    }
  }

  // forget password api
  static Future<void> forgotPassword(String email) async {
    try {
      var response = await http.post(
        Uri.parse(
            ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.forgotPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      // try and catch
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newPassword = responseData["new_password"];
        Get.defaultDialog(
          title: 'Password Baru',
          middleText: '$newPassword',
          confirm: ElevatedButton(
            onPressed: () => Get.offNamed(Routes.LOGIN),
            child: Text('OK'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  //patch api user
  static Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
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
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        // do something
        var json = jsonDecode(response.body);
        print(json);
      }
    } catch (e) {
      print(e);
    }
  }

  // sample fetch data
  static Future<String> fetchData() async {
    String token = await getToken();
    var response = await http.get(
      Uri.parse('${ApiEndPoint.baseUrl}${ApiEndPoint.authEndPoint.loginEmail}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch data');
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

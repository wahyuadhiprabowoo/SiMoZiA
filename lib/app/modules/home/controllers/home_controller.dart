import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/models/balita.dart';

import '../../../models/user.dart';

class HomeController extends GetxController {
  var nameUser = "".obs;
  var urlBalita = "".obs;
  var puskesmasId = 0.obs;
  var posyanduId = 0.obs;
  var puskesmasIdPosyandu = 0.obs;
  var foundBalita = false.obs;
  var foundPosyandu = false.obs;
  var foundPuskesmas = false.obs;
  var isLoading = false.obs;
  var namaPuskesmas = "".obs;
  var namaPosyandu = "".obs;
  RxList<Balita>? balitas = RxList<Balita>([]);

  Future<void> getAllBalita() async {
    String token = await ApiService.getToken();
    // url balita
    urlBalita.value =
        "${ApiEndPoint.baseUrl}puskesmas/${puskesmasId.value}/posyandu/${posyanduId.value}/balita/";
    try {
      ApiService.isLoading.value = true;
      Uri url = Uri.parse(urlBalita.value);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      await Future.delayed(Duration(seconds: 2));
      // masuk ke api -> data
      List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
      // print(data);
      // data dari api -> model yang telah dipersiapkan
      // print(data);
      if (response.statusCode == 200) {
        print("url balita ${urlBalita.value}");
        print("---");
        if (data.isEmpty) {
          balitas?.clear();
        } else {
          balitas?.assignAll(data.map((e) => Balita.fromJson(e)).toList());
        }
        // found balita == true
        foundBalita.value = true;
      }
    } catch (e) {
      foundBalita.value = false;
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Tidak ada data untuk ditampilkan'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Get.back();
              },
              child: Text("Ya"))
        ],
      ));
    } finally {
      ApiService.isLoading.value = false;
    }
    print("found balita ${foundBalita.value}");
  }

  // delete balita
  Future<void> deleteBalita(int balitaId) async {
    String token = await ApiService.getToken();
    String url =
        '${ApiEndPoint.baseUrl}puskesmas/$puskesmasId/posyandu/$posyanduId/balita/$balitaId';
    print(url);

    try {
      isLoading.value = true;
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      await Future.delayed(Duration(seconds: 2));
      if (response.statusCode == 200) {
        // Hapus data balita berhasil
        List<Balita> updatedBalitas =
            balitas!.where((balita) => balita.id != balitaId).toList();
        balitas!.assignAll(updatedBalitas);
        print('Data balita berhasil dihapus');
        Get.back();
      } else {
        // Gagal menghapus data balita
        print(
            'Gagal menghapus data balita. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Terjadi kesalahan dalam mengirim permintaan HTTP
      print('Terjadi kesalahan dalam menghapus data balita: $e');
    } finally {
      isLoading.value = false;
    }
  }

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

  @override
  void onInit() async {
    super.onInit();
    user();

    // Timer.periodic(Duration(seconds: 3), (Timer timer) {
    // getAllBalita();
    //   print("data telah berjalan 3 detik");
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

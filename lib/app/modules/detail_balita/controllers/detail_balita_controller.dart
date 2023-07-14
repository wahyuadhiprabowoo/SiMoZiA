import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/balita.dart';

class DetailBalitaController extends GetxController {
// dapatkan detail balita
  Balita balita = Get.arguments;
  var isLoading = false.obs;
  TextEditingController namaC = TextEditingController();
  TextEditingController usiaC = TextEditingController();
  TextEditingController namaIbuC = TextEditingController();
  TextEditingController jkC = TextEditingController();
  // variabel
  var panjangBadan = "".obs;
  var tinggiBadan = "".obs;
  var beratBadan = "".obs;
  var detakJantung = "".obs;
  var sistolik = "".obs;
  var diastolik = "".obs;
  var zscorePanjang = "".obs;
  var zscoreBerat = "".obs;
  var klasifikasiPanjang = "".obs;
  var klasifikasiBerat = "".obs;
  var klasifikasiDetakJantung = "".obs;
  // loadingscreen
  void loadingScreen() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadingScreen();
    // nilai awal
    namaC.text = balita.namaAnak;
    namaIbuC.text = balita.namaIbu;
    usiaC.text = "${balita.umur} bulan";
    jkC.text = balita.jenisKelamin;
    // pengukuran
    if (balita.umur < 10) {
      panjangBadan.value = "${balita.panjangBadan} cm";
    } else {
      tinggiBadan.value = "${balita.panjangBadan} cm";
    }

    beratBadan.value = "${balita.beratBadan} kg";
    // detakJantung.value = "${balita.detakJantung} bpm";
    // sistolik.value = "${balita.sistolik} sys";
    // diastolik.value = "${balita.diastolik} dia";
    // zscore

    zscoreBerat.value = "${balita.zscoreBeratBadan}";
    zscorePanjang.value = "${balita.zscorePanjangBadan}";
    // klasifikasi
    klasifikasiPanjang.value = "${balita.klasifikasiPanjangBadan}";
    klasifikasiBerat.value = "${balita.klasifikasiBeratBadan}";
    // klasifikasiDetakJantung.value = "${balita.klasifikasiDetakJantung}";
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

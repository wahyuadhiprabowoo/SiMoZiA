import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ta/app/modules/detail_pengukuran_berat_badan/controllers/detail_pengukuran_berat_badan_controller.dart';
import 'package:intl/intl.dart';
import 'package:ta/app/modules/detail_pengukuran_detak_jantung/controllers/detail_pengukuran_detak_jantung_controller.dart';
import 'package:ta/app/modules/detail_pengukuran_panjang_badan/controllers/detail_pengukuran_panjang_badan_controller.dart';

import '../../../api/api_services.dart';

class AddBalitaController extends GetxController {
// controller
  TextEditingController namaC = TextEditingController();
  TextEditingController usiaC = TextEditingController();
  final DetailPengukuranBeratBadanController controllerBeratBayi =
      Get.put(DetailPengukuranBeratBadanController());
  final DetailPengukuranPanjangBadanController controllerPanjangBayi =
      Get.put(DetailPengukuranPanjangBadanController());
  final DetailPengukuranDetakJantungController controllerDetakJantung =
      Get.put(DetailPengukuranDetakJantungController());
  final count = 0.obs;

  // variabel
  var usia = 0.obs;
  var puskesmasId = 0.obs;
  var posyanduId = 0.obs;
  // datetime calendar
  var fiveYearsAgo = DateTime.now().subtract(Duration(days: 365 * 5));
  var selectedDate = DateTime.now().obs;
  DateTime currentDate = DateTime.now();

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        helpText: "Tanggal Lahir Anda",
        fieldHintText: "ini hint",
        initialDate: selectedDate.value,
        firstDate: fiveYearsAgo,
        lastDate: currentDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly);

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      usiaC.text = DateFormat('dd MMM yyyy').format(picked);
    }
    // mendapatkan bulan
    var selectedUsia = getMonth();
    usia.value = selectedUsia.selectedUsia;
    print("${usia.value} bulan");
  }

  // mendapatkan usia bulan
  SelectedUsia getMonth() {
    final diffMonths = (currentDate.year - selectedDate.value.year) * 12 +
        currentDate.month -
        selectedDate.value.month;
    return SelectedUsia(selectedUsia: diffMonths);
  }

  // post data to api
  var dataPostBalita = {
    "nama_anak": "nama anak",
    "nama_ibu": "api",
    "alamat": "alamat ini",
    "jenis_kelamin": "laki-laki",
    "umur": 3,
    "berat_badan": 4,
    "panjang_badan": 4,
    "detak_jantung": 4,
    "zscore_berat_badan": 4,
    "zscore_panjang_badan": 4,
    "klasifikasi_berat_badan": "lebih",
    "klasifikasi_panjang_badan": "normal",
    "klasifikasi_detak_jantung": "takikardia",
    "sistolik": 0,
    "diastolik": 0,
  };

  //  post to api
  Future<void> postBalita(Map<String, dynamic> dataBalita) async {
    String token = await ApiService.token();
    String url =
        '${ApiEndPoint.baseUrl}puskesmas/$puskesmasId/posyandu/$posyanduId/balita';
    print(url);
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(dataBalita),
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

// get usia
class SelectedUsia {
  final int selectedUsia;
  SelectedUsia({required this.selectedUsia});
}

// berat
class ZscoreAndClasificationBerat {
  final double zscore;
  final String klasifikasi;
  ZscoreAndClasificationBerat(
      {required this.zscore, required this.klasifikasi});
}

// panjang
class ZscoreAndClasificationPanjang {
  final double zscore;
  final String klasifikasi;
  ZscoreAndClasificationPanjang(
      {required this.zscore, required this.klasifikasi});
}

// detakJantung
class ZscoreAndClasificationDetakJantung {
  final String klasifikasi;
  ZscoreAndClasificationDetakJantung({required this.klasifikasi});
}

// kode program klasifikasi detak jantung
ZscoreAndClasificationDetakJantung getKlasifikasiDetakJantung(
    int usia, int detakJantung) {
// klasifikasi detak jantung
// Bayi baru lahir hingga 1 bulan: 70 hingga 190.
// Bayi berusia 1 hingga 11 bulan: 80 hingga 160.
// Anak-anak berusia 1 hingga 2 tahun: 80 hingga 130.
// Usia 3 hingga 4 tahun: 80 hingga 120.
// >= takikardia
// <= bradikardia
//  normal
  // klasifikasi detak jantung dalam bentuk bulan
  //variabel pengukuran nilai sensor
  var klasifikasiDetakJantung =
      ""; //variabel menampung klasifikasi detak jantung
  // condition
  if (usia >= 0 && usia <= 1) {
    if (detakJantung < 70) {
      klasifikasiDetakJantung = "Bradikardia";
    } else if (detakJantung >= 70 && detakJantung <= 190) {
      klasifikasiDetakJantung = "Normal";
    } else {
      klasifikasiDetakJantung = "Takikardia";
    }
  }
  // condition
  if (usia > 1 && usia <= 11) {
    if (detakJantung < 80) {
      klasifikasiDetakJantung = "Bradikardia";
    } else if (detakJantung >= 80 && detakJantung <= 160) {
      klasifikasiDetakJantung = "Normal";
    } else {
      klasifikasiDetakJantung = "Takikardia";
    }
  }
  // condition
  if (usia > 11 && usia <= 24) {
    if (detakJantung < 80) {
      klasifikasiDetakJantung = "Bradikardia";
    } else if (detakJantung >= 80 && detakJantung <= 130) {
      klasifikasiDetakJantung = "Normal";
    } else {
      klasifikasiDetakJantung = "Takikardia";
    }
  }
  if (usia > 24 && usia <= 60) {
    if (detakJantung < 80) {
      klasifikasiDetakJantung = "Bradikardia";
    } else if (detakJantung >= 80 && detakJantung <= 120) {
      klasifikasiDetakJantung = "Normal";
    } else {
      klasifikasiDetakJantung = "Takikardia";
    }
  }
  // result
  print(klasifikasiDetakJantung);
  return ZscoreAndClasificationDetakJantung(
      klasifikasi: klasifikasiDetakJantung);
}

// kode program klasifikasi berat badan
ZscoreAndClasificationBerat getKlasifikasiBeratBadan(
    String jk, int usia, double beratBadan) {
  //Berat badan kurang
// (underweight)
// - 3 SD sd <- 2 SD
// Berat badan normal -2 SD sd +1 SD
// Risiko Berat badan lebih > +1 SD
// rumus
//  int result = -(a + b);
  ///jika berat badan - median = positif: +1 sd - median
  ///jika berat badan - median = negatif: median - (-1 sd)
// sample bb= 5.8, 3 bulan, laki-laki
  ///klasifikasi berat badan
//
  var result = 0.0;
  var resultToString = "";
  var zscoreBeratBadan = "";
  var klasifikasiBeratBadan = "";
  var min1Sd = 0.0;
  var plus1Sd = 0.0;
  var median = 0.0;
  // first condition berat badan
  if (jk == 'laki-laki') {
    // condition usia 0 klasifikasi berat badan
    if (usia == 0) {
      min1Sd = 2.9;
      median = 3.3;
      plus1Sd = 3.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      // kurang
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 1 klasifikasi berat badan
    if (usia == 1) {
      min1Sd = 3.9;
      median = 4.5;
      plus1Sd = 5.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 2 klasifikasi berat badan
    if (usia == 2) {
      min1Sd = 4.9;
      median = 5.6;
      plus1Sd = 6.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 3 klasifikasi berat badan
    if (usia == 3) {
      min1Sd = 5.7;
      median = 6.4;
      plus1Sd = 7.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 4 klasifikasi berat badan
    if (usia == 4) {
      min1Sd = 6.2;
      median = 7.0;
      plus1Sd = 7.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 5 klasifikasi berat badan
    if (usia == 5) {
      min1Sd = 6.7;
      median = 7.5;
      plus1Sd = 8.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 6 klasifikasi berat badan
    if (usia == 6) {
      min1Sd = 7.1;
      median = 7.9;
      plus1Sd = 8.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 7 klasifikasi berat badan
    if (usia == 7) {
      min1Sd = 7.4;
      median = 8.3;
      plus1Sd = 9.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 8 klasifikasi berat badan
    if (usia == 8) {
      min1Sd = 7.7;
      median = 8.6;
      plus1Sd = 9.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 9 klasifikasi berat badan
    if (usia == 9) {
      min1Sd = 8.0;
      median = 8.9;
      plus1Sd = 9.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 10 klasifikasi berat badan
    if (usia == 10) {
      min1Sd = 8.2;
      median = 9.2;
      plus1Sd = 10.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 11 klasifikasi berat badan
    if (usia == 11) {
      min1Sd = 8.4;
      median = 9.4;
      plus1Sd = 10.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 12 klasifikasi berat badan
    if (usia == 12) {
      min1Sd = 8.6;
      median = 9.6;
      plus1Sd = 10.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 13 klasifikasi berat badan
    if (usia == 13) {
      min1Sd = 8.8;
      median = 9.9;
      plus1Sd = 11.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 14 klasifikasi berat badan
    if (usia == 14) {
      min1Sd = 9.0;
      median = 10.1;
      plus1Sd = 11.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 15 klasifikasi berat badan
    if (usia == 15) {
      min1Sd = 9.2;
      median = 10.3;
      plus1Sd = 11.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 16 klasifikasi berat badan
    if (usia == 16) {
      min1Sd = 9.4;
      median = 10.5;
      plus1Sd = 11.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 17 klasifikasi berat badan
    if (usia == 17) {
      min1Sd = 9.6;
      median = 10.7;
      plus1Sd = 12.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 18 klasifikasi berat badan
    if (usia == 18) {
      min1Sd = 9.8;
      median = 10.9;
      plus1Sd = 12.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 19 klasifikasi berat badan
    if (usia == 19) {
      min1Sd = 10.0;
      median = 11.1;
      plus1Sd = 12.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 20 klasifikasi berat badan
    if (usia == 20) {
      min1Sd = 10.1;
      median = 11.3;
      plus1Sd = 12.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 21 klasifikasi berat badan
    if (usia == 21) {
      min1Sd = 10.3;
      median = 11.5;
      plus1Sd = 12.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 22 klasifikasi berat badan
    if (usia == 22) {
      min1Sd = 10.5;
      median = 11.8;
      plus1Sd = 13.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 23 klasifikasi berat badan
    if (usia == 23) {
      min1Sd = 10.7;
      median = 12.0;
      plus1Sd = 13.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 24 klasifikasi berat badan
    if (usia == 24) {
      min1Sd = 10.8;
      median = 12.2;
      plus1Sd = 13.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 25 klasifikasi berat badan
    if (usia == 25) {
      min1Sd = 11.0;
      median = 12.4;
      plus1Sd = 13.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 26 klasifikasi berat badan
    if (usia == 26) {
      min1Sd = 11.2;
      median = 12.5;
      plus1Sd = 14.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 27 klasifikasi berat badan
    if (usia == 27) {
      min1Sd = 11.3;
      median = 12.7;
      plus1Sd = 14.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 28 klasifikasi berat badan
    if (usia == 28) {
      min1Sd = 11.5;
      median = 12.9;
      plus1Sd = 14.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 29 klasifikasi berat badan
    if (usia == 29) {
      min1Sd = 11.7;
      median = 13.1;
      plus1Sd = 14.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 30 klasifikasi berat badan
    if (usia == 30) {
      min1Sd = 11.8;
      median = 13.3;
      plus1Sd = 15.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 31 klasifikasi berat badan
    if (usia == 31) {
      min1Sd = 12.0;
      median = 13.5;
      plus1Sd = 15.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 32 klasifikasi berat badan
    if (usia == 32) {
      min1Sd = 12.1;
      median = 13.7;
      plus1Sd = 15.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 33 klasifikasi berat badan
    if (usia == 33) {
      min1Sd = 12.3;
      median = 13.8;
      plus1Sd = 15.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 34 klasifikasi berat badan
    if (usia == 34) {
      min1Sd = 12.4;
      median = 14.0;
      plus1Sd = 15.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 35 klasifikasi berat badan
    if (usia == 35) {
      min1Sd = 12.6;
      median = 14.2;
      plus1Sd = 16.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 36 klasifikasi berat badan
    if (usia == 36) {
      min1Sd = 12.7;
      median = 14.3;
      plus1Sd = 16.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 37 klasifikasi berat badan
    if (usia == 37) {
      min1Sd = 12.9;
      median = 14.5;
      plus1Sd = 16.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 38 klasifikasi berat badan
    if (usia == 38) {
      min1Sd = 13.0;
      median = 14.7;
      plus1Sd = 16.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 39 klasifikasi berat badan
    if (usia == 39) {
      min1Sd = 13.1;
      median = 14.8;
      plus1Sd = 16.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 40 klasifikasi berat badan
    if (usia == 40) {
      min1Sd = 13.3;
      median = 15.0;
      plus1Sd = 17.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 41 klasifikasi berat badan
    if (usia == 41) {
      min1Sd = 13.4;
      median = 15.2;
      plus1Sd = 17.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 42 klasifikasi berat badan
    if (usia == 42) {
      min1Sd = 13.6;
      median = 15.3;
      plus1Sd = 17.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 43 klasifikasi berat badan
    if (usia == 43) {
      min1Sd = 13.7;
      median = 15.5;
      plus1Sd = 17.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 44 klasifikasi berat badan
    if (usia == 44) {
      min1Sd = 13.8;
      median = 15.7;
      plus1Sd = 17.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 45 klasifikasi berat badan
    if (usia == 45) {
      min1Sd = 14.0;
      median = 15.8;
      plus1Sd = 18.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 46 klasifikasi berat badan
    if (usia == 46) {
      min1Sd = 14.1;
      median = 16.0;
      plus1Sd = 18.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 47 klasifikasi berat badan
    if (usia == 47) {
      min1Sd = 14.3;
      median = 16.2;
      plus1Sd = 18.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 48 klasifikasi berat badan
    if (usia == 48) {
      min1Sd = 14.4;
      median = 16.3;
      plus1Sd = 18.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 49 klasifikasi berat badan
    if (usia == 49) {
      min1Sd = 14.5;
      median = 16.5;
      plus1Sd = 18.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 50 klasifikasi berat badan
    if (usia == 50) {
      min1Sd = 14.7;
      median = 16.7;
      plus1Sd = 19.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 51 klasifikasi berat badan
    if (usia == 51) {
      min1Sd = 14.8;
      median = 16.8;
      plus1Sd = 19.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 52 klasifikasi berat badan
    if (usia == 52) {
      min1Sd = 15.0;
      median = 17.0;
      plus1Sd = 19.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 53 klasifikasi berat badan
    if (usia == 53) {
      min1Sd = 15.1;
      median = 17.2;
      plus1Sd = 19.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 54 klasifikasi berat badan
    if (usia == 54) {
      min1Sd = 15.2;
      median = 17.3;
      plus1Sd = 19.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 55 klasifikasi berat badan
    if (usia == 55) {
      min1Sd = 15.4;
      median = 17.5;
      plus1Sd = 20.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 56 klasifikasi berat badan
    if (usia == 56) {
      min1Sd = 15.5;
      median = 17.7;
      plus1Sd = 20.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 57 klasifikasi berat badan
    if (usia == 57) {
      min1Sd = 15.6;
      median = 17.8;
      plus1Sd = 20.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 58 klasifikasi berat badan
    if (usia == 58) {
      min1Sd = 15.8;
      median = 18.0;
      plus1Sd = 20.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 59 klasifikasi berat badan
    if (usia == 59) {
      min1Sd = 15.9;
      median = 18.2;
      plus1Sd = 20.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
  } else if (jk == 'perempuan') {
    // do something
    // condition usia 0 klasifikasi berat badan
    if (usia == 0) {
      min1Sd = 2.8;
      median = 3.2;
      plus1Sd = 3.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      // kurang
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 1 klasifikasi berat badan
    if (usia == 1) {
      min1Sd = 3.6;
      median = 4.2;
      plus1Sd = 4.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 2 klasifikasi berat badan
    if (usia == 2) {
      min1Sd = 4.5;
      median = 5.1;
      plus1Sd = 5.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 3 klasifikasi berat badan
    if (usia == 3) {
      min1Sd = 5.2;
      median = 5.8;
      plus1Sd = 6.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 4 klasifikasi berat badan
    if (usia == 4) {
      min1Sd = 5.7;
      median = 6.4;
      plus1Sd = 7.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 5 klasifikasi berat badan
    if (usia == 5) {
      min1Sd = 6.1;
      median = 6.9;
      plus1Sd = 7.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 6 klasifikasi berat badan
    if (usia == 6) {
      min1Sd = 6.5;
      median = 7.3;
      plus1Sd = 8.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 7 klasifikasi berat badan
    if (usia == 7) {
      min1Sd = 6.8;
      median = 7.6;
      plus1Sd = 8.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 8 klasifikasi berat badan
    if (usia == 8) {
      min1Sd = 7.0;
      median = 7.9;
      plus1Sd = 9.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 9 klasifikasi berat badan
    if (usia == 9) {
      min1Sd = 7.3;
      median = 8.2;
      plus1Sd = 9.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 10 klasifikasi berat badan
    if (usia == 10) {
      min1Sd = 7.5;
      median = 8.5;
      plus1Sd = 9.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 11 klasifikasi berat badan
    if (usia == 11) {
      min1Sd = 7.7;
      median = 8.7;
      plus1Sd = 9.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 12 klasifikasi berat badan
    if (usia == 12) {
      min1Sd = 7.9;
      median = 8.9;
      plus1Sd = 10.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 13 klasifikasi berat badan
    if (usia == 13) {
      min1Sd = 8.1;
      median = 9.2;
      plus1Sd = 10.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 14 klasifikasi berat badan
    if (usia == 14) {
      min1Sd = 8.3;
      median = 9.4;
      plus1Sd = 10.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 15 klasifikasi berat badan
    if (usia == 15) {
      min1Sd = 8.5;
      median = 9.6;
      plus1Sd = 10.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 16 klasifikasi berat badan
    if (usia == 16) {
      min1Sd = 8.7;
      median = 9.8;
      plus1Sd = 11.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 17 klasifikasi berat badan
    if (usia == 17) {
      min1Sd = 8.9;
      median = 10.0;
      plus1Sd = 11.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 18 klasifikasi berat badan
    if (usia == 18) {
      min1Sd = 9.1;
      median = 10.2;
      plus1Sd = 11.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 19 klasifikasi berat badan
    if (usia == 19) {
      min1Sd = 9.2;
      median = 10.4;
      plus1Sd = 11.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 20 klasifikasi berat badan
    if (usia == 20) {
      min1Sd = 9.4;
      median = 10.6;
      plus1Sd = 12.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 21 klasifikasi berat badan
    if (usia == 21) {
      min1Sd = 9.6;
      median = 10.9;
      plus1Sd = 12.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 22 klasifikasi berat badan
    if (usia == 22) {
      min1Sd = 9.8;
      median = 11.1;
      plus1Sd = 12.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 23 klasifikasi berat badan
    if (usia == 23) {
      min1Sd = 10.0;
      median = 11.3;
      plus1Sd = 12.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 24 klasifikasi berat badan
    if (usia == 24) {
      min1Sd = 10.2;
      median = 11.5;
      plus1Sd = 13.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 25 klasifikasi berat badan
    if (usia == 25) {
      min1Sd = 11.7;
      median = 13.3;
      plus1Sd = 15.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
// condition usia 26 klasifikasi berat badan
    if (usia == 26) {
      min1Sd = 10.5;
      median = 11.9;
      plus1Sd = 13.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 27 klasifikasi berat badan
    if (usia == 27) {
      min1Sd = 10.7;
      median = 12.1;
      plus1Sd = 13.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 28 klasifikasi berat badan
    if (usia == 28) {
      min1Sd = 10.9;
      median = 12.3;
      plus1Sd = 14.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 29 klasifikasi berat badan
    if (usia == 29) {
      min1Sd = 11.1;
      median = 12.5;
      plus1Sd = 14.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 30 klasifikasi berat badan
    if (usia == 30) {
      min1Sd = 11.2;
      median = 12.7;
      plus1Sd = 14.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 31 klasifikasi berat badan
    if (usia == 31) {
      min1Sd = 11.4;
      median = 12.9;
      plus1Sd = 14.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 32 klasifikasi berat badan
    if (usia == 32) {
      min1Sd = 11.6;
      median = 13.1;
      plus1Sd = 14.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 33 klasifikasi berat badan
    if (usia == 33) {
      min1Sd = 11.7;
      median = 13.3;
      plus1Sd = 15.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 34 klasifikasi berat badan
    if (usia == 34) {
      min1Sd = 11.9;
      median = 13.5;
      plus1Sd = 15.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 35 klasifikasi berat badan
    if (usia == 35) {
      min1Sd = 12.0;
      median = 13.7;
      plus1Sd = 15.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 36 klasifikasi berat badan
    if (usia == 36) {
      min1Sd = 12.2;
      median = 13.9;
      plus1Sd = 15.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 37 klasifikasi berat badan
    if (usia == 37) {
      min1Sd = 12.4;
      median = 14.0;
      plus1Sd = 16.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 38 klasifikasi berat badan
    if (usia == 38) {
      min1Sd = 12.5;
      median = 14.2;
      plus1Sd = 16.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 39 klasifikasi berat badan
    if (usia == 39) {
      min1Sd = 12.7;
      median = 14.4;
      plus1Sd = 16.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 40 klasifikasi berat badan
    if (usia == 40) {
      min1Sd = 12.8;
      median = 14.6;
      plus1Sd = 16.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 41 klasifikasi berat badan
    if (usia == 41) {
      min1Sd = 13.0;
      median = 14.8;
      plus1Sd = 16.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 42 klasifikasi berat badan
    if (usia == 42) {
      min1Sd = 13.1;
      median = 15.0;
      plus1Sd = 17.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 43 klasifikasi berat badan
    if (usia == 43) {
      min1Sd = 13.3;
      median = 15.2;
      plus1Sd = 17.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 44 klasifikasi berat badan
    if (usia == 44) {
      min1Sd = 13.4;
      median = 15.3;
      plus1Sd = 17.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 45 klasifikasi berat badan
    if (usia == 45) {
      min1Sd = 13.6;
      median = 15.5;
      plus1Sd = 17.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 46 klasifikasi berat badan
    if (usia == 46) {
      min1Sd = 13.7;
      median = 15.7;
      plus1Sd = 18.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 47 klasifikasi berat badan
    if (usia == 47) {
      min1Sd = 13.9;
      median = 15.9;
      plus1Sd = 18.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 48 klasifikasi berat badan
    if (usia == 48) {
      min1Sd = 14.0;
      median = 16.1;
      plus1Sd = 18.5;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 49 klasifikasi berat badan
    if (usia == 49) {
      min1Sd = 14.2;
      median = 16.3;
      plus1Sd = 18.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 50 klasifikasi berat badan
    if (usia == 50) {
      min1Sd = 14.3;
      median = 16.4;
      plus1Sd = 19.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 51 klasifikasi berat badan
    if (usia == 51) {
      min1Sd = 14.5;
      median = 16.6;
      plus1Sd = 19.2;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 52 klasifikasi berat badan
    if (usia == 52) {
      min1Sd = 14.6;
      median = 16.8;
      plus1Sd = 19.4;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 53 klasifikasi berat badan
    if (usia == 53) {
      min1Sd = 14.8;
      median = 17.0;
      plus1Sd = 19.7;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 54 klasifikasi berat badan
    if (usia == 54) {
      min1Sd = 14.9;
      median = 17.2;
      plus1Sd = 19.9;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 55 klasifikasi berat badan
    if (usia == 55) {
      min1Sd = 15.1;
      median = 17.3;
      plus1Sd = 20.1;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 56 klasifikasi berat badan
    if (usia == 56) {
      min1Sd = 15.2;
      median = 17.5;
      plus1Sd = 20.3;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 57 klasifikasi berat badan
    if (usia == 57) {
      min1Sd = 15.3;
      median = 17.7;
      plus1Sd = 20.6;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 58 klasifikasi berat badan
    if (usia == 58) {
      min1Sd = 15.5;
      median = 17.7;
      plus1Sd = 20.8;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }
    // condition usia 59 klasifikasi berat badan
    if (usia == 59) {
      min1Sd = 15.6;
      median = 18.0;
      plus1Sd = 21.0;
      // zscore
      if (beratBadan > median) {
        result = (beratBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "+$resultToString SD";
      } else {
        result = (beratBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscoreBeratBadan = "$resultToString SD";
      }
      // klasifikasi berat
      if (result < -2.0) {
        klasifikasiBeratBadan = "Kurang";
      } else if (result >= -2.0 && result <= 1.0) {
        klasifikasiBeratBadan = "Normal";
      } else {
        klasifikasiBeratBadan = "Lebih";
      }
    }

    // end condition
  }

  print(result);
  print(
      "klasifikasi berat badan $klasifikasiBeratBadan dengan $zscoreBeratBadan");
  return ZscoreAndClasificationBerat(
      zscore: double.parse(resultToString), klasifikasi: klasifikasiBeratBadan);
}

// kode program klasifikasi panjang badan
ZscoreAndClasificationPanjang getKlasifikasiPanjangBadan(
  String jk,
  int usia,
  double panjangBadan,
) {
// Pendek (stunted) - 3 SD sd <- 2 SD
// Normal -2 SD sd +3 SD
// Tinggi2 > +3 SD
  ///inisialisasi variabel
  var result = 0.0;
  var resultToString = "";
  var zscorePanjangBadan = "";
  var klasifikasiPanjangBadan = "";
  var min1Sd = 0.0;
  var plus1Sd = 0.0;
  var median = 0.0;
  // first condition
  if (jk == 'laki-laki') {
    // condition usia 0 deteksi panjang badan
    if (usia == 0) {
      min1Sd = 48.0;
      median = 49.9;
      plus1Sd = 51.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 1 deteksi panjang badan
    if (usia == 1) {
      min1Sd = 52.8;
      median = 54.7;
      plus1Sd = 56.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 2 deteksi panjang badan
    if (usia == 2) {
      min1Sd = 56.4;
      median = 58.4;
      plus1Sd = 60.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 3 deteksi panjang badan
    if (usia == 3) {
      min1Sd = 59.4;
      median = 61.4;
      plus1Sd = 63.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 4 deteksi panjang badan
    if (usia == 4) {
      min1Sd = 61.8;
      median = 63.9;
      plus1Sd = 66.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 5 deteksi panjang badan
    if (usia == 5) {
      min1Sd = 63.8;
      median = 65.9;
      plus1Sd = 68.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 6 deteksi panjang badan
    if (usia == 6) {
      min1Sd = 65.5;
      median = 67.6;
      plus1Sd = 69.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 7 deteksi panjang badan
    if (usia == 7) {
      min1Sd = 67.0;
      median = 69.2;
      plus1Sd = 71.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 8 deteksi panjang badan
    if (usia == 8) {
      min1Sd = 68.4;
      median = 70.6;
      plus1Sd = 72.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 9 deteksi panjang badan
    if (usia == 9) {
      min1Sd = 69.7;
      median = 72.0;
      plus1Sd = 74.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
// condition usia 10 deteksi panjang badan
    if (usia == 10) {
      min1Sd = 71.0;
      median = 73.3;
      plus1Sd = 75.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 11 deteksi panjang badan
    if (usia == 11) {
      min1Sd = 72.2;
      median = 74.5;
      plus1Sd = 76.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 12 deteksi panjang badan
    if (usia == 12) {
      min1Sd = 73.4;
      median = 75.7;
      plus1Sd = 78.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 13 deteksi panjang badan
    if (usia == 13) {
      min1Sd = 74.5;
      median = 76.9;
      plus1Sd = 79.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 14 deteksi panjang badan
    if (usia == 14) {
      min1Sd = 75.6;
      median = 78.0;
      plus1Sd = 80.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 15 deteksi panjang badan
    if (usia == 15) {
      min1Sd = 76.6;
      median = 79.1;
      plus1Sd = 81.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 16 deteksi panjang badan
    if (usia == 16) {
      min1Sd = 77.6;
      median = 80.2;
      plus1Sd = 82.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 17 deteksi panjang badan
    if (usia == 17) {
      min1Sd = 78.6;
      median = 81.2;
      plus1Sd = 83.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 18 deteksi panjang badan
    if (usia == 18) {
      min1Sd = 79.6;
      median = 82.3;
      plus1Sd = 85.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 19 deteksi panjang badan
    if (usia == 19) {
      min1Sd = 80.5;
      median = 83.2;
      plus1Sd = 86.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 20 deteksi panjang badan
    if (usia == 20) {
      min1Sd = 81.4;
      median = 84.2;
      plus1Sd = 87.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 21 deteksi panjang badan
    if (usia == 21) {
      min1Sd = 82.3;
      median = 85.1;
      plus1Sd = 88.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 22 deteksi panjang badan
    if (usia == 22) {
      min1Sd = 83.1;
      median = 86.0;
      plus1Sd = 89.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 23 deteksi panjang badan
    if (usia == 23) {
      min1Sd = 83.9;
      median = 86.9;
      plus1Sd = 89.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 24 deteksi panjang badan
    if (usia == 24) {
      min1Sd = 84.8;
      median = 87.8;
      plus1Sd = 90.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 25 deteksi tinggi badan
    if (usia == 25) {
      min1Sd = 84.9;
      median = 88.0;
      plus1Sd = 91.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 26 deteksi tinggi badan
    if (usia == 26) {
      min1Sd = 85.6;
      median = 88.8;
      plus1Sd = 92.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 27 deteksi tinggi badan
    if (usia == 27) {
      min1Sd = 86.4;
      median = 89.6;
      plus1Sd = 92.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 28 deteksi tinggi badan
    if (usia == 28) {
      min1Sd = 87.1;
      median = 90.4;
      plus1Sd = 93.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 29 deteksi tinggi badan
    if (usia == 29) {
      min1Sd = 87.8;
      median = 91.2;
      plus1Sd = 94.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 30 deteksi tinggi badan
    if (usia == 30) {
      min1Sd = 88.5;
      median = 91.9;
      plus1Sd = 95.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 31 deteksi tinggi badan
    if (usia == 31) {
      min1Sd = 89.2;
      median = 92.7;
      plus1Sd = 96.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 32 deteksi tinggi badan
    if (usia == 32) {
      min1Sd = 89.9;
      median = 93.4;
      plus1Sd = 96.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 33 deteksi tinggi badan
    if (usia == 33) {
      min1Sd = 90.5;
      median = 94.1;
      plus1Sd = 97.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 34 deteksi tinggi badan
    if (usia == 34) {
      min1Sd = 91.1;
      median = 94.8;
      plus1Sd = 98.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 35 deteksi tinggi badan
    if (usia == 35) {
      min1Sd = 91.8;
      median = 95.4;
      plus1Sd = 99.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 36 deteksi tinggi badan
    if (usia == 36) {
      min1Sd = 92.4;
      median = 96.1;
      plus1Sd = 99.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 37 deteksi tinggi badan
    if (usia == 37) {
      min1Sd = 93.0;
      median = 96.7;
      plus1Sd = 100.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 38 deteksi tinggi badan
    if (usia == 38) {
      min1Sd = 93.6;
      median = 97.4;
      plus1Sd = 101.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 39 deteksi tinggi badan
    if (usia == 39) {
      min1Sd = 94.2;
      median = 98.0;
      plus1Sd = 101.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 40 deteksi tinggi badan
    if (usia == 40) {
      min1Sd = 94.7;
      median = 98.6;
      plus1Sd = 102.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 41 deteksi tinggi badan
    if (usia == 41) {
      min1Sd = 95.3;
      median = 99.2;
      plus1Sd = 103.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 42 deteksi tinggi badan
    if (usia == 42) {
      min1Sd = 95.9;
      median = 99.9;
      plus1Sd = 103.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 43 deteksi tinggi badan
    if (usia == 43) {
      min1Sd = 96.4;
      median = 100.4;
      plus1Sd = 104.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 44 deteksi tinggi badan
    if (usia == 44) {
      min1Sd = 97.0;
      median = 101.0;
      plus1Sd = 105.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 45 deteksi tinggi badan
    if (usia == 45) {
      min1Sd = 97.5;
      median = 101.6;
      plus1Sd = 105.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 46 deteksi tinggi badan
    if (usia == 46) {
      min1Sd = 98.1;
      median = 102.2;
      plus1Sd = 106.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 47 deteksi tinggi badan
    if (usia == 47) {
      min1Sd = 98.6;
      median = 102.8;
      plus1Sd = 106.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 48 deteksi tinggi badan
    if (usia == 48) {
      min1Sd = 99.1;
      median = 103.3;
      plus1Sd = 107.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 49 deteksi tinggi badan
    if (usia == 49) {
      min1Sd = 99.7;
      median = 103.9;
      plus1Sd = 108.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 50 deteksi tinggi badan
    if (usia == 50) {
      min1Sd = 100.2;
      median = 104.4;
      plus1Sd = 108.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 51 deteksi tinggi badan
    if (usia == 51) {
      min1Sd = 100.7;
      median = 105.0;
      plus1Sd = 109.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 52 deteksi tinggi badan
    if (usia == 52) {
      min1Sd = 101.2;
      median = 105.6;
      plus1Sd = 109.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 53 deteksi tinggi badan
    if (usia == 53) {
      min1Sd = 101.7;
      median = 106.1;
      plus1Sd = 110.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 54 deteksi tinggi badan
    if (usia == 54) {
      min1Sd = 102.3;
      median = 106.7;
      plus1Sd = 111.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 55 deteksi tinggi badan
    if (usia == 55) {
      min1Sd = 102.8;
      median = 107.2;
      plus1Sd = 111.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 56 deteksi tinggi badan
    if (usia == 56) {
      min1Sd = 103.3;
      median = 107.8;
      plus1Sd = 112.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 57 deteksi tinggi badan
    if (usia == 57) {
      min1Sd = 103.8;
      median = 108.3;
      plus1Sd = 112.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 58 deteksi tinggi badan
    if (usia == 58) {
      min1Sd = 104.3;
      median = 108.9;
      plus1Sd = 113.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 59 deteksi tinggi badan
    if (usia == 59) {
      min1Sd = 104.8;
      median = 109.4;
      plus1Sd = 114.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // print terminal
    print(resultToString);
    print(
        "panjang badan: $panjangBadan dengan zscore: $resultToString dengan klasifikasi: $klasifikasiPanjangBadan");
  }
  if (jk == "perempuan") {
    // condition usia 0 deteksi panjang badan
    if (usia == 0) {
      min1Sd = 47.3;
      median = 49.1;
      plus1Sd = 51.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 1 deteksi panjang badan
    if (usia == 1) {
      min1Sd = 51.7;
      median = 53.7;
      plus1Sd = 55.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 2 deteksi panjang badan
    if (usia == 2) {
      min1Sd = 55.0;
      median = 57.1;
      plus1Sd = 59.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 3 deteksi panjang badan
    if (usia == 3) {
      min1Sd = 57.7;
      median = 59.8;
      plus1Sd = 61.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 4 deteksi panjang badan
    if (usia == 4) {
      min1Sd = 59.9;
      median = 62.1;
      plus1Sd = 64.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 5 deteksi panjang badan
    if (usia == 5) {
      min1Sd = 61.8;
      median = 64.0;
      plus1Sd = 66.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 6 deteksi panjang badan
    if (usia == 6) {
      min1Sd = 63.5;
      median = 65.7;
      plus1Sd = 68.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 7 deteksi panjang badan
    if (usia == 7) {
      min1Sd = 65.0;
      median = 67.3;
      plus1Sd = 69.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 8 deteksi panjang badan
    if (usia == 8) {
      min1Sd = 66.4;
      median = 68.7;
      plus1Sd = 71.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 9 deteksi panjang badan
    if (usia == 9) {
      min1Sd = 67.7;
      median = 70.1;
      plus1Sd = 72.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
// condition usia 10 deteksi panjang badan
    if (usia == 10) {
      min1Sd = 69.0;
      median = 71.5;
      plus1Sd = 73.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 11 deteksi panjang badan
    if (usia == 11) {
      min1Sd = 70.3;
      median = 72.8;
      plus1Sd = 75.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 12 deteksi panjang badan
    if (usia == 12) {
      min1Sd = 71.4;
      median = 74.0;
      plus1Sd = 76.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 13 deteksi panjang badan
    if (usia == 13) {
      min1Sd = 72.6;
      median = 75.2;
      plus1Sd = 77.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 14 deteksi panjang badan
    if (usia == 14) {
      min1Sd = 73.7;
      median = 76.4;
      plus1Sd = 79.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 15 deteksi panjang badan
    if (usia == 15) {
      min1Sd = 74.8;
      median = 77.5;
      plus1Sd = 80.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 16 deteksi panjang badan
    if (usia == 16) {
      min1Sd = 75.8;
      median = 78.6;
      plus1Sd = 81.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 17 deteksi panjang badan
    if (usia == 17) {
      min1Sd = 76.8;
      median = 79.7;
      plus1Sd = 82.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 18 deteksi panjang badan
    if (usia == 18) {
      min1Sd = 77.8;
      median = 80.7;
      plus1Sd = 83.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 19 deteksi panjang badan
    if (usia == 19) {
      min1Sd = 78.8;
      median = 81.7;
      plus1Sd = 84.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 20 deteksi panjang badan
    if (usia == 20) {
      min1Sd = 79.7;
      median = 82.7;
      plus1Sd = 85.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 21 deteksi panjang badan
    if (usia == 21) {
      min1Sd = 80.6;
      median = 83.7;
      plus1Sd = 86.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 22 deteksi panjang badan
    if (usia == 22) {
      min1Sd = 81.5;
      median = 84.6;
      plus1Sd = 87.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 23 deteksi panjang badan
    if (usia == 23) {
      min1Sd = 82.3;
      median = 85.5;
      plus1Sd = 88.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 24 deteksi panjang badan
    if (usia == 24) {
      min1Sd = 83.2;
      median = 86.4;
      plus1Sd = 89.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 25 deteksi tinggi badan
    if (usia == 25) {
      min1Sd = 83.3;
      median = 86.6;
      plus1Sd = 89.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 26 deteksi tinggi badan
    if (usia == 26) {
      min1Sd = 84.1;
      median = 87.4;
      plus1Sd = 90.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 27 deteksi tinggi badan
    if (usia == 27) {
      min1Sd = 84.9;
      median = 88.3;
      plus1Sd = 91.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 28 deteksi tinggi badan
    if (usia == 28) {
      min1Sd = 85.7;
      median = 89.1;
      plus1Sd = 92.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 29 deteksi tinggi badan
    if (usia == 29) {
      min1Sd = 86.4;
      median = 89.9;
      plus1Sd = 93.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 30 deteksi tinggi badan
    if (usia == 30) {
      min1Sd = 87.1;
      median = 90.7;
      plus1Sd = 94.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 31 deteksi tinggi badan
    if (usia == 31) {
      min1Sd = 87.9;
      median = 91.4;
      plus1Sd = 95.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 32 deteksi tinggi badan
    if (usia == 32) {
      min1Sd = 88.6;
      median = 92.2;
      plus1Sd = 95.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 33 deteksi tinggi badan
    if (usia == 33) {
      min1Sd = 89.3;
      median = 92.9;
      plus1Sd = 96.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 34 deteksi tinggi badan
    if (usia == 34) {
      min1Sd = 89.9;
      median = 93.6;
      plus1Sd = 97.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 35 deteksi tinggi badan
    if (usia == 35) {
      min1Sd = 90.6;
      median = 94.4;
      plus1Sd = 98.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 36 deteksi tinggi badan
    if (usia == 36) {
      min1Sd = 91.2;
      median = 95.1;
      plus1Sd = 98.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 37 deteksi tinggi badan
    if (usia == 37) {
      min1Sd = 91.9;
      median = 95.7;
      plus1Sd = 99.6;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 38 deteksi tinggi badan
    if (usia == 38) {
      min1Sd = 92.5;
      median = 96.4;
      plus1Sd = 100.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 39 deteksi tinggi badan
    if (usia == 39) {
      min1Sd = 93.1;
      median = 97.1;
      plus1Sd = 101.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 40 deteksi tinggi badan
    if (usia == 40) {
      min1Sd = 93.8;
      median = 97.7;
      plus1Sd = 101.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 41 deteksi tinggi badan
    if (usia == 41) {
      min1Sd = 94.4;
      median = 98.4;
      plus1Sd = 102.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 42 deteksi tinggi badan
    if (usia == 42) {
      min1Sd = 95.0;
      median = 99.0;
      plus1Sd = 103.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 43 deteksi tinggi badan
    if (usia == 43) {
      min1Sd = 95.6;
      median = 99.7;
      plus1Sd = 103.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 44 deteksi tinggi badan
    if (usia == 44) {
      min1Sd = 96.2;
      median = 100.3;
      plus1Sd = 104.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 45 deteksi tinggi badan
    if (usia == 45) {
      min1Sd = 96.7;
      median = 100.9;
      plus1Sd = 105.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 46 deteksi tinggi badan
    if (usia == 46) {
      min1Sd = 97.3;
      median = 101.5;
      plus1Sd = 105.8;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 47 deteksi tinggi badan
    if (usia == 47) {
      min1Sd = 97.9;
      median = 102.1;
      plus1Sd = 106.4;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 48 deteksi tinggi badan
    if (usia == 48) {
      min1Sd = 98.4;
      median = 102.7;
      plus1Sd = 107.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 49 deteksi tinggi badan
    if (usia == 49) {
      min1Sd = 99.0;
      median = 103.3;
      plus1Sd = 107.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 50 deteksi tinggi badan
    if (usia == 50) {
      min1Sd = 99.5;
      median = 103.9;
      plus1Sd = 108.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 51 deteksi tinggi badan
    if (usia == 51) {
      min1Sd = 100.1;
      median = 104.5;
      plus1Sd = 108.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 52 deteksi tinggi badan
    if (usia == 52) {
      min1Sd = 100.6;
      median = 105.0;
      plus1Sd = 109.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 53 deteksi tinggi badan
    if (usia == 53) {
      min1Sd = 101.1;
      median = 105.6;
      plus1Sd = 110.1;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 54 deteksi tinggi badan
    if (usia == 54) {
      min1Sd = 101.6;
      median = 106.2;
      plus1Sd = 110.7;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 55 deteksi tinggi badan
    if (usia == 55) {
      min1Sd = 102.2;
      median = 106.7;
      plus1Sd = 111.3;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 56 deteksi tinggi badan
    if (usia == 56) {
      min1Sd = 102.7;
      median = 107.3;
      plus1Sd = 111.9;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 57 deteksi tinggi badan
    if (usia == 57) {
      min1Sd = 103.2;
      median = 107.8;
      plus1Sd = 112.5;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 58 deteksi tinggi badan
    if (usia == 58) {
      min1Sd = 103.7;
      median = 108.4;
      plus1Sd = 113.0;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // condition usia 59 deteksi tinggi badan
    if (usia == 59) {
      min1Sd = 104.2;
      median = 108.9;
      plus1Sd = 114.2;
      // zscore
      if (panjangBadan > median) {
        result = (panjangBadan - median) / (plus1Sd - median);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "+$resultToString SD";
      } else {
        result = (panjangBadan - median) / (median - min1Sd);
        resultToString = result.toStringAsFixed(1);
        zscorePanjangBadan = "$resultToString SD";
      }
      // klasifikasi tinggi
      if (result < -2.0) {
        klasifikasiPanjangBadan = "Stunting";
      } else if (result >= -2.0 && result <= 3.0) {
        klasifikasiPanjangBadan = "Normal";
      } else {
        klasifikasiPanjangBadan = "Tinggi";
      }
    }
    // end condition
  }
  // print terminal
  return ZscoreAndClasificationPanjang(
      zscore: double.parse(resultToString),
      klasifikasi: klasifikasiPanjangBadan);
}

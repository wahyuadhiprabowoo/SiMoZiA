import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ta/app/modules/add_balita/controllers/add_balita_controller.dart';
import 'package:ta/app/modules/detail_pengukuran_berat_badan/controllers/detail_pengukuran_berat_badan_controller.dart';
import 'package:http/http.dart' as http;
import '../../../api/api_services.dart';
import '../../../models/balita.dart';
import '../../../routes/app_pages.dart';
import '../../detail_pengukuran_detak_jantung/controllers/detail_pengukuran_detak_jantung_controller.dart';
import '../../detail_pengukuran_panjang_badan/controllers/detail_pengukuran_panjang_badan_controller.dart';
import '../../home/controllers/home_controller.dart';

class EditBalitaController extends GetxController {
  Balita balita = Get.arguments;

// other controller
  final DetailPengukuranBeratBadanController controllerBeratBayi =
      Get.put(DetailPengukuranBeratBadanController());
  final DetailPengukuranPanjangBadanController controllerPanjangBayi =
      Get.put(DetailPengukuranPanjangBadanController());
  final DetailPengukuranDetakJantungController controllerDetakJantung =
      Get.put(DetailPengukuranDetakJantungController());
  final HomeController controllerUrlBalita = Get.put(HomeController());
  final AddBalitaController controllerAddBalita =
      Get.put(AddBalitaController());
  // controller text editing
  TextEditingController namaC = TextEditingController();
  TextEditingController usiaC = TextEditingController();
  TextEditingController namaIbuC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  // variabel
  var usia = 0.obs;
  var jk = "".obs;
  late String tanggal_lahir;
  var url_balita = "".obs;
  var puskesmasId = 0.obs;
  var posyanduId = 0.obs;
  // clasifikasi
  var klasifikasi_detak_jantung = "".obs;
  var klasifikasi_berat_badan = "".obs;
  var klasifikasi_panjang_badan = "".obs;
  // zscore
  var zscore_panjang_badan = 0.0.obs;
  var zscore_berat_badan = 0.0.obs;
  // datetime calendar
  var fiveYearsAgo = DateTime.now().subtract(Duration(days: 365 * 5));
  var selectedDate = DateTime.now().obs;
  DateTime currentDate = DateTime.now();

  // open calender
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        helpText: "Tanggal Lahir Anda",
        fieldHintText: "Pilih Tanggal Lahir",
        initialDate: balita.tanggalLahir,
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
    print("usia balita: ${usia.value.obs}");
  }

  // mendapatkan usia bulan
  SelectedUsia getMonth() {
    final diffMonths = (currentDate.year - selectedDate.value.year) * 12 +
        currentDate.month -
        selectedDate.value.month;
    return SelectedUsia(selectedUsia: diffMonths);
  }

  // get url balita
  GetUrlBalita urlBalita(int id_balita) {
    var url = controllerUrlBalita.urlBalita.value + id_balita.toString();
    return GetUrlBalita(url: url);
  }

// get datetime tanggal lahir
  void getDateTimeTanggalLahir() {
    var result = controllerAddBalita.getDateTimeTglLahir(usiaC.text);
    tanggal_lahir = result.tanggal_lahir;
  }

  // get clasification detak jantung
  void getDetakJantung() {
    var result = getKlasifikasiDetakJantung(
        usia.value, int.parse(controllerDetakJantung.detakBayi.value));
    klasifikasi_detak_jantung.value = result.klasifikasi;
  }

  // get clasification panjang badan
  void getPanjangBadan() {
    var result = getKlasifikasiPanjangBadan(jk.value, usia.value,
        double.parse(controllerPanjangBayi.panjangBayi.value));
    klasifikasi_panjang_badan.value = result.klasifikasi;
    zscore_panjang_badan.value = result.zscore;
  }

  // get clasification berat badan
  void getBeratBadan() {
    var result = getKlasifikasiBeratBadan(jk.value, usia.value,
        double.parse(controllerBeratBayi.beratBayi.value));
    klasifikasi_berat_badan.value = result.klasifikasi;
    zscore_berat_badan.value = result.zscore;
  }

// patch api balitia
  Future<void> updateBalita(Map<String, dynamic> userBalita) async {
    try {
      ApiService.isLoading.value = true;
      String token = await ApiService.token();
      var response = await http.patch(
        Uri.parse("${url_balita.value}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(userBalita),
      );
      // try and catch
      await Future.delayed(Duration(seconds: 2));
      print("ini respon server ${response.statusCode}");
      if (response.statusCode == 200) {
        // do something
        var json = jsonDecode(response.body);
        // data berhasil dikirim
        print("response api setelah update data");
        print(json);
      }
    } catch (e) {
      Get.dialog(AlertDialog(
        title: Text('Peringatan'),
        content: Text('Terjadi kesalahan $e!'),
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
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // get url
    puskesmasId.value = balita.puskesmasId;
    posyanduId.value = balita.posyanduId;
    var resultUrl = urlBalita(balita.id);
    url_balita.value = resultUrl.url;
    // url_balita.value =
    // "${ApiEndPoint.baseUrl}/puskesmas/${balita.puskesmasId}/posyandu/${balita.posyanduId}/balia";
    print("url balita update: ${url_balita.value}");
    // get value balita
    namaC.text = balita.namaAnak;
    namaIbuC.text = balita.namaIbu;
    alamatC.text = balita.alamat;
    jk.value = balita.jenisKelamin;
    controllerPanjangBayi.panjangBayi.value = balita.panjangBadan.toString();
    controllerBeratBayi.beratBayi.value = balita.beratBadan.toString();
    controllerDetakJantung.detakBayi.value = balita.detakJantung.toString();
    controllerDetakJantung.diastolikBayi.value = balita.diastolik.toString();
    controllerDetakJantung.sistolikBayi.value = balita.sistolik.toString();

    // get string tanggal_lahir
    var resultTanggalLahir =
        controllerAddBalita.getTanggalLahir(balita.tanggalLahir);
    usiaC.text = resultTanggalLahir.tanggal_lahir;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

// get url balita
class GetUrlBalita {
  final String url;
  GetUrlBalita({required this.url});
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ta/app/modules/detail_pengukuran_berat_badan/controllers/detail_pengukuran_berat_badan_controller.dart';
import 'package:intl/intl.dart';
import 'package:ta/app/modules/detail_pengukuran_panjang_badan/controllers/detail_pengukuran_panjang_badan_controller.dart';

class AddBalitaController extends GetxController {
  //TODO: Implement AddBalitaController
  TextEditingController namaC = TextEditingController();
  TextEditingController usiaC = TextEditingController();
  final DetailPengukuranBeratBadanController controllerBeratBayi =
      Get.put(DetailPengukuranBeratBadanController());
  final DetailPengukuranPanjangBadanController controllerPanjangBayi =
      Get.put(DetailPengukuranPanjangBadanController());
  final count = 0.obs;

  // datetime
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
  }

  getMonth() {
    final diffMonths = (currentDate.year - selectedDate.value.year) * 12 +
        currentDate.month -
        selectedDate.value.month;
    print("umur ${diffMonths} bulan");
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

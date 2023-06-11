import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/app/modules/home/views/home_view.dart';

import '../../../routes/app_pages.dart';
import '../controllers/add_balita_controller.dart';

// ignore: must_be_immutable
class AddBalitaView extends GetView<AddBalitaController> {
  var dataPuskesmas = ["Puskesmas Karangyu", "Puskesmas Tembalang"];
  var dataPosyandu = ["Posyandu Kami", "Posyandu RT-01", "Posyandu Kita"];
  var dataJenisKelamin = ["laki-laki", "perempuan"];
  var dataUsia = ["1 Bulan", "2 Bulan", "3 Bulan"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddDataView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: Column(
            children: [
              SimpleDropdown(
                  hint: "Pilih Puskesmas",
                  label: "Puskesmas",
                  items: dataPuskesmas),
              SizedBox(height: 24),
              SimpleDropdown(
                  hint: "Pilih Posyandu",
                  label: "Posyandu",
                  items: dataPosyandu),
              SizedBox(height: 24),
              TextFormField(
                controller: controller.namaC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              TextFormField(
                  controller: controller.usiaC,
                  readOnly: true,
                  onTap: () => controller.selectDate(context),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      labelText: 'Tanggal Lahir',
                      suffixIcon: Icon(Icons.calendar_today))),
              SizedBox(height: 24),
              TextFormField(
                controller: controller.namaC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Nama Ibu",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              SimpleDropdown(
                  hint: "Pilih jenis Kelamin",
                  items: dataJenisKelamin,
                  label: "Jenis Kelamin"),
              SizedBox(height: 24),
              Card(
                elevation: 4,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.brown,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Panjang Badan",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          Text(
                            "Berat Badan",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => Text(
                              '${controller.controllerPanjangBayi.panjangBayi} cm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                          Obx(
                            () => Text(
                              '${controller.controllerBeratBayi.beratBayi} kg',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                    Routes.DETAIL_PENGUKURAN_PANJANG_BADAN);
                                Get.snackbar(
                                  'Berhasil',
                                  'Button Tambah data panjang',
                                  backgroundColor: Color(AppColors.secondary),
                                  colorText: Color(AppColors.black),
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              child: Icon(Icons.add)),
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                    Routes.DETAIL_PENGUKURAN_BERAT_BADAN);
                                Get.snackbar(
                                  'Berhasil',
                                  'Button Tambah data berat ',
                                  backgroundColor: Color(AppColors.secondary),
                                  colorText: Color(AppColors.black),
                                  snackPosition: SnackPosition.TOP,
                                );
                              },
                              child: Icon(Icons.add)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Card(
                elevation: 4,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shadowColor: Colors.brown,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Detak Jantung",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "0 bpm",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.brown.shade900),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.DETAIL_PENGUKURAN_DETAK_JANTUNG);
                            Get.snackbar(
                              'Berhasil',
                              'Button Tambah data berat ',
                              backgroundColor: Color(AppColors.secondary),
                              colorText: Color(AppColors.black),
                              snackPosition: SnackPosition.TOP,
                            );
                          },
                          child: Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Berhasil',
                      'Button Tambah data panjang',
                      backgroundColor: Color(AppColors.secondary),
                      colorText: Color(AppColors.black),
                      snackPosition: SnackPosition.TOP,
                    );
                    controller.getMonth();
                    Get.offNamed(Routes.HOME);
                  },
                  child: Text("Tambah Data")),
            ],
          ),
        ),
      )),
    );
  }
}

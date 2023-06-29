import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/models/posyandu.dart';
import 'package:ta/app/modules/home/views/home_view.dart';

import '../../../models/puskesmas.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_balita_controller.dart';

// ignore: must_be_immutable
class AddBalitaView extends GetView<AddBalitaController> {
  var dataJenisKelamin = ["laki-laki", "perempuan"];
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
              // puskesmas
              DropdownSearch<Puskesmas>(
                // clearButton: Icon(Icons.delete),
                showClearButton: true,
                label: "Puskesmas",
                hint: "Pilih Puskesmas",

                onFind: onFindMethodPuskesmas,
                popupItemBuilder: (context, item, isSelected) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Text("${item.namaPuskesmas}"),
                  ),
                ),
                itemAsString: (item) => item.namaPuskesmas,
                onChanged: (puskesmas) {
                  try {
                    if (puskesmas != null) {
                      // Melakukan tindakan saat nilai tidak null
                      controller.puskesmasId.value = puskesmas.id;
                      controller.foundPuskesmas.value = true;
                      print(controller.foundPuskesmas.value);
                      print('Nilai puskesmas tidak null');
                    } else {
                      // Melakukan tindakan saat nilai null
                      print('Nilai puskesmas null ditemukan');
                      controller.foundPuskesmas.value = false;
                      print(controller.foundPuskesmas.value);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              // posyandu
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: DropdownSearch<Posyandu>(
                  showClearButton: true,
                  label: "Posyandu",
                  hint: "Pilih Posyandu",
                  popupItemBuilder: (context, item, isSelected) => Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      child: Text("${item.namaPosyandu}"),
                    ),
                  ),
                  onFind: onFindMethodPosyandu,
                  emptyBuilder: (context, searchEntry) =>
                      Text("data tidak ditemukan"),
                  itemAsString: (item) => item.namaPosyandu,
                  onChanged: (posyandu) {
                    try {
                      if (posyandu != null) {
                        // Melakukan tindakan saat nilai tidak null
                        controller.posyanduId.value = posyandu.id;
                        controller.foundPosyandu.value = true;
                        print('Nilai posyandu tidak null');
                      } else {
                        // Melakukan tindakan saat nilai null
                        print('Nilai posyandu null ditemukan');
                        controller.foundPosyandu.value = false;
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  showSearchBox: true,
                ),
              ),

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
                controller: controller.namaIbuC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Nama Ibu",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              // alamat
              SizedBox(height: 24),

              TextFormField(
                controller: controller.alamat,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              SimpleDropdown(
                hint: "Pilih jenis Kelamin",
                items: dataJenisKelamin,
                label: "Jenis Kelamin",
                jk: controller.jk,
              ),
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
                          Obx(
                            () => Text(
                              controller.usia.value < 12
                                  ? "Panjang Badan"
                                  : "Tinggi Badan",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
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
                              '${controller.controllerPanjangBayi.panjangBayi.value} cm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                          Obx(
                            () => Text(
                              '${controller.controllerBeratBayi.beratBayi.value} kg',
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
                              },
                              child: Icon(Icons.add)),
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                    Routes.DETAIL_PENGUKURAN_BERAT_BADAN);
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Detak Jantung",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Text(
                          "Sistolik",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Text(
                          "Diastolik",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // detak jantung
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Obx(
                            () => Text(
                              '${controller.controllerDetakJantung.detakBayi.value} bpm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                        ),
                        // sistolik
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Obx(
                            () => Text(
                              '${controller.controllerDetakJantung.sistolikBayi.value} bpm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                        ),
                        // diastolik
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Obx(
                            () => Text(
                              '${controller.controllerDetakJantung.diastolikBayi.value} bpm',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.brown.shade900),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, top: 8),
                      child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.DETAIL_PENGUKURAN_DETAK_JANTUNG);
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
                    // get zscore and classification
                    // detak jantung
                    controller.getDetakJantung();
                    print(
                        "ini klasifikasi detak jantung ${controller.klasifikasi_detak_jantung.value}");
                    // post data to api
                    var dataPostBalita = {
                      "nama_anak": controller.namaC.text,
                      "nama_ibu": controller.namaIbuC,
                      "alamat": controller.alamat,
                      "jenis_kelamin": controller.jk,
                      "umur": controller.usia.value,
                      "berat_badan": double.tryParse(
                          controller.controllerBeratBayi.beratBayi.value),
                      "panjang_badan": double.tryParse(
                          controller.controllerPanjangBayi.panjangBayi.value),
                      "detak_jantung": int.tryParse(
                          controller.controllerDetakJantung.detakBayi.value),
                      "zscore_berat_badan": 4,
                      "zscore_panjang_badan": 4,
                      "klasifikasi_berat_badan": "lebih",
                      "klasifikasi_panjang_badan": "normal",
                      "klasifikasi_detak_jantung":
                          controller.klasifikasi_detak_jantung,
                      "sistolik": int.tryParse(
                          controller.controllerDetakJantung.sistolikBayi.value),
                      "diastolik": int.tryParse(controller
                          .controllerDetakJantung.diastolikBayi.value),
                    };
                    print(dataPostBalita);
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

  Future<List<Puskesmas>> onFindMethodPuskesmas(String filter) async {
    String token = await ApiService.getToken();
    try {
      var response = await http.get(
        Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.puskesmas),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var data = (jsonDecode(response.body) as Map<String, dynamic>);
      var listAllPuskesmas = data["data"] as List<dynamic>;
      var modelPuskesmas = Puskesmas.fromJsonList(listAllPuskesmas);
      return modelPuskesmas;
    } catch (e) {
      return List<Puskesmas>.empty();
    }
  }

// onfind method get posyandu
  Future<List<Posyandu>> onFindMethodPosyandu(String filter) async {
    String token = await ApiService.getToken();
    try {
      var response = await http.get(
        Uri.parse(
            "${ApiEndPoint.baseUrl}puskesmas/${controller.puskesmasId.value}/posyandu"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var data = (jsonDecode(response.body) as Map<String, dynamic>);
      var listAllPosyandu = data["data"] as List<dynamic>;
      var modelPosyandu = Posyandu.fromJsonList(listAllPosyandu);
      return modelPosyandu;
    } catch (e) {
      return List<Posyandu>.empty();
    }
  }
}

// onfind method get puskesmas

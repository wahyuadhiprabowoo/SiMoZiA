import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/models/posyandu.dart';
import 'package:ta/utils/main.dart';

import '../../../models/puskesmas.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_balita_controller.dart';

// ignore: must_be_immutable
class AddBalitaView extends GetView<AddBalitaController> {
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
                showSearchBox: true,
                onFind: onFindMethodPuskesmas,
                popupItemBuilder: (context, item, isSelected) => Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Text("${item.namaPuskesmas}"),
                  ),
                ),
                emptyBuilder: (context, searchEntry) => Center(
                    child: Container(
                  height: 200,
                  width: 200,
                  child: Lottie.asset('assets/lotties/not-found.json',
                      fit: BoxFit.contain),
                )),
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
                  emptyBuilder: (context, searchEntry) => Center(
                      child: Container(
                    height: 200,
                    width: 200,
                    child: Lottie.asset('assets/lotties/not-found.json',
                        fit: BoxFit.contain),
                  )),
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
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: controller.namaC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: controller.usiaC,
                  readOnly: true,
                  onTap: () => controller.selectDate(context),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      labelText: 'Tanggal Lahir',
                      suffixIcon: Icon(Icons.calendar_today))),
              SizedBox(height: 24),
              // nama ibu
              TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: controller.namaIbuC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Nama Ibu",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              // alamat
              TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controller.alamat,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
              SizedBox(height: 24),
              // jenis kelamin
              DropdownSearch<String>(
                mode: Mode.MENU,
                maxHeight: 132.0,
                showSelectedItem: true,
                items: ["laki-laki", "perempuan"],
                label: "Jenis Kelamin",
                hint: "Pilih Jenis Kelamin",
                // popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: (value) => controller.jk = value!,
              ),
              SizedBox(height: 24),
              // caard berat dan panjang
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
                              controller.usia.value < 10
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
                    Divider(
                      color: Colors.grey, // Warna garis bawah
                      thickness: 0.7, // Ketebalan garis bawah
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => Text(
                              controller.usia.value < 10
                                  ? '${controller.controllerPanjangBayi.panjangBayi.value} cm'
                                  : '${controller.controllerTinggiBayi.tinggiBayi.value} cm',
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
                    Divider(
                      color: Colors.grey, // Warna garis bawah
                      thickness: 0.7, // Ketebalan garis bawah
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => controller.usia.value < 10
                                ? ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(Routes
                                          .DETAIL_PENGUKURAN_PANJANG_BADAN);
                                    },
                                    child: Icon(Icons.add))
                                : ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(Routes
                                          .DETAIL_PENGUKURAN_TINGGI_BADAN);
                                    },
                                    child: Icon(Icons.add)),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                    Routes.DETAIL_PENGUKURAN_BERAT_BADAN);
                              },
                              child: Icon(Icons.add)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // card detak, tekanan darah
              // Card(
              //   elevation: 4,
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   shadowColor: Colors.brown,
              //   child: Column(
              //     children: [
              //       SizedBox(height: 24),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Text(
              //             "Detak Jantung",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.w500, fontSize: 16),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           // detak jantung
              //           Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 6.0),
              //             child: Obx(
              //               () => Text(
              //                 '${controller.controllerDetakJantung.detakBayi.value} bpm',
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 20,
              //                     color: Colors.brown.shade900),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Divider(
              //         color: Colors.grey, // Warna garis bawah
              //         thickness: 0.7, // Ketebalan garis bawah
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Text(
              //               "Sistolik",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500, fontSize: 16),
              //             ),
              //             Text(
              //               "Diastolik",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w500, fontSize: 16),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(
              //         color: Colors.grey, // Warna garis bawah
              //         thickness: 0.7, // Ketebalan garis bawah
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 12.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Obx(
              //               () => Text(
              //                 '${controller.controllerDetakJantung.sistolikBayi.value} sys',
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 24,
              //                     color: Colors.brown.shade900),
              //               ),
              //             ),
              //             Obx(
              //               () => Text(
              //                 '${controller.controllerDetakJantung.diastolikBayi.value} dia',
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 24,
              //                     color: Colors.brown.shade900),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(
              //         color: Colors.grey, // Warna garis bawah
              //         thickness: 0.7, // Ketebalan garis bawah
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0, top: 4),
              //         child: ElevatedButton(
              //             onPressed: () {
              //               Get.toNamed(Routes.DETAIL_PENGUKURAN_DETAK_JANTUNG);
              //             },
              //             child: Icon(Icons.add)),
              //       ),
              //       SizedBox(
              //         height: 8,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 48),
              Obx(
                () => ApiService.isLoading.value
                    ? LoadingScreen(
                        color: Colors.brown,
                        size: 25,
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () async {
                          // get zscore and classification
                          // detak jantung, panjangm berat
                          controller.getDetakJantung();
                          controller.getBeratBadan();
                          controller.getPanjangDanTinggiBadan();
                          controller.getDateTimeTanggalLahir();
                          // menangani null check
                          if (int.tryParse(controller
                                  .controllerDetakJantung.detakBayi.value) ==
                              0) {
                            controller.klasifikasi_detak_jantung.value = "-";
                          } else {
                            controller.klasifikasi_detak_jantung.value;
                          }
                          // pembagian kirim data tinggi dan panjang
                          // var panjang_tinggi = ""
                          var panjang_tinggi = controller.usia.value < 10
                              ? controller
                                  .controllerPanjangBayi.panjangBayi.value
                              : controller
                                  .controllerTinggiBayi.tinggiBayi.value;
                          // post data to api
                          var dataPostBalita = {
                            "nama_anak": controller.namaC.text,
                            "nama_ibu": controller.namaIbuC.text,
                            "alamat": controller.alamat.text,
                            "jenis_kelamin": controller.jk,
                            "umur": controller.usia.value,
                            "tanggal_lahir": controller.tanggal_lahir,
                            "berat_badan":
                                controller.controllerBeratBayi.beratBayi.value,
                            "panjang_badan": panjang_tinggi,
                            "detak_jantung": controller
                                .controllerDetakJantung.detakBayi.value,
                            "zscore_berat_badan":
                                controller.zscore_berat_badan.value.toString(),
                            "zscore_panjang_badan": controller
                                .zscore_panjang_badan.value
                                .toString(),
                            "klasifikasi_berat_badan":
                                controller.klasifikasi_berat_badan.value,
                            "klasifikasi_panjang_badan":
                                controller.klasifikasi_panjang_badan.value,
                            "klasifikasi_detak_jantung":
                                controller.klasifikasi_detak_jantung.value,
                            "sistolik": int.tryParse(controller
                                .controllerDetakJantung.sistolikBayi.value),
                            "diastolik": int.tryParse(controller
                                .controllerDetakJantung.diastolikBayi.value),
                          };
                          print(dataPostBalita);
                          print(panjang_tinggi);
                          await controller.postBalita(dataPostBalita);
                          Get.offAllNamed(Routes.HOME);
                          controller.showMySnackbar(
                              context, "Data telah berhasil dibuat");
                        },
                        child: Text("Tambah Data")),
              ),
            ],
          ),
        ),
      )),
    );
  }

// get puskesmas
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

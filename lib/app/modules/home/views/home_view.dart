import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:http/http.dart' as http;
import 'package:ta/app/models/posyandu.dart';
import 'package:ta/app/models/puskesmas.dart';
import 'package:ta/utils/main.dart';

import '../../../api/api_services.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => AppBarWidget(name: controller.nameUser.value),
            ), // get puskesmas
            Padding(
              padding: const EdgeInsets.all(24),
              child: DropdownSearch<Puskesmas>(
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
                      print(
                          "${ApiEndPoint.baseUrl}puskesmas/${controller.puskesmasId.value}/posyandu");
                      print('Nilai puskesmas tidak null');
                    } else {
                      // Melakukan tindakan saat nilai null
                      print('Nilai puskesmas null ditemukan');
                      controller.foundPuskesmas.value = false;
                      print(controller.foundPuskesmas.value);
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
                },
                // showSearchBox: true,
              ),
            ),
            // get posyandu
            Padding(
              padding: const EdgeInsets.only(left: 24.0, bottom: 24, right: 24),
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
                      // cetak nama posyandu
                      controller.namaPosyandu.value = posyandu.namaPosyandu;
                      print('Nilai posyandu tidak null');
                    } else {
                      // Melakukan tindakan saat nilai null
                      print('Nilai posyandu null ditemukan');
                      controller.foundPosyandu.value = false;
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
                },
                showSearchBox: true,
              ),
            ),

            Padding(
              // hasil pengukuran
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hasil Pengukuran"),
                  Obx(
                    () => controller.foundPosyandu.isTrue &&
                            controller.foundPuskesmas.isTrue
                        ? ElevatedButton(
                            onPressed: () => controller.getAllBalita(),
                            child: Text("Lihat balita"),
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),

            Obx(() {
              final balitas = controller.balitas;
              print("ini jumlah data balita ${balitas!.length}");
              if (controller.foundBalita.value == false) {
                return Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Lottie.asset('assets/lotties/not-found.json',
                        fit: BoxFit.contain),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: balitas.length,
                    itemBuilder: (context, index) {
                      final balita = balitas[index];
                      return Obx(
                        () => ApiService.isLoading.value
                            ? Padding(
                                padding: const EdgeInsets.all(44.0),
                                child: LoadingScreen(
                                    color: Colors.brown, size: 25),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 4),
                                child: Card(
                                  elevation: 4,
                                  child: Column(
                                    children: [
                                      // delete balita
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () =>
                                              Get.dialog(AlertDialog(
                                            title: Text('Peringatan'),
                                            content: Text(
                                                'Hapus data balita ${balita.namaAnak}'),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  OutlinedButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: Text("Tidak")),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Obx(
                                                    () => controller
                                                            .isLoading.value
                                                        ? LoadingScreen(
                                                            color: Colors.brown,
                                                            size: 25,
                                                          )
                                                        : ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              await controller
                                                                  .deleteBalita(
                                                                      balita
                                                                          .id);
                                                              Utils.showMySnackbar(
                                                                  context,
                                                                  "Data balita berhasil dihapus");
                                                            },
                                                            child: Text("Ya")),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                          icon:
                                              Icon(Icons.delete_outline_sharp),
                                          color: Color(AppColors.secondary),
                                        ),
                                      ),
// nama
                                      Text("Nama: ${balita.namaAnak}"),
                                      Divider(
                                        color: Colors.grey, // Warna garis bawah
                                        thickness: 0.7, // Ketebalan garis bawah
                                      ),
                                      //  pengukuran
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text("Pengukuran ")),
                                          Expanded(
                                              flex: 1,
                                              child: Text("Klasifikasi")),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey, // Warna garis bawah
                                        thickness: 0.7, // Ketebalan garis bawah
                                      ),
                                      // panjang
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text(balita.umur < 12
                                                  ? "Panjang Badan"
                                                  : "Tinggi Badan: ")),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  "${balita.klasifikasiPanjangBadan}")),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey, // Warna garis bawah
                                        thickness: 0.7, // Ketebalan garis bawah
                                      ),
                                      // berat
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text("Berat Badan: ")),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  "${balita.klasifikasiBeratBadan}")),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, right: 8.0),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: OutlinedButton(
                                              onPressed: () => Get.toNamed(
                                                  Routes.DETAIL_BALITA,
                                                  arguments: balita),
                                              child: Text("Detail"),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                );
              }
            }),

            // CardHasilPengukuran(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_BALITA),
          child: Icon(Icons.add)),
    );
  }

  // onfind method get puskesmas
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

class AppBarWidget extends StatelessWidget {
  final String name;
  const AppBarWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      // Appbar
      children: [
        Expanded(
          child: Container(
            color: Colors.brown,
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 34),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              "Hii, $name",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Color(AppColors.white)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AvatarGlow(
                              glowColor: Color(AppColors.white),
                              endRadius: 25.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: InkWell(
                                onTap: (() => Get.toNamed(Routes.EDIT_PROFILE)),
                                child: CircleAvatar(
                                  child: Image.asset(
                                    'assets/img/profile.png',
                                    fit: BoxFit.cover,
                                  ),
                                  radius: 20,
                                  // Ganti dengan path gambar avatar Anda
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 34),
                  child: Text(
                    "Selamat Datang di Si MoZiA",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SimpleDropdown extends StatelessWidget {
  final String label;
  final String hint;
  var items;
  String jk;

  SimpleDropdown(
      {required this.label,
      required this.hint,
      required this.items,
      required this.jk});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      showSearchBox: true,
      showClearButton: true,
      mode: Mode.DIALOG,
      // maxHeight: 150,
      showSelectedItem: true,
      items: items,
      label: label,
      hint: hint,
      // popupItemDisabled: (String s) => s.startsWith('I'),
      onChanged: (value) {
        jk = value!;
        print("ini jenis kelamin $jk");
      },
    );
  }
}

class CardHasilPengukuran extends StatelessWidget {
  const CardHasilPengukuran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24.0),
          child: Card(
            shadowColor: Colors.brown,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Color(AppColors.secondary),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 385,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                padding: EdgeInsets.only(top: 18),
                                alignment: Alignment.topRight,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Color(AppColors.white),
                                )),
                          ),
                          Text("Nama"),
                          SizedBox(height: 6),
                          LabelInformasiCard(label: "Wahyu Adhi Prabowo"),
                          SizedBox(height: 12),
                          Text("Usia"),
                          SizedBox(height: 6),
                          LabelInformasiCard(label: "10 Bulan"),
                          SizedBox(height: 12),
                          Text("Status"),
                          SizedBox(height: 6),
                          LabelInformasiCard(label: "Stunting"),
                          SizedBox(height: 12),
                          Text("Berat Badan"),
                          SizedBox(height: 6),
                          LabelInformasiCard(label: "Normal"),
                          SizedBox(height: 18),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  Get.snackbar("alert", "Detail di Click");
                                  Get.toNamed(Routes.DETAIL_BALITA);
                                },
                                child: Text("Detail >>")),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable

class LabelInformasiCard extends StatelessWidget {
  final String label;
  LabelInformasiCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 35,
                // color: Color(AppColors.white),
                decoration: BoxDecoration(
                  color: Color(AppColors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(label),
        )
      ],
    );
  }
}

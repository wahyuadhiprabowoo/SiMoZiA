import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/utils/main.dart';

import '../../../routes/app_pages.dart';
import '../controllers/detail_balita_controller.dart';

class DetailBalitaView extends GetView<DetailBalitaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      appBar: AppBar(
        title: Text('Detail Balita'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? LoadingScreen(color: Colors.white, size: 50)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      // Nama anak
                      Text("Nama"),
                      SizedBox(height: 8),
                      TextField(
                        // initial value
                        controller: controller.namaC,
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(height: 12),
                      // Nama Ibu
                      Text("Nama Ibu"),
                      SizedBox(height: 8),
                      TextField(
                        // initial value
                        controller: controller.namaIbuC,
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(height: 12),
                      // Usia
                      Text("Usia"),
                      SizedBox(height: 8),
                      TextField(
                        // initial value
                        controller: controller.usiaC,
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(height: 12),
                      // Jenis Kelamin
                      Text("Jenis Kelamin"),
                      SizedBox(height: 8),
                      TextField(
                        // initial value
                        controller: controller.jkC,
                        textCapitalization: TextCapitalization.words,
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                      SizedBox(height: 24),
                      //klasifikasi panjang dab berat
                      Card(
                        child: Column(children: [
                          //  pengukuran
                          SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(flex: 2, child: Text("Pengukuran")),
                              Expanded(flex: 1, child: Text("Hasil")),
                              Expanded(flex: 1, child: Text("Zscore")),
                              Expanded(flex: 1, child: Text("Klasifikasi")),
                              SizedBox(
                                width: 16,
                              ),
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
                                width: 16,
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(controller.balita.umur < 10
                                      ? "Panjang Badan"
                                      : "Tinggi Badan ")),
                              Expanded(
                                  flex: 1,
                                  child: Text(controller.balita.umur < 10
                                      ? controller.panjangBadan.value
                                      : controller.tinggiBadan.value)),
                              Expanded(
                                  flex: 1,
                                  child: Text(controller.zscorePanjang.value)),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      controller.klasifikasiPanjang.value)),
                              SizedBox(
                                width: 16,
                              ),
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
                              Expanded(flex: 2, child: Text("Berat Badan")),
                              Expanded(
                                  flex: 1,
                                  child: Text(controller.beratBadan.value)),
                              Expanded(
                                  flex: 1,
                                  child: Text(controller.zscoreBerat.value)),
                              Expanded(
                                  flex: 1,
                                  child:
                                      Text(controller.klasifikasiBerat.value)),
                              SizedBox(
                                width: 12,
                              ),
                            ],
                          ),

                          // Divider(
                          //   color: Colors.grey, // Warna garis bawah
                          //   thickness: 0.7, // Ketebalan garis bawah
                          // ),
                          // detak jantung
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 12,
                          //     ),
                          //     Expanded(flex: 2, child: Text("Detak Jantung")),
                          //     Expanded(
                          //         flex: 1,
                          //         child: Text(
                          //             controller.detakJantung.value == "0 bpm"
                          //                 ? "-"
                          //                 : controller.detakJantung.value)),
                          //     Expanded(flex: 1, child: Text("-")),
                          //     Expanded(
                          //         flex: 1,
                          //         child: Text(controller
                          //             .klasifikasiDetakJantung.value)),
                          //     SizedBox(
                          //       width: 12,
                          //     ),
                          //   ],
                          // ),

                          SizedBox(
                            height: 12,
                          ),
                        ]),
                      ),
                      SizedBox(height: 20),
                      // tekanan darah
                      // Card(
                      //   child: Column(children: [
                      //     SizedBox(height: 12),

                      //     Text("Tekanan Darah"),
                      //     Divider(
                      //       color: Colors.grey, // Warna garis bawah
                      //       thickness: 0.7, // Ketebalan garis bawah
                      //     ),
                      //     //  pengukuran
                      //     Row(
                      //       children: [
                      //         SizedBox(
                      //           width: 12,
                      //         ),
                      //         Expanded(flex: 2, child: Text("Pengukuran ")),
                      //         Expanded(flex: 1, child: Text("Hasil")),
                      //         SizedBox(
                      //           width: 12,
                      //         ),
                      //       ],
                      //     ),
                      //     Divider(
                      //       color: Colors.grey, // Warna garis bawah
                      //       thickness: 0.7, // Ketebalan garis bawah
                      //     ),
                      //     // sistolik
                      //     Row(
                      //       children: [
                      //         SizedBox(
                      //           width: 12,
                      //         ),
                      //         Expanded(flex: 2, child: Text("Sistolik")),
                      //         Expanded(
                      //             flex: 1,
                      //             child: Text(
                      //                 controller.sistolik.value == "0 sys"
                      //                     ? "-"
                      //                     : controller.sistolik.value)),
                      //         SizedBox(width: 12),
                      //       ],
                      //     ),
                      //     SizedBox(height: 12),

                      //     // diastolik
                      //     Row(
                      //       children: [
                      //         SizedBox(
                      //           width: 12,
                      //         ),
                      //         Expanded(flex: 2, child: Text("Diastolik")),
                      //         Expanded(
                      //             flex: 1,
                      //             child: Text(
                      //                 controller.diastolik.value == "0 dia"
                      //                     ? "-"
                      //                     : controller.diastolik.value)),
                      //         SizedBox(width: 12),
                      //       ],
                      //     ),
                      //     SizedBox(height: 12),
                      //   ]),
                      // ),
                      // SizedBox(height: 24),
                      Container(
                        height: 47,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.EDIT_BALITA,
                                  arguments: controller.balita);
                            },
                            child: Text("Edit Data")),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class LabelDataDetakJantung extends StatelessWidget {
  final String label;
  final String klasifikasi;
  LabelDataDetakJantung({required this.label, required this.klasifikasi});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextFormField(
          autocorrect: false,
          decoration: InputDecoration(
              label: Text(label),
              labelStyle: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontSize: 18,
                  color: Color(AppColors.black)),
              filled: true,
              fillColor: Color(AppColors.white),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          autocorrect: false,
          decoration: InputDecoration(
              label: Text(klasifikasi),
              labelStyle: TextStyle(
                  backgroundColor: Colors.transparent,
                  fontSize: 18,
                  color: Color(AppColors.black)),
              filled: true,
              fillColor: Color(AppColors.white),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
        ),
      ),
    ]);
  }
}

class LabelDataPengukuranBeratDanPanjang extends StatelessWidget {
  final String labelZscore;
  final String labelPengukuran;
  final String labelKlasifikasi;
  LabelDataPengukuranBeratDanPanjang(
      {required this.labelPengukuran,
      required this.labelKlasifikasi,
      required this.labelZscore});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
                label: Text(labelPengukuran),
                labelStyle: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                    color: Color(AppColors.black)),
                filled: true,
                fillColor: Color(AppColors.white),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
                label: Text(labelZscore),
                labelStyle: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                    color: Color(AppColors.black)),
                filled: true,
                fillColor: Color(AppColors.white),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            autocorrect: false,
            decoration: InputDecoration(
                label: Text(labelKlasifikasi),
                labelStyle: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                    color: Color(AppColors.black)),
                filled: true,
                fillColor: Color(AppColors.white),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ],
    );
  }
}

class LabelData extends StatelessWidget {
  final String label;
  LabelData({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            // enabled: false,
            autocorrect: false,
            decoration: InputDecoration(
                label: Text(label),
                labelStyle: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontSize: 18,
                    color: Color(AppColors.black)),
                filled: true,
                fillColor: Color(AppColors.white),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
          ),
        ),
      ],
    );
  }
}

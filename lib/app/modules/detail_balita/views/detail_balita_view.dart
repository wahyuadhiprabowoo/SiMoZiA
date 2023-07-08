import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/utils/main.dart';

import '../../../routes/app_pages.dart';
import '../controllers/detail_balita_controller.dart';

class DetailBalitaView extends GetView<DetailBalitaController> {
  final balita = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      appBar: AppBar(
        title: Text('DetailBalitaView'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? LoadingScreen(color: Colors.white, size: 50)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 48),
                      LabelData(label: "Nama: ${balita.namaAnak}"),
                      SizedBox(height: 24),
                      LabelData(label: "Usia: ${balita.umur}"),
                      SizedBox(height: 24),
                      LabelData(label: "Nama Ibu"),
                      SizedBox(height: 24),
                      LabelData(label: "jenis Kelamin"),
                      SizedBox(height: 24),
                      LabelDataPengukuranBeratDanPanjang(
                          labelPengukuran: "Tinggi Badan",
                          labelZscore: "zscore",
                          labelKlasifikasi: "Klasifikasi"),
                      SizedBox(height: 24),
                      LabelDataPengukuranBeratDanPanjang(
                          labelPengukuran: "Berat Badan",
                          labelZscore: "zscore",
                          labelKlasifikasi: "Klasifikasi"),
                      SizedBox(height: 24),
                      LabelDataDetakJantung(
                        label: "Detak Jantung",
                        klasifikasi: "Klasifikasi",
                      ),
                      SizedBox(height: 48),
                      Container(
                        height: 47,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.EDIT_BALITA,
                                  arguments: balita);
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

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  var dataPuskesmas = ["Puskesmas Karangyu", "Puskesmas Tembalang"];
  var dataPosyandu = ["Posyandu Kami", "Posyandu RT-01", "Posyandu Kita"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWidget(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SimpleDropdown(
                    hint: "Pilih Puskesmas",
                    label: "Puskesmas",
                    items: dataPuskesmas),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, bottom: 24, right: 24),
                child: SimpleDropdown(
                    hint: "Pilih Posyandu",
                    label: "Posyandu",
                    items: dataPosyandu),
              ),
              Padding(
                // hasil pengukuran
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hasil Pengukuran"),
                    ElevatedButton(
                        onPressed: () {}, child: Icon(Icons.filter_list))
                  ],
                ),
              ),
              CardHasilPengukuran(),
              CardHasilPengukuran(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_BALITA),
          child: Icon(Icons.add)),
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
class SimpleDropdown extends StatelessWidget {
  final String label;
  final String hint;
  var items;

  SimpleDropdown(
      {required this.label, required this.hint, required this.items});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      showClearButton: true,
      mode: Mode.DIALOG,
      maxHeight: 150,
      showSelectedItem: true,
      items: items,
      label: label,
      hint: hint,
      // popupItemDisabled: (String s) => s.startsWith('I'),
      onChanged: (value) => print(value?.length),
    );
  }
}

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

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

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
                          Text(
                            "Hi Wahyu",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(AppColors.white)),
                          ),
                          AvatarGlow(
                            glowColor: Color(AppColors.white),
                            endRadius: 30.0,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: InkWell(
                              onTap: (() => Get.toNamed(Routes.EDIT_PROFILE)),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                    'assets/img/logo.png'), // Ganti dengan path gambar avatar Anda
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

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_panjang_badan_controller.dart';

class DetailPengukuranPanjangBadanView
    extends GetView<DetailPengukuranPanjangBadanController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8;
    final containerWidthSeperEmpat = screenWidth * 0.4;
    return Scaffold(
      appBar: AppBar(
        title: Text('Panjang Badan'),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: containerWidth,
                height: 100,
                child: FirebaseAnimatedList(
                  query: controller.refPanjang,
                  itemBuilder: (context, snapshot, animation, index) {
                    controller.panjang =
                        snapshot.child("panjang_badan").value.toString();
                    return Center(
                      child: Text(
                        controller.panjang,
                        style: TextStyle(
                            fontSize: 96,
                            color: Colors.brown,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: containerWidthSeperEmpat,
              height: 47,
              child: ElevatedButton(
                  onPressed: () => controller.addpanjangBalita(),
                  child: Text("Tambah Data")),
            )
          ],
        ),
      ),
    );
  }
}

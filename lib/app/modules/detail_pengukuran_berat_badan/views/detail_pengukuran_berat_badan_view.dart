import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_berat_badan_controller.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class DetailPengukuranBeratBadanView
    extends GetView<DetailPengukuranBeratBadanController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.5;
    final containerWidthSeperEmpat = screenWidth * 0.4;
    return Scaffold(
      appBar: AppBar(
        title: Text('Berat Badan'),
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
                  query: controller.refBerat,
                  itemBuilder: (context, snapshot, animation, index) {
                    controller.berat =
                        snapshot.child("berat_badan").value.toString();
                    print("ini berat ${controller.berat}");
                    return Center(
                      child: Text(
                        controller.berat,
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
                  onPressed: () => controller.addBeratBalita(),
                  child: Text("Tambah Data")),
            )
          ],
        ),
      ),
    );
  }
}

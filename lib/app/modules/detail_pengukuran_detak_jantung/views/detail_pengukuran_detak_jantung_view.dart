import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_detak_jantung_controller.dart';

class DetailPengukuranDetakJantungView
    extends GetView<DetailPengukuranDetakJantungController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.2;
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPengukuranDetakJantungView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  value: controller.calculateProgress(),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 6,
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // detak
                Container(
                  width: containerWidth,
                  height: 55,
                  child: FirebaseAnimatedList(
                    query: controller.refDetak,
                    itemBuilder: (context, snapshot, animation, index) {
                      controller.detak =
                          snapshot.child("detak_jantung").value.toString();
                      return Center(
                        child: Text(
                          controller.detak,
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.brown,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                ),
                // sistolik
                Container(
                  width: containerWidth,
                  height: 55,
                  child: FirebaseAnimatedList(
                    query: controller.refSistolik,
                    itemBuilder: (context, snapshot, animation, index) {
                      controller.sistolik =
                          snapshot.child("sistolik_balita").value.toString();
                      return Center(
                        child: Text(
                          controller.sistolik,
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.brown,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                ),
                // diastolik
                Container(
                  width: containerWidth,
                  height: 55,
                  child: FirebaseAnimatedList(
                    query: controller.refDiastolik,
                    itemBuilder: (context, snapshot, animation, index) {
                      controller.diastolik =
                          snapshot.child("diastolik_balita").value.toString();
                      return Center(
                        child: Text(
                          controller.diastolik,
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.brown,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => controller.startTimer(), child: Icon(Icons.timer)),
    );
  }
}

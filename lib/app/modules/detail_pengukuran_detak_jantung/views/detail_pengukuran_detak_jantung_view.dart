import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_detak_jantung_controller.dart';

class DetailPengukuranDetakJantungView
    extends GetView<DetailPengukuranDetakJantungController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPengukuranDetakJantungView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailPengukuranDetakJantungView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

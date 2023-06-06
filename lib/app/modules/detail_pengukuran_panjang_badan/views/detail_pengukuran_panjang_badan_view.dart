import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_panjang_badan_controller.dart';

class DetailPengukuranPanjangBadanView
    extends GetView<DetailPengukuranPanjangBadanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPengukuranPanjangBadanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailPengukuranPanjangBadanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_pengukuran_berat_badan_controller.dart';

class DetailPengukuranBeratBadanView
    extends GetView<DetailPengukuranBeratBadanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailPengukuranBeratBadanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'DetailPengukuranBeratBadanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

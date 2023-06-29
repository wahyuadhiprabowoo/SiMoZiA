import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/models/balita.dart';
import 'package:ta/app/modules/home/controllers/home_controller.dart';

import '../controllers/edit_balita_controller.dart';

// ignore: must_be_immutable
class EditBalitaView extends GetView<EditBalitaController> {
  Balita balita = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditBalitaView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'klasifikasi detak jantung: ${balita.alamat}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Obx(
              () => Text(
                'url balita: ${controller.url.value}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                var getUrlBalita = controller.urlBalita(balita.id);
                controller.url.value = getUrlBalita.url;
              },
              child: Text("get url"))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/edit_balita_controller.dart';

class EditBalitaView extends GetView<EditBalitaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EditBalitaView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'EditBalitaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

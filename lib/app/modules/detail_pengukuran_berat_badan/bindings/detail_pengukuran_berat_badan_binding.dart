import 'package:get/get.dart';

import '../controllers/detail_pengukuran_berat_badan_controller.dart';

class DetailPengukuranBeratBadanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengukuranBeratBadanController>(
      () => DetailPengukuranBeratBadanController(),
    );
  }
}

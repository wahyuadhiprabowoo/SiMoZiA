import 'package:get/get.dart';

import '../controllers/detail_pengukuran_tinggi_badan_controller.dart';

class DetailPengukuranTinggiBadanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengukuranTinggiBadanController>(
      () => DetailPengukuranTinggiBadanController(),
    );
  }
}

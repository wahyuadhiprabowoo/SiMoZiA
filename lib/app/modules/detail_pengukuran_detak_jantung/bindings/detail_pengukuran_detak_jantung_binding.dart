import 'package:get/get.dart';

import '../controllers/detail_pengukuran_detak_jantung_controller.dart';

class DetailPengukuranDetakJantungBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengukuranDetakJantungController>(
      () => DetailPengukuranDetakJantungController(),
    );
  }
}

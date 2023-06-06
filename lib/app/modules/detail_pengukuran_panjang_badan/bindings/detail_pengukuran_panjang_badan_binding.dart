import 'package:get/get.dart';

import '../controllers/detail_pengukuran_panjang_badan_controller.dart';

class DetailPengukuranPanjangBadanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengukuranPanjangBadanController>(
      () => DetailPengukuranPanjangBadanController(),
    );
  }
}

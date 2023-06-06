import 'package:get/get.dart';

import '../controllers/detail_balita_controller.dart';

class DetailBalitaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBalitaController>(
      () => DetailBalitaController(),
    );
  }
}

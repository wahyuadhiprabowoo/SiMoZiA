import 'package:get/get.dart';

import '../controllers/add_balita_controller.dart';

class AddBalitaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBalitaController>(
      () => AddBalitaController(),
    );
  }
}

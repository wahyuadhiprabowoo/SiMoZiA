import 'package:get/get.dart';

import '../controllers/edit_balita_controller.dart';

class EditBalitaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBalitaController>(
      () => EditBalitaController(),
    );
  }
}

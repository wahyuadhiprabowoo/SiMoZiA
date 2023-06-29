import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class EditBalitaController extends GetxController {
  final HomeController controllerUrlBalita = Get.put(HomeController());
  // update data
  var url = "".obs;
  GetUrlBalita urlBalita(int id_balita) {
    var url = controllerUrlBalita.urlBalita.value + id_balita.toString();
    return GetUrlBalita(url: url);
  }

  // update data
  Future<void> updateBalita(Map<String, dynamic> balita) async {}
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

class GetUrlBalita {
  final String url;
  GetUrlBalita({required this.url});
}

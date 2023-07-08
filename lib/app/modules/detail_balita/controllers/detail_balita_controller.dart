import 'package:get/get.dart';

class DetailBalitaController extends GetxController {
  //TODO: Implement DetailBalitaController
  var isLoading = false.obs;

  // loadingscreen
  void loadingScreen() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadingScreen();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

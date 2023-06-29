import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController
  var checkToken = "".obs;
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    String token = await ApiService.token();
    checkToken.value = token;
    print("ini token splashscreen $checkToken");
    print("ini length ${checkToken.value.length}");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

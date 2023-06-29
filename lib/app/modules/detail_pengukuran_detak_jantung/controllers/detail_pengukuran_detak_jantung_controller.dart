import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DetailPengukuranDetakJantungController extends GetxController {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final refDetak = FirebaseDatabase.instance.ref('detak');
  String detak = "0";
  var detakBayi = "0".obs;
  var timerleft = 60.obs;
  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // change value
      if (timerleft.value > 0) {
        timerleft.value -= 1;
        print("function dijalankan");
      } else {
        detakBayi.value = detak;
        timer.cancel();
        Get.back();
        timerleft.value = 60;
        print(timerleft.value);
        print("ini detak_jantung bayi $detakBayi");
        print("timer sukses");
      }
    });
  }

  double calculateProgress() {
    if (timerleft.value <= 0) {
      return 1.0;
    } else {
      return timerleft / 60.0;
    }
  }

  void addDetakBalita() {
    // print("ini $detak");
    // result = panjang as RxString;
    detakBayi.value = detak;
    print("ini detak_jantung bayi $detakBayi");
    Get.back();
  }

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
}

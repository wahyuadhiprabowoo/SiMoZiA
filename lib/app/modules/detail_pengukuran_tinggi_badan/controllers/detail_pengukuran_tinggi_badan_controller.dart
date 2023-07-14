import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DetailPengukuranTinggiBadanController extends GetxController {
  //TODO: Implement DetailPengukuranTinggiBadanController
  final refTinggi = FirebaseDatabase.instance.ref('tinggi');
  String tinggi = "0";
  var tinggiBayi = "0".obs;
  // RxInt tinggiResult = ;
  void addTinggiBadan() {
    // print("ini $tinggi");
    // result = tinggi as RxString;
    tinggiBayi.value = tinggi;
    print("ini tinggi balita $tinggiBayi");
    Get.back();
  }

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

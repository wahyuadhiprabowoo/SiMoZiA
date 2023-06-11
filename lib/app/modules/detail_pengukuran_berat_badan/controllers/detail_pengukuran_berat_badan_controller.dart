import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailPengukuranBeratBadanController extends GetxController {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final refBerat = FirebaseDatabase.instance.ref('berat');
  String berat = "0";
  var beratBayi = "0".obs;
  final count = 0.obs;
  // RxInt panjangResult = ;
  void addBeratBalita() {
    // print("ini $berat");
    // result = panjang as RxString;
    beratBayi.value = berat;
    print("ini berat bayi $beratBayi");
    Get.back();
  }

  // charts

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

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class DetailPengukuranPanjangBadanController extends GetxController {
  //TODO: Implement DetailPengukuranPanjangBadanController
  final refPanjang = FirebaseDatabase.instance.ref('panjang');
  String panjang = "0";
  var panjangBayi = "0".obs;
  // RxInt panjangResult = ;
  void addpanjangBalita() {
    // print("ini $panjang");
    // result = panjang as RxString;
    panjangBayi.value = panjang;
    print("ini panjang bayi $panjangBayi");
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

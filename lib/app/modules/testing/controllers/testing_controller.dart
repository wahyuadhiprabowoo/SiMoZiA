// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:ta/app/models/puskesmas.dart';

// import '../../../konstanta/chart.dart';

// class TestingController extends GetxController {
// // get puskesmas
//   Future<List<Puskesmas>> getAllPuskesmas() async {
//     Uri url =
//         Uri.parse("https://admin-puskesmas.000webhostapp.com/api/puskesmas");
//     final response = await http.get(url);
//     // masuk ke api -> data
//     List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
//     // print(data);
//     // data dari api -> model yang telah dipersiapkan
//     if (data.isEmpty) {
//       return [];
//     } else {
//       return data.map((e) => Puskesmas.fromJson(e)).toList();
//     }
//   }

//   // datetime
//   var fiveYearsAgo = DateTime.now().subtract(Duration(days: 365 * 5));
//   var selectedDate = DateTime.now().obs;
//   DateTime currentDate = DateTime.now();
//   void selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         helpText: "Ini help",
//         fieldHintText: "ini hint",
//         initialDate: selectedDate.value,
//         firstDate: fiveYearsAgo,
//         lastDate: currentDate,
//         initialEntryMode: DatePickerEntryMode.calendarOnly);

//     if (picked != null && picked != selectedDate.value) {
//       selectedDate.value = picked;
//     }
//   }

//   getMonth() {
//     final currentDate = DateTime.now();

//     final diffMonths = (currentDate.year - selectedDate.value.year) * 12 +
//         currentDate.month -
//         selectedDate.value.month;
//     print("umur ${diffMonths} bulan");
//   }

//   // chart
//   var chartData = <ChartData>[].obs;
//   var updateCount = 0.obs;
//   Timer? timer;
//   void startLiveData() {
//     timer = Timer.periodic(Duration(seconds: 1), (_) {
//       updateCount.value++;
//       updateChartData();
//     });
//   }

//   void updateChartData() {
//     // Generate random chart data
//     final random = Random();
//     final newData = List.generate(10, (index) {
//       return ChartData(x: index.toString(), y: random.nextDouble() * 100);
//     });

//     chartData.value = newData;
//   }

//   final count = 0.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     // selectedDate();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onClose() {}
//   void increment() => count.value++;
// }

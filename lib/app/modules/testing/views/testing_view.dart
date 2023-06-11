// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:ta/app/models/puskesmas.dart';

// import '../../../konstanta/chart.dart';
// import '../controllers/testing_controller.dart';

// class TestingView extends GetView<TestingController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TestingView'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         return Column(
//           children: [
//             Text('Update Count: ${controller.updateCount.value}'),
//             Expanded(
//               child: SfCartesianChart(
//                 series: <LineSeries<ChartData, String>>[
//                   LineSeries<ChartData, String>(
//                     dataSource: controller.chartData.value,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//       // get api
//       floatingActionButton:
//           FloatingActionButton(onPressed: () => controller.getMonth()),
//     );
//   }
// }

// // class DateTimeWidget extends StatelessWidget {
// //   const DateTimeWidget({
// //     Key? key,
// //     required this.controller,
// //   }) : super(key: key);

// //   final TestingController controller;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Obx(
// //           () => Text(
// //               "Selected Date: ${controller.selectedDate.value.toString()}"),
// //         ),
// //         SizedBox(
// //           height: 32,
// //         ),
// //         ElevatedButton(
// //             onPressed: () => controller.selectDate(context),
// //             child: Text("Pilih tanggal")),
// //       ],
// //     );
// //   }
// // }

// class GetApi extends StatelessWidget {
//   const GetApi({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final TestingController controller;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Puskesmas>>(
//         future: controller.getAllPuskesmas(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (!snapshot.hasData) {
//             return Center(
//               child: Text("Tidak ada data"),
//             );
//           }
//           return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: ((context, index) {
//                 Puskesmas puskesmas = snapshot.data![index];
//                 return ListTile(
//                   leading: CircleAvatar(child: Text("${index + 1}")),
//                   title: Text(puskesmas.namaPuskesmas),
//                   trailing: Text(puskesmas.telepon),
//                   subtitle: Text(puskesmas.alamat),
//                 );
//               }));
//         });
//   }
// }

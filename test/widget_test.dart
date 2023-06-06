// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
import 'dart:io';

// void main() {
//   test(
//     'Test API',
//     () async {
//       // get puskesmas
//       const String baseUrl = 'http://admin-puskesmas.000webhostapp.com/api';
//       var valuePuskesmasId = 1;
//       var valuePosyanduId = 1;
//       var urlPuskesmas = Uri.parse(
//           '$baseUrl/balita?klasifikasi_panjang_badan=gizi'); // Ganti dengan URL server yang ingin diuji
//       try {
//         var response = await http.get(urlPuskesmas);
//         if (response.statusCode == 200) {
//           var data = response.body;
//           if (data.isEmpty) {
//             print("data kosong");
//           }
//           print(data);
//         }
//       } catch (e) {
//         throw Exception('Error $e');
//       }
//       // get detail puskesmas
//       // var urlPuskesmasDetail = Uri.parse(
//       //     '$baseUrl/puskesmas/1'); // Ganti dengan URL server yang ingin diuji
//       // try {
//       //   var response = await http.get(urlPuskesmasDetail);
//       //   if (response.statusCode == 200) {
//       //     var data = response.contentLength;
//       //     print(data);
//       //   }
//       // } catch (e) {
//       //   throw Exception('Error $e');
//       // }
//     },
//   );
// }

// klasifikasi detak jantung
// Bayi baru lahir hingga 1 bulan: 70 hingga 190.
// Bayi berusia 1 hingga 11 bulan: 80 hingga 160.
// Anak-anak berusia 1 hingga 2 tahun: 80 hingga 130.
// Usia 3 hingga 4 tahun: 80 hingga 120.
// >= takikardia
// <= bradikardia
//  normal

void main() {
  stdout.write("masukan nilai detak jantung: ");
  var input = stdin.readLineSync()!;
  print(input);
  print("data");
}

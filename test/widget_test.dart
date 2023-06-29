// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ta/app/models/balita.dart';
import 'package:ta/app/models/posyandu.dart';
import 'package:ta/app/models/puskesmas.dart';

Future<void> main() async {
// post data
  var dataPostBalita = {
    "nama_anak": "cuma teman",
    "nama_ibu": "api",
    "alamat": "alamat ini",
    "jenis_kelamin": "laki-laki",
    "umur": 3,
    "berat_badan": 4,
    "panjang_badan": 4,
    "detak_jantung": 4,
    "zscore_berat_badan": 4,
    "zscore_panjang_badan": 4,
    "klasifikasi_berat_badan": "lebih",
    "klasifikasi_panjang_badan": "normal",
    "klasifikasi_detak_jantung": "takikardia"
  };
  // update data
  var updateData = {
    "berat_badan": 10,
    "panjang_badan": 10,
    "detak_jantung": 10,
    "zscore_berat_badan": 10,
    "zscore_panjang_badan": 10,
    "klasifikasi_berat_badan": "normal",
    "klasifikasi_panjang_badan": "normal",
    "klasifikasi_detak_jantung": "normal"
  };
  test(
    'Test API',
    () async {
      // get puskesmas
      const String baseUrl = 'https://tw-demo.my.id/api';
      Uri urlPuskesmas = Uri.parse("$baseUrl/puskesmas");
      final resPuskesmas = await http.get(urlPuskesmas);
      List dataPuskesmas =
          (jsonDecode(resPuskesmas.body) as Map<String, dynamic>)["data"];
      Puskesmas puskesmas = Puskesmas.fromJson(dataPuskesmas[0]);
      var puskesmasId = puskesmas.id;
      print("id puskesmas ${puskesmasId}");
      // get posyandu
      Uri urlPosyandu = Uri.parse("$baseUrl/puskesmas/$puskesmasId/posyandu");
      print(urlPosyandu);
      final resPosyandu = await http.get(urlPosyandu);
      List dataPosyandu =
          (jsonDecode(resPosyandu.body) as Map<String, dynamic>)["data"];
      Posyandu posyandu = Posyandu.fromJson(dataPosyandu[0]);
      print("----");
      var posyanduId = posyandu.id;
      print("id posyandu ${posyanduId}");
      // // get all balita
      Uri urlBalita = Uri.parse(
          "$baseUrl/puskesmas/$puskesmasId/posyandu/$posyanduId/balita");
      final resBalita = await http.get(urlBalita);
      print(urlBalita);
      List dataBalita =
          (jsonDecode(resBalita.body) as Map<String, dynamic>)["data"];
      print("--- all balita");
      Balita balita = Balita.fromJson(dataBalita[0]);
      print(
          "nama: ${balita.namaAnak}, ibu ${balita.namaIbu} memiliki usia ${balita.umur}");
      // post balita to api
      final response = await http.post(
        urlBalita,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataPostBalita),
      );

      if (response.statusCode == 201) {
        // Data berhasil terkirim
        print('Data berhasil terkirim');
      } else {
        // Gagal mengirim data
        print('Gagal mengirim data. Status: ${response.statusCode}');
      }
      // update data
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var url = Uri.parse(
          'https://tw-demo.my.id/api/puskesmas/1/posyandu/1/balita/14');

      var responBalita =
          await http.patch(url, headers: headers, body: jsonEncode(updateData));

      if (responBalita.statusCode == 200) {
        // Data berhasil diperbarui
        print('Data berhasil diperbarui');
      } else {
        // Terjadi kesalahan dalam memperbarui data
        print(
            'Gagal memperbarui data. Status code: ${responBalita.statusCode}');
      }
      // Balita balita14 = Balita.fromJson(dataBalita[4]);
      // print(balita14.detakJantung);
    },
  );
}

// klasifikasi detak jantung
// Bayi baru lahir hingga 1 bulan: 70 hingga 190.
// Bayi berusia 1 hingga 11 bulan: 80 hingga 160.
// Anak-anak berusia 1 hingga 2 tahun: 80 hingga 130.
// Usia 3 hingga 4 tahun: 80 hingga 120.
// >= takikardia
// <= bradikardia
//  normal

///url api: https://admin-puskesmas.000webhostapp.com/api/
//all data: /all
// all puskesmas: /puskesmas
// detail puskesmas: /puskesmas/{id}
// all posyandu: /posyandu
// detail posyandu: /posyandu/{id}
// detail balita dari puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-panjang/{klasifikasi_panjang_badan}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-berat/{klasifikasi_berat_badan}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-detak/{klasifikasi_detak_jantung}
// filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-create-at
// filter create->at http://localhost:8000/api/puskesmas/1/posyandu/4/balita/filter-create-at?start_date=2023-06-11&end_date=2023-06-30

// void main() async {
//   // get puskesmas
//   Uri urlPuskesmas = Uri.parse("https://tw-demo.my.id/api/puskesmas");
//   final resPuskesmas = await http.get(urlPuskesmas);
//   List dataPuskesmas =
//       (jsonDecode(resPuskesmas.body) as Map<String, dynamic>)["data"];
//   Puskesmas puskesmas = Puskesmas.fromJson(dataPuskesmas[0]);
//   var puskesmasId = puskesmas.id;
//   print("id puskesmas ${puskesmasId}");
//   // get posyandu
//   Uri urlPosyandu = Uri.parse("https://tw-demo.my.id/api/posyandu");
//   final resPosyandu = await http.get(urlPosyandu);
//   List dataPosyandu =
//       (jsonDecode(resPosyandu.body) as Map<String, dynamic>)["data"];
//   Posyandu posyandu = Posyandu.fromJson(dataPosyandu[0]);
//   var posyanduId = posyandu.id;
//   print("id posyandu ${posyanduId}");
//   // get all balita
//   Uri urlBalita = Uri.parse(
//       "https://tw-demo.my.id/api/puskesmas/$puskesmasId/posyandu/$posyanduId/balita");
//   final resBalita = await http.get(urlBalita);
//   List dataBalita =
//       (jsonDecode(resBalita.body) as Map<String, dynamic>)["data"];
//   print("--- all balita");
//   Balita balita = Balita.fromJson(dataBalita[0]);
//   print(
//       "nama: ${balita.namaAnak}, ibu ${balita.namaIbu} memiliki usia ${balita.umur}");
//   // post balita

//   // api/async usahakan menggunakan try catch
//   // crud api
//   // create data ke API
  
//   // delete data
//   var balitaId = balita.id;
//   print(balitaId);
//   Uri deleteBalita = Uri.parse(
//       "https://tw-demo.my.id/api/puskesmas/$puskesmasId/posyandu/$posyanduId/balita/$balitaId");
//   try {
//     final response = await http.delete(
//       deleteBalita,
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // Data berhasil dihapus
//       print('Data berhasil dihapus');
//     } else {
//       // Gagal menghapus data
//       print('Gagal menghapus data. Status: ${response.statusCode}');
//     }
//   } catch (error) {
//     // Terjadi error saat koneksi atau proses penghapusan data
//     print('Terjadi error: $error');
//   }
// }

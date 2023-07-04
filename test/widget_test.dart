import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:ta/app/models/user.dart';
import 'package:ta/app/modules/add_balita/controllers/add_balita_controller.dart';

Future user() async {
  String token = await ApiService.getToken();
  try {
    var response = await http.get(
      Uri.parse(ApiEndPoint.baseUrl + ApiEndPoint.authEndPoint.user),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    // try and catch
    print("ini respon server ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      // get user information
      User user = User.fromJson(responseData);
      print(user);
    }
  } catch (e) {
    print(e);
  }
}

// get clasification panjang badan

void main() async {
  var userBalita = {
    "nama_ibu": "required",
    "nama_anak": "wahyu test post",
    "alamat": "postman",
    "jenis_kelamin": "perempuan",
    "umur": 20,
    "tanggal_lahir": "2023-06-02T18:34:40.000000Z",
    "berat_badan": "30",
    "panjang_badan": "33",
    "detak_jantung": 22,
    "zscore_berat_badan": "3",
    "zscore_panjang_badan": "3",
    "klasifikasi_berat_badan": "normal",
    "klasifikasi_panjang_badan": "normal",
    "klasifikasi_detak_jantung": "tidak normal",
  };
  print(userBalita);
  //  post to api
  void postBalita(Map<String, dynamic> dataBalita) async {
    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjYyZTQ4N2RhOTAxOTJiMWExYjkzNTYwNTY4YTI0MmYyOGVjZGRhNjQ1MjgzNzg1NGQzYTE0MGIyZGM1YmU0N2NlY2VlOWJjODNhOTMxNTciLCJpYXQiOjE2ODgzMjM0ODcuNDQ4NDI2MDA4MjI0NDg3MzA0Njg3NSwibmJmIjoxNjg4MzIzNDg3LjQ0ODQyNjk2MTg5ODgwMzcxMDkzNzUsImV4cCI6MTcxOTk0NTg4Ni4wOTIzOTg4ODE5MTIyMzE0NDUzMTI1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.fi3v9wC1GUEBN8jITOPPi-AaMV9KrCG9SBmy0Uw8kRFbmUdTC8i0OxKpgxz_nLdhnPNxS_y_XdGQhn0PG61kxYrcqJVqr8lhiO9ZW-NHpClH6tPXzOcgBxCOW0NO90vzyRva0d04pej1POPAhFiVmvHQfGWbydhJg1ioM-3BJphpxU1EVMFZRAEdbuDu8c4Sev_ln0H-Q6ud7RO5ofEnI8mFWOB9VuW30flcQYbpEQb3DQdJAQP7kApUtGLRyqWbAb3o-sSnRafXetg3iLbw5HqYI2Ipr_69XgvUxWHwmNYJ8b0hdazObAKPLPEZngD_AtWix4-hNS7-gushOWpq8SnG8HZDB3K6Fqnrco6-sn_vXWcHpu1PtK6G9NvyEB1rdnJJZGreNsoyKIfJJN5EGewcLF0pq5QEuEziiFRqOGfJIFBqBwBB5GKMNVfEq9P_hqQVqJjMAesVHDjwBOJKRn_J2Btr-B3LtSrZ-hUhW1EQfas7Kh-GyFiM2gFLaz7_bsyyJf6adfUt4FF0wiTvxmUVS7rq1WO9m3poOOg0u3wCjDslB_T6U84WLQIRNcTAMdJ6sHBwMj4mhqATsXavomcKkjzsQhktJoyWp2AAbAIMjRT2e9OaRcTsYO-KiP71YAKLoKaBW-eZy1iCIszeEHxkhOzGuhrp7zKQryGfAoU";

    String url = '${ApiEndPoint.baseUrl}puskesmas/1/posyandu/4/balita';
    print(url);
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(dataBalita),
      );
      // try and catch
      print("ini respon server ketika post data ${response.statusCode}");
      if (response.statusCode == 201) {
        // do something
        var json = jsonDecode(response.body);
        print("respon api");
        print(json);
      }
    } catch (e) {
      print(e);
    }
  }

  postBalita(userBalita);
  // String token =
  //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODQ2YjkxYTBhZGIyN2NkYjc5NjE5MmJiMDQzODk0ZmY2MTYyOThmYmFkZTM5OTk3MzFjZmQ3NGEwNmEzMjQ5NTZhZjgzYTMyNDBkNDc3ZTMiLCJpYXQiOjE2ODgyMTA1OTUuODQxNDU5LCJuYmYiOjE2ODgyMTA1OTUuODQxNDYyLCJleHAiOjE3MTk4MzI5OTUuODM2NjYyLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.IaboptQhLhIf0MGTpk8lfAYL2IYwcmPUTVnKR2FqFLh2Vh8LtDWPfo_JV3pHzJI9q_UDoFpI62KBTVY3hPNWhe-P1ZJqZtO8W2jquSndKRtoHr3sGnjiH2MA0J0Ob97KL5IjcKq7zAUQdNJzErFeP8Z0ESuYeWRMLwc0TE79sw0NSth_aIDxpD2ScHtOzaHpXhc6eJoKdV6mlDWfzZayDO1MG5gq0DFsK5oN8E5BnpXamGL6tbmTDoeJI9xWlxlM1ZABeEYBo7zBWjYn266dt3AtBMEJ_YFitDQwrikhJu4-jjw0Ysx92jcbaS_CFFHZM2cP7Xf9Z2iYwROhGOVzbMWp9QlPOAFOFVasU5S7xMTzsJ_ZPanoesEDZxkWEHNhZUYS4ddV71_LjAxSZJL40OZw9aQ4p7Jr9GvcNPwLiPCIyGGoQ8l8K-lRH-8W3iSS3dnRhx9GT68F8AcES1SufuYgzq2LQ8JJgzS6QT4l3bzdjIM_qpAcvjEHlCcbZBIvH-h2q7dh2tSKJgouACQ5Y_KUm3K9Ro5Vvp6Ham7iyoeQXgDgGN1SkdUBvN2BT7J1wcvsj126I1sDtXnQRBu7wwVpGM6s3sc94xabxe3KPF0vmDFvTStTY9wPx2ZNHR3WdqypEnUzMCN17v_0E-sdbm77sa3_hCeFjR2MTn-3K84";
  // try {
  //   var response = await http.get(
  //     Uri.parse("${ApiEndPoint.baseUrl}puskesmas/1/posyandu"),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token'
  //     },
  //   );
  //   // try and catch
  //   if (response.statusCode == 200) {
  //     var responseData = jsonDecode(response.body);
  //     print(responseData);
  //     // get user information
  //   }
  // } catch (e) {
  //   print(e);
  // }
// convert string
  // var now = DateTime.now();
  // var result = getTanggalLahir(now);
  // print(result.tanggal_lahir);
}

GetStringTanggalLahir getTanggalLahir(DateTime tanggalLahir) {
  // final DateTime dateTime = DateTime.parse(tanggal_lahir);
  String tanggal_lahir = DateFormat('dd MMM yyyy').format(tanggalLahir);
  return GetStringTanggalLahir(tanggal_lahir: tanggal_lahir);
}

class GetStringTanggalLahir {
  String tanggal_lahir;
  GetStringTanggalLahir({required this.tanggal_lahir});
}

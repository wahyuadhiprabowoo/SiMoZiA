import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final satu_empat = screenHeight * 0.3;
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(children: [
            Container(
              height: satu_empat,
              alignment: Alignment.center,
              child: Text(
                "Registrasi",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Masukan nama",
                  fillColor: Color(AppColors.white),
                  labelText: "Nama",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 24),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Masukan email",
                  fillColor: Color(AppColors.white),
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 24),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  hintText: "Masukan username",
                  fillColor: Color(AppColors.white),
                  labelText: "Username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 24),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        Get.snackbar("Perubahan",
                            "Nanti untuk menutup dan menampilkan password");
                      },
                      icon: Icon(Icons.remove_red_eye_outlined)),
                  filled: true,
                  fillColor: Color(AppColors.white),
                  hintText: "Masukan password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 47,
              child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar("title", "button di klik");
                  },
                  child: Text("Register")),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Kembali ke",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(AppColors.white),
                    fontWeight: FontWeight.w600),
              ),
              TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ))
            ])
          ]),
        ),
      ),
    );
  }
}

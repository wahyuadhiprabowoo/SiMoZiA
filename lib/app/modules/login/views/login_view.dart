import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/konstanta/colors.dart';
import 'package:ta/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.9;
    return Scaffold(
      backgroundColor: Color(AppColors.secondary),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 570,
                  color: Color(AppColors.secondary),
                ),
                Container(
                  height: 315,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Image.asset(
                          "assets/img/logo.png",
                          height: 148,
                        ),
                      ),
                      Text("Si MoZiA",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(AppColors.white),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Positioned(
                  top: 255,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: containerWidth,
                      height: 275,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(AppColors.primary),
                              blurStyle: BlurStyle.inner,
                              blurRadius: 10,
                              offset: Offset(0, 6))
                        ],
                        color: Color(AppColors.accent),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 48,
                  right: 48,
                  child: Container(
                    width: containerWidth,
                    height: 250,
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 32),
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
                        SizedBox(height: 32),
                        Container(
                          child: TextFormField(
                            autocorrect: false,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      Get.snackbar("Perubahan",
                                          "Nanti untuk menutup dan menampilkan password");
                                    },
                                    icon: Icon(Icons.remove_red_eye_outlined)),
                                filled: true,
                                // fillColor: Color(AppColors.white),
                                hintText: "Masukan password",
                                labelText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24,
                top: 24,
              ),
              child: Container(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                    child: Text("Login Sekarang"),
                    onPressed: () {
                      Get.snackbar("berhasil login", "pindah ke halaman home");
                      Get.toNamed(Routes.HOME);
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tidak memiliki akun?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(AppColors.white),
                        fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

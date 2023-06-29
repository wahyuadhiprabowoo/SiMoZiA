import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/konstanta/colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('EditProfileView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 24),
                child: Center(
                  child: Container(
                    width: 185,
                    height: 185,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38),
                      child: Image.asset(
                        'assets/img/foto.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24, bottom: 32),
                child: Container(
                  width: containerWidth,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {
                      print("object");
                      Get.snackbar("title", "edit foto ditekan",
                          borderRadius: 12,
                          snackPosition: SnackPosition.BOTTOM);
                    },
                    child: Text("Edit Foto"),
                  ),
                ),
              ),
              CardDetailProfile(),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                    width: double.infinity,
                    height: 47,
                    child: ElevatedButton(
                      child: Text("Logout"),
                      onPressed: () async {
                        // get instanse token
                        ApiService.clearToken();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                    )),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDetailProfile extends StatelessWidget {
  const CardDetailProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24.0),
          child: Card(
            shadowColor: Colors.brown,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Color(AppColors.secondary),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 450,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 48),
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
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Get.offNamed(Routes.HOME);
                                      },
                                      icon:
                                          Icon(Icons.remove_red_eye_outlined)),
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
                                  onPressed: () async {
                                    var userData = {
                                      "name": "wahyuadhip",
                                      "email": "wahyuadhiprabowo1@gmail.com",
                                      "password": "nayusanu123",
                                      "password_confirmation": "nayusanu123"
                                    };
                                    await ApiService.updateUser(userData);
                                  },
                                  child: Text("Selesai")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ta/app/api/api_services.dart';
import 'package:ta/app/konstanta/colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // stack name dan profile image
              Stack(
                children: [
                  Container(
                    height: 270,
                  ),
                  Container(
                    width: screenWidth,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(125),
                            bottomRight: Radius.circular(125))),
                  ),
                  // icons back
                  IconButton(
                      onPressed: () {
                        Get.offAllNamed(Routes.HOME);
                      },
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white),
                  // Text Nama
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: Center(
                        child: Text(
                          "${controller.nameUser.value}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Profile
                  Padding(
                    padding: const EdgeInsets.only(top: 65.0),
                    child: Center(
                      child: Container(
                        height: 250,
                        width: 250,
                        child: Image.asset(
                          'assets/img/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 48),
              // nama
              Obx(
                () => InformasiKontak(
                  title: "${controller.nameUser.value}",
                  iconLeading: Icons.account_circle_outlined,
                  iconTrailing: Icons.change_circle_outlined,
                  onTap: () => Get.bottomSheet(ChangeName()),
                ),
              ),
              // divider
              GarisPembagi(),
              // email
              Obx(
                () => InformasiKontak(
                  title: "${controller.emailUser.value}",
                  iconLeading: Icons.email_outlined,
                  iconTrailing: Icons.change_circle_outlined,
                  onTap: () => Get.bottomSheet(ChangeEmail()),
                ),
              ),
              // divider
              GarisPembagi(),
              // nama
              InformasiKontak(
                title: "********",
                iconLeading: Icons.key,
                iconTrailing: Icons.change_circle_outlined,
                onTap: () => Get.bottomSheet(ModalResetPassword()),
              ),
              // divider
              GarisPembagi(),
              SizedBox(
                height: 64,
              ),
              // button logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                    width: double.infinity,
                    height: 47,
                    child: ElevatedButton(
                      child: Text("Logout"),
                      onPressed: () {
                        controller.showAlertLogout();
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GarisPembagi extends StatelessWidget {
  const GarisPembagi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey, // Warna garis bawah
      thickness: 0.5, // Ketebalan garis bawah
      //indent: 24.0, // Jarak dari sebelah kiri
      //endIndent: 24.0, // Jarak dari sebelah kanan
    );
  }
}

class InformasiKontak extends StatelessWidget {
  final String title;
  final IconData iconLeading;
  final IconData? iconTrailing;
  final VoidCallback? onTap;
  const InformasiKontak(
      {required this.title,
      required this.iconLeading,
      this.iconTrailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        iconLeading,
        size: 36,
      ),
      trailing: InkWell(
        onTap: onTap,
        child: Icon(
          iconTrailing,
          size: 36,
        ),
      ),
    );
  }
}

// modal
// ignore: must_be_immutable
class ModalResetPassword extends StatelessWidget {
  TextEditingController newPassC = TextEditingController();
  TextEditingController confNewPassC = TextEditingController();
  var isHidden = true.obs;
  var isHiddenconf = true.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: newPassC,
                obscureText: isHidden.value == true ? true : false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                      onPressed: () {
                        isHidden.toggle();
                      },
                      icon: Icon(isHidden == true
                          ? Icons.visibility
                          : Icons.visibility_off_outlined)),
                  filled: true,
                  fillColor: Color(AppColors.white),
                  labelText: "Password Baru",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(AppColors.accent)),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Ulang password
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: confNewPassC,
                obscureText: isHiddenconf.value == true ? true : false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  suffixIcon: IconButton(
                      onPressed: () {
                        isHiddenconf.toggle();
                      },
                      icon: Icon(isHiddenconf == true
                          ? Icons.visibility
                          : Icons.visibility_off_outlined)),
                  filled: true,
                  fillColor: Color(AppColors.white),
                  labelText: "Ulangi Password Baru",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(AppColors.accent)),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            // button reset password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Kembali")),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var updatePassword = {
                        'password': newPassC.text.trim(),
                        'password_confirmation': confNewPassC.text.trim()
                      };
                      // check password
                      String text1 = newPassC.text;
                      String text2 = confNewPassC.text;
                      if (text1 == text2) {
                        await ApiService.updateUser(updatePassword);
                        Get.snackbar("Berhasil", "Password berhasil dirubah");
                        Get.offAllNamed(Routes.EDIT_PROFILE);
                      } else {
                        Get.snackbar("Peringatan", "Password tidak sama");
                      }
                    },
                    child: Text("Kirim")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// nama
// ignore: must_be_immutable
class ChangeName extends StatelessWidget {
  TextEditingController nameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              controller: nameC,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Color(AppColors.white),
                labelText: "Nama",
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(AppColors.accent)),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
            // button reset password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Kembali")),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var updateName = {
                        'name': nameC.text.trim(),
                      };
                      // check password

                      if (nameC.text.length != 0) {
                        await ApiService.updateUser(updateName);
                        Get.snackbar("Berhasil", "berhasil merubah nama");
                        Get.offAllNamed(Routes.EDIT_PROFILE);
                      }
                    },
                    child: Text("Kirim")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// email
// ignore: must_be_immutable
class ChangeEmail extends StatelessWidget {
  TextEditingController emailC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                filled: true,
                fillColor: Color(AppColors.white),
                labelText: "Email",
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(AppColors.accent)),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
            // button reset password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Kembali")),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var updateEmail = {
                        'email': emailC.text.trim(),
                      };
                      // check password

                      if (emailC.text.length != 0) {
                        await ApiService.updateUser(updateEmail);
                        Get.snackbar("Berhasil", "berhasil merubah email");
                        Get.offAllNamed(Routes.EDIT_PROFILE);
                      }
                    },
                    child: Text("Kirim")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

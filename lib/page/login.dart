import 'package:admin_panal/utils/app_colors.dart';
import 'package:admin_panal/utils/my_string.dart';
import 'package:admin_panal/utils/text_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic/controllers/auth_controller.dart';

class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({Key? key}) : super(key: key);

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  List admin = [];
  CollectionReference refrence = FirebaseFirestore.instance.collection("admin");

  getData() async {
    var val = await refrence.get();
    for (var element in val.docs) {
      setState(() {
        admin.add(element.data());
      });
    }
  }

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final controller = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.indigo.shade600])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            color: Colors.red,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 3),
                        blurRadius: 24)
                  ]),
              height: 400,
              width: 350,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextUtils(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      text: "LOGIN",
                      color: AppColors.blue,
                      underLine: TextDecoration.none,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                              controller: emailController,
                              obscureText: false,
                              validator: (value) {
                                if (value.toString().length <= 2) {
                                  return "يجب أن لا يقل الأيميل عن 8 أحرف";
                                } else if (!RegExp(validationEmail)
                                    .hasMatch(value!)) {
                                  return 'التنسيق غير صحيح';
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                suffixIcon: Text(""),
                                hintText: "الأيميل",
                              ),
                              keyboardType: TextInputType.emailAddress),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: GetBuilder<AuthController>(
                            builder: (_) {
                              return TextFormField(
                                  controller: passwordController,
                                  obscureText:
                                      controller.isvisibilty ? false : true,
                                  validator: (value) {
                                    if (value.toString().length <= 8) {
                                      return "يجب أن لا تقل كملة السر عن 8 أحرف";
                                    } else if (!RegExp(validationPassword)
                                        .hasMatch(value!)) {
                                      return 'يجب أن تحتوي على الاقل على حروف وارقام';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        controller.visibilty();
                                      },
                                      icon: controller.isvisibilty
                                          ? const Icon(
                                              Icons.visibility,
                                              color: AppColors.lightblue,
                                            )
                                          : const Icon(
                                              Icons.visibility_off,
                                              color: AppColors.blackshade,
                                            ),
                                    ),
                                    hintText: "كلمةالمرور",
                                  ),
                                  keyboardType: TextInputType.text);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.06,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: const BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                        child: GetBuilder<AuthController>(
                            builder: (_) => TextButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      String email =
                                          emailController.text.trim();
                                      String password = passwordController.text;

                                      controller.LoginAdmin(
                                          email: email, password: password);
                                    }

                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextUtils(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          text: "تسجيل الدخول",
                                          color: Colors.yellow,
                                          underLine: TextDecoration.none,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

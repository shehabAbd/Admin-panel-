import 'package:admin_panal/api/messaging.dart';
import 'package:admin_panal/utils/app_colors.dart';
import 'package:admin_panal/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selected = "all";
  var selected_val;
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(right: 300, left: 300),
          child: Center(
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value.toString().length <= 3) {
                        return "يجب أن لا يقل العنوان  عن 3 أحرف";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'عنوان الإشعار'),
                  ),
                  TextFormField(
                    controller: bodyController,
                    validator: (value) {
                      if (value.toString().length <= 5) {
                        return "يجب أن لا يقل المحتوى  عن 5 أحرف";
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(labelText: 'محتوى الإشعار'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        items: ["الكل", "مسجلين الدخول", "مسجلين الخروج"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        hint: const Text("الرجاء الإختيار"),
                        onChanged: (val) {
                          selected_val = val;
                          if (val == "الكل") {
                            setState(() {
                              selected = "all";
                            });
                          } else if (val == "مسجلين الدخول") {
                            setState(() {
                              selected = "on";
                            });
                          } else if (val == "مسجلين الخروج") {
                            setState(() {
                              selected = "exit";
                            });
                          }
                        },
                        value: selected_val,
                      ),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            sendNotification(selected);
                            bodyController.clear();
                            titleController.clear();
                          }
                        },
                        child: Container(
                          width: 70,
                          height: MediaQuery.of(context).size.height * 0.06,
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          decoration: const BoxDecoration(
                              color: AppColors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: TextUtils(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                text: "إرسال",
                                color: AppColors.white,
                                underLine: TextDecoration.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }

  Future sendNotification(String to) async {
    final response = await Messaging.sendTo(
        title: titleController.text, body: bodyController.text, fcmToken: to);
    Get.snackbar(
      'رسالة تأكيد',
      "تم ارسال الإشعار بنجاح",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

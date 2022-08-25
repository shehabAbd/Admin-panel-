import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panal/logic/controllers/firestore_methods.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_colors.dart';
import '../utils/my_string.dart';
import '../widgets/custom_button_blue.dart';
import '../widgets/custom_form_field.dart';

class Add_Ads_Screen extends StatefulWidget {
  const Add_Ads_Screen({Key? key}) : super(key: key);

  @override
  State<Add_Ads_Screen> createState() => _Add_Ads_ScreenState();
}

class _Add_Ads_ScreenState extends State<Add_Ads_Screen> {
  final TextEditingController AdsNameController = TextEditingController();

  final TextEditingController AdscuttoffController = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final controller = Get.put(FireStoreController());
  File? _pickedImage;
  final bool _isloading = false;
  Uint8List webImage = Uint8List(0);
  Future<void> _pickImage() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print("No images has been picked");
      }
    }
  }

  void postAdsImage(String uid) async {
    // start the loading
    try {
      EasyLoading.show(status: "جاري الاضافة");
      // upload to storage and db
      String res = await controller.uploadAdvertisement(
        uid,
        AdsNameController.text,
        AdscuttoffController.text,
        webImage,
      );

      if (res == "success") {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("تمت  اضافة الاعلان بنجاح ",
            duration: const Duration(microseconds: 2000));
        AdsNameController.clear();
        AdscuttoffController.clear();
      }
    } catch (e) {
      EasyLoading.showInfo(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _isloading
                      ? const CircularProgressIndicator(
                          color: AppColors.orange,
                        )
                      : const Center(),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blackshade),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                        ),
                        height: 300,
                        width: 300,
                      ),
                      _pickedImage == null
                          ? Positioned(
                              bottom: 15,
                              right: 20,
                              child: IconButton(
                                  onPressed: () {
                                    _pickImage();
                                    // _selectImage(context);
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColors.blue,
                                  )),
                            )
                          : Container(
                              margin: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blackshade),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(7)),
                              ),
                              height: 290,
                              width: 290,
                              child: Image.memory(
                                webImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: IconButton(
                            onPressed: () {
                              // _selectImage(context);
                              _pickImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.orange,
                            )),
                      )
                    ],
                  ),
                  Form(
                    key: formstate,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFromField(
                          controller: AdsNameController,
                          obscureText: false,
                          validator: (Value) {
                            if (Value.toString().length <= 3) {
                              return "يجب أن لا يقل عنوان عن 3 حروف";
                            } else if (RegExp(validationName).hasMatch(Value)) {
                              return 'يجب أن لايحتوي عنوان على رقم او رمز';
                            } else {
                              return null;
                            }
                          },
                          prefixIcon: const Icon(Icons.note),
                          suffixIcon: const Text(""),
                          hintText: " عنوان الإعلان",
                          keyboardType: TextInputType.text,
                        ),
                        TextFromField(
                          suffixIcon: const Text(""),
                          prefixIcon: const Icon(Icons.cut_outlined),
                          hintText: "الخصم على المنتج ",
                          controller: AdscuttoffController,
                          obscureText: false,
                          validator: (Value) {
                            if (Value!.length <= 0 || Value!.length >= 100) {
                              return "يرجى إدخال قيمة صحيحة";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Blue_Button(
                      onTap: () {
                        if (formstate.currentState!.validate() &&
                            _pickedImage != null) {
                          Get.defaultDialog(
                            title: "إضافة ",
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            middleText: 'هل انت متأكد من إضافة الاعلان',
                            middleTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white,
                            radius: 10,
                            textCancel: " لا ",
                            cancelTextColor: Colors.orange,
                            textConfirm: " نعم ",
                            confirmTextColor: Colors.orange,
                            onCancel: () {
                              Get.back();
                            },
                            onConfirm: () {
                              Get.back();
                              postAdsImage(
                                  FirebaseAuth.instance.currentUser!.uid);
                              webImage.clear();
                              AdsNameController.clear();
                              AdscuttoffController.clear();
                            },
                          );
                        } else if (_pickedImage == null) {
                          AwesomeDialog(
                            width: 500,
                            dialogType: DialogType.INFO,
                            animType: AnimType.SCALE,
                            context: context,
                            body: const Text("يرجى إختيار صورة"),
                            title: "تنبية",
                            btnOkOnPress: () {
                              Get.back();
                            },
                          ).show();
                        }
                      },
                      text: "إضافة ")
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

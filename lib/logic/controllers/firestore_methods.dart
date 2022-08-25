import 'dart:typed_data';
import 'package:admin_panal/logic/controllers/storage_methods.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FireStoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> deleteProduct(context, String id, String name) async {
    String message = "حدث خطأ غير متوقع";
    try {
      AwesomeDialog(
        context: context,
        width: 500,
        dialogType: DialogType.QUESTION,
        animType: AnimType.SCALE,
        title: ' هل تريد تأكيد الحذف',
        desc: 'حذف $name',
        btnCancelOnPress: () {
          Get.back();
        },
        btnOkOnPress: () async {
          await _firestore.collection('product').doc(id).delete();
          message = 'تم الحذف بنجاح';
          Get.snackbar(
            'إشعار تأكيد',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ).show();
    } catch (err) {
      message = err.toString();
      Get.snackbar(
        'Error!',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
    return message;
  }

  Future<String> block_user(context, String id, String name) async {
    String message = "حدث خطأ غير متوقع";
    try {
      AwesomeDialog(
        context: context,
        width: 500,
        dialogType: DialogType.QUESTION,
        animType: AnimType.SCALE,
        title: ' هل تريد تأكيد الحظر',
        desc: 'حظر المستخدم $name',
        btnCancelOnPress: () {
          Get.back();
        },
        btnOkOnPress: () async {
          await _firestore.collection('users').doc(id).update({
            'blocked': "yes",
          });
          message = 'تم الحظر بنجاح';
          Get.snackbar(
            'إشعار تأكيد',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ).show();
    } catch (err) {
      message = err.toString();
      Get.snackbar(
        'Error!',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
    return message;
  }

  Future<String> unblock_user(context, String id, String name) async {
    String message = "حدث خطأ غير متوقع";
    try {
      AwesomeDialog(
        context: context,
        width: 500,
        dialogType: DialogType.QUESTION,
        animType: AnimType.SCALE,
        title: ' هل تريد إلغاء الحظر',
        desc: 'إلغاء حظر المستخدم $name',
        btnCancelOnPress: () {
          Get.back();
        },
        btnOkOnPress: () async {
          await _firestore.collection('users').doc(id).update({
            'blocked': "no",
          });
          message = 'تم إلغاء الحظر بنجاح';
          Get.snackbar(
            'إشعار تأكيد',
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      ).show();
    } catch (err) {
      message = err.toString();
      Get.snackbar(
        'Error!',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
    return message;
  }


 Future<String> uploadAdvertisement(
    String uid,
    String title,
    String cuttoff,
    Uint8List adsurl,
  ) async {
    String res = "Some error occurred";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('AdsPhotos', adsurl, true);

      String adsId = const Uuid().v1(); // creates unique id based on time

      _firestore.collection('ads').doc(adsId).set({
        "adsId": adsId,
        "cuttoff": cuttoff,
        "statues": "0",
        "title": title,
        "uid": uid,
        "url": photoUrl,
        "date": DateTime.now(),
      });
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


 
}


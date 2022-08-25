import 'package:admin_panal/models/admin_model.dart';
import 'package:admin_panal/page/home.dart';
import 'package:admin_panal/routes/routes.dart';
import 'package:admin_panal/widgets/loading.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isvisibilty = false;

  void visibilty() {
    isvisibilty = !isvisibilty;
    update();
  }

  void LoginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      Get.to(const Loading());
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (error) {
      String message = '';
      if (error.code == 'user-not-found') {
        message =
            ' $email.. لا يوجد لديك حساب بهذا الايميل  انشى حسابك من صفحة انشاء الحساب';
      } else if (error.code == 'wrong-password') {
        message = '!.....كلمة المرور غير صحيحة الرجاء حاول مرة اخرى ';
      }
      Get.back();
      Get.snackbar("Warning", message, snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar(
        'Error!',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    void signUpAdmin({
      required context,
      required String email,
      required String password,
      required String username,
    }) async {
      try {
        Get.to(const Loading());
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        AdminModel user = AdminModel(
            uid: cred.user!.uid,
            password: password,
            email: email,
            username: username,
            edit: "0",
            read: "1",
            delete: "0");

        await _firestore
            .collection("admin")
            .doc(cred.user!.uid)
            .set(user.toJson());

        update();
        Get.to(const HomeScreen());

        Get.back();
        AwesomeDialog(
          context: context,
          width: 400,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'رسالة تأكيد ',
          desc: 'تم إنشاء الحساب بنجاح',
          btnOkOnPress: () {
            Get.offAllNamed(AppRoutes.home);
          },
        ).show();
      } on FirebaseAuthException catch (error) {
        Get.back();
        String message = '';
        if (error.code == 'weak-password') {
          message = ' !....كلمة مرور ضعيفة جداً  ';
        } else if (error.code == 'email-already-in-use') {
          message = ' !....الحساب موجود لهذا الايميل ';
        }
        AwesomeDialog(
          context: context,
          width: 400,
          dialogType: DialogType.INFO,
          animType: AnimType.SCALE,
          title: '...عذراً',
          desc: message,
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
        return null;
      } catch (error) {
        Get.snackbar(
          'Error!',
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 139, 190, 140),
          colorText: Colors.white,
        );
      }
    }
  }
}

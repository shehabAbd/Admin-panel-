import 'package:admin_panal/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA7F2fBmdpG5E3j3SZoaFikzx9XREkchxE",
          authDomain: "iam-creative.firebaseapp.com",
          projectId: "iam-creative",
          storageBucket: "iam-creative.appspot.com",
          messagingSenderId: "599055011108",
          appId: "1:599055011108:web:c16f9aff913c46f69937b1"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panal ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    //  home: const HomeScreen(),
    builder: EasyLoading.init(),
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? AppRoutes.home
          : AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}

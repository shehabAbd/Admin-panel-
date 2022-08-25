import 'package:admin_panal/logic/controllers/firestore_methods.dart';
import 'package:get/get.dart';

class FirestoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put((FireStoreController()));
  }
}
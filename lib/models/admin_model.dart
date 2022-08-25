import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String email;
  final String uid;
  final String password;
  final String username;
  final String read;
  final String edit;
  final String delete;


  const AdminModel({

      required this.uid,
      required this.username,
      required this.password,
      required this.email,
      required this.edit,
      required this.delete,
      required this.read,
      });

  static AdminModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return AdminModel(
      uid: snapshot["uid"],
      email: snapshot["email"],
      password: snapshot["password"],
      username: snapshot["username"],
      edit: snapshot["edit"],
      delete: snapshot["delete"],
      read: snapshot["read"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "password": password,
        "username": username,
        "edit": edit,
        "delete": delete,
        "read": read,
      };
}

import 'package:admin_panal/logic/controllers/firestore_methods.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Manage_UserScreen extends StatefulWidget {
  const Manage_UserScreen({Key? key}) : super(key: key);

  @override
  State<Manage_UserScreen> createState() => _Manage_UserScreenState();
}

class _Manage_UserScreenState extends State<Manage_UserScreen> {
  final controller = Get.put(FireStoreController());
  List admin = [];
  getdate() async {
    CollectionReference adminref =
        FirebaseFirestore.instance.collection("admin");
    await adminref
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        admin.add(element.data());
      }
    });
  }

  @override
  void initState() {
    setState(() {
      getdate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, right: 30.0, left: 40.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("type", isEqualTo: "user")
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data?.size != 0
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, i) => Material(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DataTable(
                          columnSpacing: 8,
                          border:
                              TableBorder.all(color: Colors.black, width: 0.5),
                          columns: const [
                            DataColumn(
                              label: Text('الرقم'),
                            ),
                            DataColumn(
                              label: Text('معرف الحساب'),
                            ),
                            DataColumn(
                              label: Text('الإسم'),
                            ),
                            DataColumn(
                              label: Text('الإيميل'),
                            ),
                            DataColumn(
                              label: Text('كلمة المرور'),
                            ),
                            DataColumn(
                              label: Text('الصورة'),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              snapshot.data!.docs.length,
                              (i) => DataRow(cells: [
                                    DataCell(Text("${i + 1}")),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['uid']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['name']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['email']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['password']
                                        .toString())),
                                    DataCell(
                                        SizedBox(
                                            width: 90,
                                            height: 70,
                                            child: Image.network(
                                              snapshot.data!.docs[i]
                                                  .data()['photoUrl'],
                                              fit: BoxFit.cover,
                                            )), onTap: () async {
                                      var url = snapshot.data!.docs[i]
                                          .data()['photoUrl']
                                          .toString();
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(url);
                                      } else {
                                        print(url);
                                      }
                                    }),
                                    DataCell(Row(
                                      children: [
                                        const Icon(Icons.block,
                                            color: Colors.red, size: 15),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              if (admin[0]['edit'].toString() ==
                                                  "0") {
                                                AwesomeDialog(
                                                  context: context,
                                                  width: 500,
                                                  dialogType:
                                                      DialogType.WARNING,
                                                  animType: AnimType.SCALE,
                                                  title: ' !!!تنبية',
                                                  desc:
                                                      'عذراً لاتمتلك صلاحية التعديل',
                                                  btnOkOnPress: () {
                                                    Get.back();
                                                  },
                                                ).show();
                                              } else if (admin[0]['edit']
                                                      .toString() ==
                                                  "1") {
                                                if (snapshot.data!.docs[i]
                                                        .data()['blocked']
                                                        .toString() ==
                                                    "yes") {
                                                  controller.unblock_user(
                                                      context,
                                                      snapshot.data!.docs[i]
                                                          .data()['uid']
                                                          .toString(),
                                                      snapshot.data!.docs[i]
                                                          .data()['name']
                                                          .toString());
                                                } else if (snapshot
                                                        .data!.docs[i]
                                                        .data()['blocked']
                                                        .toString() ==
                                                    "no") {
                                                  controller.block_user(
                                                      context,
                                                      snapshot.data!.docs[i]
                                                          .data()['uid']
                                                          .toString(),
                                                      snapshot.data!.docs[i]
                                                          .data()['name']
                                                          .toString());
                                                }
                                              }
                                            },
                                            child: snapshot.data!.docs[i]
                                                        .data()['blocked']
                                                        .toString() ==
                                                    "no"
                                                ? const Text("حظر الحساب")
                                                : const Text("إلغاء الحظر")),
                                      ],
                                    )),
                                  ]))),
                    ),
                  ),
                )
              : const Center(child: Text("عذراً لايوجد بيانات"));
        },
      ),
    );
  }
}

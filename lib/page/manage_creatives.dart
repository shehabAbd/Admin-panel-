import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Manage_CreativeScreen extends StatefulWidget {
  const Manage_CreativeScreen({Key? key}) : super(key: key);

  @override
  State<Manage_CreativeScreen> createState() => _Manage_CreativeScreenState();
}

class _Manage_CreativeScreenState extends State<Manage_CreativeScreen> {
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
            .where("type", isEqualTo: "creative")
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
                              label: Text(' الجنس'),
                            ),
                            DataColumn(
                              label: Text('رقم الهاتف'),
                            ),
                            DataColumn(
                              label: Text('العنوان'),
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
                                    DataCell((Text(
                                      snapshot.data!.docs[i]
                                          .data()['uid']
                                          .toString(),
                                      overflow: TextOverflow.visible,
                                    ))),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['name']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['gender']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['phone']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['address']
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
                                                  AwesomeDialog(
                                                    context: context,
                                                    width: 500,
                                                    dialogType:
                                                        DialogType.QUESTION,
                                                    animType: AnimType.SCALE,
                                                    title:
                                                        ' هل تريد إلغاء الحظر',
                                                    desc:
                                                        'إلغاء حظر المستخدم ${snapshot.data!.docs[i].data()['name']}',
                                                    btnCancelOnPress: () {
                                                      Get.back();
                                                    },
                                                    btnOkOnPress: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(snapshot
                                                              .data!.docs[i]
                                                              .data()['uid']
                                                              .toString())
                                                          .update({
                                                        'blocked': "no",
                                                      });
                                                      Get.snackbar(
                                                        'إشعار تأكيد',
                                                        'تم إلغاء حظر الحساب بنجاح',
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor:
                                                            Colors.green,
                                                        colorText: Colors.white,
                                                      );
                                                    },
                                                  ).show();
                                                } else if (snapshot
                                                        .data!.docs[i]
                                                        .data()['blocked']
                                                        .toString() ==
                                                    "no") {
                                                  AwesomeDialog(
                                                    context: context,
                                                    width: 500,
                                                    dialogType:
                                                        DialogType.QUESTION,
                                                    animType: AnimType.SCALE,
                                                    title:
                                                        ' هل تريد تأكيد الحظر',
                                                    desc:
                                                        'حظر المستخدم ${snapshot.data!.docs[i].data()['name']}',
                                                    btnCancelOnPress: () {
                                                      Get.back();
                                                    },
                                                    btnOkOnPress: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(snapshot
                                                              .data!.docs[i]
                                                              .data()['uid']
                                                              .toString())
                                                          .update({
                                                        'blocked': "yes",
                                                      });
                                                      Get.snackbar(
                                                        'إشعار تأكيد',
                                                        'تم حظر الحساب بنجاح',
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor:
                                                            Colors.green,
                                                        colorText: Colors.white,
                                                      );
                                                    },
                                                  ).show();
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

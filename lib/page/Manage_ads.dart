import 'package:admin_panal/logic/controllers/firestore_methods.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher_string.dart';

class Manage_AdsScreen extends StatefulWidget {
  const Manage_AdsScreen({Key? key}) : super(key: key);

  @override
  State<Manage_AdsScreen> createState() => Manage_AdsScreenState();
}

class Manage_AdsScreenState extends State<Manage_AdsScreen> {
  final TextEditingController prodctNameController = TextEditingController();

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
        stream: FirebaseFirestore.instance.collection('ads').orderBy("date" ,descending: true).snapshots(),
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
                          columnSpacing: 15,
                          border:
                              TableBorder.all(color: Colors.black, width: 0.5),
                          columns: const [
                            DataColumn(
                              label: Text('الرقم'),
                            ),
                            DataColumn(
                              label: Text('معرف الإعلان'),
                            ),
                            DataColumn(
                              label: Text('اسم الإعلان'),
                            ),
                            DataColumn(
                              label: Text('الخصم'),
                            ),
                            DataColumn(
                              label: Text('الصورة'),
                            ),
                            DataColumn(
                              label: Text(''),
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
                                        .data()['adsId']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['title']
                                        .toString())),
                                    DataCell(Text('${snapshot.data!.docs[i]
                                        .data()['cuttoff']}%')),
                                    DataCell(
                                        SizedBox(
                                            width: 90,
                                            height: 70,
                                            child: Image.network(
                                              snapshot.data!.docs[i]
                                                  .data()['url']
                                                  .toString(),
                                              fit: BoxFit.cover,
                                            )), onTap: () async {
                                      var url = snapshot.data!.docs[i]
                                          .data()['url']
                                          .toString();
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(url);
                                      } else {
                                        print(url);
                                      }
                                    }),
                                    DataCell(Row(
                                      children: [
                                        const Icon(Icons.check,
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
                                                dialogType: DialogType.WARNING,
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
                                                      .data()['statues']
                                                      .toString() ==
                                                  "0") {
                                                AwesomeDialog(
                                                  context: context,
                                                  width: 500,
                                                  dialogType:
                                                      DialogType.QUESTION,
                                                  animType: AnimType.SCALE,
                                                  title: ' رسالةتأكيد    ',
                                                  desc: "هل تريد نشر الإعلان؟",
                                                  btnCancelOnPress: () {
                                                    Get.back();
                                                  },
                                                  btnOkOnPress: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('ads')
                                                        .doc(snapshot
                                                            .data!.docs[i]
                                                            .data()['adsId']
                                                            .toString())
                                                        .update({
                                                      'statues': "1",
                                                    });
                                                  },
                                                ).show();
                                              }
                                            }
                                          },
                                          child: snapshot.data!.docs[i]
                                                      .data()['statues']
                                                      .toString() ==
                                                  "1"
                                              ? const Text("تم نشر الإعلان")
                                              : const Text("نشر الإعلان"),
                                        ),
                                      ],
                                    )),
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
                                                dialogType: DialogType.WARNING,
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
                                                      .data()['statues']
                                                      .toString() ==
                                                  "1") {
                                                AwesomeDialog(
                                                  context: context,
                                                  width: 500,
                                                  dialogType:
                                                      DialogType.QUESTION,
                                                  animType: AnimType.SCALE,
                                                  title: ' رسالةتأكيد ',
                                                  desc: "هل تريد رفض الإعلان؟",
                                                  btnCancelOnPress: () {
                                                    Get.back();
                                                  },
                                                  btnOkOnPress: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('ads')
                                                        .doc(snapshot
                                                            .data!.docs[i]
                                                            .data()['adsId']
                                                            .toString())
                                                        .update({
                                                      'statues': "0",
                                                    });
                                                  },
                                                ).show();
                                              }
                                            }
                                          },
                                          child: snapshot.data!.docs[i]
                                                      .data()['statues']
                                                      .toString() ==
                                                  "0"
                                              ? const Text(" تم رفض الإعلان")
                                              : const Text("رفض الإعلان"),
                                        )
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

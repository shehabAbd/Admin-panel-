import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, right: 30.0, left: 40.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admin').snapshots(),
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
                  itemBuilder: (context, i) {
                    return Material(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DataTable(
                            columnSpacing: 8,
                            dataRowHeight: 60,
                            border: TableBorder.all(
                                color: Colors.black, width: 0.5),
                            columns: const [
                              DataColumn(
                                label: Text('الرقم'),
                              ),
                              DataColumn(
                                label: Text('معرف الحساب'),
                              ),
                              DataColumn(
                                label: Text('اسم المستخدم'),
                              ),
                              DataColumn(
                                label: Text('الإيميل'),
                              ),
                              DataColumn(
                                label: Text('كلمة المرور'),
                              ),
                              DataColumn(
                                label: Text("الصلاحيات"),
                              ),
                              DataColumn(
                                label: Text(""),
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
                                          .data()['username']
                                          .toString())),
                                           DataCell(Text(snapshot.data!.docs[i]
                                          .data()['email']
                                          .toString())),
                                      DataCell(Text(snapshot.data!.docs[i]
                                          .data()['password']
                                          .toString())),
                                      DataCell(Row(
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          Column(
                                            children: [
                                              const Text("قراءة"),
                                              InkWell(
                                                  child: snapshot.data!.docs[i]
                                                              .data()['read']
                                                              .toString() ==
                                                          "1"
                                                      ? const Icon(Icons.check)
                                                      : const Icon(Icons.close),
                                                  onTap: () {
                                                    if (snapshot.data!.docs[i]
                                                            .data()['read']
                                                            .toString() ==
                                                        "0") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد منح صلاحية القراءة',
                                                          desc:
                                                              'منح صلاحية القراءة للمستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'read': '1'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم منح الصلاحية للمستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    } else if (snapshot
                                                            .data!.docs[i]
                                                            .data()['read']
                                                            .toString() ==
                                                        "1") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد حظر صلاحية القراءة',
                                                          desc:
                                                              'حظر صلاحية القراءة على المستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'read': '0'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم حظر الصلاحية على المستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    }
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: [
                                              const Text("تعديل"),
                                              InkWell(
                                                  child: snapshot.data!.docs[i]
                                                              .data()['edit']
                                                              .toString() ==
                                                          '1'
                                                      ? const Icon(Icons.check)
                                                      : const Icon(Icons.close),
                                                  onTap: () {
                                                    if (snapshot.data!.docs[i]
                                                            .data()['edit']
                                                            .toString() ==
                                                        "0") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد منح صلاحية التعديل',
                                                          desc:
                                                              'منح صلاحية التعديل للمستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'edit': '1'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم منح الصلاحية للمستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    } else if (snapshot
                                                            .data!.docs[i]
                                                            .data()['edit']
                                                            .toString() ==
                                                        "1") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد حظر صلاحية التعديل',
                                                          desc:
                                                              'حظر صلاحية الحذف على المستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'edit': '0'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم حظر الصلاحية على المستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    }
                                                  }),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            children: [
                                              const Text("حذف"),
                                              InkWell(
                                                  child: snapshot.data!.docs[i]
                                                              .data()['delete']
                                                              .toString() ==
                                                          "1"
                                                      ? const Icon(Icons.check)
                                                      : const Icon(Icons.close),
                                                  onTap: () {
                                                    if (snapshot.data!.docs[i]
                                                            .data()['delete']
                                                            .toString() ==
                                                        "0") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد منح صلاحية الحذف',
                                                          desc:
                                                              'منح صلاحية الحذف للمستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'delete': '1'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم منح الصلاحية للمستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    } else if (snapshot
                                                            .data!.docs[i]
                                                            .data()['delete']
                                                            .toString() ==
                                                        "1") {
                                                      AwesomeDialog(
                                                          context: context,
                                                          width: 500,
                                                          dialogType: DialogType
                                                              .QUESTION,
                                                          animType:
                                                              AnimType.SCALE,
                                                          title:
                                                              ' هل تريد حظر صلاحية الحذف',
                                                          desc:
                                                              'حظر صلاحية الحذف على المستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                          btnCancelOnPress: () {
                                                            Get.back();
                                                          },
                                                          btnOkOnPress:
                                                              () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'admin')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .data()[
                                                                        'uid']
                                                                    .toString())
                                                                .update({
                                                              'delete': '0'
                                                            });
                                                            Get.snackbar(
                                                              'إشعار تأكيد',
                                                              "تم حظر الصلاحية على المستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  Colors.green,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                          }).show();
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ],
                                      )),
                                      DataCell(Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              AwesomeDialog(
                                                  context: context,
                                                  width: 500,
                                                  dialogType:
                                                      DialogType.QUESTION,
                                                  animType: AnimType.SCALE,
                                                  title: ' هل تريد تأكيد الحذف',
                                                  desc:
                                                      'حذف المستخدم ${snapshot.data!.docs[i].data()['username']}',
                                                  btnOkOnPress: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("admin")
                                                        .doc(snapshot
                                                            .data!.docs[i]
                                                            .data()['uid'])
                                                        .delete();

                                                    Get.snackbar(
                                                      'إشعار تأكيد',
                                                      "تم حذف المستخدم ${snapshot.data!.docs[i].data()['username']}",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                      colorText: Colors.white,
                                                    );
                                                  },
                                                  btnCancelOnPress: () {
                                                    Get.back();
                                                  }).show();
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(Icons.delete,color: Colors.red,),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "حذف",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                    ]))),
                      ),
                    );
                  })
              : const Center(
                  child: Text(" عذراً  لايوجد  بيانات"),
                );
        },
      ),
    );
  }
}

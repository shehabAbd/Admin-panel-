import 'package:admin_panal/logic/controllers/firestore_methods.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher_string.dart';

class Manage_ProductsScreen extends StatefulWidget {
  const Manage_ProductsScreen({Key? key}) : super(key: key);

  @override
  State<Manage_ProductsScreen> createState() => Manage_ProductsScreenState();
}

class Manage_ProductsScreenState extends State<Manage_ProductsScreen> {
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
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
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
                          columnSpacing: 5,
                          border:
                              TableBorder.all(color: Colors.black, width: 0.5),
                          columns: const [
                            DataColumn(
                              label: Text('الرقم'),
                            ),
                            DataColumn(
                              label: Text('معرف المنتج'),
                            ),
                            DataColumn(
                              label: Text('اسم المنتج'),
                            ),
                            DataColumn(
                              label: Text('وصف المنتج'),
                            ),
                            DataColumn(
                              label: Text('السعر'),
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
                                        .data()['postId']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['postname']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['description']
                                        .toString())),
                                    DataCell(Text(snapshot.data!.docs[i]
                                        .data()['price']
                                        .toString())),
                                    DataCell(
                                        SizedBox(
                                            width: 90,
                                            height: 70,
                                            child: Image.network(
                                              snapshot.data!.docs[i]
                                                  .data()['postUrl'],
                                              fit: BoxFit.cover,
                                            )), onTap: () async {
                                      var url = snapshot.data!.docs[i]
                                          .data()['postUrl']
                                          .toString();
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(url);
                                      } else {
                                        print(url);
                                      }
                                    }),
                                    DataCell(Row(
                                      children: [
                                        const Icon(Icons.delete,
                                            color: Colors.red, size: 15),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            
                                            if (admin[0]['delete'].toString() ==
                                                "0") {
                                              AwesomeDialog(
                                                context: context,
                                                width: 500,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.SCALE,
                                                title: ' !!!تنبية',
                                                desc:
                                                    'عذراً لاتمتلك صلاحية الحذف',
                                                btnOkOnPress: () {
                                                  Get.back();
                                                },
                                              ).show();
                                            } else if (admin[0]['delete']
                                                    .toString() ==
                                                "1") {
                                              String id = snapshot.data!.docs[i]
                                                  .data()["postId"]
                                                  .toString();
                                              String name = snapshot
                                                  .data!.docs[i]
                                                  .data()["postname"];
                                              controller.deleteProduct(
                                                  context, id, name);
                                            }
                                          },
                                          child: const Text("حذف المنتج"),
                                        ),
                                      ],
                                    )),
                                  ]))),
                    ),
                  ),
                )
              : const Center(
                  child: Text("عذراً لايوجد بيانات"),
                );
        },
      ),
    );
  }
}

import 'package:admin_panal/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  var lenCreative = 0;
  var lenUser = 0;
  var lenProduct = 0;
  var lenAds = 0;

  Future getlenCreative() async {
    FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'creative')
          .get()
          .then((value) {
        setState(() {
          lenCreative = value.docs.length;
        });
        print(lenCreative);
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container();
      },
    );
  }

  Future getlenUser() async {
    FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'user')
          .get()
          .then((value) {
        setState(() {
          lenUser = value.docs.length;
        });
        print(lenUser);
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container();
      },
    );
  }

  Future getlenProduct() async {
    FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('product').get().then((value) {
        setState(() {
          lenProduct = value.docs.length;
        });
        print(lenProduct);
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container();
      },
    );
  }

  Future getlenAds() async {
    FutureBuilder(
      future: FirebaseFirestore.instance.collection('ads').get().then((value) {
        setState(() {
          lenAds = value.docs.length;
        });
        print(lenAds);
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container();
      },
    );
  }

  @override
  void initState() {
    getlenAds();
    getlenCreative();
    getlenProduct();
    getlenUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget analyticWidget(name) {
      return Padding(
        padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$name",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(
                        Icons.show_chart,
                        color: AppColors.orange,
                      ),
                    ],
                  )
                ]),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Row(
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              analyticWidget("الحرفيين $lenCreative"),
              analyticWidget("المستخدمين $lenUser"),
              analyticWidget("الحرف $lenProduct"),
              analyticWidget("الأعلانات $lenAds"),
            ],
          ),
        ],
      ),
    );
  }
}

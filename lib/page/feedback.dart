import 'package:admin_panal/utils/app_colors.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, right: 30.0, left: 40.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data?.size != 0
              ? ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: AppColors.white,
                      height: 15,
                    );
                  },
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) => Material(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blue.withOpacity(0.50),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      margin:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ).copyWith(right: 0),
                            child: Row(children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 6, top: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    placeholder: (conteext, url) =>
                                        const CircularProgressIndicator(
                                      color: AppColors.blue,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.person,
                                    ),
                                    imageUrl: snapshot.data!.docs[i]
                                        .data()["photoUrl"],

                                    // userData['photoUrl'].toString(),
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[i].data()["name"],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: AppColors.blackshade,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Container(
                                            child: Text(
                                              DateFormat.yMMMd()
                                                  .add_Hm()
                                                  .format(
                                                    snapshot.data!.docs[i]
                                                        .data()["date"]
                                                        .toDate(),
                                                  ),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child:
                                Text(snapshot.data!.docs[i].data()["feedback"]),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(child: Text("عذراً لايوجد بيانات"));
        },
      ),
    );
  }
}

// Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: Text(
//                         snapshot.data!.docs[i].data()["feedback"],
//                       ),
//                     ),

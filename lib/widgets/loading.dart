import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
        color:const Color.fromRGBO(255, 255, 255, 1),
        child: const SpinKitFadingCircle(
          color: Colors.black,
          size: 30,
        )
      ),
    );
  }
}

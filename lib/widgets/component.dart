import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customText(context,
        {bool upperCase = true,
        required String text,
        double? fontSize,
        Color? color,
        FontWeight? fontWeight}) =>
    Text(
      upperCase ? text.toUpperCase() : text,
      style: TextStyle(fontSize: fontSize ?? 16, color: color ?? Colors.white),
    );

blockConfirmation(context, {required String text1, String? text2, function}) =>
    AwesomeDialog(
      context: context,
      width: 500,
      dialogType: DialogType.QUESTION,
      animType: AnimType.SCALE,
      title: ' هل تريد تأكيد الحظر',
      desc: 'حظر المستخدم $text1',
      btnCancelOnPress: () {
        Get.back();
      },
      btnOkOnPress: () {},
    )..show();

Widget defaultButton(
        {double width = double.infinity,
        Color background = Colors.green,
        @required function,
        @required text,
        bool iconText = false,
        icon,
        radius}) =>
    Container(
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10.0))),
      width: width,
      height: 50,
      child: MaterialButton(
        onPressed: function,
        child: iconText == false
            ? Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            : Icon(icon),
      ),
    );

class AuthTextFromField extends StatelessWidget {
  // final TextEditingController controller;
  final String val;
  final  void Function(String?) onsave;
  final bool obscureText;
  final Function validator;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String hintText;
  final TextInputType keyboardType;
  const AuthTextFromField({
    required this.val,
    required this.onsave,
    // required this.controller,
    required this.obscureText,
    required this.validator,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
    Key? key,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: TextFormField(
        onSaved: onsave,
        initialValue: val,
        // controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        validator: (value) => validator(value),
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

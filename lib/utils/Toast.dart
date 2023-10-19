import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white,
      fontSize: 20,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_LONG);
}

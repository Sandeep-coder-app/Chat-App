import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void flutterToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 3,
    gravity: ToastGravity.BOTTOM,
    textColor: Colors.white,
    backgroundColor: Colors.red,
  );
}
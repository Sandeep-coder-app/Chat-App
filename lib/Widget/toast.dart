import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    timeInSecForIosWeb: 2,
    textColor: Colors.black,
    backgroundColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    fontSize: 16,
  );
}

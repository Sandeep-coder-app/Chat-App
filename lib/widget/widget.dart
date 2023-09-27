import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  iconColor: Color(0xFFee7b64),
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: Color(0xFFee7b64), width: 2)
  )
);
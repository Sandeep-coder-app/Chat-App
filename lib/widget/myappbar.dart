

import 'package:chat_app/pages/search_page.dart';
import 'package:flutter/material.dart';

AppBar MyAppBar(BuildContext context) {
  return AppBar(
            actions: [
          IconButton(
            onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: const Icon(Icons.search,
            color: Colors.white,),
          )
        ],
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title:const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chat",
              style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Hub",
              style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        )
  );
}
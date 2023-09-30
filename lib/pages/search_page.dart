import 'package:chat_app/helper/helper_fun.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/widget/group_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFun.getUserName().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

    String getName(String r) {
      return r.substring(r.indexOf("_")+1);
    }

    String getId(String res) {
      return res.substring(0, res.indexOf("_"));
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orange,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 27, color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Groups....",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
          ? Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            )
          )
          : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if(searchController.text.isNotEmpty) {
      setState(() {
        isJoined = true;
      });
      await DatabaseService().searchByName(searchController.text)
      .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
    ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return GroupTile(
          userName,
          searchSnapshot!.docs[index]['groupId'],
        );
      },
    )
  }
}
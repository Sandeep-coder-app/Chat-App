import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({super.key, required this.adminName, required this.groupId, required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    super.initState();

  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    .getGroupMembers(widget.groupId)
    .then((value) {
      setState(() {
        members = value;
      });
    });
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
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.orange,
        title: const Text("Group Info"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit"),
                    content: const Text("Are you sure you exit the group"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      IconButton(
                        onPressed: () async{
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                          .toggleGroupJoin(
                            widget.groupId,
                            getName(widget.adminName),
                            widget.groupName
                          ).whenComplete(() {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                          });
                        },
                        icon: const Icon(Icons.done,
                        color: Colors.green,),
                      )
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.orange.withOpacity(0.2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Text(
                      widget.groupName.substring(0,1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context,AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['members'] != null) {
            if(snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange,
                        child: Text(
                          getName(snapshot.data['members'][index])
                          .substring(0,1)
                          .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
      },
    );
  }
}
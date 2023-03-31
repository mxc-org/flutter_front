import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/newFriendsUI.dart';
import 'package:flutter_front/searchUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

import 'obj.dart';

class FriendsUI extends StatefulWidget {
  const FriendsUI({super.key});

  @override
  State<FriendsUI> createState() => _FriendsUIState();
}

class _FriendsUIState extends State<FriendsUI> {
  @override
  void initState() {
    super.initState();
    getFriends(Values.user.id);
    getNewFriends(Values.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("好友"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (buildContext) => const SearchUI(),
                ),
              );
            },
            iconSize: 25,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(
                "新的朋友",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (buildContext) => const newFriendsUI(),
                  ),
                );
              },
            ),
            myListView()
          ],
        ),
      ),
    );
  }

  Widget myListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Values.friendList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(Values.friendList[i].username),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "${Values.avatarUrl}${Values.friendList[i].avatarName}",
                ),
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {},
            child: const Text(
              "对战",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void getFriends(int id) async {
    var response = await http.get(
      Uri.parse("${Values.server}/Friend/FriendList?userId=$id"),
    );
    Values.friendList.clear();
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      setState(() {});
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      Values.friendList.add(User.mpToUser(mp));
    }
    setState(() {});
  }

  void getNewFriends(int id) async {
    var response = await http.get(
      Uri.parse("${Values.server}/Friend/RequestList?userId=$id"),
    );
    Values.newFriendList.clear();
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      setState(() {});
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      if (mp["status"] == true) {
        continue;
      }
      Values.newFriendList.add(Friend.mpToFriend(mp));
    }
    setState(() {});
  }
}

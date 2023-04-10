import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

import 'obj.dart';

class NewFriendsUI extends StatefulWidget {
  const NewFriendsUI({super.key});

  @override
  State<NewFriendsUI> createState() => _NewFriendsUIState();
}

class _NewFriendsUIState extends State<NewFriendsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新的朋友"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: myListView(),
      ),
    );
  }

  Widget myListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Values.newFriendList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(Values.newFriendList[i].userFrom.username),
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "${Values.avatarUrl}${Values.newFriendList[i].userFrom.avatarName}",
                ),
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              onAcceptPressed(Values.newFriendList[i].id);
            },
            child: const Text(
              "接受",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void onAcceptPressed(int friendId) async {
    showSingleActionDialog("已和对方成为好友，快去玩耍吧");
    await http.post(
      Uri.parse("${Values.server}/Friend/Accept"),
      body: {"friendId": friendId.toString()},
    );
    getFriends(Values.user.id);
    getNewFriends(Values.user.id);
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

  showSingleActionDialog(String content) {
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text("提示"),
        content: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "确定",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

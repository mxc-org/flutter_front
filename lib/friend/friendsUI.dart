import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/friend/invitedUI.dart';
import 'package:flutter_front/friend/newFriendsUI.dart';
import 'package:flutter_front/friend/searchUI.dart';
import 'package:flutter_front/game/createRoomUI.dart';
import 'package:flutter_front/util/values.dart';
import 'package:http/http.dart' as http;

import '../util/obj.dart';

class FriendsUI extends StatefulWidget {
  const FriendsUI({super.key});

  @override
  State<FriendsUI> createState() => _FriendsUIState();
}

class _FriendsUIState extends State<FriendsUI> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        getFriends(Values.user.id);
        getNewFriends(Values.user.id);
      },
    );
    getFriends(Values.user.id);
    getNewFriends(Values.user.id);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(127, 255, 153, 0),
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
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 252, 241, 234),
                      Color.fromARGB(255, 252, 241, 234), //开始颜色和结束颜色
                    ]),
              ),
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text(
                  "新的朋友",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (buildContext) => const NewFriendsUI(),
                    ),
                  );
                },
              ),
            ),
            const Divider(
              height: 1.0,
              color: Colors.grey,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 252, 241, 234),
                      Color.fromARGB(255, 252, 241, 234), //开始颜色和结束颜色
                    ]),
              ),
              child: ListTile(
                leading: const Icon(Icons.games),
                title: const Text(
                  "对战请求",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (buildContext) => const InvitedUI(),
                    ),
                  );
                },
              ),
            ),
            Divider(
              height: 1.0,
              color: Colors.grey,
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
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 252, 241, 234),
                    Color.fromARGB(255, 252, 241, 234), //开始颜色和结束颜色
                  ]),
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
          child: ListTile(
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
              trailing: Container(
                width: 80,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      //  begin: Alignment.topLeft,
                      //end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 239, 192, 74),
                        Colors.orange //开始颜色和结束颜色
                      ]),
                ),
                child: TextButton(
                  onPressed: () {
                    onInvitePressed(Values.friendList[i].id.toString());
                  },
                  child: Text(
                    "对战",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )),
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
    if (mounted) {
      setState(() {});
    }
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
    if (mounted) {
      setState(() {});
    }
  }

  void onInvitePressed(String inviteeId) async {
    Values.turn = true;
    var response = await http.post(
      Uri.parse("${Values.server}/Room/CreateRoom"),
      body: {"userId": Values.user.id.toString()},
    );
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      showSingleActionDialog("创建房间失败");
      return;
    }
    Values.currentRoom = Room.mpToRoom(json.decode(str));
    http.post(
      Uri.parse(
        "${Values.server}/Invitation/InviteToBattle",
      ),
      body: {
        "userId": Values.user.id.toString(),
        "inviteeId": inviteeId,
        "roomId": Values.currentRoom.id.toString(),
      },
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (buildContext) => const CreateRoomUI(),
      ),
    );
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

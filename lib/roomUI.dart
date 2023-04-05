import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/createRoomUI.dart';
import 'package:flutter_front/fightUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'obj.dart';

class RoomUI extends StatefulWidget {
  const RoomUI({super.key});

  @override
  State<RoomUI> createState() => _RoomUIState();
}

class _RoomUIState extends State<RoomUI> {
  List<User> listUser = [];
  late Timer timer;

  @override
  void initState() {
    getRoomList();
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/asdfasdf.jpeg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.75),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: roomListView(),
              ),
            ),
            ElevatedButton(
              onPressed: onCreateRoomPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(10, 50)),
              ),
              child: const Text(
                "创建房间",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(10, 50)),
              ),
              child: const Text(
                "返回主页",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget roomListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Values.roomList.length,
      itemBuilder: (context, i) {
        // 房间状态：WAITING，FIGHTING，CLOSED
        Widget trailingText = const Text("");
        if (Values.roomList[i].status == "WAITING") {
          trailingText = const Text("等待中");
        } else if (Values.roomList[i].status == "FIGHTING") {
          trailingText = const Text("游戏中");
        } else if (Values.roomList[i].status == "CLOSED") {
          trailingText = const Text("已结束");
        }
        DecorationImage decorationImage = Values.roomList[i].userIdJoin == 0
            ? const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("images/nobody.png"),
              )
            : DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  Values.avatarUrl + Values.roomList[i].userJoin!.avatarName,
                ),
              );
        return myListTile(i, trailingText, decorationImage);
      },
    );
  }

  Widget myListTile(
    int i,
    Widget trailingText,
    DecorationImage decorationImage,
  ) {
    return ListTile(
      onTap: () {
        if (Values.roomList[i].status == "WAITING") {
          onJoinRoomPressed(Values.roomList[i]);
        } else if (Values.roomList[i].status == "CLOSED") {
          showSingleActionDialog("该房间已关闭，无法进入噢");
        } else {
          showSingleActionDialog("该房间正在游戏，无法进入噢");
        }
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  Values.avatarUrl + Values.roomList[i].userCreator.avatarName,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            height: 30,
            width: 30,
            child: Image.asset('images/VS.jpeg'),
          ),
          const SizedBox(width: 15),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: decorationImage,
            ),
          )
        ],
      ),
      leading: Text("${Values.roomList[i].id}号房"),
      trailing: trailingText,
    );
  }

  void getRoomList() async {
    listUser.clear();
    var response = await http.get(
      Uri.parse("${Values.server}/Room/RoomList"),
    );
    Values.roomList.clear();
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      Values.roomList.add(Room.mpToRoom(mp));
    }
    setState(() {});
  }

  void onCreateRoomPressed() async {
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

  void onJoinRoomPressed(Room room) {
    Values.currentRoom = room;
    http.post(
      Uri.parse("${Values.server}/Room/JoinRoom"),
      body: {
        "userId": Values.user.id.toString(),
        "roomId": Values.currentRoom.id.toString(),
      },
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (buildContext) => const FightUI()),
    );
  }
}

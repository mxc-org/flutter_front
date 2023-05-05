import 'dart:convert';

import 'package:enhanced_button/enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_front/game/roomUI.dart';
import 'package:flutter_front/util/values.dart';
import 'package:http/http.dart' as http;

import 'createRoomUI.dart';
import 'fightUI.dart';
import '../util/obj.dart';

class GameUI extends StatefulWidget {
  const GameUI({super.key});

  @override
  State<GameUI> createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> {
  List<Room> roomList = [];
  @override
  Widget build(BuildContext context) {
    Values.width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/game.jpg"),
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
            Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 5),
              child: EnhancedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (buildContext) => const RoomUI(),
                      ),
                    );
                  },
                  enhancedStyle: EnhancedButtonStyle(
                    gradient: MaterialStateProperty.all(const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 239, 192, 74),
                          Colors.orange
                        ])),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "游戏大厅",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 35),
            Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 5),
              child: EnhancedButton(
                  onPressed: () {
                    onPlayNowPressed();
                  },
                  enhancedStyle: EnhancedButtonStyle(
                    gradient: MaterialStateProperty.all(const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 239, 192, 74),
                          Colors.orange
                        ])),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "立即匹配",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  onPlayNowPressed() async {
    await getRoomReadyList();
    //如果没有房间则创建，否则就直接加入房间
    if (roomList.isEmpty) {
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
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (buildContext) => const CreateRoomUI(),
        ),
      );
    } else {
      Values.currentRoom = roomList[0];
      Values.turn = false;
      var response = await http.post(
        Uri.parse("${Values.server}/Room/JoinRoom"),
        body: {
          "userId": Values.user.id.toString(),
          "roomId": Values.currentRoom.id.toString(),
        },
      );
      if (response.body == "") {
        showSingleActionDialog("哎呀，加入房间失败，请重试");
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(builder: (buildContext) => const FightUI()),
        );
      }
    }
  }

  getRoomReadyList() async {
    roomList.clear();
    var response = await http.get(
      Uri.parse("${Values.server}/Room/RoomList"),
    );
    String str = utf8.decode(response.bodyBytes);
    if (str == "") {
      return;
    }
    List<dynamic> ls = json.decode(str);
    for (Map<String, dynamic> mp in ls) {
      Room room = Room.mpToRoom(mp);
      if (room.status == "WAITING") {
        roomList.add(room);
      }
    }
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

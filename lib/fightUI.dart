import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

class FightUI extends StatefulWidget {
  const FightUI({super.key});

  @override
  State<FightUI> createState() => _FightUIState();
}

class _FightUIState extends State<FightUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/fight.jpeg"),
          fit: BoxFit.cover,
          opacity: 0.75,
        ),
      ),
      child: ElevatedButton(
        onPressed: returnRoomUI,
        child: const Text("返回"),
      ),
    );
  }

  void returnRoomUI() {
    leaveRoom();
    if (Values.currentRoom.userIdCreator == Values.user.id) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pop();
  }

  void leaveRoom() {
    http.post(
      Uri.parse("${Values.server}/Room/LeaveRoom"),
      body: {
        "userId": Values.user.id.toString(),
        "roomId": Values.currentRoom.id.toString(),
      },
    );
  }
}

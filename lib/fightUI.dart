import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';

class FightUI extends StatefulWidget {
  const FightUI({super.key});

  @override
  State<FightUI> createState() => _FightUIState();
}

class _FightUIState extends State<FightUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: returnRoomUI,
        child: const Text("返回"),
      ),
    );
  }

  void returnRoomUI() {
    if (Values.currentRoom.userIdCreator == Values.user.id) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pop();
  }
}

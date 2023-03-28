import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_front/values.dart';

class CreateRoomUI extends StatefulWidget {
  const CreateRoomUI({super.key});

  @override
  State<CreateRoomUI> createState() => _CreateRoomUIState();
}

class _CreateRoomUIState extends State<CreateRoomUI> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/asdfasdf.jpeg"),
          fit: BoxFit.cover,
          opacity: 0.75,
        ),
      ),
      child: Column(
        children: [
          const Expanded(
            child: Text(""),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(Values.avatarUrl + Values.user.avatarName),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "VS",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("images/nobody.png"),
              ),
            ),
          ),
          const Expanded(
            child: Text(""),
          ),
          ElevatedButton(
            onPressed: () {
              leaveRoom();
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
              minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
            ),
            child: const Text(
              "取消对局",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
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

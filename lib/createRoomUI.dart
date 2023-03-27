import 'package:flutter/material.dart';

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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(Values.avatarUrl + Values.user.avatarName),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 35,
            width: 35,
            child: Image.asset('images/VS.jpeg'),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("images/nobody.png"),
              ),
            ),
          ),
          SizedBox(
            height: 30,
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
          const Expanded(
            child: Text(""),
          )
        ],
      ),
    );
  }

  void leaveRoom() {
    //TODO 发送离开房间请求
  }
}

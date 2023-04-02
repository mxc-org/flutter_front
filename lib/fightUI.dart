import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;
import 'obj.dart';
import 'dart:convert';

class FightUI extends StatefulWidget {
  const FightUI({super.key});

  @override
  State<FightUI> createState() => _FightUIState();
}

class _FightUIState extends State<FightUI> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fight.jpeg"),
              fit: BoxFit.cover,
              opacity: 0.75,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (Values.ischat == false) chatbutton(),
              if (Values.ischat == true)
                Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.white,
                  child: Column(
                    children: [communicationView()],
                  ),
                ),
            ],
          )),
    );
  }

  Widget chatbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
          ),
          onPressed: startchat,
          child: const Text("与对手对话"),
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
          ),
          onPressed: returnRoomUI,
          child: const Text("返回"),
        )
      ],
    );
  }

  void startchat() async {
    Values.myWebSocket.connect();
    setState(() {
      if (Values.ischat == false) {
        Values.ischat = true;
      }
    });
  }

  void endchat() async {
    setState(() {
      if (Values.ischat == true) {
        Values.ischat = false;
      }
    });
  }

  Widget communicationView() {
    return Expanded(
      child: Column(
        children: [
          TextButton(
            onPressed: endchat,
            child: Text("收起对话框"),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: chatView(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          inputView(),
        ],
      ),
    );
  }

  Widget chatView() {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: Values.message.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Row(
            textDirection: Values.user.id == Values.message[index].fromId
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Values.currentRoom.userIdJoin ==
                              Values.message[index].fromId
                          ? Values.avatarUrl +
                              Values.currentRoom.userJoin!.avatarName
                          : Values.avatarUrl +
                              Values.currentRoom.userCreator.avatarName,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child:
                      SelectableText(Values.message[index].content.toString()),
                ),
              ),
            ],
          ));
        });
  }

  Widget inputView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 左侧文字输入框
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              cursorColor: Colors.black,
              keyboardType: TextInputType.multiline,

              minLines: 2, //最少多少行
              style: TextStyle(fontSize: 16, color: Colors.black87), //文字大小、颜色

              decoration: InputDecoration(
                isCollapsed: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 右侧发送文字的按钮
          ElevatedButton(
            onPressed: send,
            child: const Text('发送'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void send() async {
    String text = _controller.text;
    var response = await http.post(
      Uri.parse("${Values.server}/Chat/SendMessage"),
      body: {
        "fromId": Values.user.id.toString(),
        "toId": Values.currentRoom.userIdJoin == Values.user.id
            ? Values.currentRoom.userIdCreator.toString()
            : Values.currentRoom.userIdJoin.toString(),
        "content": text.toString()
      },
    );
    var response2 = await http.post(
      Uri.parse("${Values.server}/Chat/SendMessage"),
      body: {
        "fromId": Values.user.id.toString(),
        "toId": Values.user.id.toString(),
        "content": text.toString()
      },
    );
    _controller.clear();
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

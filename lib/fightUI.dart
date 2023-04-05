import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

class FightUI extends StatefulWidget {
  const FightUI({super.key});

  @override
  State<FightUI> createState() => _FightUIState();
}

class _FightUIState extends State<FightUI> {
  final TextEditingController _controller = TextEditingController();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //游戏中用户信息
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  height: 100,
                ),
                //TODO 棋盘
                const Expanded(child: Text("棋盘")),
                const SizedBox(height: 20)
              ],
            ),
            if (Values.ischat == false)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: chatbutton(),
              ),
            if (Values.ischat == true)
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: height / 2,
                color: Colors.white,
                child: communicationView(),
              ),
          ],
        ),
      ),
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
          child: const Text(
            "对话",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
          ),
          onPressed: returnRoomUI,
          child: const Text(
            "返回",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  void startchat() async {
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
            child: const Text("收起对话框"),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: chatView(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          inputView(),
        ],
      ),
    );
  }

  Widget chatView() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
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
              const SizedBox(
                width: 10,
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
                  child: SelectableText(
                    Values.message[index].content.toString(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget inputView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // 左侧文字输入框
          Expanded(
            child: TextField(
              maxLines: 2,
              controller: _controller,
              cursorColor: Colors.black,
              keyboardType: TextInputType.multiline,
              minLines: 1, //最少多少行
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ), //文字大小、颜色
              decoration: const InputDecoration(
                isCollapsed: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                contentPadding: EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 12,
                  bottom: 12,
                ),
                constraints: BoxConstraints(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 右侧发送文字的按钮
          ElevatedButton(
            onPressed: send,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  void send() {
    String text = _controller.text;
    http.post(
      Uri.parse("${Values.server}/Chat/SendMessage"),
      body: {
        "fromId": Values.user.id.toString(),
        "toId": Values.currentRoom.userIdJoin == Values.user.id
            ? Values.currentRoom.userIdCreator.toString()
            : Values.currentRoom.userIdJoin.toString(),
        "content": text.toString()
      },
    );
    http.post(
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
    Values.message.clear();
    http.post(
      Uri.parse("${Values.server}/Room/LeaveRoom"),
      body: {
        "userId": Values.user.id.toString(),
        "roomId": Values.currentRoom.id.toString(),
      },
    );
  }
}

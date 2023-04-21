import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/game/boardView.dart';
import 'package:flutter_front/game/remainTimeWidget.dart';
import 'package:flutter_front/util/values.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

import '../util/obj.dart';

class FightUI extends StatefulWidget {
  const FightUI({super.key});

  @override
  State<FightUI> createState() => _FightUIState();
}

class _FightUIState extends State<FightUI> {
  final TextEditingController _controller = TextEditingController();
  final scrollController = ScrollController();
  late Timer timer;
  List<Widget> gridList = [];
  int channum = 0;

  @override
  void initState() {
    super.initState();
    Values.remainTime = 60;
    Values.win = 0;
    Values.currentChess = ChessBoard(0, 0, -1, -1, false, false);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {});
        }
        if (Values.win == 1) {
          showSingleActionDialogAndLeave("恭喜你，成功打败了对手");
          timer.cancel();
        } else if (Values.win == 2) {
          showSingleActionDialogAndLeave("很遗憾，你失败了，不要灰心噢");
          timer.cancel();
        }
        if (Values.connectStatus == false) {
          showSingleActionDialogAndLeave("糟糕，你断线了，请重新登录");
          timer.cancel();
        }
        Values.remainTime--;
        if (Values.remainTime <= 0 && Values.turn == true) {
          showSingleActionDialogAndLeave("抱歉，你已超时");
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Values.width = MediaQuery.of(context).size.width;
    if (channum < Values.message.length) {
      scrollToBottom();
      channum = Values.message.length;
    }
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
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: myColumn(),
                  ),
                ),
                const Expanded(flex: 1, child: Text("")),
                SizedBox(
                  height: Values.width,
                  child: const BoardView(),
                ),
                const Expanded(flex: 5, child: Text("")),
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

  Widget myColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        myRow(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "对局数：${Values.currentRoom.userCreator.totalMatches}场",
                  ),
                  Text(
                    "胜率：${(Values.currentRoom.userCreator.winPercentage * 100).toStringAsFixed(2)} %",
                  ),
                ],
              ),
            ),
            const Expanded(
              child: RemainTimeWidget(),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    Values.currentRoom.userJoin == null
                        ? ""
                        : "对局数：${Values.currentRoom.userJoin!.totalMatches}场",
                  ),
                  Text(
                    "胜率：${(Values.currentRoom.userJoin!.winPercentage * 100).toStringAsFixed(2)} %",
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget myRow() {
    ImageProvider<Object> myImage;
    //判空
    if (Values.currentRoom.userIdJoin == 0) {
      myImage = const AssetImage("images/nobody.png");
    } else {
      myImage = NetworkImage(
        Values.avatarUrl + Values.currentRoom.userJoin!.avatarName,
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Values.currentRoom.userCreator.username,
                style: const TextStyle(fontSize: 20),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Values.avatarUrl +
                          Values.currentRoom.userCreator.avatarName,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const Expanded(
          flex: 1,
          child: Text(
            "VS",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                //判空
                Values.currentRoom.userIdJoin != 0
                    ? Values.currentRoom.userJoin!.username
                    : "",
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.end,
              ),
              const SizedBox(width: 10),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: myImage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget chatbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        badges.Badge(
          showBadge: Values.notice,
          child: ElevatedButton(
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
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange),
            minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
          ),
          onPressed: onReturnRoom,
          child: const Text(
            "退出",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget communicationView() {
    return Column(
      children: [
        TextButton(
          onPressed: endchat,
          child: const Text("收起对话框"),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            controller: scrollController,
            child: chatView(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        inputView(),
      ],
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
        return myListTile(index);
      },
    );
  }

  Widget myListTile(int index) {
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
                  Values.currentRoom.userIdJoin == Values.message[index].fromId
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
                color: Values.user.id != Values.message[index].fromId
                    ? Colors.grey[200]
                    : const Color.fromARGB(255, 97, 153, 243),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                Values.message[index].content.toString(),
                style: TextStyle(
                  color: Values.user.id != Values.message[index].fromId
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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

  void startchat() async {
    setState(() {
      Values.notice = false;
      if (Values.ischat == false) {
        Values.ischat = true;
        scrollToBottom();
      }
    });
  }

  void endchat() async {
    Values.notice = false;
    setState(() {
      if (Values.ischat == true) {
        Values.ischat = false;
      }
    });
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

  void onReturnRoom() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("提示"),
        content: const Text(
          "你确定要退出吗？",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "取消",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              retrunRoomConfirm();
            },
            child: const Text(
              "确定",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void retrunRoomConfirm() {
    Navigator.of(context).pop();
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

  void scrollToBottom() {
    //延迟执行滚动，防止出现异常
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      timer.cancel();
      try {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      } catch (e) {
        e;
      }
    });
  }

  void showSingleActionDialogAndLeave(String content) {
    leaveRoom();
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

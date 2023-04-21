import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/game/boardView.dart';
import 'package:flutter_front/game/remainTimeWidget.dart';
import 'package:flutter_front/util/values.dart';

import '../util/obj.dart';

class ReplayUI extends StatefulWidget {
  const ReplayUI({super.key, required this.match});
  final Match match;

  @override
  State<ReplayUI> createState() => _ReplayUIState();
}

class _ReplayUIState extends State<ReplayUI> {
  late Timer timer;
  List<Widget> gridList = [];
  late User firstUser;
  late User secondUser;
  bool isPlay = true;
  int poiter = -1;

  @override
  void initState() {
    super.initState();
    Values.win = 0;
    Values.currentChess = ChessBoard(0, 0, -1, -1, false, false);
    User winner = widget.match.winner;
    User loser = widget.match.loser;
    Values.remainTime = 0;
    Values.turn = false;
    if (widget.match.history.isNotEmpty &&
        widget.match.history[0].userId == winner.id) {
      firstUser = winner;
      secondUser = loser;
    } else {
      firstUser = loser;
      secondUser = winner;
    }
    Values.currentRoom = Room(
      0,
      "FIGHTING",
      firstUser.id,
      secondUser.id,
      firstUser,
      secondUser,
    );
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {});
        }
        // if (Values.win == 1) {
        //   showSingleActionDialog("恭喜你，成功打败了对手");
        //   timer.cancel();
        // } else if (Values.win == 2) {
        //   // showSingleActionDialog("很遗憾，你失败了，不要灰心噢");
        //   timer.cancel();
        // }
        if (isPlay == true) {
          nextStep();
        }
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
    Values.width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("对局回放"),
        backgroundColor: const Color.fromARGB(127, 255, 153, 0),
      ),
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
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
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
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange,
                      ),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(0, 50),
                      ),
                    ),
                    onPressed: () {
                      preStep();
                    },
                    child: const Text(
                      "上一步",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange,
                      ),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(0, 50),
                      ),
                    ),
                    onPressed: () {
                      playOrStop();
                    },
                    child: Text(
                      isPlay == false ? "播放" : "暂停",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange,
                      ),
                      minimumSize: const MaterialStatePropertyAll(
                        Size(0, 50),
                      ),
                    ),
                    onPressed: () {
                      nextStep();
                    },
                    child: const Text(
                      "下一步",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
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
                    "对局数：${firstUser.totalMatches}场",
                  ),
                  Text(
                    "胜率：${(firstUser.winPercentage * 100).toStringAsFixed(2)} %",
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
                    "对局数：${secondUser.totalMatches}场",
                  ),
                  Text(
                    "胜率：${(secondUser.winPercentage * 100).toStringAsFixed(2)} %",
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
                secondUser.username,
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

  void preStep() {
    if (poiter >= 0) {
      handleChess(widget.match.history[poiter], true);
      poiter--;
    } else {
      showSingleActionDialog("已经是第一步啦");
    }
    setState(() {});
  }

  void playOrStop() {
    if (isPlay == true) {
      isPlay = false;
    } else {
      isPlay = true;
    }
    setState(() {});
  }

  void nextStep() {
    poiter++;
    if (poiter < widget.match.history.length) {
      handleChess(widget.match.history[poiter], false);
    } else {
      showSingleActionDialog("已经是最后一步啦");
      isPlay = false;
      poiter--;
    }
    setState(() {});
  }

  void showSingleActionDialog(String content) {
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

  void handleChess(ChessBoard chess, bool pre) async {
    if (pre == false) {
      if (chess.userId == Values.user.id && chess.isWin == true) {
        Values.win = 1;
      } else if (chess.userId != Values.user.id && chess.isWin == true) {
        Values.win = 2;
      }
      Values.audioPlay.play("audio/chess.mp3");
      Values.chessList[chess.x * 15 + chess.y] = chess;
      Values.currentChess = chess;
    } else {
      Values.audioPlay.play("audio/chess.mp3");
      Values.chessList[chess.x * 15 + chess.y] = ChessBoard(
        0,
        0,
        -1,
        -1,
        false,
        false,
      );
      Values.currentChess = ChessBoard(
        0,
        0,
        -1,
        -1,
        false,
        false,
      );
    }
    setState(() {});
  }
}

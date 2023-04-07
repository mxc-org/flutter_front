import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/obj.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

class GridUnit extends StatefulWidget {
  const GridUnit({super.key, required this.x, required this.y});
  final int x;
  final int y;
  @override
  State<GridUnit> createState() => _GridUnitState();
}

class _GridUnitState extends State<GridUnit> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (mounted) {
          setState(() {});
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
    late Widget myWidget;
    Widget myContainer = GestureDetector(
      onTap: () {
        onTapGridUnit(widget.x, widget.y);
      },
      child: SizedBox(
        width: Values.width / 20,
        height: Values.width / 20,
      ),
    );
    //若是先手下子，则为黑子，反之为白子
    ChessBoard oneChess = Values.chessList[widget.x * 15 + widget.y];
    if (oneChess.exist && oneChess.userId == Values.currentRoom.userIdCreator) {
      myContainer = GestureDetector(
        onTap: () {
          onTapGridUnit(widget.x, widget.y);
        },
        child: Container(
          width: Values.width / 20,
          height: Values.width / 20,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/black.png"),
            ),
          ),
        ),
      );
    } else if (oneChess.exist &&
        oneChess.userId == Values.currentRoom.userIdJoin) {
      myContainer = GestureDetector(
        onTap: () {
          onTapGridUnit(widget.x, widget.y);
        },
        child: Container(
          width: Values.width / 30,
          height: Values.width / 30,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/white.png"),
            ),
          ),
        ),
      );
    }
    if (widget.x != 0 && widget.x != 14 && widget.y == 0) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const Expanded(
                child: Text(""),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      top: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 1,
                    height: Values.width,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          myContainer,
        ],
      );
    } else if (widget.x == 0 && widget.y != 0 && widget.y != 14) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(""),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      start: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: Values.width,
                    height: 1,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x != 0 && widget.x != 14 && widget.y == 14) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 1,
                    height: Values.width,
                    color: Colors.black,
                  ),
                ),
              ),
              const Expanded(
                child: Text(""),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x == 14 && widget.y != 0 && widget.y != 14) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      end: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: Values.width,
                    height: 1,
                    color: Colors.black,
                  ),
                ),
              ),
              const Expanded(
                child: Text(""),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x == 0 && widget.y == 0) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(""),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            top: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x == 14 && widget.y == 0) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            end: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            top: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(
                child: Text(""),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x == 0 && widget.y == 14) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(""),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else if (widget.x == 14 && widget.y == 14) {
      myWidget = Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: BorderDirectional(
                            end: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Text(""),
              ),
            ],
          ),
          myContainer
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1,
              minWidth: Values.width,
              maxHeight: 1,
              maxWidth: Values.width,
            ),
            child: Container(
              color: Colors.black,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Values.width,
              minWidth: 1,
              maxHeight: Values.width,
              maxWidth: 1,
            ),
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      );
    }

    return Container(
      child: myWidget,
    );
  }

  void onTapGridUnit(int x, int y) {
    if (Values.turn == false) {
      showSingleActionDialog("还没轮到你下棋噢");
    } else {
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text("提示"),
          content: const Text(
            "确定要在此下棋吗",
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
                putPiece(x, y);
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

  void putPiece(int x, int y) {
    int opponentId = 0;
    if (Values.user.id == Values.currentRoom.userIdCreator) {
      opponentId = Values.currentRoom.userIdJoin;
    } else {
      opponentId = Values.currentRoom.userIdCreator;
    }
    http.post(
      Uri.parse("${Values.server}/ChessBoard/PutPiece"),
      body: {
        "userId": Values.user.id.toString(),
        "opponentId": opponentId.toString(),
        "x": x.toString(),
        "y": y.toString(),
      },
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
}

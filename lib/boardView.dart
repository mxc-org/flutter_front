import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/obj.dart';
import 'package:flutter_front/values.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  List<Widget> gridList = [];
  late Timer timer;

  @override
  initState() {
    super.initState();
    initBoard();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (mounted) {
          initView();
          setState(() {});
        }
      },
    );
  }

  initBoard() {
    Values.chessList.clear();
    gridList.clear();
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        Values.chessList.add(
          ChessBoard(
            Values.user.id,
            Values.currentRoom.id,
            i,
            j,
            false,
            false,
          ),
        );
        gridList.add(gridUnit(Values.width / 15, i, j));
      }
    }
  }

  initView() {
    gridList.clear();
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        gridList.add(gridUnit(Values.width / 15, i, j));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            backgroundBlendMode: BlendMode.srcATop,
          ),
          child: GridView.count(crossAxisCount: 15, children: gridList),
        ),
        ElevatedButton(
          onPressed: () {
            initBoard();
            setState(() {});
          },
          child: const Text("刷新"),
        )
      ],
    );
  }

  Widget gridUnit(double width, int x, int y) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.1),
        backgroundBlendMode: BlendMode.srcATop,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 1,
              minWidth: width,
              maxHeight: 1,
              maxWidth: width,
            ),
            child: Container(
              color: Colors.black,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: width,
              minWidth: 1,
              maxHeight: width,
              maxWidth: 1,
            ),
            child: Container(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

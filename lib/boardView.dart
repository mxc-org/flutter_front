import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/gridUnit.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    initBoard();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          initView();
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          setState(() {});
        }
      },
    );
  }

  initBoard() {
    Values.chessList.clear();
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
      }
    }
    initView();
  }

  initView() {
    gridList.clear();
    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        gridList.add(GridUnit(x: j, y: i));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(223, 170, 122, 60),
        backgroundBlendMode: BlendMode.srcATop,
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 15,
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        children: gridList,
      ),
    );
  }
}

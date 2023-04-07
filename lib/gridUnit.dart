import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';

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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Widget myWidget;
    if (widget.x != 0 && widget.x != 14 && widget.y == 0) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 0 && widget.y != 0 && widget.y != 14) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x != 0 && widget.x != 14 && widget.y == 14) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 14 && widget.y != 0 && widget.y != 14) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 0 && widget.y == 0) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 14 && widget.y == 0) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 0 && widget.y == 14) {
      myWidget = Stack(
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
          //TODO 下子
        ],
      );
    } else if (widget.x == 14 && widget.y == 14) {
      myWidget = Stack(
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
          //TODO 下子
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
}

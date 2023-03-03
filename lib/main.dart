import 'package:flutter/material.dart';
import 'package:flutter_front/friendsUI.dart';
import 'package:flutter_front/gameUI.dart';
import 'package:flutter_front/myUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '网络五子棋',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '网络五子棋'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int uiType = 1;

  @override
  Widget build(BuildContext context) {
    Widget ui;
    if (uiType == 1) {
      ui = const GameUI();
    } else if (uiType == 2) {
      ui = const FriendsUI();
    } else {
      ui = const MyUI();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ui,
          ),
          Row(
            children: [
              Expanded(
                child: myTextButton(1, "游戏", Icon(Icons.games)),
              ),
              Expanded(
                child: myTextButton(2, "好友", Icon(Icons.people)),
              ),
              Expanded(
                child: myTextButton(3, "我的", Icon(Icons.person)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget myTextButton(int type, String text, Icon icon) {
    Color color;
    if (type == uiType) {
      color = Color.fromARGB(31, 104, 58, 183);
    } else {
      color = Colors.transparent;
    }
    return Container(
      color: color,
      child: TextButton(
          onPressed: () {
            uiType = type;
            setState(() {});
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                icon,
                Text(text),
              ],
            ),
          )),
    );
  }
}

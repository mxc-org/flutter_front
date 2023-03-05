import 'package:flutter/material.dart';
import 'package:flutter_front/friendsUI.dart';
import 'package:flutter_front/gameUI.dart';
import 'package:flutter_front/loginUI.dart';
import 'package:flutter_front/myUI.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '网络五子棋',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginUI(),
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
      ui = const FriendsUI();
    } else if (uiType == 2) {
      ui = const GameUI();
    } else {
      ui = const MyUI();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ui,
          ),
          Row(
            children: [
              Expanded(child: myTextButton(1, "好友", Icons.people)),
              Expanded(child: myTextButton(2, "对战", Icons.games)),
              Expanded(child: myTextButton(3, "我的", Icons.person))
            ],
          )
        ],
      ),
    );
  }

  Widget myTextButton(int type, String text, IconData icon) {
    Color color = Colors.black;
    if (uiType == type) {
      color = Colors.deepOrange;
    }
    return Container(
      child: TextButton(
        onPressed: () {
          uiType = type;
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Icon(icon, color: color),
              Text(text, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

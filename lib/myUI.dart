import 'package:flutter/material.dart';

class MyUI extends StatefulWidget {
  const MyUI({super.key});

  @override
  State<MyUI> createState() => _MyUIState();
}

class _MyUIState extends State<MyUI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("我的界面",),
    );
  }
}

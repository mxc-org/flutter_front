import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameUI extends StatefulWidget {
  const GameUI({super.key});

  @override
  State<GameUI> createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/game.jpg"),
            fit: BoxFit.cover,
            opacity: 0.75,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(0, 60)),
              ),
              child: const Text(
                "创建房间",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                minimumSize: const MaterialStatePropertyAll(Size(0, 60)),
              ),
              child: const Text(
                "匹配对手",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

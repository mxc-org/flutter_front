import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool login = false;
  @override
  Widget build(BuildContext context) {
    if (login == true) return const MyHomePage(title: "网络五子棋");
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 300),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "请输入用户名",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  hintText: "请输入用户名",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  login = true;
                  setState(() {});
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                child: const Text(
                  "登录",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text("新用户？点击注册"))
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/registerUI.dart';

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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/login.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 500),
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
                    hintText: "请输入密码",
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
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange)),
                  child: const Text(
                    "登录",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (buildContext) => const RegisterUI(),
                      ),
                    );
                  },
                  child: Text(
                    "新用户？点击注册",
                    style: TextStyle(
                        backgroundColor: Colors.white.withOpacity(0.8)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

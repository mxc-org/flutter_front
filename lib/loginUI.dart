import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/registerUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

import 'obj.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    if (Values.login == true) return const MyHomePage(title: "网络五子棋");
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
        child: Column(
          children: [
            const Expanded(
              flex: 5,
              child: Text(""),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric( horizontal: 20, vertical: 10),
                      hintText: "请输入用户名",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    onChanged: (value) {
                      username = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric( horizontal: 20, vertical: 10),
                      hintText: "请输入密码",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                    child: const Text(
                      "登录",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  // const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (buildContext) => const RegisterUI(),
                        ),
                      );
                    },
                    child: const Text("新用户？点击注册"),
                  )
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text(""),
            ),
          ],
        ),
      ),
    );
  }

  void onLoginPressed() {
    if (username == "" || password == "") {
      showSingleActionDialog("请输入用户名和密码");
      return;
    }
    Map<String, dynamic> postUser = {
      "username": username,
      "password": password
    };
    http
        .post(Uri.parse("${Values.server}/User/Login"), body: postUser)
        .then((value) {
      String response = utf8.decode(value.bodyBytes);
      if (response == "") {
        showSingleActionDialog("用户名或密码不正确");
        return;
      }
      Values.user = User.jsonToUser(response);
      Values.login = true;
      setState(() {});
    });
    setState(() {});
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

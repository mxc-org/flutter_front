import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/login_register/registerUI.dart';
import 'package:flutter_front/util/values.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/obj.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  String username = "";
  String password = "";
  bool isRemember = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readRemember();
  }

  Widget rpassword() {
    return Row(
      children: [
        Checkbox(
          value: isRemember,
          onChanged: (value) {
            isRemember = !isRemember;
            setState(() {});
          },
        ),
        TextButton(
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.all(0),
            ),
          ),
          onPressed: () {
            isRemember = !isRemember;
            setState(() {});
          },
          child: const Text("记住密码"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Values.login == true) return const MyHomePage(title: "棋艺");
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/login.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.6),
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
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

                  const SizedBox(height: 15),
                  Container(
                    width: 200,
                    height: 40,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: ElevatedButton(
                      onPressed: onLoginPressed,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                      child: const Text(
                        "登录",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      rpassword(),
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
                  // const SizedBox(height: 10),
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
      Values.myWebSocket.connect();
      Values.connectStatus = true;
      Values.login = true;
      writeDate();
      setState(() {});
    });
    setState(() {});
  }

  void writeDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
    prefs.setBool("isRemember", isRemember);
    if (isRemember) {
      prefs.setString("password", password);
    } else {
      prefs.setString("password", "");
    }
  }

  void readRemember() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isRemember = prefs.getBool("isRemember") == null
        ? false
        : prefs.getBool("isRemember")!;
    username =
        prefs.getString("username") == null ? "" : prefs.getString("username")!;
    password =
        prefs.getString("password") == null ? "" : prefs.getString("password")!;
    usernameController = TextEditingController(text: username);
    passwordController = TextEditingController(text: password);
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

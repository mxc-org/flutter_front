import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

import 'obj.dart';

class MyUI extends StatefulWidget {
  const MyUI({super.key});

  @override
  State<MyUI> createState() => _MyUIState();
}

class _MyUIState extends State<MyUI> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            //用户信息展示
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(127, 255, 153, 0),
              ),
              child: userInfoColum(),
            ),
            //其他一些选项，例如修改用户名
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: onModifyUsername,
                child: const Text(
                  "修改用户名",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: onModifyAvatar,
                child: const Text(
                  "修改头像",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(
                    Size(double.infinity, 50),
                  ),
                ),
                onPressed: onModifyPassword,
                child: const Text(
                  "修改密码",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
        Container(
          alignment: AlignmentDirectional.bottomCenter,
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
              minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
            ),
            onPressed: () {
              Values.login = false;
              setState(() {});
            },
            child: const Text(
              "退出登录",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget userInfoColum() {
    return Column(
      children: [
        //个人头像和昵称展示
        Row(
          children: [
            //头像
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              width: 80,
              height: 80,
              child: Image.network(Values.avatarUrl + Values.user.avatarName),
            ),
            //用户名
            Container(
              margin: const EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                Values.user.username,
                style: const TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //对局胜率信息展示
        Row(
          children: [
            matchInfo("胜局", Values.user.winMatches.toString()),
            matchInfo(
              "败局",
              (Values.user.totalMatches - Values.user.winMatches).toString(),
            ),
            matchInfo(
              "胜率",
              "${(Values.user.winPercentage * 100).toStringAsFixed(1)}%",
            ),
          ],
        )
      ],
    );
  }

  Widget matchInfo(String text1, String text2) {
    return Expanded(
      child: Column(
        children: [
          Text(text1, style: const TextStyle(fontSize: 20)),
          Text(text2, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  void onModifyUsername() {
    String newUsername = Values.user.username;
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text("修改用户名"),
        content: TextFormField(
          initialValue: newUsername,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            newUsername = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消", style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () async {
              bool ok = await modifyUsername(newUsername);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
              if (ok) {
                showSingleActionDialog("修改成功");
              } else {
                showSingleActionDialog("修改失败，换一个用户名试试");
              }
            },
            child: const Text("确定", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Future<bool> modifyUsername(String newUsername) async {
    Map<String, dynamic> bodyMap = {
      "userId": Values.user.id.toString(),
      "username": newUsername
    };
    if (newUsername == "") {
      return false;
    }
    var value = await http.post(
      Uri.parse("${Values.server}/User/ModifyUserName"),
      body: bodyMap,
    );
    if (value.body == "") {
      return false;
    } else {
      String res = utf8.decode(value.bodyBytes);
      Values.user = User.jsonToUser(res);
      setState(() {});
      return true;
    }
  }

  void onModifyAvatar() {}

  void onModifyPassword() {
    String newPassword = Values.user.password;
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text("修改密码"),
        content: TextFormField(
          obscureText: true,
          initialValue: newPassword,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            newPassword = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消", style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () async {
              onModifyPasswordConfirm(newPassword);
            },
            child: const Text("确定", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void onModifyPasswordConfirm(newPassword) async {
    bool ok = await modifyPassword(newPassword);
    Navigator.of(context).pop();
    if (ok) {
      showSingleActionDialog("修改成功");
    } else {
      showSingleActionDialog("修改失败");
    }
  }

  Future<bool> modifyPassword(String password) async {
    Map<String, dynamic> bodyMap = {
      "userId": Values.user.id.toString(),
      "username": password
    };
    if (password == "") {
      return false;
    }
    var value = await http.post(
      Uri.parse("${Values.server}/User/ModifyUserPassword"),
      body: bodyMap,
    );
    if (value.body == "") {
      return false;
    } else {
      String res = utf8.decode(value.bodyBytes);
      Values.user = User.jsonToUser(res);
      setState(() {});
      return true;
    }
  }

  void showSingleActionDialog(String content) {
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

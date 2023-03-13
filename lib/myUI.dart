import 'package:flutter/material.dart';
import 'package:flutter_front/main.dart';
import 'package:flutter_front/values.dart';

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
          margin: EdgeInsets.only(bottom: 20),
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
              child: Image(image: AssetImage("images/userpic.png")),
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
              "${((Values.user.winMatches / Values.user.totalMatches) * 100).toStringAsFixed(1)}%",
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
    String newUsername = "";
    showDialog(
      context: context,
      builder: (buildContext) => AlertDialog(
        title: const Text("修改用户名"),
        content: TextField(
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("确定", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void onModifyAvatar() {}

  void onModifyPassword() {}
}

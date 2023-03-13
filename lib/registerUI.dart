import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  String username = "";
  String password = "";
  String passwordAgain = "";
  String checkPassword = "";

  @override
  Widget build(BuildContext context) {
    if (passwordAgain != "" && (password != passwordAgain)) {
      checkPassword = "两次密码输入不一致";
    } else {
      checkPassword = "";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("返回登录"),
        backgroundColor: Colors.white,
      ),
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
            const Expanded(child: Text("")),
            Container(
              alignment: AlignmentDirectional.bottomCenter,
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "请再次输入密码",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    onChanged: (value) {
                      passwordAgain = value;
                      setState(() {});
                    },
                  ),
                  Text(
                    checkPassword,
                    style:
                        const TextStyle(fontSize: 16, color: Colors.deepOrange),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onRegisterPressed,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    child: const Text(
                      "注册",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onRegisterPressed() async {
    if (password != passwordAgain || password == "" || username == "") {
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text("提示"),
          content: const Text(
            "用户名密码为空，或两次密码输入不一致，请检查",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "确定",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      );
    }
    Map<String, dynamic> postBody = {
      "username": username,
      "password": password
    };
    http
        .post(Uri.parse("${Values.server}/User/Register"), body: postBody)
        .then((value) {
      //TODO 检查是否注册成功
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text("提示"),
          content: const Text(
            "注册成功，请返回登录",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "确定",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      );
    });
  }
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_front/my/historyUI.dart';
import 'package:flutter_front/util/values.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../util/obj.dart';

class MyUI extends StatefulWidget {
  const MyUI({super.key});

  @override
  State<MyUI> createState() => _MyUIState();
}

class _MyUIState extends State<MyUI> {
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: ElevatedButton(
            style: const ButtonStyle(
              minimumSize: MaterialStatePropertyAll(
                Size(double.infinity, 40),
              ),
            ),
            onPressed: onModifyUsername,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "修改用户名",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, 40),
                ),
              ),
              onPressed: onModifyAvatar,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.panorama),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "修改头像",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: ElevatedButton(
            style: const ButtonStyle(
              /*side: MaterialStatePropertyAll(
                BorderSide(width: 1, color: Colors.grey),
              ),*/
              minimumSize: MaterialStatePropertyAll(
                Size(double.infinity, 40),
              ),
            ),
            onPressed: onModifyPassword,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "修改密码",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, 40),
                ),
              ),
              onPressed: onHistoryPressed,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_alarm),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "历史记录",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ),
        const Expanded(child: Text("")),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
              minimumSize: const MaterialStatePropertyAll(Size(0, 50)),
            ),
            onPressed: () {
              onLoginOut();
            },
            child: const Text(
              "退出登录",
              style: TextStyle(color: Colors.white, fontSize: 16),
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
            Expanded(
              child: Container(),
            ),
            //头像
            GestureDetector(
              onTap: () {
                onModifyAvatar();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        NetworkImage(Values.avatarUrl + Values.user.avatarName),
                  ),
                ),
              ),
            ),
            //用户名
            GestureDetector(
              onTap: () {
                onModifyUsername();
              },
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsets.only(left: 20, top: 40),
                child: Text(
                  Values.user.username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //对局胜率信息展示

        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
        ),
      ],
    );
  }

  Widget matchInfo(String text1, String text2) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text1, style: const TextStyle(fontSize: 16)),
          Text(text2, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void getUserInfo() async {
    var response = await http.get(
      Uri.parse("${Values.server}/User/FindUserById?id=${Values.user.id}"),
    );
    String str = utf8.decode(response.bodyBytes);
    Values.user = User.jsonToUser(str);
    setState(() {});
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
              onModifyUsernameConfirm(newUsername);
            },
            child: const Text("确定", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void onModifyUsernameConfirm(String newUsername) async {
    bool ok = await modifyUsername(newUsername);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (ok) {
      showSingleActionDialog("修改成功");
    } else {
      showSingleActionDialog("修改失败，换一个用户名试试");
    }
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

  void onModifyAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result == null) {
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      // ignore: use_build_context_synchronously
      DialogRoute(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text("修改头像"),
          content: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(125),
              image: DecorationImage(
                image: MemoryImage(result.files.first.bytes!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "取消",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                onModifyAvatarConfirm(result.files.first.bytes!);
              },
              child: const Text(
                "确定",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onModifyAvatarConfirm(Uint8List fileBytes) async {
    Navigator.of(context).pop();
    bool check = await modifyAvatar(fileBytes);
    if (check == true) {
      showSingleActionDialog("修改头像成功");
    } else {
      showSingleActionDialog("修改头像失败");
    }
  }

  Future<bool> modifyAvatar(Uint8List fileBytes) async {
    var request = http.MultipartRequest(
      "post",
      Uri.parse("${Values.server}/User/UploadAvatar"),
    )
      ..fields["userId"] = Values.user.id.toString()
      ..files.add(
        http.MultipartFile.fromBytes(
          "avatar",
          fileBytes,
          filename: "${Values.user.username}.png",
        ),
      );
    var response = await request.send();
    var response2 = await http.Response.fromStream(response);
    if (response2.body == "") {
      return false;
    } else {
      String body = utf8.decode(response2.bodyBytes);
      Values.user = User.jsonToUser(body);
      setState(() {});
      return true;
    }
  }

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
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (ok) {
      showSingleActionDialog("修改成功");
    } else {
      showSingleActionDialog("修改失败");
    }
  }

  void onHistoryPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (buildContext) => const HistoryUI(),
      ),
    );
  }

  Future<bool> modifyPassword(String password) async {
    Map<String, dynamic> bodyMap = {
      "userId": Values.user.id.toString(),
      "password": password
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

  void onLoginOut() {
    Values.myWebSocket.close();
    Values.login = false;
    setState(() {});
  }
}

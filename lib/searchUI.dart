import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/values.dart';

import 'package:http/http.dart' as http;
import 'obj.dart';

class SearchUI extends StatefulWidget {
  const SearchUI({super.key});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  List<User> listUser = [];

  @override
  initState() {
    super.initState();
    onSearchPressed("");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加好友"),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          searchBar(),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: myListView(),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 50, maxWidth: width - 40),
        child: TextField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: "用户名",
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (value) {
            onSearchPressed(value);
          },
        ),
      ),
    );
  }

  Widget myListView() {
    return ListView.builder(
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: listUser.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(listUser[i].username),
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "${Values.avatarUrl}${listUser[i].avatarName}",
                ),
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              onAddPressed(listUser[i].id);
            },
            child: const Text(
              "添加",
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void onAddPressed(int id) async {
    if (id == Values.user.id) {
      showSingleActionDialog("不能自己添加自己噢");
      return;
    }
    http.post(
      Uri.parse("${Values.server}/Friend/MakeFriend"),
      body: {
        "userIdFrom": Values.user.id.toString(),
        "userIdTo": id.toString(),
      },
    );
    showSingleActionDialog("已发送好友请求");
  }

  void onSearchPressed(String username) async {
    var response = await http.get(
      Uri.parse("${Values.server}/User/FindUserByUsername?username=$username"),
    );
    if (response.body == "") {
      listUser.clear();
      setState(() {});
      return;
    }
    listUser.clear();
    List<dynamic> ls = json.decode(utf8.decode(response.bodyBytes));
    for (Map<String, dynamic> mp in ls) {
      listUser.add(User.mpToUser(mp));
    }

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

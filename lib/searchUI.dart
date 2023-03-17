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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加好友"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          searchBar(),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            shrinkWrap: true,
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
                  onPressed: () {},
                  child: const Text(
                    "添加",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    double width = MediaQuery.of(context).size.width;
    String usernameToSearch = "";
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 50, maxWidth: width - 40),
        child: TextField(
          decoration: const InputDecoration(
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
    listUser.add(User.jsonToUser(utf8.decode(response.bodyBytes)));
    setState(() {});
  }
}

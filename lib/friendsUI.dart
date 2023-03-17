import 'package:flutter/material.dart';
import 'package:flutter_front/searchUI.dart';
import 'package:flutter_front/values.dart';
import 'package:http/http.dart' as http;

class FriendsUI extends StatefulWidget {
  const FriendsUI({super.key});

  @override
  State<FriendsUI> createState() => _FriendsUIState();
}

class _FriendsUIState extends State<FriendsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("好友"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (buildContext) => SearchUI(),
                ),
              );
            },
            iconSize: 30,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              "新的朋友",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

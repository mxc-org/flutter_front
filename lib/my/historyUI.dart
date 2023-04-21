import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_front/my/replayUI.dart';
import 'package:flutter_front/util/values.dart';
import 'package:flutter_front/util/obj.dart';
import 'package:http/http.dart' as http;

class HistoryUI extends StatefulWidget {
  const HistoryUI({super.key});

  @override
  State<HistoryUI> createState() => _HistoryUIState();
}

class _HistoryUIState extends State<HistoryUI> {
  List<Match> matchList = [];

  @override
  initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("历史记录"),
        backgroundColor: const Color.fromARGB(127, 255, 153, 0),
      ),
      body: ListView.builder(
        itemCount: matchList.length,
        itemBuilder: (context, i) {
          List<String> dateArr = matchList[i].date.split(" ");
          Text winText = const Text("");
          User winner = matchList[i].winner;
          User loser = matchList[i].loser;
          late User firstUser;
          late User secondUser;
          // 此处需要判空，否则将报错
          if (matchList[i].history.isNotEmpty &&
              matchList[i].history[0].userId == winner.id) {
            //先手获胜
            firstUser = winner;
            secondUser = loser;
          } else {
            //后手获胜
            firstUser = loser;
            secondUser = winner;
          }
          if (matchList[i].winnerId == Values.user.id) {
            winText = const Text(
              "胜利",
              style: TextStyle(color: Colors.red),
            );
          } else {
            winText = const Text(
              "失败",
              style: TextStyle(color: Colors.black),
            );
          }
          return myListTile(
            dateArr,
            firstUser,
            secondUser,
            matchList[i],
            winText,
          );
        },
      ),
    );
  }

  Widget myListTile(List<String> dateArr, User firstUser, User secondUser,
      Match match, Widget winText) {
    return ListTile(
      leading: Text(
        "${dateArr[0]}\n${dateArr[1]}",
        textAlign: TextAlign.center,
      ),
      title: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "${Values.avatarUrl}${firstUser.avatarName}",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          winText,
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "${Values.avatarUrl}${secondUser.avatarName}",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      trailing: TextButton(
        child: const Text("回放"),
        onPressed: () {
          onReplayPressed(match);
        },
      ),
    );
  }

  void getHistory() async {
    matchList.clear();
    var response = await http.get(
      Uri.parse(
        "${Values.server}/Match/MatchList?userId=${Values.user.id}",
      ),
    );
    String str = utf8.decode(response.bodyBytes);
    List<dynamic> ls = json.decode(str);
    for (int i = 0; i < ls.length; i++) {
      matchList.add(Match.mpToMatch(ls[i]));
    }
    matchList = matchList.reversed.toList();
    setState(() {});
  }

  void onReplayPressed(Match match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReplayUI(match: match),
      ),
    );
  }
}

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
              Container(
                height: 30,
                width: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/q2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: winText,
              ));
        },
      ),
    );
  }

  Widget myListTile(List<String> dateArr, User firstUser, User secondUser,
      Match match, Widget winText) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 245, 229, 229), width: 1),
      ),
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
                  child: GestureDetector(
                    onTap: () {
                      showDetail(firstUser);
                    },
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
                  child: GestureDetector(
                    onTap: () {
                      showDetail(secondUser);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 80,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              //  begin: Alignment.topLeft,
              //end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 239, 192, 74),
                Colors.orange //开始颜色和结束颜色
              ]),
        ),
        child: TextButton(
          child: const Text("回放"),
          onPressed: () {
            onReplayPressed(match);
          },
        ),
      ),
    );
  }

  void showDetail(User user) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: Text(user.username),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "${Values.avatarUrl}${user.avatarName}",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("总局数：${user.totalMatches}"),
              Text("胜局数：${user.winMatches}"),
              Text("败局数：${user.totalMatches - user.winMatches}"),
              Text("胜率：${(user.winPercentage * 100).toStringAsFixed(2)}%"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onAddPressed(user.id);
              },
              child: const Text("加好友"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("确定"),
            )
          ],
        );
      },
    );
  }

  void onAddPressed(int id) async {
    Navigator.of(context).pop();
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

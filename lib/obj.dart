import 'dart:convert';

class User {
  int id;
  String username;
  String password;
  int totalMatches;
  int winMatches;
  late double winPercentage;
  String avatarName;

  User(this.id, this.username, this.password, this.totalMatches,
      this.winMatches, this.avatarName) {
    winPercentage = 0;
    if (totalMatches != 0) {
      winPercentage = winMatches / totalMatches;
    }
  }

  static User mpToUser(Map<String, dynamic> mp) {
    User user = User(
      mp["id"],
      mp["username"],
      mp["password"],
      mp["totalMatches"],
      mp["winMatches"],
      mp["avatarName"],
    );
    return user;
  }

  static User jsonToUser(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToUser(mp);
  }
}

class Friend {
  int id;
  int userIdFrom;
  int userIdTo;
  bool status;
  User userFrom;
  User userTo;
  Friend(
    this.id,
    this.userIdFrom,
    this.userIdTo,
    this.status,
    this.userFrom,
    this.userTo,
  );
  static Friend mpToFriend(Map<String, dynamic> mp) {
    Friend friend = Friend(
      mp["id"],
      mp["userIdFrom"],
      mp["userIdTo"],
      mp["status"],
      User.mpToUser(mp["userFrom"]),
      User.mpToUser(mp["userTo"]),
    );
    return friend;
  }

  static Friend jsonToFriend(String str) {
    Map<String, dynamic> mp = jsonDecode(str);
    return mpToFriend(mp);
  }
}

class Room {
  int id;
  String status;
  int userIdCreator;
  int userIdJoin;
  User userCreatetor;
  User userJoin;
  Room(this.id, this.status, this.userIdCreator, this.userIdJoin,
      this.userCreatetor, this.userJoin);
}

class Match {
  int id;
  int roomId;
  String info;
  Match(this.id, this.roomId, this.info);
}

class ChessBoard {
  int userId;
  int opponentId;
  int x;
  int y;
  int roomId;
  int count;
  bool isWin;
  ChessBoard(this.userId, this.opponentId, this.x, this.y, this.roomId,
      this.count, this.isWin);
}

class Chat {
  int fromId;
  int told;
  String content;
  DateTime time;
  Chat(this.fromId, this.told, this.content, this.time);
}

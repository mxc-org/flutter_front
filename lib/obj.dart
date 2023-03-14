class User {
  int id;
  String username;
  String password;
  int totalMatches = 33;
  int winMatches = 20;
  String avatarName = "default.png";
  User(this.id, this.username, this.password, this.totalMatches,
      this.winMatches, this.avatarName);
}

class Friend {
  int id;
  int userIdFrom;
  int userIdTo;
  bool status;
  User userFrom;
  User userTo;
  Friend(this.id, this.userIdFrom, this.userIdTo, this.status, this.userFrom,
      this.userTo);
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

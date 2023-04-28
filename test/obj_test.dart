// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_front/util/obj.dart';
import 'package:flutter_front/util/values.dart';
import 'package:http/http.dart' as http;

void main() {
  group('obj', () {
    test('User:', () {
      final user = User(0, "mdd", "", 0, 3, "");
      expect(user.id, 0);
      expect(user.username, "mdd");
      expect(user.password, "");
      expect(user.totalMatches, 0);
      expect(user.winMatches, 3);
      expect(user.avatarName, "");
    });
    test('Friend:', () {
      final user1 = User(0, "mdd", "", 0, 3, "");
      final user2 = User(1, "cnj", "", 0, 3, "");

      final friend = Friend(0, 0, 1, true, user1, user2);
      expect(friend.id, 0);
      expect(friend.userIdFrom, 0);
      expect(friend.userIdTo, 1);
      expect(friend.status, true);
      expect(friend.userFrom, user1);
      expect(friend.userTo, user2);
    });
    test('Room:', () {
      final user1 = User(0, "mdd", "", 0, 3, "");
      final user2 = User(1, "cnj", "", 0, 3, "");
      final room = Room(0, "WAITING", 0, 1, user1, user2);
      expect(room.id, 0);
      expect(room.status, "WAITING");
      expect(room.userIdCreator, 0);
      expect(room.userIdJoin, 1);
      expect(room.userCreator, user1);
      expect(room.userJoin, user2);
    });
    test('Match:', () {
      final user1 = User(0, "mdd", "", 0, 3, "");
      final user2 = User(1, "cnj", "", 0, 3, "");
      final match = Match(0, 0, 1, [], "", user1, user2);
      expect(match.id, 0);
      expect(match.winnerId, 0);
      expect(match.loserId, 1);
      expect(match.history, []);
      expect(match.date, "");
      expect(match.winner, user1);
      expect(match.loser, user2);
    });
    test('Invitation:', () {
      final user2 = User(1, "cnj", "", 0, 3, "");
      final invitation = Invitation(0, 0, 0, 1, true, true, user2);
      expect(invitation.id, 0);
      expect(invitation.roomId, 0);
      expect(invitation.inviterId, 0);
      expect(invitation.isValid, true);
      expect(invitation.isAccepted, true);
      expect(invitation.Inviter, user2);
    });
    test('ChessBoard:', () {
      final chessboard = ChessBoard(0, 0, 0, 0, true, true);
      expect(chessboard.userId, 0);
      expect(chessboard.roomId, 0);
      expect(chessboard.x, 0);
      expect(chessboard.y, 0);
      expect(chessboard.isWin, true);
      expect(chessboard.exist, true);
    });
    test('Chat:', () {
      DateTime dateTime = DateTime(2023);
      final chat = Chat("", 0, dateTime, 1);
      expect(chat.content, "");
      expect(chat.fromId, 0);
      expect(chat.time, dateTime);
      expect(chat.toId, 1);
    });
    test('MyWebSocket:', () {
      final mywebsocket = MyWebSocket();
      mywebsocket.connect();

      expect(Values.judgeconnect, true);
    });
  });
}

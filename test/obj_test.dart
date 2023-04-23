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
    });
  });
}

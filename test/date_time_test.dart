import 'package:flutter_test/flutter_test.dart';

void main() {
  test("datetime", () {
    var dateTime = DateTime.now();
    var s = dateTime.toString();
    print(s);
    print(DateTime.parse(s));
  });
}

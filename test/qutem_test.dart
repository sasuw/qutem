import 'package:test/test.dart';
import '../bin/qutem.dart' as qx;

void main() {
  test('main method runs through with exit code 0', () {
    var args = ['-v'];
    qx.main(args);
  });
}

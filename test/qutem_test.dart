import 'dart:io';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../bin/qutem.dart' as qx;
import '../lib/fileHandler.dart';
import '../lib/fileTemplateEngine.dart';

@GenerateMocks([FileHandler])
import 'qutem_test.mocks.dart';

void main() {
  group('FileHandler', () {
    test('getFileName returns the correct file name', () {
      expect(FileHandler.getFileName('/path/to/file.txt'), 'file.txt');
      expect(FileHandler.getFileName('another_file.js'), 'another_file.js');
    });

    test('writeChangedFile creates and writes file correctly', () {
      // Example test with real file on disk:
      final dir = Directory.systemTemp.createTempSync();
      final filePath = '${dir.path}/test_output.txt';

      FileHandler.writeChangedFile(filePath, 'Hello world');
      final file = File(filePath);
      expect(file.existsSync(), isTrue);
      expect(file.readAsStringSync(), 'Hello world');

      dir.deleteSync(recursive: true);
    });
  });

  group('FileTemplateEngine', () {
    test('doReplacePlaceHolder replaces placeholder with file content', () {
      // Write a temp file to disk
      final tempDir = Directory.systemTemp.createTempSync();
      final placeholderFile = File('${tempDir.path}/body.html')
        ..writeAsStringSync('Body content');

      // The real method calls File(placeholderName), so pass that path
      final result = FileTemplateEngine.doReplacePlaceHolder(
        placeholderFile.path,
        '{{!body.html}}', // the "matchStr"
      );

      expect(result, 'Body content');
      tempDir.deleteSync(recursive: true);
    });

    test('run applies placeholders to produce output file', () {
      // Minimal integration test
      final tempDir = Directory.systemTemp.createTempSync();
      final inputFile = File('${tempDir.path}/input.html')
        ..writeAsStringSync('<html>{{!body.html}}</html>');
      final bodyFile = File('${tempDir.path}/body.html')
        ..writeAsStringSync('Here is my body');
      final outputFile = File('${tempDir.path}/output.html');

      FileTemplateEngine.run(inputFile.path, outputFile.path);
      expect(outputFile.existsSync(), isTrue);
      expect(outputFile.readAsStringSync(), contains('Here is my body'));

      tempDir.deleteSync(recursive: true);
    });
  });

  group('qutem integration tests', () {
    test('runs qutem with missing file returns error code', () {
      final result = qx.run(['missing.html']);
      expect(result, 1);
    });
  });
}

import 'dart:io';
import 'package:logging/logging.dart';

import 'package:qutem/templateEngine.dart';
import 'package:qutem/fileHandler.dart';

class FileTemplateEngine {
  static final _logger = Logger('FileTemplateEngine');

  /// Replaces each placeholder marked with the
  /// given placeholderName with the text
  /// read from the placeholder file. If
  /// the file was not found, the given matchStr
  /// (placeholder plus surrounding characters)
  /// is returned, effectively making no modifications.
  static String doReplacePlaceHolder(placeholderName, matchStr) {
    var rFile = File(placeholderName);
    if (!rFile.existsSync()) {
      //file not found, we're not replacing anything
      return matchStr;
    }
    return rFile.readAsStringSync();
  }

  static void run(filePath) {
    try {
      _logger.fine('Input file: ' + filePath);

      var inputFile = File(filePath);
      var inputFileContent = inputFile.readAsStringSync();

      var htmlCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(<!--\s?{{!.*}}\s?-->)'), 7, 5);
      var jsCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(\/\/\s?{{!.*}})'), 5, 2);
      var regularPlaceHolder = PlaceHolder(RegExp(r'({{!.*}})'), 3, 2);

      inputFileContent = TemplateEngine.applyTemplate(
          inputFileContent, htmlCommentedOutPlaceHolder, doReplacePlaceHolder);
      inputFileContent = TemplateEngine.applyTemplate(
          inputFileContent, jsCommentedOutPlaceHolder, doReplacePlaceHolder);
      inputFileContent = TemplateEngine.applyTemplate(
          inputFileContent, regularPlaceHolder, doReplacePlaceHolder);

      FileHandler.writeChangedFile(filePath, inputFileContent);
    } on Exception catch (e) {
      stdout.writeln('Error.' + e.toString());
      exit(1);
    }
  }
}

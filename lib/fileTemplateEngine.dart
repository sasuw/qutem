import 'dart:io';
import 'package:logging/logging.dart';

import 'package:qutem/templateEngine.dart';
import 'package:qutem/fileHandler.dart';

class FileTemplateEngine {
  static final _logger = Logger('FileTemplateEngine');
  static int replacements = 0;

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
    FileTemplateEngine.replacements++;
    return rFile.readAsStringSync();
  }

  static void run(String inputFilePath, String outputFilePath) {
    try {
      _logger.fine('Input file: ' + inputFilePath);

      final inputFile = File(inputFilePath);
      final inputFileContent = inputFile.readAsStringSync();

      final htmlCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(<!--\s?{{!.*}}\s?-->)'), 7, 5);
      final jsCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(\/\/\s?{{!.*}})'), 5, 2);
      final regularPlaceHolder = PlaceHolder(RegExp(r'({{!.*}})'), 3, 2);

      String targetFileContent = TemplateEngine.applyTemplate(
          inputFileContent, htmlCommentedOutPlaceHolder, doReplacePlaceHolder);
      targetFileContent = TemplateEngine.applyTemplate(
          inputFileContent, htmlCommentedOutPlaceHolder, doReplacePlaceHolder);
      targetFileContent = TemplateEngine.applyTemplate(
          inputFileContent, jsCommentedOutPlaceHolder, doReplacePlaceHolder);
      targetFileContent = TemplateEngine.applyTemplate(
          inputFileContent, regularPlaceHolder, doReplacePlaceHolder);

      if (targetFileContent != inputFileContent) {
        FileHandler.writeChangedFile(outputFilePath, targetFileContent);
      }
    } on Exception catch (e) {
      stdout.writeln('Error.' + e.toString());
      exit(1);
    }
  }
}

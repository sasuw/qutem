import 'dart:io';
import 'package:logging/logging.dart';

import 'package:qutem/templateEngine.dart';
import 'package:qutem/fileHandler.dart';

class PlaceHolder {
  RegExp regExp;
  int charsToCutBefore;
  int charsToCutAfter;

  PlaceHolder(RegExp regExp, int charsToCutBefore, int charsToCutAfter) {
    this.regExp = regExp;
    this.charsToCutBefore = charsToCutBefore;
    this.charsToCutAfter = charsToCutAfter;
  }
}

class FileTemplateEngine {
  static final _logger = Logger('FileTemplateEngine');

  static void run(filePath) {
    try {
      _logger.fine('Input file: ' + filePath);

      var file = File(filePath);
      var fileContent = file.readAsStringSync();

      var htmlCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(<!--\s?{{!.*}}\s?-->)'), 7, 5);
      var jsCommentedOutPlaceHolder =
          PlaceHolder(RegExp(r'(\/\/\s?{{!.*}})'), 5, 2);
      var regularPlaceHolder = PlaceHolder(RegExp(r'({{!.*}})'), 3, 2);

      fileContent = FileTemplateEngine.applyTemplate(
          fileContent, htmlCommentedOutPlaceHolder);
      fileContent = FileTemplateEngine.applyTemplate(
          fileContent, jsCommentedOutPlaceHolder);
      fileContent =
          FileTemplateEngine.applyTemplate(fileContent, regularPlaceHolder);

      TemplateEngine.prepareDestinationDirectory();
      FileHandler.writeChangedFile(filePath, fileContent);
    } on Exception catch (e) {
      stdout.writeln('Error.' + e.toString());
      exit(1);
    }
  }

  static String applyTemplate(String fileContent, PlaceHolder placeHolder) {
    var re = placeHolder.regExp;

    Iterable matches = re.allMatches(fileContent);
    var newFileContent = fileContent;
    matches.forEach((match) {
      newFileContent = newFileContent.replaceAllMapped(re, (match) {
        var matchStr = newFileContent.substring(match.start, match.end);
        var rfp = matchStr.substring(placeHolder.charsToCutBefore,
            matchStr.length - placeHolder.charsToCutAfter);
        var rFile = File(rfp);
        if (!rFile.existsSync()) {
          return matchStr;
        }
        var rFileContent = rFile.readAsStringSync();
        return rFileContent;
      });
    });

    return newFileContent;
  }
}

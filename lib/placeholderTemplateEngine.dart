import 'dart:io';
import 'package:logging/logging.dart';

import 'package:qutem/templateEngine.dart';
import 'package:qutem/fileHandler.dart';

class PlaceholderTemplateEngine {
  static final _logger = Logger('PlaceholderTemplateEngine');

  static String doReplacePlaceHolder(placeholderName, matchStr) {
    //get corresponding template file

    //read key/value pairs from template to map

    //get value for key placeholderName

    //if found, return value, otherwise matchStr
  }

  static void run(filePath) {
    try {
      _logger.fine('Input file: ' + filePath);

      var file = File(filePath);
      var inputFileContent = file.readAsStringSync();

      var placeHolder = PlaceHolder(RegExp(r'({{.*}})'), 2, 2);

      inputFileContent = TemplateEngine.applyTemplate(
          inputFileContent, placeHolder, doReplacePlaceHolder);

      FileHandler.writeChangedFile(filePath, inputFileContent);
    } on Exception catch (e) {
      stdout.writeln('Error.' + e.toString());
      exit(1);
    }
  }
}

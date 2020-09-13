import 'dart:io';
import 'package:logging/logging.dart';
import 'package:qutem/fileHandler.dart';
import 'dart:convert';
import 'dart:core';

import 'package:qutem/templateEngine.dart';

class PlaceholderTemplateEngine {
  static final _logger = Logger('PlaceholderTemplateEngine');
  static int replacements = 0;
  static int filesCreated = 0;

  static final categoryPlaceholderMap = {};
  static var placeHolderMap = {}; //for currently processed category

  static List<String> getCategoryKeys() {
    var categoryKeys = <String>[];
    categoryPlaceholderMap.keys.forEach((categoryKey) {
      categoryKeys.add(categoryKey);
    });
    return categoryKeys;
  }

  static String doReplacePlaceHolder(placeholderName, matchStr) {
    if (placeHolderMap.containsKey(placeholderName)) {
      PlaceholderTemplateEngine.replacements++;
      return placeHolderMap[placeholderName];
    }

    return matchStr;
  }

  static void run(filePath) {
    try {
      _logger.fine('Input file: ' + filePath);

      var file = File(filePath);
      var inputFileContent = file.readAsStringSync();

      var placeHolder = PlaceHolder(RegExp(r'({{.*?}})'), 2, 2);

      categoryPlaceholderMap.forEach((languageKey, phMap) {
        placeHolderMap = phMap;
        var categoryFileContent = TemplateEngine.applyTemplate(
            inputFileContent, placeHolder, doReplacePlaceHolder);

        var relativeFilePath = FileHandler.getRelativeFilePath(filePath);
        var categoryFilePath = 'dist' +
            Platform.pathSeparator +
            languageKey +
            Platform.pathSeparator +
            relativeFilePath;
        File(categoryFilePath).createSync(recursive: true);
        filesCreated++;
        var categoryFile = File(categoryFilePath);
        categoryFile.writeAsStringSync(categoryFileContent);
      });
    } on Exception catch (e) {
      stdout.writeln('Error.' + e.toString());
      exit(1);
    }
  }

  //Prepares a map of categories to key/value maps
  static void prepareMappingsFromTemplateFile(filePath) {
    var templateFilePath = filePath + '.tmpl';
    var templateFile = File(templateFilePath);
    var templateFileContent = templateFile.readAsStringSync();

    var ls = LineSplitter();
    var lines = ls.convert(templateFileContent);
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line.isEmpty) {
        continue;
      }
      if (!line.contains('=')) {
        continue;
      }
      if (line.startsWith('#')) {
        continue;
      }

      //now we have a line containing something like this
      //title.en=Name of page
      var keyValueSeparator = '=';
      var parts = line.split(keyValueSeparator);
      var keyAndCategory = parts[0];
      parts.removeAt(0);
      var value =
          parts.join(keyValueSeparator); //in case the value contains a =

      var keyCategorySeparator = '.';
      var keyAndCategoryParts = keyAndCategory.split(keyCategorySeparator);
      var category = keyAndCategoryParts
          .removeLast(); //in case there are . chars in the key
      var key = keyAndCategoryParts.join(keyCategorySeparator);

      if (!categoryPlaceholderMap.containsKey(category)) {
        categoryPlaceholderMap[category] = {};
      }
      var placeHolderMap = categoryPlaceholderMap[category];
      placeHolderMap[key] = value;
    }

    //now we should have a categoryPlaceholderMap where each key is a category (language)
    //and each value a map of placeholders to placeholder values
  }
}

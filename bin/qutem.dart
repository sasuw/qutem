import 'dart:io';

var verboseLogging = false;

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

void main(List<String> args) async {
  var filePath;

  if (args.isEmpty) {
    stdout.writeln('Usage: qutem [INPUT FILE]');
    stdout.writeln(
        'Replaces template placeholders in given input file with contents of file given in placeholder and writes the new content to dist/ directory');
    exit(0);
  } else {
    filePath = args[0];
  }

  try {
    log('Input file: ' + filePath);

    var file = File(filePath);
    var fileContent = file.readAsStringSync();

    var htmlCommentedOutPlaceHolder =
        PlaceHolder(RegExp(r'(<!--\s?{{!.*}}\s?-->)'), 7, 5);
    var jsCommentedOutPlaceHolder =
        PlaceHolder(RegExp(r'(\/\/\s?{{!.*}})'), 5, 2);
    var regularPlaceHolder = PlaceHolder(RegExp(r'({{!.*}})'), 3, 2);

    fileContent = applyTemplate(fileContent, htmlCommentedOutPlaceHolder);
    fileContent = applyTemplate(fileContent, jsCommentedOutPlaceHolder);
    fileContent = applyTemplate(fileContent, regularPlaceHolder);

    prepareDestinationDirectory();
    writeChangedFile(filePath, fileContent);
  } on Exception catch (e) {
    stdout.writeln('Error.' + e.toString());
    exit(1);
  }
}

String applyTemplate(String fileContent, PlaceHolder placeHolder) {
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

void writeChangedFile(String filePath, String newFileContent) {
  var distFilePath = 'dist' + Platform.pathSeparator + filePath;
  File(distFilePath).createSync(recursive: true);
  var distFile = File(distFilePath);
  distFile.writeAsStringSync(newFileContent);
}

void prepareDestinationDirectory() {
  if (Directory('dist').existsSync()) {
    Directory('dist').deleteSync(recursive: true);
  }
}

void log(String msg) {
  if (verboseLogging) {
    stdout.writeln(msg);
  }
}

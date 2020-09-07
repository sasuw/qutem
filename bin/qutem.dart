import 'dart:io';

var verboseLogging = false;

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

    var re = RegExp(r'({{!.*}})');

    Iterable matches = re.allMatches(fileContent);
    var newFileContent = fileContent;
    matches.forEach((match) {
      newFileContent = newFileContent.replaceAllMapped(re, (match) {
        var matchStr = newFileContent.substring(match.start, match.end);
        var rfp = matchStr.substring(3, matchStr.length - 2);
        var rFile = File(rfp);
        if (!rFile.existsSync()) {
          return matchStr;
        }
        var rFileContent = rFile.readAsStringSync();
        return rFileContent;
      });
    });

    if (Directory('dist').existsSync()) {
      Directory('dist').deleteSync(recursive: true);
    }
    var distFilePath = 'dist' + Platform.pathSeparator + filePath;
    File(distFilePath).createSync(recursive: true);
    var distFile = File(distFilePath);
    distFile.writeAsStringSync(newFileContent);
  } on Exception catch (e) {
    stdout.writeln('Error.' + e.toString());
  }
}

void log(String msg) {
  if (verboseLogging) {
    stdout.writeln(msg);
  }
}

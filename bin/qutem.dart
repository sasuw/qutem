import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:qutem/fileTemplateEngine.dart';
import 'package:qutem/placeholderTemplateEngine.dart';
import 'package:yaml/yaml.dart';

import 'package:qutem/templateEngine.dart';

var verboseLogging = false;

const arg_version = 'version';

void main(List<String> args) {
  var filePath;

  /*
  args = [];
  filePath = '/home/sasu/Projects/qutem/test/data/test2.html';
  args.add(filePath);
  */

  if (args.isEmpty) {
    stdout.writeln('Usage: qutem [INPUT FILE]');
    stdout.writeln(
        'Replaces template placeholders in given input file with contents of file given in placeholder and writes the new content to dist/ directory');
    exit(0);
  } else {
    filePath = args[0];
  }

  final parser = ArgParser()..addFlag(arg_version, negatable: false, abbr: 'v');
  var argResults = parser.parse(args);
  if (argResults[arg_version]) {
    var version = getAppVersion();
    stdout.writeln('qutem ' + version + ' (quick template engine)');
    exit(0);
  }

  TemplateEngine.prepareDestinationDirectory();
  FileTemplateEngine.run(filePath);
  PlaceholderTemplateEngine.run(filePath);
}

String getAppVersion() {
  var ps = Platform.script;
  var psRunTimeType = ps.runtimeType.toString();
  if (psRunTimeType == '_DataUri') {
    //code execution when running pub test
    return '(version cannot be determined)';
  }
  var pathToYaml =
      join(dirname(Platform.script.toFilePath()), '../pubspec.yaml');
  var f = File(pathToYaml);
  var yamlText = f.readAsStringSync();
  var yaml = loadYaml(yamlText);

  var version = yaml['version'];
  return version;
}

void log(String msg) {
  if (verboseLogging) {
    stdout.writeln(msg);
  }
}

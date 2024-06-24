import 'dart:io';
import 'package:args/args.dart';
import 'package:qutem/fileHandler.dart';
import 'package:qutem/fileTemplateEngine.dart';
import 'package:qutem/placeholderTemplateEngine.dart';

var verboseLogging = false;

const arg_version = 'version';

void main(List<String> args) {
  var stopwatch = Stopwatch()..start();

  var filePath;

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

  //get category keys
  PlaceholderTemplateEngine.prepareMappingsFromTemplateFile(filePath);
  var categoryKeys = PlaceholderTemplateEngine.getCategoryKeys();

  doFileTemplate(filePath);
  //now we have a tmp/dest1 directory where file template engine has been applied

  if (categoryKeys.isNotEmpty) {
    //creates result documents in dist/category
    PlaceholderTemplateEngine.run(filePath);

    //copies unchanged documents (with applied file substitutions) from /tmp/dist1 directoryto dist directory
    categoryKeys.forEach((categoryKey) {
      var sourceDirPath = FileHandler.getTempDirPath('dist1');
      var targetDirPath = Directory.current.path +
          Platform.pathSeparator +
          'dist' +
          Platform.pathSeparator +
          categoryKey;
      FileHandler.copyDirectory(
          Directory(sourceDirPath), Directory(targetDirPath), false);
    });
  }

  var stopwatchElapsed = stopwatch.elapsedMilliseconds;
  print(
      'qutem finished in ${(stopwatchElapsed / 1000).toString()} s. Replaced ' +
          FileTemplateEngine.replacements.toString() +
          ' file placeholders and ' +
          PlaceholderTemplateEngine.replacements.toString() +
          ' placeholders, creating ' +
          PlaceholderTemplateEngine.filesCreated.toString() +
          ' files.');
}

//creates dist1 temp directory and applies file placeholder substitutions there
void doFileTemplate(String? filePath) {
  var dist1DirPath = FileHandler.getTempDirPath('dist1');
  FileHandler.deleteDirectory(dist1DirPath); //clean up old data
  Directory(dist1DirPath).createSync();
  FileHandler.copyDirectory(Directory.current, Directory(dist1DirPath), true);
  FileHandler.deleteDirectory(
      dist1DirPath + Platform.pathSeparator + 'dist'); //exclude dist directory

  var relativeFilePath = FileHandler.getRelativeFilePath(filePath);
  var tempFilePath = dist1DirPath + Platform.pathSeparator + relativeFilePath;
  FileTemplateEngine.run(tempFilePath);
}

String getAppVersion() {
  return '0.5.1';
}

void log(String msg) {
  if (verboseLogging) {
    stdout.writeln(msg);
  }
}

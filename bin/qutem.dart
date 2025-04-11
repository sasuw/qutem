import 'dart:io';
import 'package:args/args.dart';
import 'package:qutem/fileHandler.dart';
import 'package:qutem/fileTemplateEngine.dart';
import 'package:qutem/placeholderTemplateEngine.dart';
import 'package:yaml/yaml.dart';

const arg_version = 'version';

/// The function your tests can call.
/// Returns an integer exit code:
///   0 => success
///   non-zero => error
int run(List<String> args) {
  final stopwatch = Stopwatch()..start();

  if (args.isEmpty || args.length > 2) {
    stdout.writeln('Usage: qutem <input file> [output file]');
    stdout.writeln(
        'Replaces template placeholders in given input file with contents of file given in placeholder and writes the new content to the output file or dist directory.');
    // For "usage" we might consider returning 0 or 1. Up to you:
    return 0;
  }

  final parser = ArgParser()..addFlag(arg_version, negatable: false, abbr: 'v');
  final argResults = parser.parse(args);
  if (argResults[arg_version]) {
    final version = getAppVersion();
    stdout.writeln('qutem $version (quick template engine)');
    // Showing version is not really an error, so:
    return 0;
  }

  final inputFilePath = args[0];
  String? outputFilePath = (args.length == 2) ? args[1] : null;

  if (inputFilePath.isEmpty) {
    stdout.writeln('Input file not provided.');
    return 1; // error
  }

  // Validate outputFilePath if provided
  if (outputFilePath != null) {
    if (!outputFilePath.endsWith('.html') && !outputFilePath.endsWith('.js')) {
      stdout.writeln(
          'Output file must have .html or .js extension. Current $outputFilePath');
      return 1; // error
    }
  }

  // If the input file is missing, return 1. 
  // (Your old code just didn't test for file existence before continuing.)
  if (!File(inputFilePath).existsSync()) {
    stdout.writeln('Error: file "$inputFilePath" does not exist.');
    return 1;
  }

  try {
    if (outputFilePath != null) {
      doFileTemplate(inputFilePath, outputFilePath);
    } else {
      // get category keys
      PlaceholderTemplateEngine.prepareMappingsFromTemplateFile(inputFilePath);
      final categoryKeys = PlaceholderTemplateEngine.getCategoryKeys();

      final tempOutputFilePath = 'dist${Platform.pathSeparator}$inputFilePath';
      doFileTemplate(inputFilePath, tempOutputFilePath);
      // now we have file template applied to the file in the dist dir

      if (categoryKeys.isNotEmpty) {
        // creates result documents in dist/category
        PlaceholderTemplateEngine.run(inputFilePath);

        // copies unchanged documents (with applied file substitutions) 
        // from temp dir to dist/categoryKey/...
        for (final categoryKey in categoryKeys) {
          final sourceFilePath = tempOutputFilePath;
          final targetFilePath = Directory.current.path +
              Platform.pathSeparator +
              'dist' +
              Platform.pathSeparator +
              categoryKey +
              Platform.pathSeparator +
              FileHandler.getFileName(inputFilePath);

          // Create the target directory if it doesn't exist
          final targetDir = Directory(
              '${Directory.current.path}${Platform.pathSeparator}dist${Platform.pathSeparator}$categoryKey');
          if (!targetDir.existsSync()) {
            targetDir.createSync(recursive: true);
          }

          FileHandler.copyFile(File(sourceFilePath), File(targetFilePath));
        }
      } else {
        print('No categories found, no need to copy files.');
      }
    }
  } catch (e) {
    stdout.writeln('Error: $e');
    return 1; // return error
  }

  final stopwatchElapsed = stopwatch.elapsedMilliseconds;
  print(
    'qutem finished in ${(stopwatchElapsed / 1000).toString()} s. Replaced '
    '${FileTemplateEngine.replacements} file placeholders and '
    '${PlaceholderTemplateEngine.replacements} placeholders, creating '
    '${PlaceholderTemplateEngine.filesCreated}'
    '${outputFilePath == null ? ' files.' : ' file.'}'
  );

  return 0; // success
}

/// The main entry point that CLI calls. This calls [run()] 
/// and then calls [exit()] with the returned code.
void main(List<String> args) {
  final exitCode = run(args);
  if (exitCode != 0) {
    exit(exitCode);
  }
}

/// Helper to apply the FileTemplateEngine
/// to a file path => output file path.
void doFileTemplate(String filePath, String outputFilePath) {
  final inputFile = File(filePath);
  final outputFile = File(outputFilePath);

  FileTemplateEngine.run(inputFile.path, outputFile.path);
}

/// Example of reading pubspec.yaml. 
/// If you don't have one, or if it's in a different location, adjust accordingly.
String getAppVersion() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    return "0";
  }
  final doc = loadYaml(file.readAsStringSync()) as YamlMap?;
  if (doc == null) return "0";
  return doc['version']?.toString() ?? '0';
}

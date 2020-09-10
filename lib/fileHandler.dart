import 'dart:io';

class FileHandler {
  static void writeChangedFile(String filePath, String newFileContent) {
    var distFilePath = 'dist' + Platform.pathSeparator + filePath;
    File(distFilePath).createSync(recursive: true);
    var distFile = File(distFilePath);
    distFile.writeAsStringSync(newFileContent);
  }
}

import 'dart:io';
import 'package:path/path.dart' as path;

class FileHandler {
  static void writeChangedFile(String distFilePath, String newFileContent) {
    File(distFilePath).createSync(recursive: true);
    var distFile = File(distFilePath);
    distFile.writeAsStringSync(newFileContent);
  }

  static void copyDirectory(
          Directory source, Directory destination, bool overWriteFiles) =>
      source.listSync(recursive: false).forEach((var entity) {
        if (entity is Directory) {
          var newDirectory = Directory(
              path.join(destination.absolute.path, path.basename(entity.path)));
          newDirectory.createSync();

          copyDirectory(entity.absolute, newDirectory, overWriteFiles);
        } else if (entity is File) {
          var targetPath =
              path.join(destination.path, path.basename(entity.path));
          if (overWriteFiles || !File(targetPath).existsSync()) {
            entity.copySync(targetPath);
          }
        }
      });

  //when given a file path, the relative file path to current working
  //directory is returned.
  static String getRelativeFilePath(filePath) {
    var currentDirPath = Directory.current.path;
    return filePath
        .toString()
        .replaceFirst(currentDirPath + Platform.pathSeparator, '');
  }

  static String getTempDirPath(relativeTempDirPath) {
    return Directory.systemTemp.path +
        Platform.pathSeparator +
        relativeTempDirPath;
  }

  static void deleteDirectory(dirPath) {
    var dir = Directory(dirPath);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }
}

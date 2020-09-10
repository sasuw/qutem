import 'dart:io';

class TemplateEngine {
  static void prepareDestinationDirectory() {
    if (Directory('dist').existsSync()) {
      Directory('dist').deleteSync(recursive: true);
    }
  }
}

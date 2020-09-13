import 'dart:io';

class TemplateEngine {
  static String applyTemplate(String inputFileContent, PlaceHolder placeHolder,
      Function doReplacePlaceHolder) {
    var re = placeHolder.regExp;

    Iterable matches = re.allMatches(inputFileContent);
    var newFileContent = inputFileContent;
    matches.forEach((match) {
      newFileContent = newFileContent.replaceAllMapped(re, (match) {
        var matchStr = newFileContent.substring(match.start, match.end);
        var placeholderName = matchStr.substring(placeHolder.charsToCutBefore,
            matchStr.length - placeHolder.charsToCutAfter);

        return doReplacePlaceHolder(placeholderName, matchStr);
      });
    });

    return newFileContent;
  }
}

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

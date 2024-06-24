## 0.5.1, 2024

- Removed mandatory `.tmpl` ending from template files (what was I thinking back then?)


## 0.4.1, July 31st, 2023

- Null-safety support to ensure compatibility with Dart 3
- Dependency updates

## 0.4.0, September 13th, 2020

- The complete source directory (i.e. also including files not touched by qutem) is now copied to the dist directory, for easier subsequent deployment of web site
- Now dist directory existing contents are not deleted before running qutem
- Fixed bug causing substitutions for multiple placeholders in one line to fail

## 0.3.2, September 13th, 2020

- Added status output after successful run displaying elapsed time and number of replacements

## 0.3.1, September 12th, 2020

- Support for adding comments with # to template file
- Fixed bug causing file tags not to work

## 0.3.0, September 11th, 2020

- Support for internationalized template files

## 0.2.0, September 8th, 2020

- Placeholders now work as intended within HTML or JavaScript comments

## 0.1.0, September 7th, 2020

- Initial version, most basic use case working (replace placeholder with file contents in file)

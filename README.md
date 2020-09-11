<!-- ABOUT THE PROJECT -->
# About qutem

qutem (**qu**ick **tem**plate engine) is a simple template engine for creating static, internationalized websites. It runs as a single executable program on your Linux, Mac or Windows.

## Why?

I could not find a simple template engine running in a terminal allowing me to replace placeholders with file contents, so I decided to create my own. A while later I wanted to create internationalized pages from a template file as well, so I added that functionality.

# Getting started as user

## Downloads

You can download the latest release from here: [https://github.com/sasuw/qutem/releases](https://github.com/sasuw/qutem/releases)

## Installing

Unpack the tar.gz or zip file and execute the qutem from your terminal or command line window. For a more permanent installation, copy qutem e.g. to /usr/local/bin (Linux/MacOS) or to C:\Windows\system32 (Windows).

## Usage and functionality

There are two things qutem can do:  
 1. replace placeholders with file contents (i.e. inserting files into files)  
 2. create multiple files from one content file and one template file, e.g. for different languages

### 1. Inserting files into files

In the file, where you want content to be inserted, insert a snippet like this

    {{!file.txt}}

and the placeholder will be replaced with the content of the file. The file path is relative to the directory where qutem is executed. 

If the placeholder is within an HTML or JavaScript comment without other text content, the comment part is removed when the placeholder is substituted. This enables you to put placeholders in your files without creating errors when using the files before running qutem. See example below for a demonstration.

#### Example

Suppose you have a file index.html with the following content

    <!DOCTYPE html>
    <html lang="en">
    
    <head>
        <!-- Below is the title text placeholder, which qutem will replace -->
    	<title>{{!title.txt}}</title>
    </head>
    <body>
    	<!-- Below is the body template placeholder, which qutem will replace -->
        <!--{{!body.html}}-->
    </body>
    </html>

and the following two files with their respective contents

<u>title.txt:</u>

    Title of test page

<u>body.html:</u>

    <p>This is the body</p>

You want to insert the contents of these two files into index.html where the respective placeholders are.

You run

    qutem index.html

Now you have a new file dist/index.html with the following content

    !DOCTYPE html>
    <html lang="en">
    
    <head>
        <!-- Below is the title text placeholder, which qutem will replace -->
    	<title>Title of test page</title>        
    </head>
    <body>
    	<!-- Below is the body template placeholder, which qutem will replace -->
        <p>This is the body</p>
    </body>

### 2. Create multiple files from one content file and one template file

You have a content file containing a placeholder like this

    {{placeHolder}}

and a template file with placeholder values like this

    placeHolder.en=placeholder
    placeholder.de=Platzhalter
    placeholder.it=segnaposto

Running qutem results in three files in three directories "en", "de" and "it" containing the respective files with the string "{{placeHolder}}" replaced with "placeholder", "Platzhalter" and "segnaposto".

# Getting started as developer

## Prerequisites

Dart is installed. See [https://dart.dev/get-dart](https://dart.dev/get-dart)

## Project structure

Standard dart project structure created with [pub](https://dart.dev/tools/pub/cmd), see [https://dart.dev/tools/pub/package-layout](https://dart.dev/tools/pub/package-layout)

The main executable, qutem.dart is located in the bin directory. The internal libraries used by qutem are in the lib directory.

The tests are in the test directory and the test data is in the test/data directory.

## Running the code

When you are in the project root directory, you can execute

    dart bin/qutem.dart

to run the program. For debugging, you can use e.g. [Visual Studio Code](https://code.visualstudio.com/).


# Miscellaneous

<!-- CONTRIBUTING -->
## Contributing

You can contribute to this project in many ways:

  * submitting an issue (bug or enhancement proposal) 
  * testing
  * contributing code

If you want to contribute code, please open an issue or contact me beforehand to ensure that your work in line with the project goals.

When you decide to commit some code:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Built With

* [dart](https://dart.dev)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
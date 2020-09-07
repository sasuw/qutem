<!-- ABOUT THE PROJECT -->
## About qutem

qutem (**qu**ick **tem**plate engine) is a simple template engine to perform one functionality: replacing placeholders with file contents.

### Usage

Suppose you have index.html with the following content

    <html>
        <head>
        </head>
    //(...)

and a header.html file with the following content

    <title>This is the title from header.html</title>

You want to insert the  contents of the header.html file to index.html file.

You modify the index.html thusly:

    <html>
        <head>
            {{!header.html}}
        </head>
    //(...)

and run

    qutem index.html

Now you have a new file dist/index.html with the following content

    <html>
        <head>
            <title>This is the title from header.html</title>
        </head>
    //(...)

Please note that the contents of the dist directory is removed completely when running qutem, so that the dist directory contains only the new file.

### History

I could not find a simple template engine running in a terminalallowing me to replace placeholders with file contents, so I decided to create my own.

### Project structure

Standard dart project structure created with [pub](https://dart.dev/tools/pub/cmd), see [https://dart.dev/tools/pub/package-layout](https://dart.dev/tools/pub/package-layout)

### Built With

* [dart](https://dart.dev)

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

Dart is installed. See [https://dart.dev/get-dart](https://dart.dev/get-dart)

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


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
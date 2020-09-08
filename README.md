<!-- ABOUT THE PROJECT -->
## About qutem

qutem (**qu**ick **tem**plate engine) is a simple template engine to perform one functionality: replacing placeholders with file contents.

### Usage

In the file, where you want content to be inserted, insert a snippet like this

{{!file.txt}}

and the placeholder will be replaced with the content of the file. The file path is relative to the directory where qutem is executed. 

If the placeholder is within an HTML or JavaScript comment without other text content, the comment part is removed when the placeholder is substituted. This enables you to put placeholders in your files without creating errors when using the files before running qutem. See example below for a demonstration.

#### Usage example

Suppose you have a file index.html with the following content

    <!DOCTYPE html>
    <html lang="en">
    
    <head>
        <!-- Below is the title text placeholder, which qutem will replace -->
    	<title>{{!title.txt}}</title>
    	<script>
    		//Below is the header template placeholder, which qutem will replace
    		//{{!header.js}}
    	</script>
        
    </head>
    <body>
    	<!-- Below is the body template placeholder, which qutem will replace -->
        <!--{{!body.html}}-->
    </body>
    </html>

and the following three files with their respective contents

<u>title.txt:</u>

    Title of test page

<u>header.js:</u>

    console.log('hello qutem');

<u>body.html:</u>

    <p>This is the body</p>

You want to insert the contents of the three files into index.html where the respective placeholders are.

You run

    qutem index.html

Now you have a new file dist/index.html with the following content

    !DOCTYPE html>
    <html lang="en">
    
    <head>
    	<title>Title of test page</title>
    	<script>
    		//Below is the header template placeholder, which qutem will replace
    		console.log('hello qutem');
    	</script>
        
    </head>
    <body>
    	<!-- Below is the body template placeholder, which qutem will replace -->
        <p>This is the body</p>
    </body>

Please note that the contents of the dist directory is removed completely when running qutem, so that the dist directory contains only the new file.

### History

I could not find a simple template engine running in a terminal allowing me to replace placeholders with file contents, so I decided to create my own.

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
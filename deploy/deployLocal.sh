#!/bin/bash
dart pub get
dart compile exe bin/qutem.dart -o bin/qutem
sudo cp bin/qutem /usr/local/bin/
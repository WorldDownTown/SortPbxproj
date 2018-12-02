# SortPbxproj

![platforms](https://img.shields.io/badge/platforms-macOS-333333.svg)
[![License](https://img.shields.io/:license-mit-blue.svg)](https://doge.mit-license.org)
[![Language: Swift 4.2](https://img.shields.io/badge/swift-4.2-e05c43.svg?style=flat)](https://developer.apple.com/swift)

`SortPbxproj` is a command-line tool that sort "children" and "files" sections in Xcode project.pbxproj files. This script is inspired on by [sort-Xcode-project-file](https://github.com/WebKit/webkit/blob/master/Tools/Scripts/sort-Xcode-project-file).

|before|after|
|:---|:---|
|![file_inspector_before.png](screenshots/file_inspector_before.png)|![file_inspector_after.png](screenshots/file_inspector_after.png)|
|![compile_sources_before.png](screenshots/compile_sources_before.png)|![compile_sources_after.png](screenshots/compile_sources_after.png)|

## Installation

### Homebrew (Recommended)

```sh
$ brew install WorldDownTwon/tap/sort-pbxproj
```

or

```sh
$ brew tap WorldDgwnTown/taps
$ brew install sort-pbxproj
```

### From Source

Clone the master branch of the repository, then run `make install`.

```sh
$ git clone https://github.com/WorldDownTown/SortPbxproj.git
$ make install
```

## Usage

```sh
$ sort-pbxproj <path>

ex 1)
$ sort-pbxproj SampleApp.xcodeproj

ex 2)
$ sort-pbxproj SampleApp.xcodeproj/project.pbxproj
```

### Arguments

#### `path`

File path to `*.xcodeproj` or `project.pbxproj`.

### Options

You can see options by `sort-pbxproj --help`.

#### --no-warnings

- Default: false
- `sort-pbxproj` checks the filename, and an error occurs if it is not `project.pbxproj`. By adding `--no-warnings` flag, script ignores the filename.

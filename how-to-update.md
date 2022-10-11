# update Package

```
$ vim update Package.swift
```

# create .pbxproj

```
$ swift package generate-xcodeproj
```

# open Xcode & update code

```
$ open SortPbxproj.xcodeproj
```

# build

```
$ swift build
```

# execute binary

```sh
$ .build/debug/sort-pbxproj SortPbxproj.xcodeproj
```

# upgrade homebrew

```sh
$ ./release.sh <tag> <github-access-token>
```


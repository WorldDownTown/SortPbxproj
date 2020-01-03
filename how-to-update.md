```
# update Package
vim update Package.swift
# create .pbxproj
swift package generate-xcodeproj
# open Xcode & update code
open SortPbxproj.xcodeproj
# build
swift build
# execute binary
.build/debug/SortPbxproj SortPbxproj.xcodeproj
```

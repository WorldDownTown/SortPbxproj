// swift-tools-version:5.1.0

import PackageDescription

let package = Package(
    name: "SortPbxproj",
    products: [
        .executable(name: "sort-pbxproj", targets: ["SortPbxproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.9.2"),
    ],
    targets: [
        .target(name: "SortPbxproj", dependencies: ["SortPbxprojCore", "Commander"]),
        .target(name: "SortPbxprojCore"),
        .testTarget(name: "SortPbxprojTests", dependencies: ["SortPbxproj"]),
        .testTarget(name: "SortPbxprojCoreTests", dependencies: ["SortPbxprojCore"]),
    ]
)

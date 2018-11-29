// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SortPbxproj",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
    ],
    targets: [
        .target(name: "SortPbxproj", dependencies: ["SortPbxprojCore", "Commander"]),
        .target(name: "SortPbxprojCore"),
        .testTarget(name: "SortPbxprojTests", dependencies: ["SortPbxproj"]),
        .testTarget(name: "SortPbxprojCoreTests", dependencies: ["SortPbxprojCore"]),
    ]
)

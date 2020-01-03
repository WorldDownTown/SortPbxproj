//
//  ProjectFileWriter.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public class ProjectFileWriter {
    public enum Error: Swift.Error {
        case fileNotCreated, fileHandleNotCreated
    }

    private let fileManager: FileManager = .default
    private let path: String
    private var fileHandle: FileHandle!

    public init(path: String) {
        self.path = path
    }

    // FIXME: better tmporary filname
    private var tmpFilename: String { path + "-XXXXXXXX" }

    /// Create a temporary empty file
    public func createTmpFile() throws {
        guard fileManager.createFile(atPath: tmpFilename, contents: nil) else {
            throw Error.fileNotCreated
        }
        guard let handle = FileHandle(forWritingAtPath: tmpFilename) else {
            throw Error.fileHandleNotCreated
        }
        fileHandle = handle
    }

    public func write(string: String) {
        fileHandle.write("\(string)\n".data(using: .utf8)!)
    }

    public func overwritePbxproj() throws {
        defer {
            removeTmpFile()
        }
        try fileManager.removeItem(atPath: path)
        try fileManager.moveItem(atPath: tmpFilename, toPath: path)
    }

    private func removeTmpFile() {
        _ = try? fileManager.removeItem(atPath: tmpFilename)
    }
}

//
//  PathChecker.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public struct PathChecker {
    public enum Error: Swift.Error {
        case filePathDoesNotExist
    }
    enum PathType { case file, directory }

    static func type(of path: String) throws -> PathType {
        var isDirectory: ObjCBool = true
        let exists: Bool = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        switch (exists, isDirectory.boolValue) {
        case (true, true): return .directory
        case (true, false): return .file
        case (false, _): throw Error.filePathDoesNotExist
        }
    }
}

//
//  PathChecker.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public struct PathChecker {
    public enum Error: Swift.Error { case filePathDoesNotExist }
    enum PathType { case file, directory }

    static func type(of path: String) throws -> PathType {
        var isDirectory: ObjCBool = true
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return isDirectory.boolValue ? .directory : .file
        } else {
            throw Error.filePathDoesNotExist
        }
    }
}

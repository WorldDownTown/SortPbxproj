//
//  PathDecorator.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public struct PathDecorator {
    public enum Error: Swift.Error {
        case projectFileDoesNotExist
    }

    private let path: String
    private let strict: Bool
    public init(path: String, strict: Bool) {
        self.path = path
        self.strict = strict
    }

    public func decorate() throws -> String {
        let projectFileName: String = "project.pbxproj"
        switch try PathChecker.type(of: path) {
        case .file:
            if strict && !path.hasSuffix(projectFileName) {
                throw Error.projectFileDoesNotExist
            }
            return path
        case .directory:
            let appendedPath: String = path.appendingPathComponent(projectFileName)
            guard case .some(.file) = try? PathChecker.type(of: appendedPath) else {
                throw Error.projectFileDoesNotExist
            }
            return appendedPath
        }
    }
}

private extension String {
    func appendingPathComponent(_ path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}

//
//  FileReader.swift
//  Commander
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public struct FileReader {
    private let path: String
    private let manager: FileManager = .default

    public init(path: String) throws {
        self.path = path
    }

    public func sort() throws {
    }

    func copy(to pathToCopy: String? = nil) throws {
        let toPath: String = pathToCopy ?? path + ".bk"
        try manager.copyItem(atPath: path, toPath: toPath)
    }
}

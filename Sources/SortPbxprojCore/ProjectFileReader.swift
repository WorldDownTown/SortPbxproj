//
//  ProjectFileReader.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

public typealias CallbackToWrite = (String) -> Void

public class ProjectFileReader {
    private enum ReadLineState {
        case startFiles
        case sortingFiles
        case endFiles
        case startChildren
        case sortingChildren
        case endChildren
        case other
    }

    private let contents: String
    private let mainGroup: String?

    public init(path: String) throws {
        contents = try String(contentsOfFile: path, encoding: .utf8)
        mainGroup = ProjectFileReader.searchMainGroup(in: contents)
    }

    private static func searchMainGroup(in contents: String) -> String? {
        contents
            .components(separatedBy: "\n")
            .lazy
            .compactMap { $0.regexMatches(#"\s*mainGroup = ([0-9A-F]{24});$"#).last }
            .first
    }

    private func calculateState(for line: String, lastState: ReadLineState, lastTwoLines: [String]) -> ReadLineState {
        guard line.regexMatches(#"^(\s*)files = \(\s*$"#).isEmpty else {
            return .startFiles
        }

        if !line.regexMatches(#"^(\s*)children = \(\s*$"#).isEmpty {
            // ignore children in mainGroup
            guard let mainGroup = mainGroup, let lineBeforeTwo = lastTwoLines.first, !lineBeforeTwo.regexMatches(#"^\s+\#(mainGroup) = \{$"#).isEmpty else {
                return .startChildren
            }
        }

        switch lastState {
        case .startFiles, .sortingFiles:
            if line.regexMatches(#"^\s*\);\s*$"#).isEmpty {
                return .sortingFiles
            } else {
                return .endFiles
            }
        case .startChildren, .sortingChildren:
            if line.regexMatches(#"^\s*\);\s*$"#).isEmpty {
                return .sortingChildren
            } else {
                return .endChildren
            }
        default:
            return .other
        }
    }

    private func write(line: String, state: ReadLineState, linesToSort: [String], callback: CallbackToWrite) {
        switch state {
        case .endFiles:
            let lines:String = linesToSort
                .sorted(by: sortFiles)
                .joined(separator: "\n")
            if !lines.isEmpty {
                callback(lines)
            }
        case .endChildren:
            let lines:String = linesToSort
                .sorted(by: sortChildren)
                .joined(separator: "\n")
            if !lines.isEmpty {
                callback(lines)
            }
        default:
            break
        }

        switch state {
        case .startFiles, .endFiles, .startChildren, .endChildren, .other:
            callback(line)
        default:
            break
        }
    }

    /// Sort files lines by filename in ascending order
    ///
    /// ex) sorted lines
    /// ```
    /// files = (
    ///     CE169517209EEDF0000D56D9 /* AppDelegate.swift in Sources */,
    ///     CE169519209EEDF0000D56D9 /* ViewController.swift in Sources */,
    /// );
    /// ```
    ///
    /// - Parameters:
    ///     - line1: line1
    ///     - line2: line2
    /// - Returns:
    ///     - Sorted array of lines
    private func sortFiles(line1: String, line2: String) -> Bool {
        let pattern: String = #"^\s*[0-9A-F]{24} /\* (.+) in "#
        guard let filename1: String = line1.regexMatches(pattern).last,
            let filename2: String = line2.regexMatches(pattern).last else { return true }
        return filename1.lowercased() < filename2.lowercased()
    }

    /// Sort children lines by filename in ascending order
    ///
    /// ex) sorted lines
    /// ```
    /// children = (
    ///     CE169516209EEDF0000D56D9 /* AppDelegate.swift */,
    ///     CE16951D209EEDF1000D56D9 /* Assets.xcassets */,
    ///     CE169522209EEDF1000D56D9 /* Info.plist */,
    ///     CE16951F209EEDF1000D56D9 /* LaunchScreen.storyboard */,
    ///     CE16951A209EEDF0000D56D9 /* Main.storyboard */,
    ///     CE169518209EEDF0000D56D9 /* ViewController.swift */,
    /// );
    /// ```
    ///
    /// - Parameters:
    ///     - line1: line1
    ///     - line2: line2
    /// - Returns:
    ///     Sorted array of lines
    private func sortChildren(line1: String, line2: String) -> Bool {
        let patternForFilename: String = #"^\s*[0-9A-F]{24} /\* (.+) \*/,$"#
        guard let filename1: String = line1.regexMatches(patternForFilename).last,
            let filename2: String = line2.regexMatches(patternForFilename).last else { return true }

        let patternForExtension: String = #"\.([^\.]+)$"#
        let ext1: String? = filename1.regexMatches(patternForExtension).last
        let ext2: String? = filename2.regexMatches(patternForExtension).last
        if ext1 == nil && ext2 != nil || ext1 != nil && ext2 == nil {
            return ext1 == nil
        }

        return filename1.lowercased() < filename2.lowercased()
    }

    public func sortLines(callback: @escaping CallbackToWrite) {
        var lastState: ReadLineState = .other
        var lastTwoLines: [String] = []
        var linesToSort: [String] = []

        contents.enumerateLines { line, _ in
            let state: ReadLineState = self.calculateState(for: line, lastState: lastState, lastTwoLines: lastTwoLines)

            defer {
                lastTwoLines.append(line)
                lastTwoLines = lastTwoLines.suffix(2).map { $0 }
                lastState = state
            }

            switch state {
            case .sortingFiles, .sortingChildren:
                linesToSort.append(line)
            default: break
            }

            self.write(line: line, state: state, linesToSort: linesToSort, callback: callback)

            switch state {
            case .endFiles, .endChildren:
                linesToSort.removeAll()
            default: break
            }
        }
    }
}

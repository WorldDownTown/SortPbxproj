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
        var result: String?
        contents.enumerateLines { line, stop in
            if let match = line.regexMatches(#"\s*mainGroup = ([0-9A-F]{24});$"#).last {
                result = match
                stop = true
            }
        }
        return result
    }

    private func calculateState(for line: String, lastState: ReadLineState, lastTwoLines: [String]) -> ReadLineState {
        guard line.regexMatches(#"^(\s*)files = \(\s*$"#).isEmpty else {
            return .startFiles
        }

        if !line.regexMatches(#"^(\s*)children = \(\s*$"#).isEmpty {
            if let mainGroup,
               let lineBeforeTwo = lastTwoLines.first,
               !lineBeforeTwo.regexMatches(#"^\s+\#(mainGroup) = \{$"#).isEmpty {
                // continue
            } else {
                // ignore children in mainGroup
                return .startChildren
            }
        }

        switch lastState {
        case .startFiles, .sortingFiles:
            return line.regexMatches(#"^\s*\);\s*$"#).isEmpty ? .sortingFiles : .endFiles
        case .startChildren, .sortingChildren:
            return line.regexMatches(#"^\s*\);\s*$"#).isEmpty ? .sortingChildren : .endChildren
        case .endFiles, .endChildren, .other:
            return .other
        }
    }

    private func write(line: String, state: ReadLineState, linesToSort: [String], callback: CallbackToWrite) {
        switch state {
        case .startFiles, .startChildren, .other:
            callback(line)
        case .endFiles, .endChildren:
            let lines: String = linesToSort
                .sorted(by: state == .endFiles ? sortFiles : sortChildren)
                .joined(separator: "\n")
            if !lines.isEmpty {
                callback(lines)
            }
            callback(line)
        case .sortingFiles, .sortingChildren:
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
        let count1: Int = filename1.regexMatches(patternForExtension).count
        let count2: Int = filename2.regexMatches(patternForExtension).count
        if count1 == count2 {
            return filename1.lowercased() < filename2.lowercased()
        } else {
            return count1 == 0
        }
    }

    public func sortLines(callback: @escaping CallbackToWrite) {
        var lastState: ReadLineState = .other
        var lastTwoLines: [String] = []
        var linesToSort: [String] = []

        contents.enumerateLines { [weak self] line, _ in
            guard let self else { return }
            let state: ReadLineState = self.calculateState(for: line,
                                                           lastState: lastState,
                                                           lastTwoLines: lastTwoLines)

            defer {
                lastTwoLines.append(line)
                lastTwoLines = lastTwoLines.suffix(2).map { $0 }
                lastState = state
            }

            switch state {
            case .sortingFiles, .sortingChildren:
                linesToSort.append(line)
            case .startFiles, .endFiles, .startChildren, .endChildren, .other:
                break
            }

            self.write(line: line, state: state, linesToSort: linesToSort, callback: callback)

            switch state {
            case .endFiles, .endChildren:
                linesToSort.removeAll()
            case .startFiles, .sortingFiles, .startChildren, .sortingChildren, .other:
                break
            }
        }
    }
}

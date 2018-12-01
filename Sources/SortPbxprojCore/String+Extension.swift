//
//  String+Extension.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

extension String {
    private var nsString: NSString {
        return self as NSString
    }

    private func regexMatch(_ pattern: String) throws -> NSTextCheckingResult? {
        let regex: NSRegularExpression = try .init(pattern: pattern)
        return regex.firstMatch(in: self, range: NSMakeRange(0, nsString.length))
    }

    func regexMatches(_ pattern: String) -> [String] {
        guard case .some(.some(let result)) = try? regexMatch(pattern) else { return [] }
        return (0..<result.numberOfRanges)
            .map { result.range(at: $0) }
            .map { nsString.substring(with: $0) }
    }

    func appendingPathComponent(_ path: String) -> String {
        return nsString.appendingPathComponent(path)
    }
}

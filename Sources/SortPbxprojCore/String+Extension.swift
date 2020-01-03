//
//  String+Extension.swift
//  SortPbxprojCore
//
//  Created by Keisuke Shoji on 2018/12/01.
//

import Foundation

extension String {
    private var nsString: NSString { self as NSString }

    func regexMatches(_ pattern: String) -> [String] {
        guard let result: NSTextCheckingResult =
            try? NSRegularExpression(pattern: pattern)
                .firstMatch(in: self, range: NSMakeRange(0, nsString.length)) else { return [] }
        return (0..<result.numberOfRanges).lazy
            .map(result.range(at:))
            .map(nsString.substring(with:))
    }

    func appendingPathComponent(_ path: String) -> String {
        nsString.appendingPathComponent(path)
    }
}

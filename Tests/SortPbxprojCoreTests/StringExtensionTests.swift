//
//  StringExtensionTests.swift
//  SortPbxprojCoreTests
//
//  Created by Keisuke Shoji on 2018/12/02.
//

@testable import SortPbxprojCore
import XCTest

final class StringExtensionTests: XCTestCase {
    func testRegex() {
        XCTAssertEqual("2020/12/31".regexMatches(#"(\d{4})/(\d{2})/(\d{2})"#), ["2020/12/31", "2020", "12", "31"])
    }

    func testAppendingPathComponent() {
        XCTAssertEqual("/foo/bar".appendingPathComponent("baz"), "/foo/bar/baz")
        XCTAssertEqual("/foo/bar".appendingPathComponent("/baz"), "/foo/bar/baz")
        XCTAssertEqual("/foo/bar/".appendingPathComponent("baz"), "/foo/bar/baz")
        XCTAssertEqual("/foo/bar/".appendingPathComponent("/baz"), "/foo/bar/baz")
    }
}

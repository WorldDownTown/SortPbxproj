//
//  PathCheckerTests.swift
//  SortPbxprojCoreTests
//
//  Created by Keisuke Shoji on 2018/12/02.
//

@testable import SortPbxprojCore
import XCTest

final class PathCheckerTests: XCTestCase {
    func testSample() {
        XCTAssertThrowsError(try PathChecker.type(of: ""))
    }
}

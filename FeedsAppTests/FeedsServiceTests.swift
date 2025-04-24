//
//  FeedsServiceTests.swift
//  FeedsApp
//
//  Created by Arshwin on 23/04/25.
//

import XCTest
@testable import FeedsApp
import Combine

final class FeedsServiceTests: XCTestCase {

    func testFetchPosts_Success() async throws {
        let service = FeedsService()
        let posts = try? await service.fetchPosts()
        XCTAssertNotNil(posts, "fetchPosts should return posts on success")
        XCTAssertFalse(posts!.isEmpty, "Posts array should not be empty")
    }

    func testReadJSON_FileExists() {
        let service = FeedsService()
        let json = service.readJSON(from: "FeedsJSON")
        XCTAssertNotNil(json, "readJSON should return JSON if file exists")
    }

    func testReadJSON_FileDoesNotExist() {
        let service = FeedsService()
        let json = service.readJSON(from: "NonExistentFile")
        XCTAssertNil(json, "readJSON should return nil if file does not exist")
    }
}

//
//  FeedsViewModelTests.swift
//  FeedsApp
//
//  Created by Arshwin on 23/04/25.
//

import XCTest
import Combine
@testable import FeedsApp
final class FeedsViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    // Mock FeedsService
    private struct MockFeedsService: FeedsServiceProtocol {
        
        var result: Result<[FeedsResponse], Error>
        func fetchPosts() async throws -> [FeedsResponse] {
            switch result {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        }
    }

    @MainActor func testLoadPosts_Success() throws {
        // Given
        let expectedPosts = [
            FeedsResponse.init(JSONString: "{\"id\": \"DJDphyX\",\"account_id\": 190749447,\"title\": \"Chasing Morning Light\",\"seo_title\": \"\",\"description\": \"\",\"view_count\": 0,\"upvote_count\":0,\"downvote_count\":0,\"point_count\": 0,\"image_count\": 1,\"comment_count\": 0,\"favorite_count\": 0,\"virality\": 0,\"score\": 0,\"in_most_viral\": false,\"is_album\": true,\"is_mature\": false,\"cover_id\": \"0aNIBif\",\"created_at\": \"2025-04-21T21:54:04Z\",\"updated_at\": null,\"url\": \"https://imgur.com/a/DJDphyX\",\"privacy\": \"private\",\"vote\": null,\"favorite\": false,\"is_ad\": false,\"ad_type\": 0,\"ad_url\": \"\",\"include_album_ads\": false,\"shared_with_community\": false,\"is_pending\": false,\"platform\": \"api\",\"media\":[{\"id\": \"0aNIBif\",\"account_id\": 190749447,\"mime_type\": \"image/jpeg\",\"type\": \"image\",\"name\": \"\",\"basename\": \"\",\"url\": \"https://i.imgur.com/0aNIBif.jpeg\",\"ext\":\"jpeg\",\"width\": 735,\"height\": 976,\"size\": 193130,\"metadata\": {\"title\": \"\",\"description\": \"\",\"is_animated\": false,\"is_looping\": false,\"duration\": 0,\"has_sound\": false},\"created_at\": \"2025-04-21T21:54:04Z\",\"updated_at\": null}],\"display\": []}"),
            FeedsResponse.init(JSONString:"{\"id\":\"48YuIt0\",\"account_id\":190749447,\"title\":\"EchoesofSilence\",\"seo_title\":\"\",\"description\":\"\",\"view_count\":0,\"upvote_count\":0,\"downvote_count\":0,\"point_count\":0,\"image_count\":1,\"comment_count\":0,\"favorite_count\":0,\"virality\":0,\"score\":0,\"in_most_viral\":false,\"is_album\":true,\"is_mature\":false,\"cover_id\":\"q9F0Ufa\",\"created_at\":\"2025-04-21T21:53:28Z\",\"updated_at\":null,\"url\":\"https://imgur.com/a/48YuIt0\",\"privacy\":\"private\",\"vote\":null,\"favorite\":false,\"is_ad\":false,\"ad_type\":0,\"ad_url\":\"\",\"include_album_ads\":false,\"shared_with_community\":false,\"is_pending\":false,\"platform\":\"api\",\"media\":[{\"id\":\"q9F0Ufa\",\"account_id\":190749447,\"mime_type\":\"video/mp4\",\"type\":\"video\",\"name\":\"\",\"basename\":\"\",\"url\":\"https://i.imgur.com/q9F0Ufa.mp4\",\"ext\":\"mp4\",\"width\":428,\"height\":854,\"size\":10410947,\"metadata\":{\"title\":\"\",\"description\":\"\",\"is_animated\":true,\"is_looping\":true,\"duration\":35.035,\"has_sound\":true},\"created_at\":\"2025-04-21T21:53:28Z\",\"updated_at\":null}],\"display\":[]}")
        ].compactMap({$0})
        let mockService = MockFeedsService(result: .success(expectedPosts))
        let viewModel = FeedsViewModel(feedService: mockService)
        let expectation = XCTestExpectation(description: "Posts loaded successfully")

        // When
        Task {
            await viewModel.loadPosts()

            // Then
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
            XCTAssertNil(viewModel.errorMessage, "errorMessage should be nil on success")
            XCTAssertEqual(viewModel.posts.count, expectedPosts.count, "posts should match expected posts")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor func testLoadPosts_Failure() throws {
        // Given
        let mockError = URLError(.badServerResponse)
        let mockService = MockFeedsService(result: .failure(mockError))
        let viewModel = FeedsViewModel(feedService: mockService)
        let expectation = XCTestExpectation(description: "Posts failed to load")

        // When
        Task {
            await viewModel.loadPosts()

            // Then
            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loading")
            XCTAssertNotNil(viewModel.errorMessage, "errorMessage should not be nil on failure")
            XCTAssertTrue(viewModel.posts.isEmpty, "posts should be empty on failure")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    @MainActor func testLoadPosts_MultipleCalls() throws {
        // Given
        let expectedPosts = [
            FeedsResponse.init(JSONString: "{\"id\": \"DJDphyX\",\"account_id\": 190749447,\"title\": \"Chasing Morning Light\",\"seo_title\": \"\",\"description\": \"\",\"view_count\": 0,\"upvote_count\":0,\"downvote_count\":0,\"point_count\": 0,\"image_count\": 1,\"comment_count\": 0,\"favorite_count\": 0,\"virality\": 0,\"score\": 0,\"in_most_viral\": false,\"is_album\": true,\"is_mature\": false,\"cover_id\": \"0aNIBif\",\"created_at\": \"2025-04-21T21:54:04Z\",\"updated_at\": null,\"url\": \"https://imgur.com/a/DJDphyX\",\"privacy\": \"private\",\"vote\": null,\"favorite\": false,\"is_ad\": false,\"ad_type\": 0,\"ad_url\": \"\",\"include_album_ads\": false,\"shared_with_community\": false,\"is_pending\": false,\"platform\": \"api\",\"media\":[{\"id\": \"0aNIBif\",\"account_id\": 190749447,\"mime_type\": \"image/jpeg\",\"type\": \"image\",\"name\": \"\",\"basename\": \"\",\"url\": \"https://i.imgur.com/0aNIBif.jpeg\",\"ext\":\"jpeg\",\"width\": 735,\"height\": 976,\"size\": 193130,\"metadata\": {\"title\": \"\",\"description\": \"\",\"is_animated\": false,\"is_looping\": false,\"duration\": 0,\"has_sound\": false},\"created_at\": \"2025-04-21T21:54:04Z\",\"updated_at\": null}],\"display\": []}"),
            FeedsResponse.init(JSONString:"{\"id\":\"48YuIt0\",\"account_id\":190749447,\"title\":\"EchoesofSilence\",\"seo_title\":\"\",\"description\":\"\",\"view_count\":0,\"upvote_count\":0,\"downvote_count\":0,\"point_count\":0,\"image_count\":1,\"comment_count\":0,\"favorite_count\":0,\"virality\":0,\"score\":0,\"in_most_viral\":false,\"is_album\":true,\"is_mature\":false,\"cover_id\":\"q9F0Ufa\",\"created_at\":\"2025-04-21T21:53:28Z\",\"updated_at\":null,\"url\":\"https://imgur.com/a/48YuIt0\",\"privacy\":\"private\",\"vote\":null,\"favorite\":false,\"is_ad\":false,\"ad_type\":0,\"ad_url\":\"\",\"include_album_ads\":false,\"shared_with_community\":false,\"is_pending\":false,\"platform\":\"api\",\"media\":[{\"id\":\"q9F0Ufa\",\"account_id\":190749447,\"mime_type\":\"video/mp4\",\"type\":\"video\",\"name\":\"\",\"basename\":\"\",\"url\":\"https://i.imgur.com/q9F0Ufa.mp4\",\"ext\":\"mp4\",\"width\":428,\"height\":854,\"size\":10410947,\"metadata\":{\"title\":\"\",\"description\":\"\",\"is_animated\":true,\"is_looping\":true,\"duration\":35.035,\"has_sound\":true},\"created_at\":\"2025-04-21T21:53:28Z\",\"updated_at\":null}],\"display\":[]}")
        ].compactMap({$0})

        let mockService = MockFeedsService(result: .success(expectedPosts))
        let viewModel = FeedsViewModel(feedService: mockService)
        let expectation1 = XCTestExpectation(description: "First load")
        let expectation2 = XCTestExpectation(description: "Second load")

        // When
        Task {
            await viewModel.loadPosts()
            XCTAssertTrue(viewModel.isLoading, "isLoading should be true during first load")
            expectation1.fulfill()

            await viewModel.loadPosts()
            XCTAssertTrue(viewModel.isLoading, "isLoading should be true during second load")
            expectation2.fulfill()

            XCTAssertFalse(viewModel.isLoading, "isLoading should be false after loads")
            XCTAssertEqual(viewModel.posts.count, expectedPosts.count, "posts should be loaded")
        }

        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
}

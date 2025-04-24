//
//  FeedsViewModel.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//



// ViewModel responsible for managing and exposing feed data to the UI layer.
// Utilizes Combine to publish loading state, data, and errors.
// Communicates with the service layer via `FeedsServiceProtocol`.

import Foundation
import Combine

// ViewModel that handles the logic for fetching and exposing feed posts.
// Runs on the main actor to safely update UI-related state.
@MainActor
final class FeedsViewModel: ObservableObject {
    // The list of feed posts to be displayed in the UI.
    @Published var posts: [FeedsResponse] = []
    // Indicates whether the feed data is currently being loaded.
    @Published var isLoading = false
    // Holds an error message if fetching feed data fails.
    @Published var errorMessage: String?

    // Service responsible for providing feed data. Injected via protocol for testability.
    private let feedsService: FeedsServiceProtocol

    // Initializes the view model with a feeds service dependency.
    // - Parameter feedService: A service conforming to `FeedsServiceProtocol`.
    init(feedService: FeedsServiceProtocol = FeedsService()) {
        self.feedsService = feedService
    }

    // Asynchronously loads feed posts using the feeds service.
    // Updates loading state, captured posts, and error messages.
    func loadPosts() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await feedsService.fetchPosts()
            self.posts = result
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

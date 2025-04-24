//
//  FeedsCoordinator.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//

// Coordinator responsible for creating and managing the Feeds module.
// Handles dependency injection and view model initialization.

import SwiftUI

protocol FeedsCoordinatorType {}
// Coordinates the flow for the Feeds feature, setting up dependencies and returning the main view.
final class FeedsCoordinator: FeedsCoordinatorType {

    // Dependency to fetch feed data, injected for better testability and modularity.
    private let feedsService: FeedsServiceProtocol

    // Initializes the coordinator with a feeds service. Default implementation provided.
    // - Parameter feedsService: A service conforming to `FeedsServiceProtocol`.
    init(feedsService: FeedsServiceProtocol = FeedsService()) {
        self.feedsService = feedsService
    }

    // Starts the Feeds module by injecting dependencies and returning the root view.
    // - Returns: The `FeedsView` initialized with its view model.
    @MainActor
    func start() -> some View {
        let viewModel = FeedsViewModel(feedService: feedsService)
        return FeedsView(viewModel: viewModel)
    }
}

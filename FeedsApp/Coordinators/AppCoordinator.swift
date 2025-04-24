//
//  AppCoordinator.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//


import SwiftUI
import AVKit
// AppCoordinator is responsible for the overall coordination of the application.
// It manages the flow between different high-level features
final class AppCoordinator {

    //FeedsCoordinator  manages the navigation
    // and flow of the Feeds feature.
    private let feedsCoordinator: FeedsCoordinator

    // Initializes the `AppCoordinator` with a `FeedsCoordinator`.
    init(feedsCoordinator: FeedsCoordinatorType = FeedsCoordinator(feedsService: FeedsService())) {
        if let coordinator = feedsCoordinator as? FeedsCoordinator {
            self.feedsCoordinator = coordinator
        } else {
            self.feedsCoordinator = FeedsCoordinator(feedsService: FeedsService())
        }
    }
    
    //start() used to kickstart the app 
    @MainActor
    func start() -> some View {
        NavigationStack {
            feedsCoordinator.start()
        }
        .navigationViewStyle(.stack)
    }
}

//
//  FeedsApp.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//


import SwiftUI
import SwiftData

// The main application struct conforming to the `App` protocol.
// This struct defines the app's entry point and scene configuration.
@main
struct FeedsApp: App {

    // The main scene of the application.
    // It initializes and presents the `FeedsView` with its associated `FeedsViewModel`.
    var body: some Scene {
        // Injecting a new instance of `FeedsViewModel` into `FeedsView`.
        // This sets up the data and logic layer for the view.
        WindowGroup {
            FeedsView(viewModel: FeedsViewModel())
        }
    }
}

//
//  FeedsView.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//

import SwiftUI
import AVKit // Keep AVKit import if FeedsMediaPlayer uses it

// This view displays a vertically scrolling feed of media posts using a rotated TabView.
struct FeedsView: View {
    // ViewModel instance responsible for fetching and managing feed data
    @StateObject private var viewModel: FeedsViewModel
    // Tracks the currently visible feed index in the TabView for managing playback and state
    @State private var currentFeedIndex: Int?

    // Custom initializer that accepts an external ObservableObject and ensures it is a FeedsViewModel
    init(viewModel: any ObservableObject) {
        if let viewModel = viewModel as? FeedsViewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            // Fallback in case the cast fails – instantiate a default view model
            debugPrint("Failed to intialize FeedsView")
            let model = FeedsViewModel(feedService: FeedsService())
            _viewModel = StateObject(wrappedValue: model)
        }
    }

    var body: some View {
        // Use GeometryReader to get the screen size for rotating and fitting views correctly
        GeometryReader { geometry in
            // TabView is used with selection binding to track which page (feed) is currently visible
            TabView(selection: $currentFeedIndex) { // Use selection binding
                // Render feed items when data is available
                if !viewModel.posts.isEmpty {
                    ForEach(viewModel.posts.indices, id: \.self) { index in
                        // Display individual feed item using a custom media player view
                        // The player handles image or video playback depending on the content type
                        FeedsMediaPlayer(
                            feed: $viewModel.posts[index], // Pass the specific post data
                            index: index,                  // Pass this view's index
                            currentFeedIndex: $currentFeedIndex // Pass the binding to the active index
                        )
                        // Ensure full-screen usage for each feed item
                        .frame(width: geometry.size.width, height: geometry.size.height) // Use full height for vertical scroll illusion
                        // Rotate each content view to undo the outer TabView rotation
                        .rotationEffect(.degrees(-90)) // Rotate content view back
                        // Tag each item with its index to enable selection tracking
                        .tag(index as Int?) // Tag must match selection type (Int?)
                        .ignoresSafeArea()
                    }
                // Show loading indicator while data is being fetched
                } else if viewModel.isLoading {
                    ProgressView()
//                        .frame(width: geometry.size.width, height: geometry.size.height)
                // Show error or empty state message when no posts are available
                } else {
                    Text(viewModel.errorMessage ?? "No posts available.")
//                         .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            // Rotate the TabView for vertical paging and adjust its frame accordingly
            .frame(width: geometry.size.height, height: geometry.size.width) // Swap dimensions for rotation
            // Offset the rotated TabView back into the visible screen bounds
            .rotationEffect(.degrees(90), anchor: .topLeading) // Rotate TabView
            .offset(x: geometry.size.width) // Offset back into view after rotation
            // Extend content to full screen by ignoring safe area insets
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            .background(Color.black)
            // Set initial feed index when the view first appears
            .onAppear {
                // Set the initial feed index when the view appears,
                // only if posts are available.
                if !viewModel.posts.isEmpty && currentFeedIndex == nil {
                    currentFeedIndex = 0
                }
            }
            // No longer need onChange here to manually control players.
            // FeedsMediaPlayer will react internally based on currentFeedIndex.
        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea() // Apply ignoresSafeArea to GeometryReader if needed
        .background(Color.black) // Background for the whole area
        // Perform asynchronous task to load posts from the view model
        .task {
            if viewModel.posts.isEmpty { // Load only if not already loaded
                 await viewModel.loadPosts()
                 // After loading, if posts exist, set the initial index
                 if !viewModel.posts.isEmpty {
                     currentFeedIndex = 0
                 }
            }
        }
        // Display error message overlay if loading failed and no posts are available
        .overlay {
             if let errorMessage = viewModel.errorMessage, !viewModel.isLoading && viewModel.posts.isEmpty {
                 VStack {
                     Text("Error")
                         .font(.headline)
                     Text(errorMessage)
                         .font(.subheadline)
                 }
                 .padding()
                 .background(.ultraThinMaterial)
                 .cornerRadius(10)
             }
         }
        
    }
}

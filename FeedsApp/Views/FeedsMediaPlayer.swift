//
//  FeedsMediaPlayer.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//
import SwiftUI
import AVFoundation
import AVKit


struct FeedsMediaPlayer: View {
    // The feed content to display, including media and title.
    @Binding var feed: FeedsResponse
    var index: Int? = 0
    // The currently visible feed index used to manage video playback state.
    @Binding var currentFeedIndex: Int?
    // Manages video player lifecycle, including loading, playing, and pausing.
    @StateObject private var playerManager = VideoPlayerManager()
    
    
    var body: some View {
        // The main view container that adjusts layout based on available screen size.
        GeometryReader { geometry in
            ZStack {
                if let player = playerManager.player, self.feed.media?.first?.type == "video" {
                    // Display the video player when media type is "video"
                    VideoPlayer(player: player)
                        .aspectRatio(contentMode: .fill)
                        .disabled(true)
                        .frame(width: geometry.size.width)
                } else {
                    // Display an image using AsyncImage if media type is not "video"
                    AsyncImage(url: URL(string: self.feed.media?.first?.url ?? "")!) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        default:
                            ProgressView()
                        }
                    }
                    .ignoresSafeArea()
                }
                
                // Overlay feed title at the bottom of the screen
                VStack {
                    Spacer()
                    Text("\(feed.title ?? "")")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.45))
                }
            }
            .frame(width: geometry.size.width)
            // Load and play video when the view appears and the media is a video
            .onAppear {
                print("FeedsMediaPlayer \(index ?? 0) appeared")
                if let videoURL = feed.media?.first?.url, feed.media?.first?.type == "video" {
                    playerManager.loadVideo(from: URL(string: videoURL)!)
                }
                updatePlaybackState()
            }
            // Pause the video player when the view disappears
            .onDisappear {
                print("FeedsMediaPlayer \(index ?? 0) disappeared")
                playerManager.pause()
            }
            // Observe current feed index changes to manage video playback state
            .onChange(of: currentFeedIndex) { newIndex,arguments  in
                print("FeedsMediaPlayer \(index ?? 0) observed current index change to: \(String(describing: newIndex))")
                updatePlaybackState()
            }
        }
    }
    
    // Plays or pauses video based on whether the current feed index matches this feed's index
    private func updatePlaybackState() {
        if index == currentFeedIndex {
            if feed.media?.first?.type == "video" {
                playerManager.play()
            }
        } else {
            playerManager.pause()
        }
    }
}

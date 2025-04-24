//
//  VideoPlayerManager.swift
//  FeedsApp
//
//  Created by Arshwin on 23/04/25.
//


import SwiftUI
import AVKit
import Combine


// - Publishes playback state and supports external control via Combine.
final class VideoPlayerManager: ObservableObject {
    // The AVPlayer instance used for standard video playback.
    var player: AVPlayer?
    // An AVQueuePlayer used for looping video playback.
    private var queuePlayer: AVQueuePlayer? // Separate queue player
    // The AVPlayerItem currently loaded for playback.
    private var playerItem: AVPlayerItem?
    // Publishes the current playback state (playing or paused).
    @Published var isPlaying: Bool = false
    // Indicates whether the video should loop continuously.
    @Published var isLooping: Bool = false
    
    // Used to enable seamless looping when using AVQueuePlayer.
    private var looper: AVPlayerLooper?
    // A Combine subject that emits the current AVPlayer instance for observers.
    let playerSubject = CurrentValueSubject<AVPlayer?, Never>(nil)
    // Stores Combine subscriptions to manage their lifecycle.
    private var cancellables = Set<AnyCancellable>()
    
    // Initializes the video player manager and sets up KVO observers.
    init() {
        setupObservers()
    }
    
    // Cleans up resources and removes observers when the manager is deallocated.
    deinit {
        removeObservers()
    }
    
    //Loads a video from the specified URL and prepares the player.
    //- Parameters:
    //  - url: The URL of the video to play.
    //  - loop: Whether the video should loop continuously.
    func loadVideo(from url: URL, loop: Bool = false) {
        isLooping = loop
        playerItem = AVPlayerItem(url: url)
        
        if loop {
            queuePlayer = AVQueuePlayer(items: [playerItem!])
            player = queuePlayer
            setupLooping()
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        playerSubject.send(player)
    }
    
    // Starts or resumes video playback.
    func play() {
        player?.play()
        isPlaying = true
    }
    
    // Pauses the currently playing video.
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    // Toggles between playing and pausing the video.
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    // Seeks the video to a specific time.
    // - Parameter time: The time to seek to.
    func seek(to time: CMTime) {
        player?.seek(to: time)
    }
    
    // Sets up the AVPlayerLooper to loop the video continuously.
    private func setupLooping() {
        guard let qPlayer = queuePlayer, let pItem = playerItem else { return }
        looper = AVPlayerLooper(player: qPlayer, templateItem: pItem)
    }
    
    // Observes the player's timeControlStatus to update playback state.
    private func setupObservers() {
        player?.publisher(for: \.timeControlStatus)
            .removeDuplicates()
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // Cancels and removes all Combine subscriptions.
    private func removeObservers() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

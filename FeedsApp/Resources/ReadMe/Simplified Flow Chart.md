


## FeedsApp Flowchart
============================


[FeedsApp] --(Initializes)--> [AppCoordinator]

                    ↓

[AppCoordinator] --(Initializes)--> [FeedsCoordinator]

                    ↓

[AppCoordinator] --(Starts)--> [NavigationStack]

                    ↓
                        
[FeedsCoordinator] --(Starts)--> [FeedsViewModel] --(Creates)--> [FeedsView]              
                        

                    ↓

[FeedsView] --(Loads Data)--> [FeedsViewModel.loadPosts()]

                    ↓

[FeedsViewModel.loadPosts()] --(Calls)--> [FeedsService.fetchPosts()]

                    ↓
                       
[FeedsCoordinator] --(Reads JSON)--> "FeedsJSON.json" --(Parses)--> [FeedsResponse]                              
                    
                    ↓
                    
[FeedsService.fetchPosts()] --(Returns Data)--> [FeedsViewModel.loadPosts()]
                    
                    ↓
                    
[FeedsViewModel.loadPosts()] --(Updates)--> [FeedsViewModel.posts], [FeedsViewModel.isLoading], [FeedsViewModel.errorMessage]
                    
                    ↓
                    
[FeedsViewModel] --(@Published updates)--> [FeedsView]
                    
                    ↓
                    
[FeedsView] --(Displays)--> [FeedsMediaPlayer] (for each feed)
                    
                    ↓
                    
[FeedsMediaPlayer] --(Manages Playback)--> [VideoPlayerManager]




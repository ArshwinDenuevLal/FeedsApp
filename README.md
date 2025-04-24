--------------------------------------------------------------------------------------------------------------------------------
##**FeedsApp - Scrollable Video/Image Feeds similar to Instagram Reels window**
--------------------------------------------------------------------------------------------------------------------------------

##**To know more have a look into. Suggestions and advices are always welcome**

https://docs.google.com/document/d/1XmVp2O9JVo-AITUXZERGqz6CsotqyoadI70f_mUyeYQ/edit?tab=t.0

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

<p>
<img src="https://github.com/ArshwinDenuevLal/FeedsApp/blob/main/FeedsApp%20Screen%20Recording.gif"></p>


[FeedsApp] --(Initializes)--> [AppCoordinator]
                        
                        ⬇
[AppCoordinator] --(Initializes)--> [FeedsCoordinator]

                        ⬇
[AppCoordinator] --(Starts)--> [NavigationStack]

                        ⬇
[FeedsCoordinator] --(Starts)--> [FeedsViewModel] --(Creates)--> [FeedsView]
              
                        ⬇
[FeedsView] --(Loads Data)--> [FeedsViewModel.loadPosts()]

                        ⬇
[FeedsViewModel.loadPosts()] --(Calls)--> [FeedsService.fetchPosts()]

                        ⬇
[FeedsCoordinator] --(Reads JSON)--> "FeedsJSON.json" --(Parses)--> [FeedsResponse]                              

                        ⬇
[FeedsService.fetchPosts()] --(Returns Data)--> [FeedsViewModel.loadPosts()]

                        ⬇
[FeedsViewModel.loadPosts()] --(Updates)--> [FeedsViewModel.posts], [FeedsViewModel.isLoading], [FeedsViewModel.errorMessage]

                        ⬇
[FeedsViewModel] --(@Published updates)--> [FeedsView]

                        ⬇
[FeedsView] --(Displays)--> [FeedsMediaPlayer] (for each feed)

                        ⬇
[FeedsMediaPlayer] --(Manages Playback)--> [VideoPlayerManager]


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------







--------------------------------

##**File-by-File Explanation**

--------------------------------

##**FeedsApp.swift:**

* This is the entry point of the application.
* It defines the `FeedsApp` struct, which conforms to the `App` protocol.
* The `body` of the `App` creates a `WindowGroup` and initializes the `FeedsView`, injecting a `FeedsViewModel`. This is where the SwiftUI part of the app starts.

##**AppCoordinator.swift:**

* This file defines the `AppCoordinator`, which is responsible for the overall app's navigation and flow.
* It initializes the `FeedsCoordinator`, which manages the flow for the feeds feature.
* The `start()` function creates a `NavigationStack` and starts the `FeedsCoordinator`. In a more complex app, the `AppCoordinator` might handle transitions between different features (e.g., login, settings).

##**FeedsCoordinator.swift:**

* The `FeedsCoordinator` is responsible for setting up and starting the feeds feature.
* It takes a `FeedsServiceProtocol` as a dependency, allowing for dependency injection (for testing or different data sources).
* The `start()` function creates the `FeedsViewModel`, injecting the `FeedsService`, and then creates the `FeedsView`, passing in the `ViewModel`. This connects the ViewModel to the View.

##**FeedsService.swift:**

* This file defines the `FeedsService` and the `FeedsServiceProtocol`.
* The `FeedsServiceProtocol` declares the `fetchPosts()` function, which is responsible for fetching feed data.
* The `FeedsService` class implements `FeedsServiceProtocol` and provides the actual implementation of `fetchPosts()`. It reads data from a local JSON file ("FeedsJSON.json") and uses `ObjectMapper` to parse it into `FeedsResponse` objects.
* It also includes a `FeedServiceError` enum to handle specific errors during data fetching.
* The `readJSON(from:)` function handles reading the JSON data from the file.

##**FeedsViewModel.swift:**

* The `FeedsViewModel` is the heart of the MVVM pattern, managing the data for the `FeedsView`.
* It has `@Published` properties (`posts`, `isLoading`, `errorMessage`) to hold the state of the data, loading status, and any error messages. `@Published` makes these properties observable, so the View can react to changes.
* It takes a `FeedsServiceProtocol` as a dependency to fetch the data.
* The `loadPosts()` function is responsible for:
    * Setting `isLoading` to `true` to indicate that data loading has started.
    * Calling `feedsService.fetchPosts()` to retrieve the data.
    * Storing the fetched data in the `posts` array.
    * Handling errors and setting the `errorMessage` if necessary.
    * Setting `isLoading` to `false` when data loading is complete.

##**FeedsView.swift:**

* The `FeedsView` is the SwiftUI view that displays the feed data.
* It uses `@StateObject` to create and hold an instance of the `FeedsViewModel`. `@StateObject` ensures the `ViewModel` persists across view updates.
* It uses a `TabView` to display the feeds, allowing the user to swipe through them.
* It displays either the list of posts (using `FeedsMediaPlayer` for each post), a loading indicator (`ProgressView`), or an error message, based on the state in the `ViewModel`.
* It uses `GeometryReader` to handle dynamic sizing.
* The `onAppear` and `task` modifiers are used to trigger the data loading (`viewModel.loadPosts()`) and set the initial feed index.

##**FeedsMediaPlayer.swift:**

* The `FeedsMediaPlayer` is a reusable SwiftUI view responsible for displaying individual feed items (either video or image) and managing video playback.
* It takes a `Binding<FeedsResponse>` to observe and react to changes in the feed data, the index of the current feed, and a binding to the `currentFeedIndex` from the parent `FeedsView`.
* It uses `VideoPlayer` to display videos and `AsyncImage` to display images.
* It uses a `VideoPlayerManager` to encapsulate and manage the `AVPlayer` logic
* It controls video playback (play/pause) based on whether the feed's index matches the `currentFeedIndex` from the `FeedsView`.

##**Data Models (FeedsResponse.swift, Media.swift, Metadata.swift):**

* These files define the data structures used to represent the feed data.
* They use `ObjectMapper` to facilitate mapping JSON data to Swift objects.
* `FeedsResponse` represents a single feed item and contains properties like `id`, `title`, `description`, and an array of `Media`.
* `Media` represents a media file (image or video) associated with a feed.


----------------------------------------------------------------------------------
#**MVVM Implementation**
----------------------------------------------------------------------------------
* **Model:** The `FeedsResponse`, `Media`, and `Metadata` structs represent the data model. The `FeedsService` is responsible for retrieving this data.
* **View:** `FeedsView` and `FeedsMediaPlayer` are the views. They display the data and handle user interaction.  `FeedsMediaPlayer` also contains the `VideoPlayerManager` to manage the player.
* **ViewModel:** `FeedsViewModel` acts as the ViewModel. It fetches data from the `FeedsService`, prepares it for display, and updates the View via `@Published` properties.




-----------------------------------------------------------------------------------
#**Control Flow**
-----------------------------------------------------------------------------------



Here's a step-by-step breakdown of the control flow:

##**App Launch:** 
`FeedsApp` initializes the `AppCoordinator`.

##**Coordinator Setup:**
    * `AppCoordinator` initializes `FeedsCoordinator`.
    * `FeedsCoordinator` is given a `FeedsService` instance (or a mock for testing).
    
##**View Creation:**
    * `AppCoordinator` starts the app by creating a `NavigationStack` and calling `FeedsCoordinator.start()`.
    * `FeedsCoordinator.start()` creates a `FeedsViewModel` (injecting the `FeedsService`) and a `FeedsView` (injecting the `ViewModel`).
    
##**Data Loading:**
    * `FeedsView`'s `task` modifier calls `viewModel.loadPosts()` when the view appears.
    * `FeedsViewModel.loadPosts()`:
        * Sets `isLoading` to `true`.
        * Calls `feedsService.fetchPosts()`.
        * `FeedsService.fetchPosts()`:
            * Reads data from "FeedsJSON.json".
            * Parses the JSON into `FeedsResponse` objects.
            * Returns the array of `FeedsResponse`.
        * `FeedsViewModel.loadPosts()` receives the data:
            * Stores the data in the `posts` array.
            * Sets `isLoading` to `false`.
            * Handles any errors from the service and sets `errorMessage`.
            
##**View Updates:**
    * The `@Published` properties in `FeedsViewModel` (`posts`, `isLoading`, `errorMessage`) notify `FeedsView` of any changes.
    * `FeedsView` updates its UI based on the new data or state.
    * `FeedsView` creates `FeedsMediaPlayer` instances for each feed, passing in the feed data and the `currentFeedIndex` binding.
    
##**Media Playback:**
    * `FeedsMediaPlayer` uses the `VideoPlayerManager` to load and control video playback.
    * It observes the `currentFeedIndex` to determine when to start or pause video playback.



----------------------------------------------------------------------------------
#**Key MVVM Principles Demonstrated**
----------------------------------------------------------------------------------

##**Separation of Concerns:** 
Each component has a specific responsibility (View displays, ViewModel manages data, Service fetches data).

##**Data Binding:** 
`@Published` properties in the ViewModel enable data binding, so the View automatically updates when the data changes.

##**Testability:** 
The use of protocols (like `FeedsServiceProtocol`) makes it easier to mock dependencies for unit testing.

##**Reusability:** 
`FeedsMediaPlayer` is a reusable component for displaying media.

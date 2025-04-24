//
//  FeedsViewModel.swift
//  FeedsApp
//
//  Created by Arshwin on 17/04/25.
//

// Implements the service layer responsible for fetching and parsing feed data from a local JSON file.
// Conforms to `FeedsServiceProtocol` and uses ObjectMapper for model conversion.

import Foundation
import ObjectMapper

// A protocol defining the contract for fetching feed posts asynchronously.
protocol FeedsServiceProtocol {
    // Fetches a list of feed posts asynchronously.
    // - Returns: An array of `FeedsResponse` items.
    // - Throws: An error if fetching or parsing fails.
    func fetchPosts() async throws -> [FeedsResponse]
}

// Default implementation of `FeedsServiceProtocol` that reads feed data from a local JSON file.
final class FeedsService: FeedsServiceProtocol {

    // Attempts to read and parse the JSON feed data from a file named "FeedsJSON".
    // - Returns: A list of feed responses parsed using ObjectMapper.
    // - Throws: An empty array is returned if reading or parsing fails.
    func fetchPosts() async throws -> [FeedsResponse] {
        if let jsonObject =  self.readJSON(from: "FeedsJSON") {
            let result = Mapper<FeedsResponse>().mapArray(JSONArray: jsonObject)
            return result
        }
        return []
    }

    // Custom errors for the `FeedsService`, providing meaningful descriptions for UI or debugging.
    enum FeedServiceError: LocalizedError {
        case invalidURL
        case parsingError
        case underlying(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The file URL is invalid."
            case .parsingError:
                return "Failed to parse JSON."
            case .underlying(let error):
                return error.localizedDescription
            }
        }
    }

    // Reads and parses JSON data from a given file in the main bundle.
    // - Parameter filename: The name of the JSON file (without extension).
    // - Returns: A dictionary array representing the JSON structure or nil if parsing fails.
    func readJSON(from filename: String) -> [[String: Any]]? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Error: Could not find \(filename).json in the main bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return json
            } else {
                print("Error: Could not parse JSON from data.")
                return nil
            }
        } catch {
            print("Error reading or parsing JSON: \(error)")
            return nil
        }
    }

}

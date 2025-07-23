//
//  MoviesTaskTests.swift
//  MoviesTaskTests
//
//  Created by Macos on 21/07/2025.
//

import XCTest
import Combine
@testable import MoviesTask

final class MoviesTaskTests: XCTestCase {
    
    var viewModel: MovieViewModel!
    var cancellables: Set<AnyCancellable>!
    var mockNetwork: MockNetworkManager!
    
    override func setUp() {
           super.setUp()
           cancellables = []
           mockNetwork = MockNetworkManager()
           viewModel = MovieViewModel(networkManager: mockNetwork)
       }
       
       override func tearDown() {
           viewModel = nil
           cancellables = nil
           mockNetwork = nil
           super.tearDown()
       }

    func testFetchPopularMoviesFallbackToCache() {
            let mockMovies = [
                Movie(
                    id: 1,
                    title: "Mock Movie",
                    originalTitle: "Mock",
                    originalLanguage: "en",
                    releaseDate: "2025-05-01",
                    overview: "Test",
                    rating: 7.5,
                    voteCount: 100,
                    posterPath: "/test.jpg",
                    backdropPath: "/back.jpg",
                    genreIds: [1, 2]
                )
            ]
            MovieStorageManager.shared.saveMovies(mockMovies, to: "popular_movies.json")
            
            mockNetwork.result = .failure(NSError(domain: "", code: -1))
            
            let expectation = XCTestExpectation(description: "Fallback to cached popular movies")
            
            viewModel.$popularMovies
                .dropFirst()
                .sink { movies in
                    if !movies.isEmpty {
                        XCTAssertEqual(movies.count, 1)
                        XCTAssertEqual(movies.first?.title, "Mock Movie")
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)

            viewModel.fetchPopularMovies()

            wait(for: [expectation], timeout: 3.0)
        }

        func testFetchTopMovies2025FromCache_FailureCase() {
            let mockMovies = [
                Movie(
                    id: 2,
                    title: "Top 2025 Movie",
                    originalTitle: "Top 2025",
                    originalLanguage: "en",
                    releaseDate: "2025-06-01",
                    overview: "Top Movie",
                    rating: 8.0,
                    voteCount: 200,
                    posterPath: "/top.jpg",
                    backdropPath: "/top_back.jpg",
                    genreIds: [1, 2]
                )
            ]
            MovieStorageManager.shared.saveMovies(mockMovies, to: "top_2025_movies.json")

            mockNetwork.result = .failure(NSError(domain: "", code: -1))
            
            let expectation = XCTestExpectation(description: "Load top 2025 movies from cache")
            
            viewModel.$movies
                .dropFirst()
                .sink { movies in
                    XCTAssertFalse(movies.isEmpty, "Expected to load movies from cache")
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.fetchTopMovies2025()
            
            wait(for: [expectation], timeout: 2.0)
        }



    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

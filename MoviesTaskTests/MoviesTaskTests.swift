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
    
    override func setUp() {
            super.setUp()
            viewModel = MovieViewModel()
            cancellables = []
        }
        
        override func tearDown() {
            viewModel = nil
            cancellables = nil
            super.tearDown()
        }

    func testFetchPopularMoviesFallbackToCache() {
        let mockMovies = [
            Movie(
                id: 1,
                title: "Mock",
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
        
        let mockNetwork = MockNetworkManager()
        mockNetwork.result = .failure(NSError(domain: "", code: -1))
        
        let viewModel = MovieViewModel(networkManager: mockNetwork)
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
        let expectation = XCTestExpectation(description: "not load top 2025 movies from cache")
        
        viewModel = MovieViewModel(networkManager: MockNetworkManager())
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertFalse(movies.isEmpty, "no movies to be loaded from cache")
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

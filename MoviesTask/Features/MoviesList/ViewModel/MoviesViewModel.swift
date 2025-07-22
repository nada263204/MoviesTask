//
//  MoviesViewModel.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation
import Combine

class MovieViewModel {
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var popularMovies: [Movie] = []

    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTopMovies2025() {
        state = .loading
        let endpoint = APIEndpoint.topMovies(year: 2025)

        NetworkManager.shared
            .request(endpoint, responseType: MovieResponse.self)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error)
                    self?.movies = MovieStorageManager.shared.loadMovies(from: "top_movies_2025.json")
                }
            } receiveValue: { [weak self] response in
                self?.movies = response.results
                self?.state = .success
                MovieStorageManager.shared.saveMovies(response.results, to: "top_movies_2025.json")
            }
            .store(in: &cancellables)
    }


    func fetchPopularMovies() {
        state = .loading

        NetworkManager.shared
            .request(.popularMovies, responseType: MovieResponse.self)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error)
                    self?.popularMovies = MovieStorageManager.shared.loadMovies(from: "popular_movies.json")
                }
            } receiveValue: { [weak self] response in
                self?.popularMovies = response.results
                self?.state = .success
                MovieStorageManager.shared.saveMovies(response.results, to: "popular_movies.json")
            }
            .store(in: &cancellables)
    }



}



enum ViewState {
    case idle
    case loading
    case success
    case failure(Error)
}

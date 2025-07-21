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
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTopMovies2025() {
        state = .loading

        let endpoint = APIEndpoint.topMovies(year: 2025)

        NetworkManager.shared
            .request(endpoint, responseType: MovieResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.movies = response.results
                self?.state = .success
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

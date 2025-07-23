//
//  DISwinjectContainer.swift
//  MoviesTask
//
//  Created by Macos on 23/07/2025.
//

import Swinject
import UIKit

final class DISwinjectContainer {
    static let shared = DISwinjectContainer()
    private let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(NetworkManaging.self) { _ in
            NetworkManager.shared
        }

        container.register(MovieViewModel.self) { r in
            MovieViewModel(networkManager: r.resolve(NetworkManaging.self)!)
        }

        container.register(FavoriteViewModel.self) { _ in
            FavoriteViewModel()
        }

        container.register(HomeMovieListViewController.self) { r in
            let vc = HomeMovieListViewController(nibName: "HomeMovieListViewController", bundle: nil)
            vc.setViewModel(r.resolve(MovieViewModel.self)!)
            vc.movieDetailsFactory = DefaultMovieDetailsModuleFactory()
            return vc
        }

        container.register(MovieDetailsViewController.self) { (r, movie: Movie) in
            let vc = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
            vc.movie = movie
            vc.favoriteViewModel = r.resolve(FavoriteViewModel.self)!
            return vc
        }
        
        container.register(FavoriteViewController.self) { r in
            let vc = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
            vc.setViewModel(r.resolve(FavoriteViewModel.self)!)
            return vc
        }

    }


    func resolveHomeVC() -> HomeMovieListViewController {
        return container.resolve(HomeMovieListViewController.self)!
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return container.resolve(type)!
    }
    
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        return container.resolve(type, argument: argument)!
    }

}

protocol HomeModuleFactory {
    func makeHomeModule() -> UIViewController
}

class DefaultHomeModuleFactory: HomeModuleFactory {
    func makeHomeModule() -> UIViewController {
        return DISwinjectContainer.shared.resolve(HomeMovieListViewController.self)
    }
}


protocol MovieDetailsModuleFactory {
    func makeMovieDetailsModule(for movie: Movie) -> UIViewController
}

class DefaultMovieDetailsModuleFactory: MovieDetailsModuleFactory {
    func makeMovieDetailsModule(for movie: Movie) -> UIViewController {
        return DISwinjectContainer.shared.resolve(MovieDetailsViewController.self, argument: movie)
    }
}


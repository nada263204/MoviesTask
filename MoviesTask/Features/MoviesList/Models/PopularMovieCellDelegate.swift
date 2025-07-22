//
//  PopularMovieCellDelegate.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import Foundation

protocol PopularMovieCellDelegate: AnyObject {
    func didUpdateFavoriteStatus(for movie: Movie, isNowFavorite: Bool)
}

//
//  FavoriteMovieCellCollectionViewCell.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class FavoriteMovieCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var favoriteMovieImage: UIImageView!
    @IBOutlet weak var favoriteMovieDate: UILabel!
    @IBOutlet weak var favoroteTitle: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    weak var delegate: FavoriteMovieCellDelegate?
    
    private var currentMovie: Movie?
    private var viewModel = FavoriteViewModel()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        favoriteMovieImage.contentMode = .scaleAspectFill
        favoriteMovieImage.clipsToBounds = true
        layer.cornerRadius = 10
        clipsToBounds = true
        
        favoriteButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteButton.addGestureRecognizer(tapGesture)
    }


    func configure(with movie: Movie) {
        currentMovie = movie
        favoroteTitle.text = movie.title
        favoriteMovieDate.text = movie.releaseDate

        if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.favoriteMovieImage.image = UIImage(data: data)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.favoriteMovieImage.image = UIImage(systemName: "photo")
                    }
                }
            }
        }

        updateFavoriteIcon()
    }

    private func updateFavoriteIcon() {
        guard let movie = currentMovie else { return }
        let isFav = viewModel.isFavorite(movie: movie)
        let imageName = isFav ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
        favoriteButton.tintColor = isFav ? .red : .white
    }

    @objc private func favoriteButtonTapped() {
        guard let movie = currentMovie else { return }

        if viewModel.isFavorite(movie: movie) {
            delegate?.didRequestRemoveFavorite(movie)
        } else {
            viewModel.addToFavorites(movie: movie)
            updateFavoriteIcon()
        }
    }

}


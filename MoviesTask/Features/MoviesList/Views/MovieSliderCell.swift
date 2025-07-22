//
//  MovieSliderCell.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import UIKit
import SDWebImage


class MovieSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var isFavorite: Bool = false
    private let favoriteViewModel = FavoriteViewModel()
    private var currentMovie: Movie?

    
       
    func configure(with movie: Movie, isFavorite: Bool? = nil) {
        self.currentMovie = movie
        self.isFavorite = isFavorite ?? favoriteViewModel.isFavorite(movie: movie)
        updateFavoriteButton()

        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseURL + movie.posterPath) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "image"))
        }
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ratingLabel.text = "⭐️ \(movie.rating)"
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        releaseDateLabel.font = UIFont.boldSystemFont(ofSize: releaseDateLabel.font.pointSize)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: ratingLabel.font.pointSize)
    }


    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let movie = currentMovie else { return }

        if isFavorite {
            if let vc = self.parentViewController {
                let alert = UIAlertController(
                    title: "Remove from Favorites",
                    message: "Are you sure you want to remove this movie from favorites?",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                    self.favoriteViewModel.removeFromFavorites(movie: movie)
                    self.isFavorite = false
                    self.updateFavoriteButton()
                }))
                vc.present(alert, animated: true, completion: nil)
            }
        } else {
            favoriteViewModel.addToFavorites(movie: movie)
            isFavorite = true
            updateFavoriteButton()
        }
    }

    
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    
}


extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}

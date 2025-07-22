//
//  MovieDetailsViewController.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    
    var movie: Movie!
    
    private let favoriteViewModel = FavoriteViewModel()
    private var isFavorite: Bool = false
    weak var delegate: MovieDetailsDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
           view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
           [titleLabel, ratingLabel, releaseDateLabel, overviewLabel, voteAverageLabel, originalLanguageLabel].forEach {
               $0?.textColor = .white
               $0?.font = UIFont.boldSystemFont(ofSize: 16)
               $0?.numberOfLines = 0
           }
       }

    private func configureUI() {
        guard let movie = movie else { return }

        titleLabel.text = movie.title
        ratingLabel.text = "Rating: ⭐️ \(movie.rating)"
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        overviewLabel.text = movie.overview
        voteAverageLabel.text = "Vote Count: \(movie.voteCount)"
        originalLanguageLabel.text = "Language: \(movie.originalLanguage.uppercased())"

        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseURL + movie.posterPath) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }

        isFavorite = favoriteViewModel.isFavorite(movie: movie)
        updateFavoriteIcon()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(tapGesture)
    }

    private func updateFavoriteIcon() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
    }

    @objc private func favoriteButtonTapped() {
        guard let movie = movie else { return }

        if isFavorite {
            let alert = UIAlertController(
                title: "Remove from Favorites",
                message: "Are you sure you want to remove this movie from favorites?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                self.favoriteViewModel.removeFromFavorites(movie: movie)
                self.isFavorite = false
                self.updateFavoriteIcon()
                self.delegate?.didUpdateFavoriteStatus(for: movie, isFavorite: false)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            favoriteViewModel.addToFavorites(movie: movie)
            isFavorite = true
            updateFavoriteIcon()
            delegate?.didUpdateFavoriteStatus(for: movie, isFavorite: true)
        }
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

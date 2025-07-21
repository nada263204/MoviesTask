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
    
       
    func configure(with movie: Movie) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let url = URL(string: baseURL + movie.posterPath) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
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



}

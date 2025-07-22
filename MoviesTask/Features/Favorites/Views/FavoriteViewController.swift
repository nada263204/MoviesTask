//
//  FavoriteViewController.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!

    private let viewModel = FavoriteViewModel()
    private var favoriteMovies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
        title = "Favorite"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        favoriteCollectionView.backgroundColor = view.backgroundColor
        setupCollectionView()
        loadFavorites()
    }

    private func setupCollectionView() {
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self

        let nib = UINib(nibName: "FavoriteMovieCellCollectionViewCell", bundle: nil)
        favoriteCollectionView.register(nib, forCellWithReuseIdentifier: "FavoriteMovieCellCollectionViewCell")

        if let layout = favoriteCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }

    private func loadFavorites() {
        favoriteMovies = viewModel.getFavoriteMovies()
        favoriteCollectionView.reloadData()
    }
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovieCellCollectionViewCell", for: indexPath) as? FavoriteMovieCellCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = favoriteMovies[indexPath.item]
        cell.configure(with: movie)
        cell.delegate = self  
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 200)
    }
}

extension FavoriteViewController: FavoriteMovieCellDelegate {
    func didRequestRemoveFavorite(_ movie: Movie) {
        let alert = UIAlertController(
            title: "Remove Favorite",
            message: "Are you sure you want to remove \"\(movie.title)\" from favorites?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.removeFromFavorites(movie: movie)

            if let index = self.favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
                self.favoriteMovies.remove(at: index)
                self.favoriteCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        })

        present(alert, animated: true)
    }
}

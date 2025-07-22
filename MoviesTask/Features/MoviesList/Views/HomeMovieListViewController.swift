//
//  HomeMovieListViewController.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import UIKit
import Combine

class HomeMovieListViewController: ViewController {

    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var goToFavoriteScreen: UIImageView!

    private let viewModel = MovieViewModel()
    private var cancellables = Set<AnyCancellable>()

    var timer: Timer?
    var currentIndex = 0
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)

        setupCollections()
        bindViewModel()
        viewModel.fetchTopMovies2025()
        viewModel.fetchPopularMovies()
        //startSliderTimer()
        setupFavoriteIconTap()
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center

    }

    func bindViewModel() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.loadingIndicator.startAnimating()
                case .success, .failure:
                    self?.loadingIndicator.stopAnimating()
                case .idle:
                    break
                }
            }
            .store(in: &cancellables)

        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                self.sliderCollectionView.reloadData()
                self.currentIndex = 0
                self.scrollToCurrentIndex(animated: false)
            }
            .store(in: &cancellables)

        viewModel.$popularMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.popularCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }


    func setupCollections() {
        let nib1 = UINib(nibName: "MovieSliderCell", bundle: nil)
        sliderCollectionView.register(nib1, forCellWithReuseIdentifier: "MovieSliderCell")
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        sliderCollectionView.isPagingEnabled = true

        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        sliderCollectionView.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)

        let nib2 = UINib(nibName: "PopularMovieCell", bundle: nil)
        popularCollectionView.register(nib2, forCellWithReuseIdentifier: "PopularMovieCell")
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self

        if let layout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        popularCollectionView.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)
    }

    func startSliderTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollSlider), userInfo: nil, repeats: true)
    }

    @objc func autoScrollSlider() {
        guard viewModel.movies.count > 1 else { return }

        currentIndex = (currentIndex + 1) % viewModel.movies.count
        scrollToCurrentIndex(animated: true)
    }

    func scrollToCurrentIndex(animated: Bool) {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        if currentIndex < viewModel.movies.count {
            sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }


    func setupFavoriteIconTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteIconTapped))
        goToFavoriteScreen.isUserInteractionEnabled = true
        goToFavoriteScreen.addGestureRecognizer(tapGesture)
    }

    @objc func favoriteIconTapped() {
        let favoritesVC = FavoriteViewController(nibName: "FavoriteViewController", bundle: nil)
        favoritesVC.title = "Favorites"
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
}


extension HomeMovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == sliderCollectionView) ? viewModel.movies.count : viewModel.popularMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteViewModel = FavoriteViewModel()

        if collectionView == sliderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieSliderCell", for: indexPath) as! MovieSliderCell
            let movie = viewModel.movies[indexPath.item]
            let isFavorite = favoriteViewModel.isFavorite(movie: movie)
            cell.configure(with: movie, isFavorite: isFavorite)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularMovieCell", for: indexPath) as! PopularMovieCell
            let movie = viewModel.popularMovies[indexPath.item]
            let isFavorite = favoriteViewModel.isFavorite(movie: movie)
            cell.configure(with: movie, isFavorite: isFavorite)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderCollectionView {
            return CGSize(width: collectionView.frame.width - 20, height: collectionView.frame.height)
        } else {
            return CGSize(width: 310, height: collectionView.frame.height)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == sliderCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            currentIndex = page
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = (collectionView == sliderCollectionView) ? viewModel.movies[indexPath.item] : viewModel.popularMovies[indexPath.item]
        let detailsVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}


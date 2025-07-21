//
//  SplashViewController.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class SplashViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let homeVC = HomeMovieListViewController(nibName: "HomeMovieListViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: homeVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
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

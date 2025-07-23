//
//  SplashViewController.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import UIKit
import Lottie

class SplashViewController: ViewController {

    @IBOutlet weak var myLogo: UIImageView!
    private var animationView: LottieAnimationView!

    var homeModuleFactory: HomeModuleFactory! 

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 31/255, green: 29/255, blue: 43/255, alpha: 1.0)

        animationView = LottieAnimationView(name: "logo")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let homeVC = self.homeModuleFactory.makeHomeModule()
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

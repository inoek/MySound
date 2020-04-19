//
//  MainTabBarController.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719351113, blue: 0.4505646229, alpha: 1)
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "Search - Selected"), title: "Поиск"),
            generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "Library"), title: "Поиск")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
}


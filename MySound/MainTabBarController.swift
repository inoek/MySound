//
//  MainTabBarController.swift
//  MySound
//
//  Created by Игорь Ноек on 19.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import SwiftUI

//функции делегата
protocol MainTabBarControllerDelegate: class {
    func minimizedTrackDetailController()
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self//реализатор делегата
        
        view.backgroundColor = .gray
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719351113, blue: 0.4505646229, alpha: 1)
        
        var library = Library()//экземпляр файла SwiftUI
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "Library")
        hostVC.tabBarItem.title = "Бибилиотека"
        
        
        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "Search - Selected"), title: "Поиск")
            //generateViewController(rootViewController: hostVC, image: #imageLiteral(resourceName: "Library"), title: "Поиск")
        ]
    }
    
    //создаём tabBar
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self//указываем делегата
        trackDetailView.delegate = searchVC//и уточняем
        //trackDetailView.backgroundColor = .green
        
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        //auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        
        // trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    
}

extension MainTabBarController: MainTabBarControllerDelegate {

    
    
    
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
        //trackDetailView на весь экран
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()//обновляем экран каждую ммсекунду
                        self.tabBar.alpha = 0//скрываем ТБ
                        self.trackDetailView.miniTrackView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        
        guard let viewModel = viewModel else { return }//проверяем есть ли viewModel
        self.trackDetailView.set(viewModel: viewModel)
        
        
    }
    
    //реализовываем методы делегата
    func minimizedTrackDetailController() {
        //trackDetailView в окошко
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()//обновляем экран каждую ммсекунду
                        self.trackDetailView.miniTrackView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0
                        self.tabBar.alpha = 1//показываем ТБ

        },
                       completion: nil)


    }
    
    
}



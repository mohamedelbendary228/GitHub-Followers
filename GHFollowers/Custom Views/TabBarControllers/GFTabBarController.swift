//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 07/10/2026.
//

import UIKit

class GFTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem =  UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 0
        )
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesListVC = FavoritesListVC()
        favoritesListVC.title = "Favorite"
        favoritesListVC.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        
        return UINavigationController(rootViewController: favoritesListVC)
    }
    
}

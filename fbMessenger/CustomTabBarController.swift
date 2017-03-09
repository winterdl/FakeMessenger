//
//  CustomTabBarController.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/3/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let resentMessegerNavController =  UINavigationController(rootViewController: friendsController)
        resentMessegerNavController.tabBarItem.title = "Recent"
        resentMessegerNavController.tabBarItem.image = UIImage(named: "recent")
        viewControllers = [resentMessegerNavController]

        createDummyNavController(name: "Calls", inmageName: "calls")
        createDummyNavController(name: "Groups", inmageName: "groups")
        createDummyNavController(name: "People", inmageName: "people")
        createDummyNavController(name: "Settings", inmageName: "settings")

    }

    private func createDummyNavController(name: String, inmageName: String) {
        let viewController = BaseViewController()
        viewController.navigationItem.title = name
        let navController =  UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = name
        navController.tabBarItem.image = UIImage(named: inmageName)
        viewControllers?.append(navController)
    }

}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

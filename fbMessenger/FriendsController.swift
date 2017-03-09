//
//  FriendsController.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/1/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var dataSource: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = .white
        // allows dragging up and down
        collectionView?.alwaysBounceVertical = true
        
        // Register cell classes
        self.collectionView!.register(FriendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // load DataSource
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.tabBarController?.tabBar.isHidden == true {
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.isHidden = false
                self.tabBarController?.tabBar.frame.origin.y = self.view.bounds.height -
                    (self.tabBarController?.tabBar.bounds.height)!
            }, completion: nil)
        }
        
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = dataSource?.count {
            return count
        }
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        cell.message = dataSource?[indexPath.item]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controler = ChatLogController(collectionViewLayout: layout)
        
        controler.friend = dataSource?[indexPath.item].friend
        
        navigationController?.pushViewController(controler, animated: true)
        
        UIView.animate(withDuration: 0.05, animations: {
            self.tabBarController?.tabBar.frame.origin.y = self.view.bounds.height
        }) { _ in
            self.tabBarController?.tabBar.isHidden = true
        }

        
    }
    
}

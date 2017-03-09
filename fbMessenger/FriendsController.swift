//
//  FriendsController.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/1/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    lazy var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        request.predicate = NSPredicate(format: "lastMessage != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext:
            context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    

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
        
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err)
        }
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

    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completion) in
            
            let lastItem = self.fetchResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        let friend = fetchResultsController.object(at: indexPath) as! Friend

        cell.message = friend.lastMessage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controler = ChatLogController(collectionViewLayout: layout)
        
        let friend = fetchResultsController.object(at: indexPath) as! Friend

        controler.friend = friend
        
        navigationController?.pushViewController(controler, animated: true)
        
        UIView.animate(withDuration: 0.05, animations: {
            self.tabBarController?.tabBar.frame.origin.y = self.view.bounds.height
        }) { _ in
            self.tabBarController?.tabBar.isHidden = true
        }

        
    }
    
}

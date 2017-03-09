//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/3/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "cellId"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    var friend : Friend? {
        didSet {
            navigationItem.title = friend?.name
        }
    }
    
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageTextInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type message here.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let topBorderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.80, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.init(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(self.sendButtonHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult> = {         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func sendButtonHandler() {
        if messageTextInputField.text != "" {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            FriendsController.createOwnMessageWithText(messageText: messageTextInputField.text!, friend: friend!, minutesAgo: 0, isReaded: true, context: context)
            
            do {
                try context.save()
                messageTextInputField.text = nil
            } catch let err {
                print(err)
            }
        }
        
    }
    
    var inputContainerBottomConstraint: NSLayoutConstraint?
    
    func setupInputField() {
        view.addSubview(inputContainerView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: inputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(60)]", views: inputContainerView)
        inputContainerBottomConstraint = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        inputContainerBottomConstraint?.isActive = true
        
        
        inputContainerView.addSubview(messageTextInputField)
        inputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0]|", views: messageTextInputField)
        inputContainerView.addConstraintsWithFormat(format: "V:[v0(60)]|", views: messageTextInputField)

        inputContainerView.addSubview(topBorderLine)
        inputContainerView.addSubview(sendButton)
        
        inputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderLine)
        inputContainerView.addConstraintsWithFormat(format: "V:|[v0(1)]", views: topBorderLine)
        
        inputContainerView.addConstraintsWithFormat(format: "H:[v0(80)]|", views: sendButton)
        inputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchResultsController.performFetch()
        } catch let err {
            print(err)
        }
        
        collectionView?.backgroundColor = .white
        navigationController?.view.tintColor = .black
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputField()

        addObserverFofKeyBoard()
        collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 60)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //http://stackoverflow.com/questions/14760496/uicollectionview-automatically-scroll-to-bottom-when-screen-loads
        showLastMessage(animated: false)
    }
    
    func addObserverFofKeyBoard () {
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardHandlert), name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandlert), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHandlert(notification: Notification) {
        let isKeybordShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.inputContainerBottomConstraint?.constant = isKeybordShowing ? -keyboardFrame.height : 0
        }

        UIView.animate(withDuration: (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval), animations: {
                    self.view.layoutIfNeeded()
            }, completion: {
                _ in
                if isKeybordShowing {
                self.state = true
                self.showLastMessage(animated: true)
                }
            })
    }

    var state = true
    
    func showLastMessage(animated: Bool) {
        if state {
            let lastItem = self.fetchResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            state = false
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

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        
        let message = fetchResultsController.object(at: indexPath) as! Message
        
        cell.message = message
       
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.messageTextInputField.endEditing(true)
    }
    
    
    
    var estimatedFrame : CGRect?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = fetchResultsController.object(at: indexPath) as! Message

        if let text = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrameSize = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrameSize.height + 20)
        }
        return CGSize(width: view.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
}

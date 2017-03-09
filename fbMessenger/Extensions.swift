//
//  Extensions.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/1/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: Any]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension FriendsController {
    
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
           let entityNames = ["Friend", "Message"]
            
            do {
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                        for obj in objects! {
                            context.delete(obj)
                        }
                }
                
                try context.save()
                
            } catch let err {
                print(err)
            }
            
        }

    }
    
    func setupData() {
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let mark = createFriend(friendName: "Mark Zuckerberg", imageName: "zuckprofile", context: context)
            createMessageWithText(messageText: "Hello, my name is Mark. Nice to meet you..", friend: mark, minutesAgo: 7, isReaded:true, isSender: false, context: context)
            
            let steve = createFriend(friendName: "Steve Jobs", imageName: "steve_profile", context: context)
            createMessageWithText(messageText: "Apple creates great iOS devices for the world...", friend: steve, minutesAgo: 10, isReaded: true, isSender: false, context: context)
            createMessageWithText(messageText: " It’s faster and more powerful than before, yet remarkably thinner and lighter. It has the brightest, most colorful Mac notebook display ever. And it introduces the Touch Bar — a Multi-Touch enabled strip of glass built into the keyboard for instant access to the tools you want, right when you want them. The new MacBook Pro is built on groundbreaking ideas. And it’s ready for yours.", friend: steve, minutesAgo: 8, isReaded: true, isSender: false, context: context)
            createMessageWithText(messageText: "The Touch Bar replaces the function keys that have long occupied the top of your keyboard with something much more versatile and capable.", friend: steve, minutesAgo: 7, isReaded: true, isSender: true, context: context)
            
            createMessageWithText(messageText: "The Touch Bar replaces the function keys that have long occupied the top of your keyboard with something much more versatile and capable.", friend: steve, minutesAgo: 9, isReaded: true, isSender: true, context: context)
            
            
            let donald = createFriend(friendName: "Donald Trump", imageName: "donald_trump_profile", context: context)
            createMessageWithText(messageText: "Let's make Amerika greate again...", friend: donald, minutesAgo: 20, isReaded: true, isSender: false, context: context)
            createMessageWithText(messageText: "You are fired...", friend: donald, minutesAgo: 15, isReaded: true, isSender: false,  context: context)
            
            
            
            let gandhi = createFriend(friendName: "Mahatma Gandhi", imageName: "gandhi", context: context)
            createMessageWithText(messageText: "Love, Piace, and Joy", friend: gandhi, minutesAgo: 60 * 24, isReaded: true, isSender: false, context: context)

            
            
            
            let hillary = createFriend(friendName: "Hillary Gandhi", imageName: "hillary_profile", context: context)
            createMessageWithText(messageText: "Please vote for me, you did for Billy!", friend: hillary, minutesAgo: 8 * 60 * 24, isReaded: true, isSender: false, context: context)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
        }
    
    }
    
    private func createFriend(friendName: String, imageName: String, context: NSManagedObjectContext) -> Friend {
        let friend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        friend.name = friendName
        friend.profileImageName = imageName
        return friend
    }
    
    private func createMessageWithText(messageText: String, friend: Friend, minutesAgo: Double, isReaded: Bool, isSender: Bool, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = messageText
        message.hasReaded = isReaded
        message.isSender = isSender
        friend.lastMessage = message
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    
    }
    
    static func createOwnMessageWithText(messageText: String, friend: Friend, minutesAgo: Double, isReaded: Bool, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = messageText
        message.hasReaded = isReaded
        message.isSender = true
        friend.lastMessage = message
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)

    }
    
    
    
    private func fetchFriends() -> [Friend]? {
       
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            
            do {
                return try context.fetch(fetchRequest) as? [Friend]
            } catch let err {
                print(err)
            }
            
        }

        return nil
    }

}

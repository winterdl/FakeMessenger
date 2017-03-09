//
//  Message+CoreDataProperties.swift
//  
//
//  Created by Ihar Tsimafeichyk on 3/9/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var hasReaded: Bool
    @NSManaged public var isSender: Bool
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}

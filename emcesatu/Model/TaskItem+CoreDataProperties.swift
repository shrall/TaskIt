//
//  TaskItem+CoreDataProperties.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 11/04/22.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var deadlineBool: Bool
    @NSManaged public var difficulty: Int16
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var ruled: Bool

}

extension TaskItem : Identifiable {

}

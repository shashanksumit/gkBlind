//
//  Question+CoreDataProperties.swift
//  gkBlind
//
//  Created by CG-3 on 25/01/17.
//  Copyright © 2017 CG-3. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question");
    }

    @NSManaged public var questionId: Int16
    @NSManaged public var questionString: String?
    @NSManaged public var score: Int32
    @NSManaged public var questionIs: NSSet?

}

// MARK: Generated accessors for questionIs
extension Question {

    @objc(addQuestionIsObject:)
    @NSManaged public func addToQuestionIs(_ value: Option)

    @objc(removeQuestionIsObject:)
    @NSManaged public func removeFromQuestionIs(_ value: Option)

    @objc(addQuestionIs:)
    @NSManaged public func addToQuestionIs(_ values: NSSet)

    @objc(removeQuestionIs:)
    @NSManaged public func removeFromQuestionIs(_ values: NSSet)

}

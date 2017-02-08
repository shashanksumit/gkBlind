//
//  Option+CoreDataProperties.swift
//  gkBlind
//
//  Created by CG-3 on 25/01/17.
//  Copyright © 2017 CG-3. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option");
    }

    @NSManaged public var optionId: Int32
    @NSManaged public var optionString: String?
    @NSManaged public var isOption: Bool
    @NSManaged public var questionId: Int32
    @NSManaged public var optionIs: Question?

}

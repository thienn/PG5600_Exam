//
//  Characters+CoreDataProperties.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 28/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//
//

import Foundation
import CoreData


extension Characters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Characters> {
        return NSFetchRequest<Characters>(entityName: "Characters")
    }

    @NSManaged public var films: String?
    @NSManaged public var name: String?

}

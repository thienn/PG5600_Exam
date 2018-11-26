//
//  Films+CoreDataProperties.swift
//  PG5600_Exam
//
//  Created by Thien Nguyen on 26/11/2018.
//  Copyright © 2018 Thien Cong Pham. All rights reserved.
//
//

import Foundation
import CoreData


extension Films {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Films> {
        return NSFetchRequest<Films>(entityName: "Films")
    }

    @NSManaged public var title: String?
    @NSManaged public var episodeid: Int16
    @NSManaged public var director: String?
    @NSManaged public var producer: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var crawl: String?

}

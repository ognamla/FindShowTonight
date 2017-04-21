//
//  TheWallDataMO+CoreDataProperties.swift
//  
//
//  Created by Ognam.Chen on 2017/4/21.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TheWallDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TheWallDataMO> {
        return NSFetchRequest<TheWallDataMO>(entityName: "TheWallData");
    }

    @NSManaged public var date: String?
    @NSManaged public var showName: String?

}

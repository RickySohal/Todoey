//
//  Item.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-26.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var itemName = ""
     @objc dynamic var checked = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
    
    
}

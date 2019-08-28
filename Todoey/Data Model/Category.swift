//
//  Category.swift
//  Todoey
//
//  Created by Ricky Sohal on 2019-08-26.
//  Copyright © 2019 Ricky Sohal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryName = ""
    let item = List<Item>()
}

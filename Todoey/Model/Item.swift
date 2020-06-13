//
//  Item.swift
//  Todoey
//
//  Created by Roman Kavinskyi on 11.03.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var timeCreated: Date?
    @objc dynamic var color: String?
    var parentCategory = LinkingObjects(fromType: Categories.self, property: "items")
}

//
//  Category.swift
//  Todoey
//
//  Created by Roman Kavinskyi on 11.03.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    let items = List<Item>()
}

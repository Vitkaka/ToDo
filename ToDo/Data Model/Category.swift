//
//  Category.swift
//  ToDo
//
//  Created by hackeru on 10/02/2020.
//  Copyright © 2020 hackeru. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

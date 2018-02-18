//
//  Dates.swift
//  Nooot
//
//  Created by Анатолий on 18.02.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import Foundation
import RealmSwift

class Dates: Object {
    dynamic var min: Int = Int()
    dynamic var hour: Int = Int()
    dynamic var day: Int = Int()
    dynamic var month: Int = Int()
    dynamic var year: Int = Int()
}

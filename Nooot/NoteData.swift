//
//  NoteData.swift
//  Nooot
//
//  Created by Анатолий on 20.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import Foundation
import RealmSwift

class NoteData: Object {
   dynamic var titleName: String = ""
    var textList = List<BodyText>()
    
//    override static func primaryKey() -> String? {
//        return "titleName"
//    }
    
}

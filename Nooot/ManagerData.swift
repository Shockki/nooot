//
//  ManagerData.swift
//  Nooot
//
//  Created by Анатолий on 20.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

class ManagerData {
    
// Получает JSON заметики и записывает в базу
    
    func loadJSON(title: String) {
        
        let note: NoteData = NoteData()
        let bodyText: BodyText = BodyText()
//        let url = "http://nooot.co/api/texts/\(capitalizingFirstLetter(name: title))"
        let url = "http://nooot.co/api/texts/\(title)"
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
            print("1.1 Start \(Thread.current)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let realm = try! Realm()
            
                note.titleName = json["title"].stringValue
//                print(json)
                bodyText.bodyText = json["body"].stringValue
                note.textList.append(bodyText)
//                print(note)
//                print("1.2 Load \(Thread.current)")
                try! realm.write {
//                    realm.add(note, update: true)   // primaryKey
                    realm.add(note)
                }
//                print("1.3 Write \(Thread.current)")
                semaphore.signal()
//                load = true as AnyObject
            case .failure(let error):
                print(error)
            }
        }
      
    }
    
// Первую букву делает заглавной
    
    func capitalizingFirstLetter(name: String) -> String {
        let first = String(name.characters.prefix(1)).capitalized
        let other = String(name.characters.dropFirst())
        print("Capitalizing \(Thread.current)")
        return first + other
    }

    
// Взвращает текст выбранной заметки
    
    func getNoteDataText(title: String) -> String {
        
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        var body: String = ""
            for value in data[0].textList {
            body.append(value.bodyText)
            }
        if body .isEmpty {
            body = "Type anything you want here. When you'll come back your text will still be here."
        }
        print("2.GetText \(Thread.current)")
        return body
    }

// Возвращает все заметки из базы

    func getAllNotes() -> [String] {
        
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self)
//        print("----------------------------------------------------")
//        print(data)
//        print("----------------------------------------------------")
        var titleList: [String] = []
        for value in data {
//            titleList.append(capitalizingFirstLetter(name: value.titleName))
            titleList.append(value.titleName)

        }
        print("1. GetAllNotes \(Thread.current)")
        
        return titleList
    }
    
// Удаление заметки
    
    func removeNoteDataFronDB(title: String) {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", capitalizingFirstLetter(name: title))
        try! realm.write {
            realm.delete(data[0].textList[0])
            realm.delete(data)
        }
        print("Delete Note")

    }
    
    
// Удаление всех заметок

    func removeAllNoteDataFronDB() {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self)
        try! realm.write {
            realm.delete(data)
        }
        let dataText = realm.objects(BodyText.self)
        try! realm.write {
            realm.delete(dataText)
        }
        print("Remove All")
    }
    
    func reverseNotes (input: [String]) -> [String] {
        var note: [String] = []
        for n in input.reversed() {
            note.append(n)
        }
        return note
    }

    
}

var load: AnyObject? {
    get {
        return UserDefaults.standard.object(forKey: "flag") as AnyObject?
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "flag")
        UserDefaults.standard.synchronize()
    }
}

var semaphore = DispatchSemaphore(value: 0)

let serialQueue = DispatchQueue(label: "serial_queue")

let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)





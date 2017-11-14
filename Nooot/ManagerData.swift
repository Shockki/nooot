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
        let encodedTitle = space(title: title).addingPercentEscapes(using: String.Encoding.utf8)!
        let note: NoteData = NoteData()
        let bodyText: BodyText = BodyText()
        let url = "http://nooot.co/api/texts/\(encodedTitle)"
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
            print("1.1 Start \(Thread.current)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let realm = try! Realm()
//                print(json)
                note.titleName = json["title"].stringValue
                bodyText.bodyText = json["body"].stringValue
                bodyText.idNote = json["_id"].stringValue
                note.textList.append(bodyText)
                
                try! realm.write {
                    realm.add(note, update: true)   // primaryKey
                }

                semaphore.signal()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func saveNoteText(title: String, body: String) {
        let idNote: String = getNoteDataId(title: title)
        let param = [
            "_id":"\(idNote)",
            "title":"\(title)",
            "body":"\(body)",
            ]

        Alamofire.request("http://nooot.co/api/texts/\(idNote)", method: .post, parameters: param, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON(queue: concurrentQueue) { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }

    
// Взвращает текст выбранной заметки
    
    func getNoteDataText(title: String) -> String {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        var body: String = ""
        for value in data[0].textList {
            body.append(value.bodyText)
        }
        print("2.GetText \(Thread.current)")
        return body
    }
    
// Взвращает id выбранной заметки
    
    func getNoteDataId(title: String) -> String {
        
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        var id: String = ""
        for value in data[0].textList {
            id.append(value.idNote)
        }
        print("2.GetId \(Thread.current)")
        return id
    }

// Возвращает все заметки из базы

    func getAllNotes() -> [String] {
        
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self)
        var titleList: [String] = []
        for value in data {
            titleList.append(value.titleName)
        }
        print("1. GetAllNotes \(Thread.current)")
        return titleList
    }
    
// Удаление заметки
    
    func removeNoteDataFromDB(title: String) {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", capitalizingFirstLetter(name: title))
        try! realm.write {
            realm.delete(data[0].textList[0])
            realm.delete(data)
        }
        print("Delete Note")
    }
    
// Удаление всех заметок

    func removeAllNoteDataFromDB() {
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
    
// Заменяет пробел символами
    
    func space(title: String) -> String {
        var array: String = ""
        for i in title.characters {
            if i == " " {
                array.append("%20")
            }else{
                array.append(i)
            }
        }
        return array
    }
    
// Первую букву делает заглавной
    
    func capitalizingFirstLetter(name: String) -> String {
        let first = String(name.characters.prefix(1)).capitalized
        let other = String(name.characters.dropFirst())
        print("Capitalizing \(Thread.current)")
        return first + other
    }

    func reverseNotes (input: [String]) -> [String] {
        var note: [String] = []
        for n in input.reversed() {
            note.append(n)
        }
        return note
    }
    
// Делает проверку на сущ. заметки
    
    func returnText(titleName: String) -> String{
        let noteList: [String] = getAllNotes()
        var getText: String = noteList.last!
        for value in noteList {
            if value == titleName.lowercased() || value == titleName.capitalized {
                getText = value
            }
        }
        print("ReturnText \(Thread.current)")
        return getText
    }
}

var semaphore = DispatchSemaphore(value: 0)

let serialQueue = DispatchQueue(label: "serial_queue")

let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)





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
    let settings: FuncSettings = FuncSettings()
    
    //MARK: Получает JSON заметики и записывает в базу
    func loadJSON(title: String) {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let encodedTitle = title.replacingOccurrences(of: " ", with: "%20").addingPercentEscapes(using: String.Encoding.utf8)!
        let note: NoteData = NoteData()
        let bodyText: BodyText = BodyText()
        let dates: Dates = Dates()
        let url = "http://nooot.co/api/texts/\(encodedTitle)"
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
            //            print("1.1 Start \(Thread.current)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let realm = try! Realm()
                //                print(json)
                note.titleName = json["title"].stringValue
                bodyText.bodyText = json["body"].stringValue
                bodyText.idNote = json["_id"].stringValue
                dates.min = 0
                dates.hour = 0
                dates.day = 0
                dates.month = 0
                dates.year = 0
                bodyText.dates.append(dates)
                note.textList.append(bodyText)
                
                try! realm.write {
                    realm.add(note, update: true)   // primaryKey
                }
                //                print("semaphore.signal")
                semaphore.signal()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadJSON_refreshText(title: String) {
        let encodedTitle = title.replacingOccurrences(of: " ", with: "%20").addingPercentEscapes(using: String.Encoding.utf8)!
        let url = "http://nooot.co/api/texts/\(encodedTitle)"
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
            print("1.1 Start \(Thread.current)")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let realm =  try! Realm()
                print(json)
                let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
                try! realm.write {
                    for value in data[0].textList {
                        value.bodyText = json["body"].stringValue
                    }
                }
                print(json["body"].stringValue)
                semaphore.signal()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: Отправляет JSON заметики
    func saveNoteText(title: String, body: String) {
        let idNote: String = getNoteData_Id(title: title)
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
    
    
    //MARK: Взвращает текст выбранной заметки
    
    func getNoteData_Text(title: String) -> String {
        let realm =  try! Realm()
        var body: String = ""
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        for value in data[0].textList {
            body.append(value.bodyText)
        }
        //        print("2.GetText \(Thread.current)")
        return body
    }
    
    //MARK: Взвращает id выбранной заметки
    
    private func getNoteData_Id(title: String) -> String {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        var id: String = ""
        for value in data[0].textList {
            id.append(value.idNote)
        }
        return id
    }
    
    //MARK: Взвращает дату последнего редактирования выбранной заметки
    
    func getNoteData_Date(title: String) -> [Int] {
        var d: [Int] = []
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        print("data[0] - \(data[0].textList[0].dates)")
        for value in data[0].textList[0].dates {
            d.append(value.year)
            d.append(value.month)
            d.append(value.day)
            d.append(value.hour)
            d.append(value.min)
        }
        return d
    }
    
    
    //MARK: Возвращает имя всех заметок из базы
    
    func getAllNotes() -> [String] {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self)
        var titleList: [String] = []
        for value in data {
            titleList.append(value.titleName)
        }
        //        print("1. GetAllNotes \(Thread.current)")
        return titleList
    }
    
    //MARK: Удаление заметки
    
    func removeNoteDataFromDB(title: String) {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        try! realm.write {
            realm.delete(data[0].textList[0])
            realm.delete(data)
        }
    }
    
    //MARK: Удаление всех заметок
    
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
        let dataDate = realm.objects(Dates.self)
        try! realm.write {
            realm.delete(dataDate)
        }
    }
    
    //MARK: Первую букву делает заглавной
    
    private func capitalizingFirstLetter(name: String) -> String {
        let first = String(name.characters.prefix(1)).capitalized
        let other = String(name.characters.dropFirst())
        //        print("Capitalizing \(Thread.current)")
        return first + other
    }
    
    func reverseNotes (input: [String]) -> [String] {
        var note: [String] = []
        for n in input.reversed() {
            note.append(n)
        }
        return note
    }
    
    //MARK: Делает проверку на сущ. заметки
    
    func checkForAvailable(titleName: String) -> String{
        let noteList: [String] = getAllNotes()
        print("noteList - \(noteList)")
        var getText: String = ""
        for value in noteList {
            if value == titleName.lowercased() || value == titleName.capitalized {
                getText = value
            }
        }
        print("getText - \(getText)")
        return getText
    }
    
    func refresh_Text(title: String, newBodyText: String) {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        try! realm.write {
            for value in data[0].textList {
                value.bodyText = newBodyText
            }
        }
    }
    
    func refresh_Date(title: String) {
        let realm =  try! Realm()
        let data = realm.objects(NoteData.self).filter("titleName  BEGINSWITH %@", title)
        var date = settings.date()
        try! realm.write {
            for value in data[0].textList[0].dates {
                value.year = date[0]
                value.month = date[1]
                value.day = date[2]
                value.hour = date[3]
                value.min = date[4]
            }
        }
    }
    
    func returnText(titleName: String) -> String{
        let noteList: [String] = getAllNotes()
        var getText: String = ""
        if noteList.isEmpty {
            var getText: String = ""
        }else{
            getText = noteList.last!
            for value in noteList {
                if value == titleName.lowercased() || value == titleName.capitalized {
                    getText = value
                }
            }
        }
        //        print("ReturnText \(Thread.current)")
        return getText
    }
    
}

var semaphore = DispatchSemaphore(value: 0)

let serialQueue = DispatchQueue(label: "serial_queue")

let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)





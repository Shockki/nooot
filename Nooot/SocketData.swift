//
//  SocketData.swift
//  Nooot
//
//  Created by Анатолий on 28.03.2018.
//  Copyright © 2018 Анатолий Модестов. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SocketData {
    private let socket = SocketIOClient(socketURL: URL(string:"ws://nooot.co/socket.io")!)
    private let manager: ManagerData = ManagerData()
    var textView: UITextView = UITextView()
    var id: String = ""
    var titleName: String = ""
    var check: Bool = false
    
    func startSocket() {
        addHandlers()
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
        
   private func addHandlers() {
            
        socket.on("typing") {[weak self] data, ack in
            self?.typing()
            return
        }
            
        socket.on("update") {[weak self] data, ack in
            self?.update(data: data)
            return
        }
        
        socket.on("connect") { _, _ in
//            self.infoLabel(label: label)
            print("Сокет подключен")
            self.emit()
        }
            
        socket.on("error") { _, _ in
//                self.error(label: label)
        }
            
//        socket.onAny {print("-----------------------------------------\nGot event: \($0.event)\nItems: \($0.items!)\n-----------------------------------------")}
        socket.onAny {print("--- Got event: \($0.event)")}
    }
        
    private func typing() {
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func update(data: [Any]) {
        textView.text = parsejson(data: data)
        textView.isEditable = true
        textView.isSelectable = true
        textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        check = true
    }


    func emit() {
        socket.emit("changeRoom", id)
    }
    
    private func parsejson(data: [Any]) -> String {
        let json = data as? [[String: Any]]
        let myjson = JSON(json![0])
        return String(cString: myjson["text"].stringValue.cString(using: .isoLatin1)!, encoding: .utf8)!
    }
    
//    func infoLabel(label: UILabel) {
//        socket.emit("changeRoom", idNote)
//        label.text = "Socket Connected."
//        print("Socket Connected.")
//    }
    
    private func error(label: UILabel) {
        label.text = "отсутствует подключение"
    }
}

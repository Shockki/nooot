//
//  ViewController.swift
//  Nooot
//
//  Created by Анатолий on 20.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var labelBodyText: UILabel!
    
    var noteText: String = ""
    var notesList: [String] = ["lol"]
    let manager: ManagerData = ManagerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        if load == nil {
            
            for note in notesList {
                manager.loadJSON(title: note)
            }
            semaphore.wait()
            print("2.ReloadHistory \(Thread.current)")
            historyTableView.reloadData()
        } else {
            notesList = manager.getAllNotes()
            print(notesList)
        }
    }
    
// Кнопка "Готово"
    
    @IBAction func buttonAction(_ sender: Any) {
    
        if textField.text!.isEmpty {
            let alertCont = UIAlertController(title: "Введите имя заметки", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alertCont.addAction(action)
            self.present(alertCont, animated: true, completion: nil)
        }else{
            
            manager.loadJSON(title: textField.text!)
            
            semaphore.wait()
            labelBodyText.text! = manager.getNoteDataText(title: textField.text!)
            notesList.append(textField.text!)
            print(notesList)
            print("3.ReloadHistory \(Thread.current)")
            historyTableView.reloadData()
            
            
        }
    }
    
// Кнопка удаления всей истории
    
    @IBAction func removeAllHistoryNotes(_ sender: Any) {
        manager.removeAllNoteDataFronDB()
        notesList.removeAll()
        print("ReloadHistory \(Thread.current)")
        historyTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
// Источник данных таблицы
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notesList[indexPath.row]
//        cell.detailTextLabel?.text = manager.getNoteDataText(title: (cell.textLabel?.text)!)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.detailTextLabel?.font = UIFont(name: "Gill Sans", size: 12)
        return cell
    }
    
// Action swiping
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Шаринг
        
        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            let activityVC = UIActivityViewController(activityItems: ["http://nooot.co/text/\(self.notesList[indexPath.row])"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
            self.historyTableView.isEditing = false
        }
        
        shareAction.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        // Копирование ссылки заметки
        
        let copyAction = UITableViewRowAction(style: .default, title: "Copy") { (action, indexPath) in
            print("copy")
            self.historyTableView.isEditing = false
        }
        copyAction.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        // Удаление заметки
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("delete")
            
            self.manager.removeNoteDataFronDB(title: self.notesList[indexPath.row])
            self.notesList.remove(at: indexPath.row)
            self.historyTableView.reloadData()
            self.historyTableView.isEditing = false
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return [copyAction, deleteAction, shareAction]
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue .identifier == "details" {
            if let indexPath = historyTableView.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.hisTitleName = notesList[indexPath.row]
                
            }
            
        }
    }
    
//    Порядок TableView снизу вверх
//    
//    func updateTableContentInset() {
//        let numRows = tableView(historyTableView, numberOfRowsInSection: 0)
//        var contentInsetTop = historyTableView.bounds.size.height
//        for i in 0..<numRows {
//            contentInsetTop -= tableView(historyTableView, heightForRowAt: IndexPath(item: i, section: 0))
//            if contentInsetTop <= 0 {
//                contentInsetTop = 0
//            }
//        }
//        historyTableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
//    }

    

}

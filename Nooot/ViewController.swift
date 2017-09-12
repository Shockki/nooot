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

    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyTableViewTwo: UITableView!
    @IBOutlet weak var labelHello: UILabel!
    @IBOutlet weak var labelBodyText: UILabel!
    @IBOutlet weak var buttonDeleteAll: UIButton!
    @IBOutlet weak var buttonDeleteAllTwo: UIButton!
    @IBOutlet weak var visited: UILabel!
    @IBOutlet weak var visitedTwo: UILabel!
    
    var noteText: String = ""
    var notesList: [String] = []
    var notesReverse: [String] = []
    let manager: ManagerData = ManagerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        historyTableView.delegate = self
        buttonDeleteAll.titleLabel?.adjustsFontSizeToFitWidth = true

        notesReverse = manager.getAllNotes()
        notesList = manager.reverseNotes(input: notesReverse)
        sizeTableView()
    }
    
// Скрывает клавиатуру, когда пользователь касается внешнего вида
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//----------------------------------TableView----------------------------------------------
    
// Кнопка удаления всей истории
    
    @IBAction func removeAllHistoryNotes(_ sender: Any) {
        removeAll()
    }
    @IBAction func removeAllHistoryNotesTwo(_ sender: Any) {
        removeAll()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeAll() {
        let alertContr = UIAlertController(title: "Вы действительно хотите очистить историю?", message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: "Очистить", style: .destructive) { (action) in
            self.manager.removeAllNoteDataFronDB()
            self.notesList.removeAll()
            self.historyTableView.reloadData()
            self.historyTableViewTwo.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertContr.addAction(actionDelete)
        alertContr.addAction(actionCancel)
        present(alertContr, animated: true, completion: nil)
    }

    func sizeTableView() {
        if notesList.count < 4 {
            visited.alpha = 1
            visitedTwo.alpha = 0
            buttonDeleteAll.alpha = 1
            buttonDeleteAllTwo.alpha = 0
            historyTableView.alpha = 1
            historyTableViewTwo.alpha = 0
            labelHello.alpha = 1
            labelBodyText.alpha = 1
        }else{
            visited.alpha = 0
            visitedTwo.alpha = 1
            buttonDeleteAll.alpha = 0
            buttonDeleteAllTwo.alpha = 1
            historyTableView.alpha = 0
            historyTableViewTwo.alpha = 1
            labelHello.alpha = 0
            labelBodyText.alpha = 0
        }
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
//        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        cell.detailTextLabel?.font = UIFont(name: "Gill Sans", size: 12)
        
        // Изменение цвета при нажатии:
        
        // Цвет бекграунда
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.00336881564, green: 0.483507812, blue: 0.999037087, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        // Цвет текста
        cell.textLabel?.highlightedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        cell.detailTextLabel?.highlightedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue .identifier == "details" {
            if let indexPath = historyTableView.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.titleName = notesList[indexPath.row]
                
            }else if let indexPath = historyTableViewTwo.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.titleName = notesList[indexPath.row]
            }
        }
    }
    
// Action swiping
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        // Шаринг
//        
//        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
//            let activityVC = UIActivityViewController(activityItems: ["http://nooot.co/text/\(self.notesList[indexPath.row])"], applicationActivities: nil)
//            activityVC.popoverPresentationController?.sourceView = self.view
//            
//            self.present(activityVC, animated: true, completion: nil)
//            self.historyTableView.isEditing = false
//        }
//        
//        shareAction.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        
//        // Удаление заметки
//        
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            print("delete")
//            
//            self.manager.removeNoteDataFronDB(title: self.notesList[indexPath.row])
//            self.notesList.remove(at: indexPath.row)
//            self.historyTableView.reloadData()
//            self.historyTableView.isEditing = false
//        }
//        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        
//        return [deleteAction, shareAction]
//    }
}

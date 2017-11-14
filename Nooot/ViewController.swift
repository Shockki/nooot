//
//  ViewController.swift
//  Nooot
//
//  Created by Анатолий on 20.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var historyTableViewTwo: UITableView!
    @IBOutlet weak var labelHello: UILabel!
    @IBOutlet weak var labelBodyText: UILabel!
    @IBOutlet weak var buttonDeleteAll: UIButton!
    @IBOutlet weak var buttonDeleteAllTwo: UIButton!
    @IBOutlet weak var visited: UILabel!
    @IBOutlet weak var visitedTwo: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var addNewNoteView: UIView!
    @IBOutlet weak var textFieldAddNote: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelNoteTitleOnView: UILabel!
    
    var noteText: String = ""
    var notesList: [String] = []
    var notesReverse: [String] = []
    let manager: ManagerData = ManagerData()
    let settings: FuncSettings = FuncSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        textFieldAddNote.delegate = self
        buttonDeleteAll.titleLabel?.adjustsFontSizeToFitWidth = true
        viewBackground.alpha = 0
        addNewNoteView.alpha = 0
        
        addNewNoteView.layer.cornerRadius = 16
        textFieldAddNote.layer.cornerRadius = 11
        labelNoteTitleOnView.text! = NSLocalizedString("Note title", comment: "")
        // Меняет положение курсора
        textFieldAddNote.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textFieldAddNote.leftViewMode = .always
        addNewNoteView.frame = CGRect(x: addNewNoteView.frame.origin.x, y: addNewNoteView.frame.origin.y - 200, width: addNewNoteView.frame.size.width, height: addNewNoteView.frame.size.height)
        
        notesReverse = manager.getAllNotes()
        notesList = manager.reverseNotes(input: notesReverse)
        settings.sizeTableView(notesList: notesList, historyTableView: historyTableView, historyTableViewTwo: historyTableViewTwo)
    }
    
// Действие, когда пользователь касается внешнего вида
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == viewBackground){
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.4, animations: { self.viewBackground.alpha = 0 })
            UIView.animate(withDuration: 0.4, animations: {
                self.addNewNoteView.frame = CGRect(x: self.addNewNoteView.frame.origin.x, y: self.addNewNoteView.frame.origin.y - 200, width: self.addNewNoteView.frame.size.width, height: self.addNewNoteView.frame.size.height)
            })
        }
    }
    
// Кнопка удаления всей истории
    
    @IBAction func removeAllHistoryNotes(_ sender: Any) {
        removeAllNotes()
    }
    @IBAction func removeAllHistoryNotesTwo(_ sender: Any) {
        removeAllNotes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAddNewNote(_ sender: Any) {
        
        // Анимация появления View
        self.addNewNoteView.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.addNewNoteView.frame = CGRect(x: self.addNewNoteView.frame.origin.x, y: self.addNewNoteView.frame.origin.y + 200, width: self.addNewNoteView.frame.size.width, height: self.addNewNoteView.frame.size.height)
        })
        UIView.animate(withDuration: 0.6, animations: { self.viewBackground.alpha = 0.38 })
        textFieldAddNote.becomeFirstResponder() // Появляется клавиатура
    }

    @IBAction func buttonGoText(_ sender: Any) {
        performAction()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performAction()
        return true
    }
    
    func performAction() {
        if textFieldAddNote.text!.isEmpty {
            settings.shakeView(addNewNoteView)
        } else {
            textFieldAddNote.resignFirstResponder() // Скрывает клавиатуру
            performSegue(withIdentifier: "goText", sender: self)
        }
    }
    
    func removeAllNotes() {
        let alertContr = UIAlertController(title: NSLocalizedString("Are you sure you want to clear history?", comment: ""), message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
            self.manager.removeAllNoteDataFromDB()
            self.notesList.removeAll()
            self.settings.sizeTableView(notesList: self.notesList, historyTableView: self.historyTableView, historyTableViewTwo: self.historyTableViewTwo)
        }
        let actionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertContr.addAction(actionDelete)
        alertContr.addAction(actionCancel)
        present(alertContr, animated: true, completion: nil)
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
        cell.indentationWidth = 2
        cell.indentationLevel = 2

        // Изменение цвета при нажатии:
        
        // Цвет бекграунда
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.00336881564, green: 0.483507812, blue: 0.999037087, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        // Цвет текста
        cell.textLabel?.highlightedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let indexPath = historyTableView.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.titleName = notesList[indexPath.row]
                
            }else if let indexPath = historyTableViewTwo.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.titleName = notesList[indexPath.row]
            }
        }
        if segue.identifier == "goText" {
            let destVC: TextViewController = segue.destination as! TextViewController
            destVC.titleName.append(textFieldAddNote.text!)
        }
    }
    
//    // Action swiping
//
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
//        shareAction.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
//
//        // Удаление заметки
//
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            print("delete")
//
//            self.manager.removeNoteDataFromDB(title: self.notesList[indexPath.row])
//            self.notesList.remove(at: indexPath.row)
//            self.historyTableView.reloadData()
//            self.historyTableView.isEditing = false
//        }
//        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//
//        return [deleteAction, shareAction]
//    }
}

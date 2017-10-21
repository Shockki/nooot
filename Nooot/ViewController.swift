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
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var but1: UIButton!
    @IBOutlet weak var but2: UIButton!
    @IBOutlet weak var but3: UIButton!
    
    @IBOutlet weak var addNewNoteView: UIView!
    @IBOutlet weak var textFieldAddNote: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelNoteTitleOnView: UILabel!
    
    var noteText: String = ""
    var notesList: [String] = []
    var notesReverse: [String] = []
    let manager: ManagerData = ManagerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        textFieldAddNote.delegate = self
        buttonDeleteAll.titleLabel?.adjustsFontSizeToFitWidth = true
        navigationController?.navigationBar.shadowImage = UIImage()
        viewBackground.alpha = 0
        addNewNoteView.alpha = 0
        disButton(butt: but1)
        disButton(butt: but2)
        disButton(butt: but3)
        
        notesReverse = manager.getAllNotes()
        notesList = manager.reverseNotes(input: notesReverse)
        sizeTableView()
    }
    
// Скрывает клавиатуру, когда пользователь касается внешнего вида
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == viewBackground){
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.4, animations: { self.viewBackground.alpha = 0 })
            UIView.animate(withDuration: 0.4, animations: { self.addNewNoteView.alpha = 0 })
            
            print("dismiss")
        }
    }
    
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
    
    @IBAction func buttonAddNewNote(_ sender: Any) {
        addNewNoteView.layer.cornerRadius = 16
        textFieldAddNote.layer.cornerRadius = 11
        labelNoteTitleOnView.text! = NSLocalizedString("Note title", comment: "")
        textFieldAddNote.becomeFirstResponder() // Появляется клавиатура
        
        // Меняет положение курсора
        textFieldAddNote.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textFieldAddNote.leftViewMode = .always
        
        // Анимация появления View
        addNewNoteView.alpha = 1
        addNewNoteView.transform = CGAffineTransform(scaleX: 0.3, y: 2)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.addNewNoteView.transform = .identity
        })
        UIView.animate(withDuration: 0.6, animations: { self.viewBackground.alpha = 0.38 })        
    }

    @IBAction func buttonGoText(_ sender: Any) {
        performAction()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performAction()
        textFieldAddNote.resignFirstResponder() // Скрывает клавиатуру
        return true
    }
    
    func performAction() {
        if textFieldAddNote.text!.isEmpty {
            textFieldAddNote.resignFirstResponder()
            let alertContr = UIAlertController(title: NSLocalizedString("Enter title of the note", comment: ""), message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            }
            alertContr.addAction(action)
            present(alertContr, animated: true, completion: nil)
        } else {
            textFieldAddNote.resignFirstResponder()
            performSegue(withIdentifier: "goText", sender: self)
        }
    }
    
    func removeAll() {
        let alertContr = UIAlertController(title: NSLocalizedString("Are you sure you want to clear history?", comment: ""), message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
            self.manager.removeAllNoteDataFronDB()
            self.notesList.removeAll()
            self.historyTableViewTwo.reloadData()
            self.sizeTableView()
            self.view.setNeedsDisplay()
        }
        let actionCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertContr.addAction(actionDelete)
        alertContr.addAction(actionCancel)
        present(alertContr, animated: true, completion: nil)
    }
    
    func sizeTableView() {
        switch notesList.count {
        case 0:
            UIView.animate(withDuration: 0.2, animations: {
                self.historyTableViewTwo.alpha = 0
                self.historyView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: {
                self.historyTableViewTwo.alpha = 0
                self.historyView.alpha = 1
                self.but1.setTitle(self.notesList[0], for: .normal)
                self.but2.alpha = 0
                self.but3.alpha = 0
            })
        case 2:
            UIView.animate(withDuration: 0.2, animations: {
                self.historyTableViewTwo.alpha = 0
                self.historyView.alpha = 1
                self.but1.setTitle(self.notesList[0], for: .normal)
                self.but2.setTitle(self.notesList[1], for: .normal)
                self.but2.alpha = 1
                self.but3.alpha = 0
            })
        case 3:
            UIView.animate(withDuration: 0.2, animations: {
                self.historyTableViewTwo.alpha = 0
                self.historyView.alpha = 1
                self.but1.setTitle(self.notesList[0], for: .normal)
                self.but2.setTitle(self.notesList[1], for: .normal)
                self.but3.setTitle(self.notesList[2], for: .normal)
                self.but2.alpha = 1
                self.but3.alpha = 1
            })
            
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.historyView.alpha = 0
                self.historyTableViewTwo.alpha = 1
                self.historyTableViewTwo.reloadData()
            })
        }
    }
    
    func disButton (butt: UIButton) {
        butt.layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        butt.layer.shadowOpacity = 1
        butt.layer.shadowRadius = 1
        butt.layer.shadowOffset = CGSize(width: 2, height: 1)
        butt.layer.masksToBounds = false
//        butt.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: .normal)
    }
    
    @IBAction func but1(_ sender: Any) {
        but1.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        but1.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        performSegue(withIdentifier: "but1", sender: self)
    }
    @IBAction func but2(_ sender: Any) {
        but2.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        but2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        performSegue(withIdentifier: "but2", sender: self)
    }
    @IBAction func but3(_ sender: Any) {
        but3.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        but3.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        performSegue(withIdentifier: "but2", sender: self)
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
        if segue .identifier == "details" {
          if let indexPath = historyTableViewTwo.indexPathForSelectedRow {
                let destVC: TextViewController = segue.destination as! TextViewController
                destVC.titleName = notesList[indexPath.row]
            }
        }
        if segue.identifier == "goText" {
            let destVC: TextViewController = segue.destination as! TextViewController
            destVC.titleName.append(textFieldAddNote.text!)
        }
        if segue.identifier == "but1" {
            let destVC: TextViewController = segue.destination as! TextViewController
            destVC.titleName.append(but1.titleLabel!.text!)
        }
        if segue.identifier == "but2" {
            let destVC: TextViewController = segue.destination as! TextViewController
            destVC.titleName.append(but2.titleLabel!.text!)
        }
        if segue.identifier == "but3" {
            let destVC: TextViewController = segue.destination as! TextViewController
            destVC.titleName.append(but3.titleLabel!.text!)
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

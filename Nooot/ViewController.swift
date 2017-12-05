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
    @IBOutlet weak var buttonShowView: UIButton!
    
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        textFieldAddNote.delegate = self
        buttonDeleteAll.titleLabel?.adjustsFontSizeToFitWidth = true
        viewBackground.alpha = 0
        addNewNoteView.alpha = 0
        buttonShowView.alpha = 1
        
        addNewNoteView.layer.cornerRadius = 16
        textFieldAddNote.layer.cornerRadius = 11
        labelNoteTitleOnView.text! = NSLocalizedString("Note title", comment: "")
        // Меняет положение курсора
        textFieldAddNote.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textFieldAddNote.leftViewMode = .always
        addNewNoteView.frame = CGRect(x: addNewNoteView.frame.origin.x, y: addNewNoteView.frame.origin.y - 150, width: addNewNoteView.frame.size.width, height: addNewNoteView.frame.size.height)
        
        notesReverse = manager.getAllNotes()
        for note in notesReverse {
            notesList.append(manager.spaceDel(title: note))
        }
        notesList = manager.reverseNotes(input: notesList)
        settings.sizeTableView(notesList: notesList, historyTableView: historyTableView, historyTableViewTwo: historyTableViewTwo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        buttonShowView.alpha = 1
        notesReverse = manager.getAllNotes()
        notesList.removeAll()
        for note in notesReverse {
            notesList.append(manager.spaceDel(title: note))
        }
        notesList = manager.reverseNotes(input: notesList)
        settings.sizeTableView(notesList: notesList, historyTableView: historyTableView, historyTableViewTwo: historyTableViewTwo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonAddNewNote(_ sender: Any) {
        // Анимация появления View
        textFieldAddNote.text? = ""
        self.addNewNoteView.alpha = 1
        self.buttonShowView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.addNewNoteView.frame = CGRect(x: self.addNewNoteView.frame.origin.x, y: self.addNewNoteView.frame.origin.y + 150, width: self.addNewNoteView.frame.size.width, height: self.addNewNoteView.frame.size.height)
//                self.navigationController?.isNavigationBarHidden = true
        })
        UIView.animate(withDuration: 0.6, animations: { self.viewBackground.alpha = 0.38 })
        textFieldAddNote.becomeFirstResponder() // Появляется клавиатура
    }
    
// Действие, когда пользователь касается внешнего вида
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == viewBackground){
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.4, animations: { self.viewBackground.alpha = 0 })
            UIView.animate(withDuration: 0.4, animations: {
                self.addNewNoteView.frame = CGRect(x: self.addNewNoteView.frame.origin.x, y: self.addNewNoteView.frame.origin.y - 150, width: self.addNewNoteView.frame.size.width, height: self.addNewNoteView.frame.size.height)
            })
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .allowAnimatedContent, animations: {
                self.buttonShowView.alpha = 1
            }, completion: nil)
        }
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
//            UIView.animate(withDuration: 0.65, animations: {
//                self.navigationController?.isNavigationBarHidden = false
//            })
            textFieldAddNote.resignFirstResponder() // Скрывает клавиатуру
            UIView.animate(withDuration: 0.3, animations: {
                self.addNewNoteView.frame = CGRect(x: self.addNewNoteView.frame.origin.x, y: self.addNewNoteView.frame.origin.y - 150, width: self.addNewNoteView.frame.size.width, height: self.addNewNoteView.frame.size.height)
                self.viewBackground.alpha = 0
            })
            performSegue(withIdentifier: "goText", sender: self)
        }
    }
    
    @IBAction func removeAllHistoryNotes(_ sender: Any) {
        let alertContr = UIAlertController(title: NSLocalizedString("Are you sure you want to clear history?", comment: ""), message: nil, preferredStyle: .actionSheet)
        let actionDelete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (action) in
            self.manager.removeAllNoteDataFromDB()
            self.notesList.removeAll()
            self.settings.sizeTableView(notesList : self.notesList, historyTableView: self.historyTableView, historyTableViewTwo: self.historyTableViewTwo)
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
        
//        let butBack = UIImage(named: "back")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem = UIBarButtonItem(image: butBack, style: .plain, target: nil, action: nil)
//        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")

    }
}

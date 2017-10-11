//
//  PopupView.swift
//  Nooot
//
//  Created by Анатолий on 30.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class PopupView: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var addNewNoteView: UIView!
    @IBOutlet weak var textFieldAddNote: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    
    var manager: ManagerData = ManagerData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldAddNote.delegate = self
        addNewNoteView.layer.cornerRadius = 16
        textFieldAddNote.layer.cornerRadius = 11
        textFieldAddNote.becomeFirstResponder()


        // Меняет положение курсора
        textFieldAddNote.leftView = UIView(frame: .init(x: 0, y: 0, width: 8, height: 0))
        textFieldAddNote.leftViewMode = .always
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { execute in
//        UIView.animate(withDuration: 1.0, animations: { self.viewBackground.alpha = 0.38 })
//        }
        
    }
    
    @IBAction func buttonAddNewNote(_ sender: Any) {
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
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Если происходит нажатие везде, кроме выбранного View (addNewNoteView)
        let touch = touches.first!
        if(touch.view != addNewNoteView){
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.1, animations: { self.viewBackground.alpha = 0 })
            dismiss(animated: true, completion: nil)
            print("dismiss")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goText" {
            let navCont = segue.destination as! UINavigationController
            let destVC = navCont.topViewController as! TextViewController
            destVC.titleName.append(textFieldAddNote.text!)
        }
    }
}

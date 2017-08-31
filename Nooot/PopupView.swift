//
//  PopupView.swift
//  Nooot
//
//  Created by Анатолий on 30.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class PopupView: UIViewController {

    @IBOutlet weak var addNewNoteView: UIView!
    
    @IBOutlet weak var textFieldAddNote: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewNoteView.layer.cornerRadius = 15
        textFieldAddNote.layer.cornerRadius = 11
    
        

        textFieldAddNote.becomeFirstResponder()
    }
    @IBAction func buttonAddNewNote(_ sender: Any) {
        if textFieldAddNote.text!.isEmpty {
            textFieldAddNote.resignFirstResponder()
            let alertContr = UIAlertController(title: "Введите имя заметки", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default) { (action) in
//                self.textFieldAddNote.becomeFirstResponder()
            }
            alertContr.addAction(action)
            present(alertContr, animated: true, completion: nil)
            
        } else {
            textFieldAddNote.resignFirstResponder()
            performSegue(withIdentifier: "goNewViewNote", sender: nil)
        }
    }
    

    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Если происходит нажатие везде, кроме выбранного View (addNewNoteView)
        let touch = touches.first!
        if(touch.view != addNewNoteView){
            self.view.endEditing(true)
            dismiss(animated: true, completion: nil)
            print("dismiss")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goNewViewNote" {
            let destVC: NewTextViewController = segue.destination as! NewTextViewController
            destVC.noteList.append(textFieldAddNote.text!)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

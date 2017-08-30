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
        textFieldAddNote.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

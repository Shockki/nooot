//
//  TextViewController.swift
//  Nooot
//
//  Created by Анатолий on 21.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var nameOfTitle: UILabel!
   
    
    let manager: ManagerData = ManagerData()
    
    var hisTitleName: String = ""
    var hisBodyText: String = ""
    var notesList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.loadJSON(title: hisTitleName)
        semaphore.wait()
        
        notesList = manager.getAllNotes()
        hisTitleName = notesList.last!
        
        nameOfTitle.text! = hisTitleName
        historyTextView.text! = manager.getNoteDataText(title: hisTitleName)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

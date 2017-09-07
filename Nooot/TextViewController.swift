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
    
    var titleName: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---------------------------------------------")
        
        manager.loadJSON(title: titleName)
        
        semaphore.wait()
        titleName = manager.getAllNotes().last!
        historyTextView.text? =  manager.getNoteDataText(title: titleName)
        nameOfTitle.text! = titleName
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

//
//  TextViewController.swift
//  Nooot
//
//  Created by Анатолий on 21.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var nameOfTitle: UILabel!
    @IBOutlet weak var idLabel: UILabel!
   
    
    let manager: ManagerData = ManagerData()
    
    var titleName: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        print("---------------------------------------------")
        
        manager.loadJSON(title: titleName)
        semaphore.wait()
        
        titleName = manager.returnText(titleName: titleName)
        print(titleName)
        
        nameOfTitle.text! = titleName
        idLabel.text! = manager.getNoteDataId(title: titleName)
        historyTextView.text? =  manager.getNoteDataText(title: titleName)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}

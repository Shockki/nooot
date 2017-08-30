//
//  TextViewController.swift
//  Nooot
//
//  Created by Анатолий on 21.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UINavigationBarDelegate {

    
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var nameOfTitle: UILabel!
   
    
    let manager: ManagerData = ManagerData()
    
    var hisTitleName: String = ""
    var hisBodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameOfTitle.text! = hisTitleName
        historyTextView.text! = manager.getNoteDataText(title: hisTitleName)

    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
}

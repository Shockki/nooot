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
   
    let manager: ManagerData = ManagerData()
    
    var titleName: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        
        manager.loadJSON(title: titleName)
        semaphore.wait()
        
        titleName = manager.returnText(titleName: titleName)
        print(titleName)
        
        nameOfTitle.text! = titleName
        historyTextView.text? =  manager.getNoteDataText(title: titleName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        historyTextView.resignFirstResponder()
        
        let alertContr = UIAlertController(title: "Готово!", message: nil, preferredStyle: .alert)
        self.present(alertContr, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) { execute in alertContr.dismiss(animated: true, completion: nil)}
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

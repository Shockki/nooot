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
    @IBOutlet weak var doneButton: UIButton!
    
    
    let manager: ManagerData = ManagerData()
    
    var titleName: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        doneButton.alpha = 0
        
        manager.loadJSON(title: titleName)
        semaphore.wait()
        
        titleName = manager.returnText(titleName: titleName)      
        nameOfTitle.text! = titleName
        bodyText =  manager.getNoteDataText(title: titleName)
        if bodyText.isEmpty {
            historyTextView.text? = NSLocalizedString("Enter text..", comment: "")
        }else{
            historyTextView.text? = bodyText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        doneButton.alpha = 1
        return true
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        historyTextView.resignFirstResponder()
        doneButton.alpha = 0
        
        let alertContr = UIAlertController(title: NSLocalizedString("Ready!", comment: ""), message: nil, preferredStyle: .alert)
        self.present(alertContr, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) { execute in alertContr.dismiss(animated: true, completion: nil)}
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        doneButton.alpha = 0
        self.view.endEditing(true)
    }
}

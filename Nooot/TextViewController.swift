//
//  TextViewController.swift
//  Nooot
//
//  Created by Анатолий on 21.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
   
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var nameOfTitle: UILabel!
    @IBOutlet weak var doneButton: UIButton!
        
    let manager: ManagerData = ManagerData()
    let settings: FuncSettings = FuncSettings()
    
    var titleName: String = ""
    var bodyText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        doneButton.alpha = 0
  
        manager.loadJSON(title: titleName)
        semaphore.wait()

        titleName = manager.returnText(titleName: titleName)      
        nameOfTitle.text! = manager.spaceDel(title: titleName)
        bodyText =  manager.getNoteDataText(title: titleName)
        if bodyText.isEmpty {
            historyTextView.text? = NSLocalizedString("Your note...", comment: "")
        }else{
            historyTextView.text? = bodyText
            settings.searchLinks(bodyText: bodyText, textView: historyTextView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        doneButton.alpha = 1
        if historyTextView.text! == NSLocalizedString("Your note...", comment: "") {
            historyTextView.text? = ""
        }
        return true
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        historyTextView.resignFirstResponder()
        doneButton.alpha = 0
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        performSegue(withIdentifier: "goHome", sender: self)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if historyTextView.text.isEmpty {
            if bodyText.isEmpty {
                historyTextView.text? = NSLocalizedString("Your note...", comment: "")
            }else{
                historyTextView.text? = bodyText
            }
        }
        doneButton.alpha = 0
        self.view.endEditing(true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}






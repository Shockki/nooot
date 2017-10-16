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
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe(swipe:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
  
        manager.loadJSON(title: titleName)
        semaphore.wait()

        titleName = manager.returnText(titleName: titleName)      
        nameOfTitle.text! = titleName
        bodyText =  manager.getNoteDataText(title: titleName)
        if bodyText.isEmpty {
            historyTextView.text? = NSLocalizedString("Your note...", comment: "")
        }else{
            historyTextView.text? = bodyText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func actionSwipe(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .right {
            performSegue(withIdentifier: "goHome", sender: self)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        doneButton.alpha = 1
        if bodyText.isEmpty {
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
        doneButton.alpha = 0
        if bodyText.isEmpty {
            historyTextView.text? = NSLocalizedString("Your note...", comment: "")
        }
        self.view.endEditing(true)
    }
}

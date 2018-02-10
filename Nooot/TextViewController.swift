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
    let reachability: Reachability = Reachability()!
    
    var titleName: String = ""
    var bodyText: String = ""
    let yourNote = NSLocalizedString("Your note...", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        historyTextView.textContainerInset = UIEdgeInsetsMake(20, 11, 50, 11)
        
        automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        doneButton.isHidden = true
        
        //  Проверка на изменение интернета
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("error")
        }
        
        if bodyText.isEmpty {
            settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))

        }else{
            settings.textSettings(historyTextView, bodyText)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        doneButton.isHidden = false
        if historyTextView.text! == NSLocalizedString("Your note...", comment: "") {
            historyTextView.text? = ""
            historyTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        doneButton.isHidden = true
        if historyTextView.text.isEmpty {
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }
        }
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        historyTextView.resignFirstResponder()
        doneButton.isHidden = true
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.popViewController(animated: true)
    }
    
    func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            historyTextView.contentInset = UIEdgeInsets.zero
        }else{
            historyTextView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: keyboardEndFrame.height + 80, right: 0)
//            historyTextView.scrollIndicatorInsets = historyTextView.contentInset
        }
        historyTextView.scrollRangeToVisible(historyTextView.selectedRange)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
    func internetAvailable() {
        manager.loadJSON(title: titleName)
        semaphore.wait()
            
        titleName = manager.returnText(titleName: titleName)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        title = titleName.replacingOccurrences(of: "%20", with: " ")
        bodyText =  manager.getNoteDataText(title: titleName)
        historyTextView.isEditable = true
    }
    
    func internetNotAvailable() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
        title = titleName.replacingOccurrences(of: "%20", with: " ")
        bodyText =  manager.getNoteDataText(title: titleName)
        historyTextView.isEditable = false
    }
    
    func internetChanged(note:Notification) {
        let reach = note.object as! Reachability
        if reach.connection == .none {
            DispatchQueue.main.async {
                self.internetNotAvailable()
            }
        }else{
            DispatchQueue.main.async {
                self.internetAvailable()
            }
        }
    }
}







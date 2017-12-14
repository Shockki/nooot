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
        navSettings()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        historyTextView.textContainerInset = UIEdgeInsetsMake(20, 11, 50, 11)
        
        automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        doneButton.isHidden = true
  
        manager.loadJSON(title: titleName)
        semaphore.wait()

        titleName = manager.returnText(titleName: titleName)      
        title = manager.spaceDel(title: titleName)
        bodyText =  manager.getNoteDataText(title: titleName)
        
        if bodyText.isEmpty {
            historyTextView.text? = NSLocalizedString("Your note...", comment: "")
            historyTextView.textColor = #colorLiteral(red: 0.5137254902, green: 0.5098039216, blue: 0.5333333333, alpha: 1)
        }else{
            settings.textSettings(historyTextView, bodyText)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navSettings()
    }
    
    func navSettings() {
        navigationController?.navigationBar.layer.shadowColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 0
        navigationController?.navigationBar.layer.shadowOpacity = 3
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        doneButton.isHidden = false
        if historyTextView.text! == NSLocalizedString("Your note...", comment: "") {
            historyTextView.text? = ""
            historyTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return true
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        historyTextView.resignFirstResponder()
        doneButton.isHidden = true
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if historyTextView.text.isEmpty {
            if bodyText.isEmpty {
                historyTextView.text? = NSLocalizedString("Your note...", comment: "")
                historyTextView.textColor = #colorLiteral(red: 0.5137254902, green: 0.5098039216, blue: 0.5333333333, alpha: 1)
            }
        }
        doneButton.isHidden = true
        self.view.endEditing(true)
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
}

extension UINavigationBar {
    func setBottomBorderColor(color: UIColor?, height: CGFloat, onOff: Bool) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        if onOff == true {
            addSubview(bottomBorderView)
        }
    }
}






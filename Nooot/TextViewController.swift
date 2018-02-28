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
    @IBOutlet weak var doneButton: UIButton!
    
    let manager: ManagerData = ManagerData()
    let settings: FuncSettings = FuncSettings()
    let reachability: Reachability = Reachability()!
    
    var titleName: String = ""
    var subtitle: String = ""
    var bodyText: String = ""
    var checkBodyText: String = ""
    var date: [Int] = []
    var checkDate: Bool = false
    var arrayNote: [String] = []
    let yourNote = NSLocalizedString("Your note...", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTextView.delegate = self
        settings.historyTextView = historyTextView
        settings.navContr = navigationController
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        historyTextView.textContainerInset = UIEdgeInsetsMake(20, 11, 50, 11)
        navigationController?.setNavigationBarHidden(false, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        doneButton.isHidden = true
        historyTextView.isEditable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        //  Проверка на изменение интернета
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
            print("*************************************************")
        }catch{
            print("error")
        }
        
//        if reachability.connection == .none {
//            internetNotAvailable()
//        }else{
//            internetAvailable()
//        }
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
        historyTextView.isEditable = false
        historyTextView.dataDetectorTypes = .link
        if historyTextView.text.isEmpty {
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }
        }
    }
    
    @IBAction func buttonSaveText(_ sender: Any) {
        navigationItem.titleView = settings.setTitle(title: titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "сохранение изменений...")
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        manager.refresh_Text(title: titleName, newBodyText: historyTextView.text)
        manager.refresh_Date(title: titleName)
        historyTextView.resignFirstResponder()
        doneButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: (.now() + 1), execute: {
            self.navigationItem.titleView = self.settings.setTitle(title: self.titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия")
        })
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
    
    //MARK: Интернет доступен
    func internetAvailable() {
        print("internet Available")
        
        historyTextView.dataDetectorTypes = .link
        if titleName.isEmpty {
            titleName = manager.getAllNotes().last!
            bodyText = manager.getNoteData_Text(title: titleName)
            navigationItem.titleView = settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия")
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }else{
                settings.textSettings(historyTextView, bodyText)
            }
        }else{
            checkBodyText = manager.returnNewText(title: titleName)
            bodyText = manager.getNoteData_Text(title: titleName)
            if checkBodyText == bodyText {
                date = manager.getNoteData_Date(title: titleName)
            }else{
                bodyText = checkBodyText
                manager.delete_Date(title: titleName)
                date = manager.getNoteData_Date(title: titleName)
            }
            
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }else{
                settings.textSettings(historyTextView, bodyText)
            }
            
            if settings.checkDate(date: date) == false {
                navigationItem.titleView = settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия")
            }else{
                navigationItem.titleView = settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: settings.subtitle(today: date))
            }
        }
    }
    @objc func textViewTapped(_ aRecognizer: UITapGestureRecognizer) {
        historyTextView.dataDetectorTypes = []
        historyTextView.isEditable = true
        historyTextView.becomeFirstResponder()
    }

    //MARK: Интернет недоступен
    func internetNotAvailable() {
        print("internet Not Available")

        historyTextView.dataDetectorTypes = []
        bodyText = manager.getNoteData_Text(title: titleName)
        if bodyText.isEmpty {
            settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
        }else{
            settings.textSettings(historyTextView, bodyText)
        }
        navigationItem.titleView = settings.setTitle(title: titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "отсутствует подключение к интернету...")
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

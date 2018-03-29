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
    let socket: SocketData = SocketData()
    
    var titleName: String = ""
    var checkTitleName = false
    var subtitle: String = ""
    var bodyText: String = ""
    var checkBodyText: String = ""
    var id: String = ""
    var date: [Int] = []
    var checkDate: Bool = false
    var arrayNote: [String] = []
    let yourNote = NSLocalizedString("Your note...", comment: "")
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n")
        if titleName.isEmpty {
            checkTitleName = false
            titleName = manager.getAllNotes().last!
            socket.titleName = titleName.replacingOccurrences(of: "%20", with: " ")
            socket.id = manager.getNoteData_Id(title: titleName)
        }else{
            checkTitleName = true
            socket.titleName = titleName.replacingOccurrences(of: "%20", with: " ")
            socket.id = manager.getNoteData_Id(title: titleName)
        }
        socket.textView = historyTextView
        socket.navContr = navigationController
        socket.navItem = navigationItem
        
        settings.activityIndicator(indicator, view)
        settings.historyTextView = historyTextView
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        historyTextView.textContainerInset = UIEdgeInsetsMake(20, 11, 50, 11)
        navigationController?.setNavigationBarHidden(false, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        doneButton.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        //  Проверка на изменение интернета
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("error")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print("viewWillAppear")
        indicator.startAnimating()
        socket.startSocket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        indicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        socket.disconnect()
        if socket.check == true{
            manager.refresh_Text(title: titleName, newBodyText: historyTextView.text)
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
        settings.setTitle(title: titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "сохранение изменений...", navContr: navigationController, navItem: navigationItem)
        manager.saveNoteText(title: titleName, body: historyTextView.text)
        manager.refresh_Text(title: titleName, newBodyText: historyTextView.text)
//        manager.refresh_Date(title: titleName)
        historyTextView.resignFirstResponder()
        doneButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: (.now() + 0.5), execute: {
            self.settings.setTitle(title: self.titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия", navContr: self.navigationController, navItem: self.navigationItem)
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
        print("Интернет доступен")
        if checkTitleName == false {
            titleName = manager.getAllNotes().last!
            socket.titleName = titleName.replacingOccurrences(of: "%20", with: " ")
            socket.id = manager.getNoteData_Id(title: titleName)
            bodyText = manager.getNoteData_Text(title: titleName)
            manager.delete_Date(title: titleName)
//            settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия", navContr: navigationController!, navItem: navigationItem)
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }else{
                settings.textSettings(historyTextView, bodyText)
            }
        }else{
            socket.titleName = titleName.replacingOccurrences(of: "%20", with: " ")
            socket.id = manager.getNoteData_Id(title: titleName)
            
            checkBodyText = manager.returnNewText(title: titleName)
            bodyText = manager.getNoteData_Text(title: titleName)
            if checkBodyText == bodyText {
                date = manager.getNoteData_Date(title: titleName)
            }else{
                bodyText = checkBodyText
                manager.delete_Date(title: titleName)
                date = manager.getNoteData_Date(title: titleName)
            }
//            if settings.checkDate(date: date) == false {
//                settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "актуальная версия", navContr: navigationController, navItem: navigationItem)
//            }else{
//                settings.setTitle(title: titleName.replacingOccurrences(of: "%20", with: " "), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: settings.subtitle(today: date), navContr: navigationController, navItem: navigationItem)
//            }
            
            if bodyText.isEmpty {
                settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
            }else{
                settings.textSettings(historyTextView, bodyText)
            }
        }
        indicator.stopAnimating()
    }
    
//    @objc func textViewTapped(_ aRecognizer: UITapGestureRecognizer) {
//        historyTextView.dataDetectorTypes = []
//        historyTextView.isEditable = true
//        historyTextView.becomeFirstResponder()
//    }

    //MARK: Интернет недоступен
    func internetNotAvailable() {
        print("Интернет НЕ доступен")
        historyTextView.dataDetectorTypes = []
        historyTextView.isEditable = false
        bodyText = manager.getNoteData_Text(title: titleName)
        settings.setTitle(title: titleName, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), subtitle: "отсутствует подключение к интернету...", navContr: navigationController, navItem: navigationItem)
        if bodyText.isEmpty {
            settings.textSettings(historyTextView, NSLocalizedString("Your note...", comment: ""))
        }else{
            settings.textSettings(historyTextView, bodyText)
        }
        indicator.stopAnimating()
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

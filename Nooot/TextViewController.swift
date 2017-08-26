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
    @IBOutlet weak var nameOfTitle: UINavigationItem!
    
    let manager: ManagerData = ManagerData()
    
    var hisTitleName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameOfTitle.title! = hisTitleName
        historyTextView.text! = manager.getNoteDataText(title: hisTitleName)
        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["http://nooot.co/text/\(hisTitleName)"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
}

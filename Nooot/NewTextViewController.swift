//
//  NewTextViewController.swift
//  Nooot
//
//  Created by Анатолий on 30.08.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import UIKit

class NewTextViewController: UIViewController {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    var manager: ManagerData = ManagerData()
    var noteList: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.loadJSON(title: noteList)
        
        semaphore.wait()
        noteList = manager.getAllNotes().last!
        textView.text? =  manager.getNoteDataText(title: noteList)
        labelTitle.text! = noteList
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goNewViewNote(segue: UIStoryboardSegue) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

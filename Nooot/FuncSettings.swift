//
//  FuncSettings.swift
//  Nooot
//
//  Created by Анатолий on 06.11.17.
//  Copyright © 2017 Анатолий Модестов. All rights reserved.
//

import Foundation
import UIKit

class FuncSettings {
    
    func sizeTableView(notesList: [String], historyTableViewTwo: UITableView, historyView: UIView, but1: UIButton, but2: UIButton, but3: UIButton) {
        switch notesList.count {
        case 0:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyView.alpha = 1
                but1.setTitle(notesList[0], for: .normal)
                but2.alpha = 0
                but3.alpha = 0
            })
        case 2:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyView.alpha = 1
                but1.setTitle(notesList[0], for: .normal)
                but2.setTitle(notesList[1], for: .normal)
                but2.alpha = 1
                but3.alpha = 0
            })
        case 3:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyView.alpha = 1
                but1.setTitle(notesList[0], for: .normal)
                but2.setTitle(notesList[1], for: .normal)
                but3.setTitle(notesList[2], for: .normal)
                but2.alpha = 1
                but3.alpha = 1
            })
            
        default:
            UIView.animate(withDuration: 0.2, animations: {
                historyView.alpha = 0
                historyTableViewTwo.alpha = 1
                historyTableViewTwo.reloadData()
            })
        }
    }
    
    func shakeView(_ vw: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: vw.center.x - 4, y: vw.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: vw.center.x + 4, y: vw.center.y))
        
        vw.layer.add(animation, forKey: "position")
    }
    
    func settingsButton (_ button: UIButton) {
        button.layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 2, height: 1)
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(FuncSettings.butHighlight(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(FuncSettings.butNormal(_:)), for: .touchUpInside)
    }
    
    @objc private func butHighlight(_ but: UIButton) {
        but.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .highlighted)
        but.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    @objc private func butNormal(_ but: UIButton) {
        but.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .highlighted)
        but.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

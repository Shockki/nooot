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
    
    func sizeTableView(notesList: [String], historyTableView: UITableView, historyTableViewTwo: UITableView) {
        switch notesList.count {
        case 0:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 1
            })
        case 2:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 1
            })
        case 3:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 1
            })
            
        default:
            UIView.animate(withDuration: 0.2, animations: {
                historyTableView.alpha = 0
                historyTableViewTwo.alpha = 1
                historyTableViewTwo.reloadData()
            })
        }
    }
    
    func shakeView(_ vw: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2.5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: vw.center.x - 4, y: vw.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: vw.center.x + 4, y: vw.center.y))
        
        vw.layer.add(animation, forKey: "position")
    }
}

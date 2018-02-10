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
    let manager: ManagerData = ManagerData()
    
    func sizeTableView(notesList: [String], historyTableView: UITableView, historyTableViewTwo: UITableView) {
        switch notesList.count {
        case 0:
            UIView.animate(withDuration: 0.15, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 0
            })
        case 1...3:
            UIView.animate(withDuration: 0.15, animations: {
                historyTableViewTwo.alpha = 0
                historyTableView.alpha = 1
                historyTableView.reloadData()
            })            
        default:
            UIView.animate(withDuration: 0.15, animations: {
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
    
    func colorTitle(title: String, colorTitle: UIColor) -> NSMutableAttributedString {
        let attributes = [NSForegroundColorAttributeName: colorTitle]
        let attrString = NSMutableAttributedString(string: title.replacingOccurrences(of: "%20", with: " "), attributes: attributes)
        return attrString
    }
    
    func textSettings(_ historyTextView: UITextView, _ bodyText: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        var colorAttr = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        paragraphStyle.lineHeightMultiple = 22.0
        paragraphStyle.maximumLineHeight = 22.0
        paragraphStyle.minimumLineHeight = 22.0
        if bodyText == NSLocalizedString("Your note...", comment: "") {
            colorAttr = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        let attributes = [NSFontAttributeName: UIFont(name: "Kailasa", size: 15), NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: colorAttr]
        let attributedString = NSMutableAttributedString(string: bodyText, attributes: attributes)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
        historyTextView.attributedText = attributedString
    }
    
    func searchLinks(bodyText: String, textView: UITextView)  {
        let colorAttr = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let attributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16), NSForegroundColorAttributeName: colorAttr]
        let attributedString = NSMutableAttributedString(string: bodyText, attributes: attributes)
   
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: bodyText, options: [], range: NSRange(location: 0, length: bodyText.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: bodyText) else { continue }
        
            attributedString.addAttribute(NSLinkAttributeName, value: bodyText[range], range: match.range)
            textView.attributedText = attributedString
        }
    }
    
    func navSettings(_ navigationController: UINavigationController?) {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        navigationController?.navigationBar.layer.shadowRadius = 0
        navigationController?.navigationBar.layer.shadowOpacity = 3
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    }
}









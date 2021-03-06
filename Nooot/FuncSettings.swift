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
    
    var historyTextView: UITextView = UITextView()
    
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
        
        // поиск ссылок
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        let matches = detector.matches(in: bodyText, options: [], range: NSRange(location: 0, length: bodyText.utf16.count))
////        for match in matches {
////            guard let range = Range(match.range, in: bodyText) else { continue }
////            attributedString.addAttribute(NSLinkAttributeName, value: bodyText[range], range: match.range)
////        }
//        if matches.isEmpty {
//            historyTextView.attributedText = attributedString
//            historyTextView.isEditable = true
//        }else{
//            let tap = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
//            historyTextView.addGestureRecognizer(tap)
//            historyTextView.attributedText = attributedString
//        }
        historyTextView.attributedText = attributedString
    }
    
    @objc func textViewTapped(_ aRecognizer: UITapGestureRecognizer) {
        historyTextView.dataDetectorTypes = []
        historyTextView.isEditable = true
        historyTextView.becomeFirstResponder()
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
    
    func activityIndicator(_ activityIndicator: UIActivityIndicatorView, _ view: UIView) {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
    }
    
    func setTitle(title:String,_ colorTitle: UIColor, subtitle:String, navContr: UINavigationController?, navItem: UINavigationItem) {
        let titleLabel = UILabel(frame: CGRect(x:0, y:-5, width:0, height:0))
        let wn = (navContr?.navigationBar.frame.size.width)! / 1.5
        var colorSubtitle = #colorLiteral(red: 0.6106639504, green: 0.6106786728, blue: 0.6106707454, alpha: 1)
        if subtitle == "актуальная версия" {
            colorSubtitle = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = colorTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.frame.size.width = wn
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel(frame: CGRect(x:0, y:18, width:0, height:0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = colorSubtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        subtitleLabel.frame.size.width = wn
        subtitleLabel.textAlignment = .center
        
//        let titleView = UIView(frame: CGRect(x:0, y:0, width:max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height:30))
        let titleView = UIView(frame: CGRect(x:0, y:0, width:wn, height:30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
//        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
//        if widthDiff < 0 {
//            let newX = widthDiff / 2
//            subtitleLabel.frame.origin.x = abs(newX)
//        } else {
//            let newX = widthDiff / 2
//            titleLabel.frame.origin.x = newX
//        }
        navItem.titleView = titleView
    }
    
    //MARK: Возвращает текущую дату
    func date() -> [Int] {
        var d: [Int] = []
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        d.append(year)
        let month = calendar.component(.month, from: date)
        d.append(month)
        let day = calendar.component(.day, from: date)
        d.append(day)
        let hour = calendar.component(.hour, from: date)
        d.append(hour)
        let minutes = calendar.component(.minute, from: date)
        d.append(minutes)
        //    print("Время - \(hour):\(minutes) \(day).\(month).\(year)")
        return d
    }
    
    //MARK: Возвращает статус субтитров
    func subtitle(saved: [Int], onOff: Bool) -> String {
        var date: [Int] = self.date()
        if date[0] == saved[0] { // год
            if date[1] == saved[1] { //месяц
                if date[2] == saved[2] { //день
                    if date[3] == saved[3] { // часы
                        if date[4] - saved[4] == 0 { // минуты
                            if onOff == true {
                                return "актуальная версия"
                            }else{
                                return "сохраненно меньше мин назад"
                            }
                        }else{
                            return "сохраненная версия (\(date[4] - saved[4])мин назад)"
                        }
                    }else{
                        return "сохраненная версия (\(60 - saved[4] + date[4])ч назад)"
                    }
                }else if date[2] - 1 > saved[2] {
                    return "(сохраненная версия (\(saved[2]).\(saved[1]).\(saved[0])))"
                }else if (24 - saved[3] + date[3]) >= 24 {
                    return "сохраненная версия (вчера)"
                }else if (24 - saved[3] + date[3]) <= 24  {
                    if (24 - saved[3] + date[3]) <= 1 {
                        if 60 - saved[4] + date[4] < 60 {
                            return "сохраненная версия (\(60 - saved[4] + date[4])мин назад)"
                        }else{
                            return "сохраненная версия (\(24 - saved[3] + date[3])ч назад)"
                        }
                    }else{
                        return "сохраненная версия (\(24 - saved[3] + date[3])ч назад)"
                    }
                }else{
                    return "сохраненная версия (\(saved[2]).\(saved[1]).\(saved[0]))"
                }
            }else{
                return "сохраненная версия (\(saved[2]).\(saved[1]).\(saved[0]))"
            }
        }else{
            return "сохраненная версия (\(saved[2]).\(saved[1]).\(saved[0]))"
        }
    }
    
    //MARK: Проверка на наличие даты
    func checkDate(date: [Int]) -> Bool {
        if date[0] == 0 && date[1] == 0 && date[2] == 0 && date[3] == 0 && date[4] == 0 {
            return false
        }else{
            return true
        }
    }
    
}









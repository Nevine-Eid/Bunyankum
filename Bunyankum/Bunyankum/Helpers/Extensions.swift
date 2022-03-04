//
//  Extensions.swift
//  3emala
//
//  Created by YoussefRomany on 2/20/20.
//  Copyright © 2019 hardTask. All rights reserved.
//

import Foundation
import UIKit
import Foundation

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}




//MARK: - uilabel
extension UILabel {
    //check if the uilabel truncated
    func isTruncated() -> Bool {
        
        if let string = self.text {
            
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font],
                context: nil).size
            
            return (size.height > self.bounds.size.height)
        }
        
        return false
    }
    
}


extension UIViewController
{
    
    func textAllignment(lable : UILabel)
    {
    if UIApplication.isRTL()  {
    lable.textAlignment = .right
    return
    }
    else
    {
     lable.textAlignment  = .left
    return
    }

    }
    func textAllignment(textview : UITextView)
    {
        if UIApplication.isRTL()  {
            textview.textAlignment = .right
            return
        }
        else
        {
            textview.textAlignment  = .left
            return
        }
        
    }
    
    /// flip any view 180 degree in arabic language
    ///
    /// - Parameter view: any view to flip
    public func flip(view:UIView){
        if UIApplication.isRTL()
        {
            UIView.animate(withDuration: 0.25, animations: {
                view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        }
    }
}


extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}



extension Double {
    var currency: String {
        get {
            return String(self) + " " + localizedSitringFor(key: "currency")
        }
    }
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .transitionFlipFromRight, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}


extension UITextView {
    
    func centerText() {
        self.textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}


extension UILabel {
    func setTextColorToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: myGradient!)
    }
}



extension String {
    
    func containsWithoutIgnoringCase(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func haveTextInField() -> Bool {
        if (self.count>=1) {
            return true
        }
        
        return false
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    /// Apply strike font on text
     /// example ------  someLabel.attributedText = someText.strikeThrough()
     func strikeThrough() -> NSAttributedString {
       let attributeString = NSMutableAttributedString(string: self)
       attributeString.addAttribute(
         NSAttributedString.Key.strikethroughStyle,
         value: 1,
         range: NSRange(location: 0, length: attributeString.length))

         return attributeString
     }
     

     public var replacedArabicDigitsWithEnglish: String {
         var str = self
         let map = ["٠": "0",
                    "١": "1",
                    "٢": "2",
                    "٣": "3",
                    "٤": "4",
                    "٥": "5",
                    "٦": "6",
                    "٧": "7",
                    "٨": "8",
                    "٩": "9"]
         map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
         return str
     }
    
    //right is the first encountered string after left
      func between(_ left: String, _ right: String) -> String? {
          guard
              let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
              , leftRange.upperBound <= rightRange.lowerBound
              else { return nil }
          
          let sub = self[leftRange.upperBound...]
          let closestToLeftRange = sub.range(of: right)!
          return String(sub[..<closestToLeftRange.lowerBound])
      }
      
      var length: Int {
          get {
              return self.count
          }
      }
      
      func substring(to : Int) -> String {
          let toIndex = self.index(self.startIndex, offsetBy: to)
          return String(self[...toIndex])
      }
      
      func substring(from : Int) -> String {
          let fromIndex = self.index(self.startIndex, offsetBy: from)
          return String(self[fromIndex...])
      }
      
      func substring(_ r: Range<Int>) -> String {
          let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
          let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
          let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
          return String(self[indexRange])
      }
      
      func character(_ at: Int) -> Character {
          return self[self.index(self.startIndex, offsetBy: at)]
      }
      
      func lastIndexOfCharacter(_ c: Character) -> Int? {
          return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
      }
}



extension UISearchBar{
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}

public func dateFromString(dateString: String) -> Date?{
    //let dateString = "2019-05-20T12:36:20.102"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    //dateFormatter.locale = Locale.init(identifier: "en_GB")
    return dateFormatter.date(from: dateString)
}

public func stringFromDate(date: Date)->String {
    
    let dateFormatter = DateFormatter()
    if L102Language.isRTL {
        dateFormatter.locale = Locale(identifier: "ar_AR")
    }
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}


public func UTCToLocal(date:String, returnFormat : String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    let dt = dateFormatter.date(from: date)
    print("ddddddddddddddddddddddddddd",dt)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = returnFormat
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    
    return dateFormatter.string(from: dt!)
}



extension UIView{
    
    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))

        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
    
    
    func addConstraintWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UINavigationController {

   func backToViewController(vc: Any) {
      // iterate to find the type of vc
      for element in viewControllers as Array {
        if "\(type(of: element)).Type" == "\(type(of: vc))" {
            self.popToViewController(element, animated: true)
            break
         }
      }
   }

}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}


extension UITabBar {
func tabsVisiblty(_ isVisiblty: Bool = true){
    if isVisiblty {
        self.isHidden = false
        self.layer.zPosition = 0
    } else {
        self.isHidden = true
        self.layer.zPosition = -1
    }
}
}


extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}



extension String {
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    var digitString: String { filter { ("0"..."9").contains($0) } }

}

// var digitString: String { filter { ("0"..."9").contains($0) } }



extension UITableView {
    func registerNib<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell{
        let identifier = String(describing: Cell.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in dequeue cell")
        }
        
        return cell
    }
}


extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            // Fallback on earlier versions
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }
}

extension UIImage {
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

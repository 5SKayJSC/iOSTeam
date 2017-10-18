//
//  StringExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

extension String {
    
    var length : Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        
        return self[start..<end]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    public func indexOfCharacter(_ char: Character) -> Int? {
        if let idx = self.characters.index(of: char) {
            return self.characters.distance(from: self.startIndex, to: idx)
        }
        
        return nil
    }
    
    func stringHeightWithMaxWidth(_ maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [String: AnyObject] = [NSFontAttributeName: font]
        let size: CGSize = self.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        
        return size.height
    }
    
    func evaluateStringWidth(_ font: UIFont) -> CGFloat {
        //let font = UIFont.systemFontOfSize(15)
        let attributes = NSDictionary(object: font, forKey:NSFontAttributeName as NSCopying)
        let sizeOfText = self.size(attributes: (attributes as! [String : AnyObject]))
        
        return sizeOfText.width
    }
    
    func intValue() -> Int {
        if let value = Int(self) {
            return value
        }
        
        return 0
    }
    
    func floatValue() -> Float {
        if let value = Float(self) {
            return value
        }
        
        return 0.0
    }
    
    func doubleValue() -> Double {
        if let value = Double(self) {
            return value
        }
        
        return 0.0
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isValidUsername() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([一-龯]+|[ぁ-んァ-ン]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+)$", options: .caseInsensitive)
            
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,12}"
        let stricterFilterString = "^.{6,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        
        return passwordTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let types:NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, characters.count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
    
    func toUnderlineMutableString(_ color: UIColor) -> NSMutableAttributedString {
        let mutableAtributeString = NSMutableAttributedString(attributedString: NSAttributedString(string: self))
        mutableAtributeString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleDouble.rawValue, range: NSMakeRange(0, self.characters.count))
        mutableAtributeString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, self.characters.count))
        
        return mutableAtributeString
    }
    
    func timeUTCtoDateString(format: String = "YYYY-MM-dd") -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat =  format
        if let timeInterval = Double(self), timeInterval > 0 {
            
            return dateFormater.string(from: Date(timeIntervalSince1970: timeInterval))
        } else {
            
            return ""
        }
    }
    
    func toAtributeHTMLString() -> NSAttributedString? {
        do {
            
            let htmlString = "<font color=\"#383838\">" + self + "</font>"
            let data = htmlString.data(using:
                String.Encoding.unicode, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                let allRange = NSRange(location: 0, length: str.length)
                let newStr = NSMutableAttributedString(attributedString: str)
                newStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 13)], range: allRange)
                return newStr
            }
        } catch {
        }
        return nil
    }
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

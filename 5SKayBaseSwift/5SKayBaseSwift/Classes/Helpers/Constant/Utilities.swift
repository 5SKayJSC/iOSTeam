//
//  Utilities.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation
import UIKit

@objc class  Utilities: NSObject {
    
    /**
     * @brief: Get object from NSUserDefault
     **/
    static func getObject(_ key: String) -> AnyObject? {
        let object: AnyObject? = UserDefaults.standard.object(forKey: key) as AnyObject?
        if let obj: AnyObject = object {
            return NSKeyedUnarchiver.unarchiveObject(with: obj as! Data) as AnyObject?
        } else {
            return nil
        }
    }
    
    /**
     * @brief: Set object to NSUserDefault
     **/
    static func setObject(_ object: AnyObject?, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object!)
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: key)
        userDefaults.synchronize()
    }
    
    static func dateStringFormatter(_ date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // "yyyy-MM-dd'T'HH:mm:ss+00:00"
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "JST")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateInString: String = dateFormatter.string(from: date)
        return dateInString
    }
    
    /**
     Convert unixTime to date & time string
     
     - parameter unixTime: <#unixTime description#>
     
     - returns: string example: 08/31 11:35
     */
    static func timeStringFromUnixTime(_ unixTime: Double, enterDiv: Bool = false) -> String {
        //Convert to Date
        let date = Date(timeIntervalSince1970: unixTime)
        
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if !enterDiv {
            dateFormatter.dateFormat = "MM/dd HH:mm"
        } else {
            dateFormatter.dateFormat = "MM/dd\nHH:mm"
        }
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormatter.string(from: date)
        //print("formatted date is =  \(dateString)")
        return dateString
    }
    
    /**
     * @brief: Convert date string to NSDate
     **/
    static func createDateFormString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let dateToBeSaved = dateFormatter.date(from: dateString) {
            print(dateToBeSaved) // "2015-09-04 22:15:54 +0000"
            return dateToBeSaved
        }
        return nil
    }
    
    class func getCurrentViewController() -> UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("UIAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        
        return presentedVC
    }
    
    
    
    static func loadImageFromUrl(_ url: String, view: UIImageView) {
        
        // Create Url from string
        let url = URL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        })
        
        // Run task
        task.resume()
    }
    
    static func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    static func generateSign(_ name: String?) -> String {
        var stringSign = ""
        
        if name != nil && name!.length > 0 {
            var nameArray = name!
                .components(separatedBy: " ")
            if nameArray.count > 1 {
                let firstCharacter = (((nameArray[0] as String)[0]) as String).uppercased()
                let secondCharacter = (((nameArray[1] as String)[0]) as String).uppercased()
                
                stringSign = "\(firstCharacter)\(secondCharacter)"
            } else {
                nameArray = name!.components(separatedBy: ".")
                if nameArray.count > 1 {
                    let firstCharacter = (((nameArray[0] as String)[0]) as String).uppercased()
                    let secondCharacter = (((nameArray[1] as String)[0]) as String).uppercased()
                    
                    stringSign = "\(firstCharacter)\(secondCharacter)"
                } else {
                    if name!.length > 1 {
                        let string = (name! as NSString).substring(to: 2)
                        stringSign = string.uppercased()
                    } else {
                        stringSign = name!.uppercased()
                    }
                }
            }
        }
        
        return stringSign
    }
    
    static func caculateDistanceTimeFrom(_ date: Date, toDate: Date) -> String {
        var dateString: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        var year: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?//, month: Int?
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let components: DateComponents = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date, to: toDate, options: .matchFirst)
        
        year = components.year
        //month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = components.second
        
        if year! > 0 {
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateString = dateFormatter.string(from: date)
        } else if day! > 0 {
            dateString = dateFormatter.string(from: date)
        } else {
            if hour! <= 12 {
                if hour! <= 0 {
                    if minute! <= 0 {
                        if second! == 1 {
                            dateString = "1 " + LANGTEXT(key: "SECOND").lowercased() + " " + LANGTEXT(key: "AGO").lowercased()
                        } else {
                            dateString = NSString(format:"%0.1d %@ %@", second!, LANGTEXT(key: "SECONDS").lowercased(), LANGTEXT(key: "AGO").lowercased()) as String
                        }
                    } else {
                        if minute! == 1 {
                            dateString = "1 " + LANGTEXT(key: "MINUTE").lowercased() + " " + LANGTEXT(key: "AGO").lowercased()
                        } else {
                            dateString = NSString(format:"%0.1d %@ %@", minute!, LANGTEXT(key: "MINUTES").lowercased(), LANGTEXT(key: "AGO").lowercased()) as String
                        }
                    }
                } else if hour! == 1 {
                    dateString = "1 " + LANGTEXT(key: "HOUR").lowercased() + " " + LANGTEXT(key: "AGO").lowercased()
                } else {
                    dateString = NSString(format:"%0.1d %@ %@", hour!, LANGTEXT(key: "HOURS").lowercased(), LANGTEXT(key: "AGO").lowercased()) as String
                }
            } else {
                dateString = dateFormatter.string(from: date)
            }
        }
        
        return dateString
    }
    
    static func remainingTimeFrom(_ intTime: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var hour: Int?, minute: Int?, second: Int?
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let date = Date(timeIntervalSince1970: TimeInterval(intTime))
        let components: DateComponents = (calendar as NSCalendar).components([.hour, .minute, .second], from: date)
        
        hour = components.hour
        minute = components.minute
        second = components.second
        
        return String(format: "%0.2d:%0.2d:%0.2d", hour ?? 0, minute ?? 0, second ?? 0)
    }
    
    static func calculateAgeFromBirthday(_ birthDay: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let components: DateComponents = (calendar as NSCalendar).components([.year], from: birthDay, to: now, options: .matchFirst)
        let age = components.year
        
        return age!
    }
    
    /**
     reachability class
     
     - returns: NetworkStatus
     */
     
    static func getTopViewController() -> UIViewController? {
        if let currentVC = Utilities.getCurrentViewController() {
            return currentVC
        }
        
        return nil
    }
    
    /**
     draw a text on an image
     
     - parameter drawText: the text is drawed
     - parameter inImage:  image to draw
     - parameter atPoint:  point to draw text
     
     - returns: a image that is drawed the text
     */
    static func drawTextToImage(_ drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 20)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }
    
    /**
     draw textes on an image
     
     - parameter drawTexts: the textes are drawed
     - parameter inImage:   image to draw
     - parameter atPoints:  points to draw text
     
     - returns: a image that is drawed the text
     */
    static func drawTextsToImage(_ drawTexts: [NSString], inImage: UIImage, atPoints: [CGPoint]) -> UIImage {
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 20)
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        for index in 0..<drawTexts.count {
            // Create a point within the space that is as bit as the image
            let rect = CGRect(x: atPoints[index].x, y: atPoints[index].y, width: inImage.size.width, height: inImage.size.height)
            
            // Draw the text into an image
            drawTexts[index].draw(in: rect, withAttributes: textFontAttributes)
        }
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }
    
    class func getCurrentLanguageCode() -> String {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String
    }
    
    class func getOSVersion() -> String {
        return UIDevice.current.systemVersion as String
    }
    
    class func getDeviceOS() -> String {
        return "iOS"
    }
}

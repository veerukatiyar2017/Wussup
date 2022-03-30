//
//  WUExtensions.swift
//  Wussup
//
//  Created by MAC26 on 16/04/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit
import SVProgressHUD

extension Optional {
    var orNil : String {
        if self == nil {
            return "nil"
        }
        if "\(Wrapped.self)" == "String" {
            return "\"\(self!)\""
        }
        return "\(self!)"
    }
}

extension Character {
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}

extension String {
    
    var isMobile : Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        if texttest1.evaluate(with: self){
            return true
        }
        return false
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    
    var isValidEmail : Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if  emailTest.evaluate(with: self){
            return true
        }
        return false
        
    }
    
    var isValidPassword : Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        return passwordTest.evaluate(with: self)
    }

    
    /// Returns trim string
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var trimmedEmoji: String {
        return String(self.filter { !$0.isEmoji() })
    }
    
    /// Returns length of string
    var length: Int{
        return self.count
    }
    
    /// Returns length of string after trim it
    var trimmedLength: Int{
        return self.trimmed.length
    }
    
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    func dateFromCustomString(withFormat format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
    
    func isValidForUrl() -> Bool{
        
        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
}

extension Date {
    
    private static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    
    private static func components(_ fromDate: Date) -> DateComponents! {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    func add(days: Int) -> Date {
        var dateComp = DateComponents()
        dateComp.day = days
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func isToday() -> Bool {
        let comp1 = Date.components(self)
        let comp2 = Date.components(Date())
        return ((comp1!.year == comp2!.year) && (comp1!.month == comp2!.month) && (comp1!.day == comp2!.day))
    }
    
    func isTommorow() -> Bool {
        let comp1 = Date.components(self)
        let comp2 = Date.components(self.tommorow())
        return ((comp1!.year == comp2!.year) && (comp1!.month == comp2!.month) && (comp1!.day == comp2!.day))
    }
    func tommorow() -> Date {
        return Date().add(days: 1)
    }
    
    //2016-10-07T02:33:07.713   yyyy-MM-dd'T'HH:mm:ss.SSS 2016-10-06T00:00:00
    static var dateOnlyFormat: String {
        return "MM/dd/yyyy"
    }
    
    static var dateFormatForBirthday: String {
        return "MMMM dd, yyyy"
    }
    
    
    static func stringFromCustomDate(fromDate date:Date, withFormat format:String) -> String {
        let formatter = DateFormatter()
         formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    /// Returns string in application date format
    var stringDate: String? {
        return Date.stringFromCustomDate(fromDate: self, withFormat: Date.dateOnlyFormat)
    }
    
    var stringDateForBirthday: String? {
        return Date.stringFromCustomDate(fromDate: self, withFormat: Date.dateFormatForBirthday)
    }
    
    func toUTCString()-> String{
        let df = DateFormatter()
//        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(abbreviation: "UTC")!
        df.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let timeStr = df.string(from: self)
        return timeStr
    }
    
    static func currentDateString()-> String{
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let timeStr = df.string(from: date)
        return timeStr
    }
    
    static func currentDateStringInUTC()-> String{
        let date = Date()
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")!
        df.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let timeStr = df.string(from: date)
        return timeStr
    }
    
    
    static func UTCToLocalDate(dateStr : String, format :String = "MM/dd/yyyy hh:mm a" ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: dateStr)

        let sourceTimeZone : TimeZone = TimeZone(abbreviation: "UTC")!
        let destinationTimeZone : TimeZone? = TimeZone.current
        
        let sourceGMTOffset : Int = sourceTimeZone.secondsFromGMT(for: dt!)
        let destinationGMTOffset : Int = destinationTimeZone!.secondsFromGMT(for: dt!)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset - sourceGMTOffset)
        
        let date : Date = Date.init(timeInterval: interval, since: dt!)
        return date
    }
    
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dayAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd")
        return df.string(from: self)
    }
    
    static func dateObject(dateStr : String) -> Date? {
        let df = DateFormatter()
         df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        return df.date(from: dateStr)
    }
    
    static func dateObjectForEventExpire(dateStr : String) -> Date? {
        let df = DateFormatter()
//        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return df.date(from: dateStr)
    }
    
    static func dateObjectNotUTC(dateStr : String) -> Date? {
        let df = DateFormatter()
         df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "MM/dd/yyyy hh:mm a"
        return df.date(from: dateStr)
    }
    
    func monthAsStringInUTC() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dayAsStringInUTC() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.setLocalizedDateFormatFromTemplate("dd")
        
        return df.string(from: self)
    }
    
    
    func isInNext7Days()-> Bool
    {
        let units  = Set<Calendar.Component>([.second, .minute, .hour, .day])
        let calendar = Calendar.current
        let components = calendar.dateComponents(units, from: self, to: Date())
        if (components.day! <= 7)
        {
            return true
        }
        return false
    }
    
    func isWeekendDays()-> Bool
    {
        let units  = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekday])
        let calendar = Calendar.current
        let components = calendar.dateComponents(units, from: self)
        if components.weekday == 1 || components.weekday == 7
        {
            return true
        }
        return false
    }
    
    static func getCombinedDateForDay(startDate :  String , endDate : String ) -> String{
        let strtDate = Date.dateObject(dateStr: startDate)
        let endedDate = Date.dateObject(dateStr: endDate)
        
        var dateCombine = ""
        
        //        let units  = Set<Calendar.Component>([.second, .minute, .hour, .day])
        //        let calendar = Calendar.current
        //        let components = calendar.dateComponents(units, from: strtDate!, to: endedDate!)
        
        let startDay = strtDate!.dayAsString()
        let endDay = endedDate!.dayAsString()
        
        if startDay == endDay
        {
            let date1 = Date.stringFromCustomDate(fromDate: strtDate!, withFormat: "EEEE hh:mm a")
            let date2 = Date.stringFromCustomDate(fromDate: endedDate!, withFormat: "hh:mm a")
            dateCombine = date1 + " - " + date2
        }
        else {
            let date1 = Date.stringFromCustomDate(fromDate: strtDate!, withFormat: "MMM dd, hh:mm a")
            let date2 = Date.stringFromCustomDate(fromDate: endedDate!, withFormat: "MMM dd, yyyy hh:mm a")
            dateCombine = date1 + " - " + date2
        }
        //        if (components.day! >= 1)
        //        {
        //            // Month
        //            let date1 = Date.stringFromCustomDate(fromDate: strtDate!, withFormat: "MMMM dd")
        //            let date2 = Date.stringFromCustomDate(fromDate: endedDate!, withFormat: "MMMM dd, yyyy")
        //            dateCombine = date1 + " - " + date2
        //        }else{
        //            //sunday
        //            let date1 = Date.stringFromCustomDate(fromDate: strtDate!, withFormat: "EEEE hh:mm a")
        //            let date2 = Date.stringFromCustomDate(fromDate: endedDate!, withFormat: "hh:mm a")
        //            dateCombine = date1 + " - " + date2
        //        }
        return dateCombine
    }
}

extension CGFloat{
    var colorRange: CGFloat {
        return self / 255.0
    }
    
    /// Returns propotional width according to device width
    var propotional: CGFloat {
        return CGFloat(Device.SCREEN_WIDTH) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
    }
    /// Returns propotional height according to device height
    var propotionalHeight: CGFloat {
        return Device.SCREEN_HEIGHT / CGFloat(IPHONE6_HEIGHT) * CGFloat(self)
    }
}


extension Double {
    
    var colorRange: CGFloat {
        return CGFloat(self / 255.0)
    }
    
    /// Returns propotional height according to device height
    var propotionalHeight: CGFloat {
        return Device.SCREEN_HEIGHT / CGFloat(IPHONE6_HEIGHT) * CGFloat(self)
    }
    
    /// Returns propotional width according to device width
    var propotional: CGFloat {
        return CGFloat(Device.SCREEN_WIDTH) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
    }
    
    var propotionalFont: CGFloat {
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            return CGFloat(Device.SCREEN_WIDTH) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        } else {
            return CGFloat(Device.SCREEN_HEIGHT) / CGFloat(IPHONE6_WIDTH) * CGFloat(self)
        }
    }
    
    
    
    /// Returns rounded value for passed places
    ///
    /// - parameter places: Pass number of digit for rounded value off after decimal
    ///
    /// - returns: Returns rounded value with passed places
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

extension NSData {
    func castToCPointer<T>() -> T {
        let mem = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T.Type>.size)
        self.getBytes(mem, length: MemoryLayout<T.Type>.size)
        return mem.move()
    }
}


extension UIColor {
    
    convenience init(hexString: String) {
        
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (0, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    static var deleteRedButton: UIColor {
        return  UIColor(red: 226.0.colorRange, green: 56.0.colorRange, blue: 6.0.colorRange, alpha: 1.0)
    }
    static var bgRedButton: UIColor {
        return  UIColor(red: 201.0.colorRange, green: 40.0.colorRange, blue: 47.0.colorRange, alpha: 1.0)
    }
    static var mainViewBackGroundColor: UIColor {
        return  UIColor(red: 240.0.colorRange, green: 240.0.colorRange, blue: 240.0.colorRange, alpha: 1.0)
    }
    static var LiveCamYellowColor: UIColor {
        return  UIColor(red: 255.0.colorRange, green: 225.0.colorRange, blue: 146.0.colorRange, alpha: 1.0)
    }
    
    static var SearchBarYellowColor: UIColor {
        return  UIColor(red: 255.0.colorRange, green: 202.0.colorRange, blue: 5.0.colorRange, alpha: 1.0)
    }
    
    static var GreenColor: UIColor {
        return  UIColor(red: 126.0.colorRange, green: 211.0.colorRange, blue: 33.colorRange, alpha: 1.0)
    }
    
    static var RedColor: UIColor {
        return  UIColor(red: 238.0.colorRange, green: 65.0.colorRange, blue: 54.0.colorRange, alpha: 1.0)
    }

    static var LightGrayColor: UIColor {
        return  UIColor(red: 166.0.colorRange, green: 168.0.colorRange, blue: 171.0.colorRange, alpha: 1.0)
    }
    
    static var LightGrayShadowColor: UIColor {
        return  UIColor(red: 168.0.colorRange, green: 168.0.colorRange, blue: 168.0.colorRange, alpha: 1.0)
    }
    
    static var BlueColor: UIColor {
        return  UIColor(red: 0.0.colorRange, green: 122.0.colorRange, blue: 255.0.colorRange, alpha: 1.0)
    }
    
    static var FoodColor: UIColor {
        return  UIColor(red: 238.0.colorRange, green: 65.0.colorRange, blue: 64.0.colorRange, alpha: 1.0)
    }
    
    static var NightLifeColor: UIColor {
        return  UIColor(red: 74.0.colorRange, green: 144.0.colorRange, blue: 226.0.colorRange, alpha: 1.0)
    }
    
    static var TravelColor: UIColor {
        return  UIColor(red: 189.0.colorRange, green: 16.0.colorRange, blue: 224.0.colorRange, alpha: 1.0)
    }
    
    static var EventColor: UIColor {
        return  UIColor(red: 0.0.colorRange, green: 212.0.colorRange, blue: 103.0.colorRange, alpha: 1.0)
    }
    
    static var LiveCamsColor: UIColor {
        return  UIColor(red: 255.0.colorRange, green: 202.0.colorRange, blue: 5.0.colorRange, alpha: 1.0)
    }
    
    static var CafesColor: UIColor {
        return  UIColor(red: 170.0.colorRange, green: 133.0.colorRange, blue: 44.0.colorRange, alpha: 1.0)
    }
    
    static var CollegesColor: UIColor {
        return  UIColor(red: 144.0.colorRange, green: 19.0.colorRange, blue: 254.0.colorRange, alpha: 1.0)
    }
    
    static var ArtsEntertainmentColor: UIColor {
        return  UIColor(red: 126.0.colorRange, green: 211.0.colorRange, blue: 33.0.colorRange, alpha: 1.0)
    }
    
    static var ShopColor: UIColor {
        return  UIColor(red: 255.0.colorRange, green: 0.0.colorRange, blue: 139.0.colorRange, alpha: 1.0)
    }
    
    static var OtherColor: UIColor {
        return  UIColor(red: 246.0.colorRange, green: 147.0.colorRange, blue: 29.0.colorRange, alpha: 1.0)
    }
    
    static var MusicColor: UIColor {
        return  UIColor(red: 249.0.colorRange, green: 118.0.colorRange, blue: 255.0.colorRange, alpha: 1.0)
    }
    
    static var LoalPromosColor: UIColor {
        return  UIColor(red: 255.0.colorRange, green: 202.0.colorRange, blue: 5.0.colorRange, alpha: 1.0)
    }
    
    static var ClaimThisBusinessColor: UIColor {
        return  UIColor(red: 64.colorRange, green: 64.0.colorRange, blue: 66.0.colorRange, alpha: 1.0)
    }
    
    static var OutDoorsColor: UIColor {
        return  UIColor(red: 80.0.colorRange, green: 227.0.colorRange, blue: 194.0.colorRange, alpha: 1.0)
    }
    
    static var ProfileCellSelectedColor: UIColor {
        return  UIColor(red: 102.0.colorRange, green: 102.0.colorRange, blue: 102.0.colorRange, alpha: 1.0)
    }
    static var DarkGrayColor: UIColor {
        return  UIColor(red: 74.0.colorRange, green: 74.0.colorRange, blue: 74.0.colorRange, alpha: 1.0)
    }
    
    static var buttonDistanceColor: UIColor {
        return  UIColor(red: 224.0.colorRange, green: 68.0.colorRange, blue: 30.0.colorRange, alpha: 1.0)
    }
    
    static var mainBackgroundColor: UIColor {
        return  UIColor(red: 240.0.colorRange, green: 240.0.colorRange, blue: 240.0.colorRange, alpha: 1.0)
    }
    
    static var blueBackgroundColor: UIColor {
        return  UIColor(red: 214.0.colorRange, green: 234.0.colorRange, blue: 255.0.colorRange, alpha: 1.0)
    }
    
    static var btnLightGrayColor: UIColor {
        return  UIColor(red: 166.0.colorRange, green: 168.0.colorRange, blue: 171.0.colorRange, alpha: 1.0)
    }
    
    
    static var btnJoinWussupGreenColor: UIColor {
        return  UIColor(red: 81.0.colorRange, green: 171.0.colorRange, blue: 55.0.colorRange, alpha: 1.0)
    }
    
    static var btnFacebookBlueColor: UIColor {
        return  UIColor(red: 100.0.colorRange, green: 120.0.colorRange, blue: 167.0.colorRange, alpha: 1.0)
    }
    
    static var blackColor: UIColor {
        return  UIColor(red: 0.0.colorRange, green: 0.0.colorRange, blue: 2.0.colorRange, alpha: 1.0)
    }
    
    static var btnForgotPwdGreenColor: UIColor {
        return  UIColor(red: 126.0.colorRange, green: 211.0.colorRange, blue: 33.0.colorRange, alpha: 1.0)
    }
    
    static var btnMoreBlueSelectedColor: UIColor {
        return  UIColor(red: 134.0.colorRange, green: 188.0.colorRange, blue: 246.0.colorRange, alpha: 1.0)
    }
    
    static var AddToCalenderNormalColor: UIColor {
        return  UIColor(red: 128.0.colorRange, green: 129.0.colorRange, blue: 132.0.colorRange, alpha: 1.0)
    }
    
    static var AddToCalenderSelectedColor: UIColor {
        return  UIColor(red: 194.0.colorRange, green: 196.0.colorRange, blue: 198.0.colorRange, alpha: 1.0)
    }
    
    static var WhiteShadeBGColor: UIColor {
        return  UIColor(red: 242.0.colorRange, green: 242.0.colorRange, blue: 242.0.colorRange, alpha: 1.0)
    }
    
    static var LiveCamSepratorColor: UIColor {
        return  UIColor(red: 147.0.colorRange, green: 149.0.colorRange, blue: 151.0.colorRange, alpha: 1.0)
    }
    
    static var FilterCategoryColor: UIColor {
        return  UIColor(red: 218.0.colorRange, green: 218.0.colorRange, blue: 218.0.colorRange, alpha: 1.0)
    }
    
    static var cliamBusinessSepratorColor: UIColor {
        return  UIColor(red: 151.0.colorRange, green: 151.0.colorRange, blue: 151.0.colorRange, alpha: 1.0)
    }
    
    static var CABOrangeColor: UIColor {
        return  UIColor(red: 240.0.colorRange, green: 90.0.colorRange, blue: 40.0.colorRange, alpha: 1.0)
    }
    
    static var OpenNowGreenColor: UIColor {
        return  UIColor(red: 0.0.colorRange, green: 165.0.colorRange, blue: 80.0.colorRange, alpha: 1.0)
    }
    
    static var CABBGColor: UIColor {
        return  UIColor(red: 74.0.colorRange, green: 74.0.colorRange, blue: 74.0.colorRange, alpha: 1.0)
    }
    
    /// Returns dark color of any color
    var darker: UIColor {
        return mixWithColor(color: UIColor.white, amount:0.25)//More amount more dark
    }
    
    private func mixWithColor(color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0
        
        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor( red:r1*(1.0-amount)+r2*amount,
                        green:g1*(1.0-amount)+g2*amount,
                        blue:b1*(1.0-amount)+b2*amount,
                        alpha: alpha1 )
    }
   
}



extension UIApplication {
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version) (build #\(build))"
    }
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        //        self.view.addSubview(toastLabel)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    func setInteractiveGestureEnable(enable : Bool)
    {
        if self.navigationController!.responds(to: (#selector(getter: UINavigationController.interactivePopGestureRecognizer))) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}

extension UIButton {

    @IBInspectable
    var cornerRadiusSameAsHeight: Bool {
        get {
            return true
        }
        set {
            if newValue == true {
                layer.cornerRadius = self.frame.size.height / 2
                layer.masksToBounds = newValue
            }
            
        }
    }
    
    
    /// This property is change font-size of Button's text propotionaly if assigned /On/ from Interface builder
    @IBInspectable
    var isPropotional: Bool{
        get {
            return true
        }
        
        set {
            if newValue == true {
                self.imageView?.contentMode = .scaleAspectFit
                let fontSize = Double((self.titleLabel!.font!.pointSize))
                self.titleLabel?.font = UIFont(name: self.titleLabel!.font!.fontName, size: fontSize.propotional)
            }
        }
    }
    
    var height : CGFloat{
        get {
            return self.frame.size.height
        }
    }
    
    var width : CGFloat{
        get {
            return self.frame.size.width
        }
    }
    
    /// Add required shadow to button for Application
    func addShadow() {
        self.layer.shadowRadius = 1
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    // Set title withput animation
    func setTitleWithoutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, for: .normal)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    func isEnableButton(isEnabled : Bool){
        self.isEnabled = isEnabled
        self.alpha = isEnabled == true ? 1.0 : 0.5
    }
    
    func isEnableColorOfButton(isEnabled : Bool){
        self.alpha = isEnabled == true ? 1.0 : 0.5
    }
    
}

extension UILabel {

    /// This property is change font-size of Label's text propotionaly, if assigned `On` from Interface builder
    @IBInspectable
    var isPropotional: Bool{
        get {
            return true
        }
        
        set {
            if newValue == true {
                let fontSize = Double((self.font!.pointSize))
                self.font = UIFont(name: self.font!.fontName, size: fontSize.propotional)
            }
        }
    }
    
    var height : CGFloat{
        get {
            return self.frame.size.height
        }
    }
    
    var width : CGFloat{
        get {
            return self.frame.size.width
        }
    }
}

extension UITextField{
    
    /// This property is change font-size of Label's text propotionaly, if assigned `On` from Interface builder
    @IBInspectable
    var isPropotional: Bool{
        get {
            return true
        }
        
        set {
            if newValue == true {
                let fontSize = Double((self.font!.pointSize))
                self.font = UIFont(name: self.font!.fontName, size: fontSize.propotional)
            }
        }
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        get
        {
            return #imageLiteral(resourceName: "Search")
        }
        set {
            if newValue != nil
            {
                updateLeftViewImage(image: newValue!)
            }
        }
    }
    
    func updateLeftViewImage(image : UIImage) {
        leftViewMode = UITextFieldViewMode.always
        let viewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        viewLeft.addSubview(imageView)
        leftView = viewLeft
    }
}


extension UITextView {
    
   
    /// This property is change font-size of Label's text propotionaly, if assigned `On` from Interface builder
    @IBInspectable
    var isPropotional: Bool{
        get {
            return true
        }
        
        set {
            if newValue == true {
                let fontSize = Double((self.font!.pointSize))
                self.font = UIFont(name: self.font!.fontName, size: fontSize.propotional)
            }
        }
    }
    
    var height : CGFloat{
        get {
            return self.frame.size.height
        }
    }
    
    var width : CGFloat{
        get {
            return self.frame.size.width
        }
    }
}
extension UIImageView {
    
    var height : CGFloat{
        get {
            return self.frame.size.height
        }
    }
    
    var width : CGFloat{
        get {
            return self.frame.size.width
        }
    }
    
//    func setImageURL(with url: URL?) {
//        if self.frame.size.width >= self.frame.size.height {
//            self.sd_setImage(with: url, placeholderImage: UIImage.placeHolderLandscape)
//        } else {
//            self.sd_setImage(with: url, placeholderImage: UIImage.placeHolder)
//        }
//
//    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double(CGFloat.pi * 2))
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

extension UIImage {
    /// Returns Avtar image
    static var avtar: UIImage {
        return UIImage(named: "profilePic.png")!
    }
    
    static var placeHolderLandscape: UIImage {
        return UIImage(named: "placeHolderLandScape.png")!
    }
    
    static var placeHolder: UIImage {
        return UIImage(named: "placeHolderPortrait.png")!
    }
    
    func resizeImage(newSize: CGSize) -> UIImage {
        
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        
        let aspectRatio = max(aspectWidth, aspectheight)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x:0, y:0, width:size.width,height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UIStoryboard {
    
    static var splash: UIStoryboard {
        return UIStoryboard(name: "Splash", bundle: nil)
    }
    
    static var loginSignUp: UIStoryboard {
        return UIStoryboard(name: "LoginSignUp", bundle: nil)
    }
    
    static var tabBar: UIStoryboard {
        return UIStoryboard(name: "Tabbar", bundle: nil)
    }
    
    static var home: UIStoryboard {
        return UIStoryboard(name: "Home", bundle: nil)
    }
    
    static var venue: UIStoryboard {
        return UIStoryboard(name: "Venue", bundle: nil)
    }
    
    static var liveCam: UIStoryboard {
        return UIStoryboard(name: "LiveCam", bundle: nil)
    }
    
    static var events: UIStoryboard {
        return UIStoryboard(name: "Events", bundle: nil)
    }
    
    static var favorites: UIStoryboard {
        return UIStoryboard(name: "Favorites", bundle: nil)
    }
    
    static var userProfile: UIStoryboard {
        return UIStoryboard(name: "UserProfile", bundle: nil)
    }
    /// Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.get(ProfileViewController.self) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    public func get<T:UIViewController>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        
        guard let viewController = instantiateViewController(withIdentifier: storyboardID) as? T else {
            return nil
        }
        
        return viewController
    }
    
}

extension UserDefaults {
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key) as Any?
        }
        set {
            set(newValue, forKey: key)
            synchronize()
        }
    }
    
    public static func contains(key: String) -> Bool {
        return self.standard.contains(key: key)
    }
    
    public func contains(key: String) -> Bool {
        return self.dictionaryRepresentation().keys.contains(key)
    }
    
    public func reset() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
           /* if key == Key.email || key == "Countries" || key == Key.language || key == Key.password {
                continue
            }*/
            UserDefaults.standard.removeObject(forKey: key)
        }
        synchronize()
    }
}


extension UIViewController {
    
    func pushToSearchViewController(){
        if let vc = UIStoryboard.home.get(WUHomeSearchViewController.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func push(_ viewController:UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController(){
        if self.isModal() == true{
            self.dismiss(animated: true, completion: nil)
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToViewController( viewController : UIViewController, withAnimation : Bool){
        _ = self.navigationController?.popToViewController(viewController, animated: withAnimation)
    }
    
    func present(_ viewController:UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func setBackButton(){
        let yourBackImage = UIImage(named: "ic_back")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = "Back"
    }
    
}

extension UIView {
    
    func isHiddenWithAnimate(isHidden:Bool,completion: @escaping ((Bool) -> ())){
        self.alpha = isHidden ? 1:0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.showHideTransitionViews, animations: { () -> Void in
            self.alpha = isHidden ? 0:1
        }, completion: { (bool) -> Void in
            completion(bool)
        }
        )
    }
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadowWithPath(scale: Bool = true,color: UIColor,radius: CGFloat = 1) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 20 // 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowWithPath(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor = UIColor.gray,
                    opacity: Float = 1.0,
                    offSet: CGSize = CGSize(width: 0.0, height: 4.0),
                    radius: CGFloat = 2.0,
                    scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
    }
    func dropBlcakShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset =  CGSize(width: 0.0, height: 4.0)
        self.layer.shadowRadius = 2.0
    }
    
    
    @IBInspectable
    var propotionalCornerRadius: CGFloat {
        get {
            return layer.cornerRadius.propotional
        }
        set {
            layer.cornerRadius = newValue.propotional
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


extension UITableView {
    
    func getCell<T:UITableViewCell>(identifier:T.Type) -> T?{
        let cellID = String(describing: identifier)
        guard let cell = self.dequeueReusableCell(withIdentifier: cellID) as? T else {
             Utill.printInTOConsole(printData:"cell not exist")
            return nil
        }
        return cell
    }
}

extension UIImage {
    
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}

enum HUDType: Int {
    
    case show = 0 , success, error, progress
}

extension SVProgressHUD {
    
    static func show(message: String, type: HUDType, userInteraction: Bool = false) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        switch type {
        case .show:
            SVProgressHUD.show(withStatus: message)
            break
        case .success:
            SVProgressHUD.showSuccess(withStatus: message)
            break
        case .error:
            SVProgressHUD.showError(withStatus: message)
            break
        case .progress:
            guard let n = NumberFormatter().number(from: message) else {
                return
            }
            
            SVProgressHUD.showProgress(Float(n))
            break
        }
    }
    
    static func hide() {
        UIApplication.shared.endIgnoringInteractionEvents()
        self.dismiss()
    }
}

//Protocal that copyable class should conform
protocol Copying {
    init(original: Self)
}

//Concrete class extension
extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

//Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
}


extension UIFont {
    static let ProximaNovaMedium = { (size: CGFloat) -> UIFont! in
        return UIFont(name: "ProximaNova-Medium", size: size)
    }
    
    static let ProximaNovaBold = { (size: CGFloat) -> UIFont? in
        return UIFont(name: "ProximaNova-Bold", size: size)
    }
    
    static let ProximaNovaRegular = { (size: CGFloat) -> UIFont! in
        return UIFont(name: "ProximaNova-Regular", size: size)
    }
    static let ProximaNovaExtraBold = { (size: CGFloat) -> UIFont! in
        return UIFont(name: "ProximaNova-Extrabld", size: size)
    }
    
    static let ProximaNovaThin = { (size: CGFloat) -> UIFont! in
        return UIFont(name: "ProximaNovaT-Thin", size: size)
    }
    
    static let MyriadProSemiboldItalic = { (size: CGFloat) -> UIFont? in
        return UIFont(name: "MyriadPro-SemiboldIt", size: size)
    }
    
    static let MyriadProBoldItalic = { (size: CGFloat) -> UIFont? in
        return UIFont(name: "MyriadPro-BoldIt", size: size)
    }
    
    static let MyriadProBold = { (size: CGFloat) -> UIFont? in
        return UIFont(name: "MyriadPro-Bold", size: size)
    }
}

extension Int {
    
    func toString() -> String{
        return "\(self)"
    }
}

extension Notification.Name {
    static let interestToProfile = Notification.Name("InterestToProfile")
    static let profileToFav = Notification.Name("profileToFavourite")

}

extension NSLayoutConstraint {
//    override open var description: String {
//        let id = identifier ?? "NO ID"
//        return "id: \(id), constant: \(constant)"
//    }
}

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController:UIDocumentInteractionController?
    
    // singleton manager
    static let sharedManager:InstagramManager = {
        let instance = InstagramManager()
        return instance
    }()
    
    func postFileToInstagramWithCaption(objectMediaID:String, isImage:Bool) {
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let stringMediaToShare:String?
            if isImage{//Share Image
                stringMediaToShare = "instagram://library?&LocalIdentifier=\(objectMediaID)"
            }else{ //Share Video
                stringMediaToShare = "instagram://library?&LocalIdentifier==\(objectMediaID)"
            }
            if let objectShareURL = URL.init(string:stringMediaToShare!){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(objectShareURL)
                } else {
                    // Fallback on earlier versions
                }
            }
        } else {
            //Open Instagram in AppStore
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "https://itunes.apple.com/in/app/instagram/id389801252?m")!)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

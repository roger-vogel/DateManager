
import UIKit

public enum ClockPreference: Int { case c12, c24 }
public enum DateString: Int { case date, dayAndDate, dayDateAndTime }

public class DateManager: NSObject {
    
    // MARK: - PROPERTIES
    public var theDate: Date?
    public var dateFormatter = DateFormatter()
    public var clockPreference: ClockPreference = .c12
   
    let usds = "MM/dd"
    let euds = "dd/MM"
    let usd = "M/d/YY"
    let eud = "dd/MM/yyyy"
    let ust = "h:mm a"
    let eut = "HH:mm"
    let usdd = "E MM/dd/yyyy"
    let eudd = "E dd/MM/yyyy"
    let usddt = "E MM/dd/yyyy 'at' h:mm a"
    let euddt = "E dd/MM/yyyy 'at' HH:mm"
    let mday = "dd"
    let api = "yyyy-MM-dd.HH:mm"
    let dot = "yyyy.MM.dd"
    let cyr = "yyyy"
    
    // MARK: - COMPUTED PROPERTIES
    public var dateValue: UInt64 {
        
        get { return UInt64(theDate!.timeIntervalSince1970) }
    }
    
    public var gmtDate: Date {
        
        get {
            
            var GMTDate = Date()
            
            let secondsFromGMT = -(TimeZone.current.secondsFromGMT())
            GMTDate = theDate!.addingTimeInterval(TimeInterval(secondsFromGMT))
            
            return GMTDate
        }
    }
  
    public var localDate: Date {
        
        get { return theDate! }
        set { theDate = newValue }
    }
  
    public var serverDateAndTime: String {
        
        get {
            
            dateFormatter.dateFormat = api
            return dateFormatter.string(from: gmtDate)
        }
           
        set {
            
            dateFormatter.dateFormat = api
            let gmtDate = dateFormatter.date(from: newValue)!
            
            let secondsFromGMT = TimeZone.current.secondsFromGMT()
            theDate = gmtDate.addingTimeInterval(TimeInterval(secondsFromGMT))
        }
    }
    
    public var dateComponents: DateComponents {
        
        get {
            
            var dateComponents = DateComponents()
            let calendar = Calendar.current
            
            // Convert and store as date components in appointment record
            dateComponents.year = calendar.component(.year, from: theDate!)
            dateComponents.month = calendar.component(.month, from: theDate!)
            dateComponents.day = calendar.component(.day, from: theDate!)
            dateComponents.hour = calendar.component(.hour, from: theDate!)
            dateComponents.minute = calendar.component(.minute, from: theDate!)
            dateComponents.weekday = calendar.component(.weekday, from: theDate!)
            dateComponents.weekOfYear = calendar.component(.weekOfYear, from: theDate!)
        
            return dateComponents
        }
        
        set { theDate = NSCalendar.current.date(from: newValue)! }
    }
    
    public var shortDateString: String {
        
        get {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usds } else {dateFormatter.dateFormat = euds }
            return dateFormatter.string(from: theDate!)
        }
        
        set {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usds }
            else { dateFormatter.dateFormat = euds }
            
            theDate = dateFormatter.date(from: newValue)
        }
        
    }
    
    public var dayDateAndTimeString: String {
        
        get {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usddt } else {dateFormatter.dateFormat = euddt }
            return dateFormatter.string(from: theDate!)
        }
        
        set {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usddt }
            else { dateFormatter.dateFormat = euddt }
            
            theDate = dateFormatter.date(from: newValue)
        }
    }
    
    public var dayAndDateString: String {
        
        get {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usdd } else {dateFormatter.dateFormat = eudd }
            return dateFormatter.string(from: theDate!)
        }
        
        set {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usdd }
            else { dateFormatter.dateFormat = eudd }
            
            theDate = dateFormatter.date(from: newValue)
        }
    }
    
    public var dateString: String {
        
        get {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usd } else {dateFormatter.dateFormat = eud }
            return dateFormatter.string(from: theDate!)
        }
        
        set {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = usd } else { dateFormatter.dateFormat = eud }
            theDate = dateFormatter.date(from: newValue)
        }
    }
    
    public var dotString: String {
        
        dateFormatter.dateFormat = dot
        return dateFormatter.string(from: theDate!)
    }
    
    public var timeString: String {
   
        get {
            
            if clockPreference == .c12 { dateFormatter.dateFormat = ust } else {dateFormatter.dateFormat = eut }
            return dateFormatter.string(from: theDate!)
        }
    }
    
    public var dateAndTimeString: String {
   
        get {
            
            if clockPreference == .c12 {
                
                dateFormatter.dateFormat = usddt }
            
            else {dateFormatter.dateFormat = euddt }
            
            return dateFormatter.string(from: theDate!)
        }
    }
    
    public var dayOfWeekString: String {
        
        let days = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[dateComponents.weekday!-1]
    }
    
    public var dayOfMonthString: String {
    
        var monthDay = String(dateComponents.day!)
        
        switch monthDay.last! {
            
            case "1": monthDay += "st"
            case "2": monthDay += "nd"
            case "3": monthDay += "rd"
            default: monthDay += "th"
        }
   
        return monthDay
    }
    
    public var dayOfMonthNumberString: String {
        
        return String(dateComponents.day!)
    }
    
    public var cleanYearString: String {
        
        dateFormatter.dateFormat = cyr
        return dateFormatter.string(from: theDate!)
    }
    
    public var dayOfWeek: Int {
        
        return dateComponents.weekday!
    }
    
    public var startOfWeek: Date {
        
        return endOfWeek.addingTimeInterval(TimeInterval(-604800))
    }
    
    public var endOfWeek: Date {
        
        let daysToWeekEnd = 7 - dateComponents.weekday!
        return theDate!.addingTimeInterval(TimeInterval(84000 * daysToWeekEnd))
        
    }
    
    public var isToday: Bool {
      
        let today = DateManager().dateComponents
        
        if dateComponents.year! == today.year! && dateComponents.month! == today.month! && dateComponents.day! == today.day! { return true }
        return false
    }
    
    public var isThisWeek: Bool {
        
        let dateManager = DateManager()
        
        let endOfWeek = dateManager.endOfWeek
        let startOfWeek = dateManager.startOfWeek
        
        if theDate! >= startOfWeek && theDate! <= endOfWeek { return true }
        return false
        
    }
    
    public var isUpcoming: Bool {
        
        let endOfWeek = DateManager().endOfWeek
        
        if theDate! > endOfWeek { return true }
        return false
    }
    
    public var isPast: Bool {
        
        let components = dateComponents
        let todaysComponents = DateManager().dateComponents
        
        // Is the date in the past?
        if components.year! < todaysComponents.year! { return true }
        if components.month! < todaysComponents.month! { return true }
        if components.day! < todaysComponents.day! { return true }
        
        return false
    }
    
    // MARK: - INITIALIZATION
    public init (date: Date? = Date()) {
        
        super.init()

        theDate = date
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (date: DateManager) {
        
        super.init()

        theDate = date.localDate
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (fromServerDateAndTime: String) {
        
        super.init()
        
        serverDateAndTime = fromServerDateAndTime
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (fromDayDateAndTime: String) {
        
        super.init()
        
        dayDateAndTimeString = fromDayDateAndTime
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (fromGMTDayDateAndTime: String) {
        
        super.init()
        
        convertFromGMT(ddtGMT: fromGMTDayDateAndTime)
       
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (fromDayAndDate: String) {
        
        super.init()
     
        dayAndDateString = fromDayAndDate
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
    
    public init (fromDate: String) {
        
        super.init()
        
        dateString = fromDate
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
       
    // MARK: - METHODS
    public func gmtString(_ inFormat: DateString) -> String {
        
        let theGMTDate = DateManager(date: gmtDate)
        
        switch inFormat {
            
            case .date: return theGMTDate.dateString
            case .dayAndDate: return theGMTDate.dayAndDateString
            case .dayDateAndTime: return theGMTDate.dayDateAndTimeString
        }
    }
    
    public func convertFromGMT(ddtGMT: String) {
        
        dayDateAndTimeString = ddtGMT
        
        var theLocalDate = Date()
        let secondsFromGMT = TimeZone.current.secondsFromGMT()
       
        theLocalDate = theDate!.addingTimeInterval(TimeInterval(secondsFromGMT))
        theDate = theLocalDate
    }
   
    public func todayIsInRangeTo(endDate: DateManager) -> Bool {
        
        let today = DateManager().dateComponents
        let start = dateComponents
        let end = endDate.dateComponents
     
        if today.year! >= start.year! && today.month! >= start.month! && today.day! >= start.day! {
            
            if today.year! <= end.year! && today.month! <= end.month! && today.day! <= end.day! { return true }
        }
        
        return false
    }
    
    public func updateDateTo(newDate: DateManager) {
        
        dateComponents.year = newDate.dateComponents.year!
        dateComponents.month = newDate.dateComponents.month!
        dateComponents.day = newDate.dateComponents.day!
        dateComponents.weekday = newDate.dateComponents.weekday!
        
        theDate = NSCalendar.current.date(from: dateComponents)!
    }
    
    public func updateTimeTo(newTime: DateManager) {
        
        dateComponents.hour = newTime.dateComponents.hour!
        dateComponents.minute = newTime.dateComponents.minute!
        
        theDate = NSCalendar.current.date(from: dateComponents)!
    }
    
    public func isSameDay(comparing: DateManager) -> Bool {
        
        let myDateComponents = dateComponents
        let comparetToDateComponents = comparing.dateComponents
        
        if myDateComponents.year! == comparetToDateComponents.year! &&
           myDateComponents.month! == comparetToDateComponents.month! &&
           myDateComponents.day! == comparetToDateComponents.day! { return true }
       
        return false
    }
    
    public func isIn(month: Int16)-> Bool {
        
        if Int16(dateComponents.month!) == month + 1 { return true }
        return false
    }
    
}

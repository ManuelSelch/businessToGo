import Foundation

extension Date {
    static func getToday() -> Date {
        let calendar = Calendar.current
        let now = Date.now
        let startOfDay = calendar.startOfDay(for: now)
        return startOfDay
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        return calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func addDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: self)
        return calendar.date(byAdding: .day, value: days, to: today) ?? self
    }
    
    func getDay() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
    
    func getWeekday() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func isDay(of date: Date) -> Bool {
        let date1 = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let date2 = Calendar.current.dateComponents([.day, .month, .year], from: date)
        
        return (date1.year == date2.year) && (date1.month == date2.month) && (date1.day == date2.day)
    }
    

    
    func isWeekOfYear(of date: Date) -> Bool {
        let date1 = Calendar.current.dateComponents([.weekOfYear, .year], from: self)
        let date2 = Calendar.current.dateComponents([.weekOfYear, .year], from: date)
        
        return (date1.year == date2.year) && (date1.weekOfYear == date2.weekOfYear)
    }
    
    func isMonth(of date: Date) -> Bool {
        let date1 = Calendar.current.dateComponents([.month, .year], from: self)
        let date2 = Calendar.current.dateComponents([.month, .year], from: date)
        
        return (date1.year == date2.year) && (date1.month == date2.month)
    }
    
    
    func isYear(of date: Date) -> Bool {
        let date1 = Calendar.current.dateComponents([.year], from: self)
        let date2 = Calendar.current.dateComponents([.year], from: date)
        
        return (date1.year == date2.year)
    }
}

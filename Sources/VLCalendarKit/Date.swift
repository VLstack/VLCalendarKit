import Foundation
import VLDateKit

public extension Date
{
 var daysInMonthForCalendarDisplay: [ Date ]
 {
  var days: [ Date ] = []
  // Current month days
  let _startOfMonth: Date = self.startOfMonth
  let _numberOfDaysInMonth: Int = self.numberOfDaysInMonth
  for dayOffset in 0..<_numberOfDaysInMonth
  {
   let newDay: Date = Calendar.current.date(byAdding: .day, value: dayOffset, to: _startOfMonth) ?? .distantFuture
   days.append(newDay)
  }
  
  // Previous month days
  let _startOfPreviousMonth: Date = self.startOfPreviousMonth
  let _numberOfDaysInPreviousMonth: Int = _startOfPreviousMonth.numberOfDaysInMonth
  
  for dayOffset in 0..<_numberOfDaysInPreviousMonth
  {
   let newDay: Date = Calendar.current.date(byAdding: .day, value: dayOffset, to: _startOfPreviousMonth) ?? .distantPast
   days.append(newDay)
  }
  
  let _sundayBeforeStartOfMonth: Date = self.sundayBeforeStartOfMonth
  let _endOfMonth: Date = self.endOfMonth
  return days.filter { $0 >= _sundayBeforeStartOfMonth && $0 <= _endOfMonth }.sorted(by: <)
 }
}

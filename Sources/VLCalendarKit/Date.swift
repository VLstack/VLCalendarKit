import Foundation

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
   days.append(_startOfMonth.adding(.day, value: dayOffset))
  }
  
  // Previous month days
  let _startOfPreviousMonth: Date = self.startOfPreviousMonth
  let _numberOfDaysInPreviousMonth: Int = _startOfPreviousMonth.numberOfDaysInMonth
  for dayOffset in 0..<_numberOfDaysInPreviousMonth
  {
   days.append(_startOfPreviousMonth.adding(.day, value: dayOffset))
  }

  let _firstWeekdayBeforeStartOfMonth: Date = self.firstWeekdayBeforeStartOfMonth
  let _endOfMonth: Date = self.endOfMonth

  return days.filter { $0 >= _firstWeekdayBeforeStartOfMonth && $0 <= _endOfMonth }.sorted(by: <)
 }
}

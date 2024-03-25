import SwiftUI
import VLDateKit

public struct VLCalendarView: View
{
 private let date: Date?
 
 private let columns: [ GridItem ] = Array(repeating: GridItem(.flexible()), count: 7)
 private let daysOfWeek: [ String ] = Date.firstLetterOfWeekDayCapitalized
 
 @State private var days: [ Date ] = []
 
 public init(at date: Date?)
 {
  self.date = date
 }
 
 public var body: some View
 {
  // TODO: handle spacing with environment
  VStack
  {
   // TODO: show headerView based on environment (true by default)
   headerView
   gridView
  }
  .onAppear(perform: onAppear)
 }
}

// MARK: - Components
extension VLCalendarView
{
 private func dayView(_ date: Date) -> some View
 {
  Text(date.formatted(.dateTime.day()))
  // TODO: handle style with environment/modifiers
   .fontWeight(.bold)
   .foregroundStyle(.secondary)
  // TODO: handle minHeight with environment
   .frame(maxWidth: .infinity, minHeight: 40)
   .background {
    // TODO: handle style with environment/modifiers
    RoundedRectangle(cornerRadius: 8)
     .fill(Color(.systemGray5))
   }
 }
 
 private var gridView: some View
 {
  LazyVGrid(columns: columns)
  {
   ForEach(days, id: \.self)
   {
    dayView($0)
   }
  }
 }
 
 private var headerView: some View
 {
  // TODO: handle spacing with environment
  HStack
  {
   ForEach(daysOfWeek.indices, id: \.self)
   {
    index in
    Text(daysOfWeek[index])
    // TODO: handle style with environment/modifiers
     .fontWeight(.bold)
     .frame(maxWidth: .infinity)
   }
  }
 }
}

// MARK: - Computed properties
extension VLCalendarView
{
}

// MARK: - Functions
extension VLCalendarView
{
 private func onAppear()
 {
 }
}

// MARK: - Previews
#Preview("Date.now")
{
 VLCalendarView(at: Date.now)
  .padding()
}

#Preview("Date.now")
{
 VLCalendarView(at: Date.now)
  .padding()
}

import SwiftUI
import VLDateKit
import VLViewKit

public struct VLCalendarView<HeaderDay: View, GridDay: View>: View
{
 private let headerDay: (String) -> HeaderDay
 private let gridDay: (Date) -> GridDay
 private let date: Date
 private let horizontalSpacing: CGFloat
 private let verticalSpacing: CGFloat
 private let columns: [ GridItem ]
 private let weekdays: [ String ]

 @Binding var headerSize: CGSize
 @Binding var gridSize: CGSize

 @State private var days: [ Date ] = []

 public init(_ date: Date? = nil,
             horizontalSpacing: CGFloat = 0,
             verticalSpacing: CGFloat = 0,
             weekdays days: [ String ]? = nil,
             headerSize: Binding<CGSize>? = nil,
             gridSize: Binding<CGSize>? = nil,
             @ViewBuilder headerDay: @escaping (String) -> HeaderDay,
             @ViewBuilder gridDay: @escaping (Date) -> GridDay)
 {
  self.date = date ?? Date.now
  self.horizontalSpacing = horizontalSpacing
  self.verticalSpacing = verticalSpacing
  self.headerDay = headerDay
  self.gridDay = gridDay
  self._headerSize = headerSize ?? Binding(get: { .zero }, set: { _ in })
  self._gridSize = gridSize ?? Binding(get: { .zero }, set: { _ in })

  self.columns = Array(repeating: GridItem(.flexible(), spacing: horizontalSpacing),
                       count: 7)
  
  var wdays: [ String ] = days ?? Date.weekdays.map { String($0.prefix(1)) }
  while wdays.count < 7 { wdays.append("") }
  if wdays.count > 7 { wdays.removeLast(wdays.count - 7) }
  self.weekdays = wdays
 }
 
 public init(_ date: Date? = nil,
             horizontalSpacing: CGFloat = 0,
             verticalSpacing: CGFloat = 0,
             weekdays: [ String ]? = nil,
             headerSize: Binding<CGSize>? = nil,
             gridSize: Binding<CGSize>? = nil,
             @ViewBuilder gridDay: @escaping (Date) -> GridDay) where HeaderDay == Text
 {
  self.init(date,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            weekdays: weekdays,
            headerSize: headerSize,
            gridSize: gridSize,
            headerDay: { Text($0).fontWeight(.bold) },
            gridDay: gridDay)
 }
 
 public init(_ date: Date? = nil,
             horizontalSpacing: CGFloat = 0,
             verticalSpacing: CGFloat = 0,
             weekdays: [ String ]? = nil,
             headerSize: Binding<CGSize>? = nil,
             gridSize: Binding<CGSize>? = nil,
             @ViewBuilder headerDay: @escaping (String) -> HeaderDay) where GridDay == Text
 {
  self.init(date,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            weekdays: weekdays,
            headerSize: headerSize,
            gridSize: gridSize,
            headerDay: headerDay,
            gridDay: { Text($0.formatted(.dateTime.day())) })
 }

 public init(_ date: Date? = nil,
             horizontalSpacing: CGFloat = 0,
             verticalSpacing: CGFloat = 0,
             weekdays: [ String ]? = nil,
             headerSize: Binding<CGSize>? = nil,
             gridSize: Binding<CGSize>? = nil) where HeaderDay == Text, GridDay == Text
 {
  self.init(date,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            weekdays: weekdays,
            headerSize: headerSize,
            gridSize: gridSize,
            headerDay: { Text($0).fontWeight(.bold) },
            gridDay: { Text($0.formatted(.dateTime.day())) })
 }

 public var body: some View
 {
  VStack(spacing: 0)
  {
//   headerView.onSizeChange { headerSize = $0 }
//   gridView.onSizeChange { gridSize = $0 }
   headerView.onSizeChange(size: $headerSize)
   gridView.onSizeChange(size: $gridSize)
  }
  .onAppear(perform: onAppear)
 }
}

// MARK: - Components
extension VLCalendarView
{
 @ViewBuilder
 private func dayView(_ day: Date) -> some View
 {
  if day.monthNumber != date.monthNumber
  {
   Color.clear
  }
  else
  {
   gridDay(day)
  }
 }
 
 private var gridView: some View
 {
  LazyVGrid(columns: columns,
            spacing: verticalSpacing)
  {
   ForEach(days, id: \.self)
   {
    dayView($0)
     .frame(maxWidth: .infinity)
   }
  }
 }
 
 private var headerView: some View
 {
  HStack(spacing: horizontalSpacing)
  {
   ForEach(weekdays.indices, id: \.self)
   {
    headerDay(weekdays[$0])
     .frame(maxWidth: .infinity)
   }
  }
 }
}

// MARK: - Functions
extension VLCalendarView
{
 private func onAppear()
 {
  days = date.daysInMonthForCalendarDisplay
 }
}

// MARK: - Previews
#if targetEnvironment(simulator)
#Preview
{
 ScrollView
 {
  VLCalendarView(weekdays: [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"])
   .padding()
  
  VLCalendarView(headerDay:
                 {
                  day in
                  Circle()
                   .foregroundStyle(.blue)
                   .padding(2)
                   .overlay { Text(day).foregroundStyle(.white) }
                 })
  .padding()
  
  VLCalendarView(gridDay: {
   day in
   
   Text(day.formatted(.dateTime.day()))
    .fontWeight(.bold)
    .foregroundStyle(.secondary)
    .frame(maxWidth: .infinity, minHeight: 40)
    .background { RoundedRectangle(cornerRadius: 8) .fill(Color(.systemGray5)) }
    .padding(2)
  })
  .padding()
 }
}

#endif

import SwiftUI
import Foundation

struct ScheduledItem {
    var contentText: String
    var day: Date
    var endTime: Date
    var startTime: Date
}

struct ContentView: View {
    @State private var textFieldInput: String = ""
    @State private var listItems: [Date: [String]] = [:]
    
    var body: some View {
        VStack {
            List {
                ForEach(listItems.sorted(by: { $0.key < $1.key }), id: \.key) { key, items in
                    Section(header: Text("List \((key))")) {
                        ForEach(items, id: \.self) { item in
                            ListItemView(item: item) {
                                handleEditItem(item)
                            } onDelete: {
                                handleDeleteItem(item, for: key)
                            }
                        }
                    }
                }
            }
            
            
            Spacer()
            
            HStack {
                Spacer()
                
                TextField("テキストを入力してください", text: $textFieldInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    registerItem()
                }) {
                    Text("登録")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .onAppear {
            removePreviousLists()
        }
    }
    
    private func handleEditItem(_ item: String) {
        print("Edit item: \(item)")
    }
    
    private func handleDeleteItem(_ item: String, for key: Date) {
        listItems[key]?.removeAll(where: { $0 == item })
        if listItems[key]?.isEmpty ?? false {
            listItems[key] = nil
        }
    }
    
    private func registerItem() {
        var dayString = ""
        
        let text = textFieldInput
        var components = text.split(separator: " ")
        
        var firstComponent: String?
        var lastComponent: String?
        var timeComponent: String?
        
        // 入力値をバリデーションする
        ValidationHelper.validateComponents(text)
        if let first = components.first.map(String.init), let last = components.last.map(String.init) {
            firstComponent = first
            lastComponent = last

            components = components.dropFirst().dropLast()

            // 残りのText
            let remainingText = components.joined(separator: " ")
            print("残りもの")
            print(remainingText)
            
            if let firstOfRemaining = components.first.map(String.init) {
                timeComponent = firstOfRemaining
            }


        } else {
            print("The string is empty or only contains spaces.")
        }

        // firstComponentとlastComponentをスコープの外で使えるようにする
        if let first = firstComponent, let last = lastComponent {
            print("First component (outside the scope): \(first)")
            print("Last component (outside the scope): \(last)")
        }
        
        if let slashIndex = firstComponent?.firstIndex(of: "/") {
            let startIndex = firstComponent?.index(slashIndex, offsetBy: -2, limitedBy: firstComponent!.startIndex) ?? firstComponent!.startIndex
            let endIndex = firstComponent?.index(slashIndex, offsetBy: 3, limitedBy: firstComponent!.endIndex) ?? firstComponent!.endIndex
            let mString = String(firstComponent![startIndex..<slashIndex])
            var dString = String(firstComponent![slashIndex..<endIndex])
            dString.removeFirst()
            
            if mString.first == "0" {
                dayString += String(mString.dropFirst())
            } else {
                dayString += mString
            }
            
            dayString += "/"
            
            if dString.first == "0" {
                dayString += String(dString.dropFirst())
            } else {
                dayString += dString
            }
        }
        print(dayString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        
        let currentDate = Date()
        
        let currentCalendar = Calendar.current
        let currentComponents = currentCalendar.dateComponents([.year, .month, .day], from: currentDate)
        
        if let dayDate = dateFormatter.date(from: dayString) {
            let targetComponents = currentCalendar.dateComponents([.month, .day], from: dayDate)
            var futureComponents = DateComponents()
            
            if let currentMonth = currentComponents.month, let currentDay = currentComponents.day,
               let targetMonth = targetComponents.month, let targetDay = targetComponents.day {
                
                if currentMonth > targetMonth || (currentMonth == targetMonth && currentDay > targetDay) {
                    futureComponents.year = currentComponents.year! + 1
                } else {
                    futureComponents.year = currentComponents.year
                }
                
                
                futureComponents.month = targetMonth
                futureComponents.day = targetDay
                
                if let futureDate = currentCalendar.date(from: futureComponents) {
                    listItems[futureDate, default: []].append(textFieldInput)
                    textFieldInput = ""
                } else {
                    print("日付の変換に失敗しました。")
                }
            } else {
                print("日付の変換に失敗しました。")
            }
        } else {
            print("日付の変換に失敗しました。")
        }
    }
    
    private func removePreviousLists() {
        let currentDate = Date()
        
        for key in listItems.keys {
            if key < currentDate {
                listItems[key] = nil
            }
        }
    }
}

struct ListItemView: View {
    let item: String
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Text(item)
            .contextMenu {
                Button(action: onEdit) {
                    Text("編集")
                    Image(systemName: "pencil")
                }
                
                Button(action: onDelete) {
                    Text("削除")
                    Image(systemName: "trash")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

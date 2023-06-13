import SwiftUI
import Foundation

struct ContentView: View {
    @State private var textFieldInput: String = ""
    @State private var listItems: [Date: [String]] = [:]
    
    var body: some View {
        VStack {
            List {
                ForEach(listItems.sorted(by: { $0.key < $1.key }), id: \.key) { key, items in
                    Section(header: Text("List \((key))")) { // 日付を表示するためにフォーマット
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
        
        if let slashIndex = textFieldInput.firstIndex(of: "/") {
            let startIndex = textFieldInput.index(slashIndex, offsetBy: -2, limitedBy: textFieldInput.startIndex) ?? textFieldInput.startIndex
            let endIndex = textFieldInput.index(slashIndex, offsetBy: 3, limitedBy: textFieldInput.endIndex) ?? textFieldInput.endIndex
            let mString = String(textFieldInput[startIndex..<slashIndex])
            var dString = String(textFieldInput[slashIndex..<endIndex])
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
                    // 未来の年になるように設定
                    futureComponents.year = currentComponents.year! + 1
                } else {
                    futureComponents.year = currentComponents.year
                }
                
                futureComponents.month = targetMonth
                futureComponents.day = targetDay
                
                if let futureDate = currentCalendar.date(from: futureComponents) {
                    // dayDateをDate型として使用できる
                    // ここでlistItemsへのアクセスや操作を行う
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

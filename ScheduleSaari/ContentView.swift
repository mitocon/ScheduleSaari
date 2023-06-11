import SwiftUI

struct ContentView: View {
    @State private var textFieldInput: String = ""
    @State private var listItems: [String: [String]] = [:]

    var body: some View {
        VStack {
            List {
                ForEach(listItems.keys.sorted(), id: \.self) { key in
                    Section(header: Text("List \(key)")) {
                        ForEach(listItems[key] ?? [], id: \.self) { item in
                            Text(item)
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
                    let rawDayString = String(textFieldInput.prefix(5))
                    var dayString = ""
                    
                    
                    // 前3文字以内に"/"の有無の確認が必要
                    // 全体にスペースの有無の確認が必要
                    
                    
                    // dayStringに"5/2", "6/14"などの日付を代入する。
                    if let slashIndex = rawDayString.firstIndex(of: "/") {
                        let startIndex = rawDayString.index(slashIndex, offsetBy: -2, limitedBy: rawDayString.startIndex) ?? rawDayString.startIndex
                        let endIndex = rawDayString.index(slashIndex, offsetBy: 3, limitedBy: rawDayString.endIndex) ?? rawDayString.endIndex
                        dayString = String(rawDayString[startIndex..<slashIndex]) + String(rawDayString[slashIndex..<endIndex])
                    }

                    listItems[dayString, default: []].append(textFieldInput)
                    textFieldInput = ""
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
}

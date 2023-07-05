//
//  ValidationHelper.swift
//  ScheduleSaari
//
//  Created by Itoi_Dev on 2023/06/19.
//

import Foundation

class ValidationHelper {
    static func validateComponents(_ rawText: String) {
        let components = rawText.split(separator: " ")
        
        let firstComponent = String(components[0])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        
        let isValidFirstComponent = (dateFormatter.date(from: firstComponent) != nil)
        let isValidLastComponent = (components.last?.count ?? 0) <= 50
        
        switch components.count {
        case 2:
            if isValidFirstComponent && isValidLastComponent {
                // componentsの数が2で、条件に合致する場合の処理
                print("Components count is 2 and valid")
                // ここに処理を追加
            } else {
                // componentsの数が2で、条件に合致しない場合の処理
                print("Components count is 2 but invalid")
                // ここに処理を追加
            }
        case 3:
            let secondComponent = String(components[1])
            let timeFormat = DateFormatter()
            let timeFormats = ["HHmm", "Hmm", "HH:mm", "H:mm"]
            let isValidSecondComponent = timeFormats.contains { format in
                timeFormat.dateFormat = format
                return timeFormat.date(from: secondComponent) != nil
            }
            
            if isValidFirstComponent && isValidLastComponent && isValidSecondComponent {
                // componentsの数が3で、条件に合致する場合の処理
                print("Components count is 3 and valid")
                // ここに処理を追加
            } else {
                // componentsの数が3で、条件に合致しない場合の処理
                print("Components count is 3 but invalid")
                // ここに処理を追加
            }
        case 4:
            let secondComponent = String(components[1])
            let timeFormat = DateFormatter()
            let timeFormats = ["HHmm", "Hmm", "HH:mm", "H:mm"]
            let isValidSecondComponent = timeFormats.contains { format in
                timeFormat.dateFormat = format
                return timeFormat.date(from: secondComponent) != nil
            }
            
            let thirdComponent = String(components[2])
            let isValidThirdComponent = timeFormats.contains { format in
                timeFormat.dateFormat = format
                return timeFormat.date(from: thirdComponent) != nil
            }
            
            if isValidFirstComponent && isValidLastComponent && isValidSecondComponent && isValidThirdComponent {
                // componentsの数が4で、条件に合致する場合の処理
                print("Components count is 4 and valid")
                // ここに処理を追加
            } else {
                // componentsの数が4で、条件に合致しない場合の処理
                print("Components count is 4 but invalid")
                // ここに処理を追加
            }
        default:
            // 上記のいずれの条件にも一致しない場合の処理
            print("登録内容が多すぎます")
            // ここに処理を追加
        }
    }
}

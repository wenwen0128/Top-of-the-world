//
//  Question.swift
//  世界之最
//
//  Created by 溫皓 on 2023/6/13.
//

import Foundation
import UIKit

// 導入 CodableCSV （新增）
import CodableCSV

// 定義一個適用於讀取 CSV 資料的結構
struct Question: Codable {
    
    let questionText: String        // 題目的文字
    let options: String          // 選項的文字
    let correctAnswerText: String     // 正確答案
}

// 在 Question.swift 中新增了一個擴展
extension Question {
    static var data: [Self] {
        var array = [Self]()
        
        // 檢查是否能夠讀取名為 "Geography" 的資料檔案
        if let data = NSDataAsset(name: "Geography")?.data {
            
            // 使用 CSVDecoder 來解碼 CSV 資料
            let decoder = CSVDecoder {
                $0.headerStrategy = .firstLine
            }
            do {
                // 將資料解碼為 Question 的陣列
                array = try decoder.decode([Self].self, from: data)
            } catch {
                print(error)
            }
        }
        // 返回解碼後的陣列
        return array
    }
}

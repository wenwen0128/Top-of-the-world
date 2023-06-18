//
//  ViewController.swift
//  世界之最
//
//  Created by 溫皓 on 2023/6/11.
//

import UIKit
import CodableCSV

class ViewController: UIViewController {
    // 儲存從 Question.data 中取得的問題，這是一個由 Question 結構所組成
    var question = Question.data
    // 用於儲存目前要顯示的問題，初始值與 questions 相同
    var currentQuestion = Question.data
    // 控制當前題目的索引位置
    var index = 0
    // 分數追蹤 (答對時可以加分)
    var score = 0
    
    // 進度條和標籤的 IBOutlet
    @IBOutlet weak var testProgressView: UIProgressView!
    @IBOutlet weak var progressViewLabel: UILabel!
    // 選項按鈕的 IBOutlet
    @IBOutlet var optionButtons: [UIButton]!
    
    // 分數標籤的 IBOutlet
    @IBOutlet weak var scoreLabel: UILabel!
    
    // 重新開始遊戲按鈕的 IBOutlet
    @IBOutlet weak var restartButton: UIButton!
    // 問題內容標籤的 IBOutlet
    @IBOutlet weak var questionContentLabel: UILabel!
    // 答案結果標籤的 IBOutlet
    @IBOutlet weak var answerResultLabel: UILabel!
    // 正確答案標籤的 IBOutlet
    @IBOutlet weak var correctAnwserLabel: UILabel!
    
    // 下一題按鈕的 IBOutlet
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隱藏初始狀態下的相關元件
        scoreLabel.isHidden = true
        questionContentLabel.isHidden = true
        answerResultLabel.isHidden = true
        restartButton.isHidden = true
        nextButton.isHidden = true
        correctAnwserLabel.isHidden = true
        
        // 執行重新開始遊戲的方法
        restartGameButton(restartButton)
        
        print(question)
    }
    
    // 按下正確答案按鈕時的動作
    @IBAction func correctAnswerButton(_ sender: UIButton) {
        let answer = currentQuestion[index].correctAnswerText
        
        // 判斷是否為正確答案
        if sender.title(for: .normal) == answer {
            score += 10
            answerResultLabel.text = "哎唷不錯喔！"
        } else {
            answerResultLabel.text = "哭啊答錯了！"
            correctAnwserLabel.isHidden = false
            correctAnwserLabel.text = "正確答案： \(currentQuestion[index].correctAnswerText)"
        }
        
        // 禁用所有選項按鈕
        for button in optionButtons {
            button.isEnabled = false
        }
        
        questionContentLabel.isHidden = true
        answerResultLabel.isHidden = false
        nextButton.isHidden = false
        
        // 檢查是否為最後一題
        if index == currentQuestion.count - 1 {
            questionContentLabel.isHidden = true
        }
    }
    
    // 按下下一題按鈕時的動作
    @IBAction func nextButton(_ sender: Any) {
        if index < currentQuestion.count - 1 {
            index += 1
            setQuestion()
            
            questionContentLabel.isHidden = false
            answerResultLabel.isHidden = true
            nextButton.isHidden = true
            correctAnwserLabel.isHidden = true
        } else {
            answerResultLabel.isHidden = true
            nextButton.isHidden = true
            restartButton.isHidden = false
            correctAnwserLabel.isHidden = true
            getScoreResult()
        }
        
        progressViewKit()
    }
    
    // 按下重新開始遊戲按鈕時的動作
    @IBAction func restartGameButton(_ sender: UIButton) {
        // 打亂問題順序並取出前 10 題
        question.shuffle()
        currentQuestion = Array(question.prefix(10))
        index = 0
        setQuestion()
        testProgressView.progress = 0.1
        progressViewLabel.text = "第  1  題"
        score = 0
        answerResultLabel.isHidden = true
        questionContentLabel.isHidden = false
        scoreLabel.isHidden = true
        restartButton.isHidden = true
        nextButton.isHidden = true
    }
    
    // 設置問題內容和選項按鈕的方法
    func setQuestion() {
        questionContentLabel.text = currentQuestion[index].questionText
        
        // 將選項拆分為陣列並設置選項按鈕的標題
        let optionsArray = currentQuestion[index].options.split(separator: ",").map(String.init)
        
        for i in 0..<optionsArray.count {
            optionButtons[i].setTitle(optionsArray[i], for: .normal)
            
            // 啟用所有選項按鈕
            for button in optionButtons {
                button.isEnabled = true
            }
        }
    }
    
    // 取得分數結果並顯示在分數標籤中的方法
    func getScoreResult() {
        scoreLabel.isHidden = false
        scoreLabel.text = "得分：\(score) 分"
    }
    
    // 更新進度條和標籤的方法
    func progressViewKit() {
        testProgressView.progress = Float(index + 1) / 10
        progressViewLabel.text = "第  \(index + 1)  題"
    }
}

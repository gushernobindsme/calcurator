//
//  ViewController.swift
//  calculator
//
//  Created by Takumi ERA on 2019/07/21.
//  Copyright © 2019年 inmotion. All rights reserved.
//

import UIKit
import Expression

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 計算結果のラベルを空にする
        resultLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * 各種計算ボタンの押下
     */
    @IBAction func inputFormula(_ sender: UIButton) {
        // 計算結果を取得
        guard let formulaText = resultLabel.text else {
            return
        }
        
        // どのボタンを押下したかを取得
        guard let senderedText = sender.titleLabel?.text else {
            return
        }
        
        // 計算結果の末尾にボタン名をつける
        resultLabel.text = formulaText + senderedText
    }

    /**
     * クリアボタンの押下
     */
    @IBAction func clearCalculation(_ sender: UIButton) {
        // 計算結果のラベルを空にする
        resultLabel.text = ""
    }

    /**
     * イコールボタンの押下
     */
    @IBAction func calculateAnswer(_ sender: UIButton) {
        // ここまでの計算式を取得する
        guard let formulaText = resultLabel.text else {
            return
        }
        
        // 計算式を評価
        let formula: String = formatFormula(formulaText)
        
        // 計算結果のラベルに反映
        resultLabel.text = evalFormula(formula)
    }

    private func formatFormula(_ formula: String) -> String {
        // 入力された整数には「.0」を追加して小数として評価する。「÷」を「/」に、「×」を「*」に置換する
        return formula.replacingOccurrences(
            of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
            with: "$1.0",
            options: NSString.CompareOptions.regularExpression,
            range: nil)
            .replacingOccurrences(
                of: "÷",
                with: "/")
            .replacingOccurrences(
                of: "×",
                with: "*"
        )
    }
    
    private func evalFormula(_ formula: String) -> String {
        do {
            let expression = Expression(formula)
            let answer = try expression.evaluate()
            return formatAnswer(String(answer))
        } catch {
            return "式を正しく入力してください"
        }
    }
    
    private func formatAnswer(_ answer: String) -> String {
        // 答えの小数点以下が「.0」だった場合は、「.0」を削除して答えを整数で表示する
        return answer.replacingOccurrences(
            of: "\\.0$",
            with: "",
            options: NSString.CompareOptions.regularExpression,
            range: nil)
    }

}


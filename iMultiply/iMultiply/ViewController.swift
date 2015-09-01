//
//  ViewController.swift
//  iMultiply
//
//  Created by Max Marze on 8/31/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var multiplierLabel: UILabel!
    @IBOutlet var multiplicandLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var answerChoicesSegmentedControl: UISegmentedControl!
    
    @IBOutlet var nextButton: UIButton!
    
    let maxRandomNumber: UInt32 = 15
    let numberOfAnswerChoices: Int = 4
    
    let maxDifferenceBetweenAnswerAndChoices: Int = 5
    
    let numberOfProblems = 10
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    
    var correctAnswerSegmentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createNewMultiplicationProblem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func createNewMultiplicationProblem() {
        
        let randomMultiplier = arc4random_uniform(maxRandomNumber) + 1
        let randomMultiplicand = arc4random_uniform(maxRandomNumber) + 1
        
        let correctResult = randomMultiplicand * randomMultiplier
        
        multiplierLabel.text = String(randomMultiplier)
        multiplicandLabel.text = String(randomMultiplicand)
        resultLabel.text = String(correctResult)
        
        resultLabel.hidden = true
        
        nextButton.hidden = true
        
        var answerChoices = [UInt32](count: numberOfAnswerChoices, repeatedValue: 0)
        
        answerChoices[0] = correctResult
        
        var differenceBetweenAnswerAndChoicesMin : Int = 0
        
        if Int(correctResult) - maxDifferenceBetweenAnswerAndChoices <= 0 {
            differenceBetweenAnswerAndChoicesMin = maxDifferenceBetweenAnswerAndChoices - Int(correctResult)
        } else {
            differenceBetweenAnswerAndChoicesMin = maxDifferenceBetweenAnswerAndChoices
        }
        
        for var i = 1; i < answerChoices.count; i++ {
            var newChoice = answerChoices[i - 1]
            while contains(answerChoices, newChoice) {
//                newChoice = arc4random_uniform(UInt32(correctResult))
                newChoice = correctResult
                newChoice = arc4random_uniform(2) == 1 ? newChoice + arc4random_uniform(UInt32(maxDifferenceBetweenAnswerAndChoices)) + 1 : newChoice - (arc4random_uniform(UInt32(differenceBetweenAnswerAndChoicesMin)) + 1)
            }
            answerChoices[i] = newChoice
        }
        
        shuffle(&answerChoices)
        
        answerChoicesSegmentedControl.removeAllSegments()
        
        for (index, choice) in enumerate(answerChoices) {
            answerChoicesSegmentedControl.insertSegmentWithTitle(String(choice), atIndex: index, animated: false)
            
            if choice == correctResult {
                correctAnswerSegmentIndex = index
            }
        }
        
    }

    
    // (c) 2014 Nate Cook, licensed under the MIT license
    //
    // Fisher-Yates shuffle as top-level functions and array extension methods
    
    /// Shuffle the elements of `list`.
    private func shuffle<C: MutableCollectionType where C.Index == Int>(inout list: C) {
        let c = count(list)
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
    }
    
    
    @IBAction func answerChoiceSelected(sender: AnyObject) {
        
        if answerChoicesSegmentedControl.selectedSegmentIndex == correctAnswerSegmentIndex {
            correctAnswers++
        } else {
            incorrectAnswers++
        }
        
        resultLabel.hidden = false
        
        if correctAnswers + incorrectAnswers == numberOfProblems {
            nextButton.setTitle("Reset", forState: UIControlState.Normal)
        }
        
        nextButton.hidden = false
    }
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        
        
        if nextButton.titleForState(UIControlState.Normal) == "Reset" {
            correctAnswers = 0
            incorrectAnswers = 0
        }
        
        correctAnswerSegmentIndex = -1
        answerChoicesSegmentedControl.selectedSegmentIndex = -1
        createNewMultiplicationProblem()
        
    }
}


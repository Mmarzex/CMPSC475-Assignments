//
//  ViewController.swift
//  iMultiply
//
//  Created by Max Marze on 8/31/15.
//  Copyright (c) 2015 Max Marze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum IMultiplyButtonState : String {
        case Start = "Start"
        case Next = "Next"
        case Reset = "Reset"
    }
    
    @IBOutlet var multiplierLabel: UILabel!
    @IBOutlet var multiplicandLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var answerCounterLabel: UILabel!
    
    @IBOutlet var answerChoicesSegmentedControl: UISegmentedControl!
    
    @IBOutlet var changeStateButton: UIButton!
    
    let maxRandomNumber: UInt32 = 15
    let numberOfAnswerChoices: Int = 4
    
    let maxDifferenceBetweenAnswerAndChoices: Int = 5
    
    let numberOfProblems = 10
    
    var currentQuestion = 1
    
    var correctAnswers = 0
    var incorrectAnswers = 0
    
    var correctAnswerSegmentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setChangeStateButtonTitle(state : IMultiplyButtonState) {
        changeStateButton.setTitle(state.rawValue, forState: .Normal)
    }
    
    private func setInitialState() {
        resultLabel.hidden = true
        multiplierLabel.hidden = true
        multiplicandLabel.hidden = true
        answerChoicesSegmentedControl.hidden = true
        answerCounterLabel.hidden = true
        setChangeStateButtonTitle(.Start)
    }
    
    private func setDefaultStateOfView() {

        resultLabel.hidden = true
        changeStateButton.hidden = true
        multiplierLabel.hidden = false
        multiplicandLabel.hidden = false
        answerChoicesSegmentedControl.hidden = false
        answerCounterLabel.hidden = false
        
        answerChoicesSegmentedControl.removeAllSegments()
        
        answerCounterLabel.text = "Correct Answers " + String(correctAnswers) +  "/" + String(currentQuestion)
        
        setChangeStateButtonTitle(.Next)
    }

    private func createNewMultiplicationProblem() {
        
        let randomMultiplier = arc4random_uniform(maxRandomNumber) + 1
        let randomMultiplicand = arc4random_uniform(maxRandomNumber) + 1
        
        let correctResult = randomMultiplicand * randomMultiplier
        
        multiplierLabel.text = String(randomMultiplier)
        multiplicandLabel.text = String(randomMultiplicand)
        resultLabel.text = String(correctResult)
        
        setDefaultStateOfView()
                
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
                newChoice = correctResult
                newChoice = arc4random_uniform(2) == 1 ? newChoice + arc4random_uniform(UInt32(maxDifferenceBetweenAnswerAndChoices)) + 1 : newChoice - (arc4random_uniform(UInt32(differenceBetweenAnswerAndChoicesMin)) + 1)
            }
            answerChoices[i] = newChoice
        }
        
        let randomIndex: Int = Int(arc4random_uniform(UInt32(numberOfAnswerChoices - 1)) + 1)
        
        swap(&answerChoices[randomIndex], &answerChoices[0])
        
        for (index, choice) in enumerate(answerChoices) {
            answerChoicesSegmentedControl.insertSegmentWithTitle(String(choice), atIndex: index, animated: false)
            
            if choice == correctResult {
                correctAnswerSegmentIndex = index
            }
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
            setChangeStateButtonTitle(.Reset)
            answerCounterLabel.text = "Correct Answers " + String(correctAnswers) +  "/" + String(currentQuestion)
        }
        
        changeStateButton.hidden = false
    }
    
    /* Change the title of this function */
    @IBAction func changeStateButtonAction(sender: AnyObject) {
        
        if changeStateButton.titleForState(.Normal) == IMultiplyButtonState.Start.rawValue {
            createNewMultiplicationProblem()
        } else if changeStateButton.titleForState(.Normal) == IMultiplyButtonState.Reset.rawValue {
            correctAnswers = 0
            incorrectAnswers = 0
            currentQuestion = 1
            setInitialState()
        } else {
            currentQuestion++
            answerCounterLabel.text = "Correct Answers " + String(correctAnswers) +  "/" + String(currentQuestion)
            
            correctAnswerSegmentIndex = -1
            answerChoicesSegmentedControl.selectedSegmentIndex = -1
            createNewMultiplicationProblem()
        }
    }
}


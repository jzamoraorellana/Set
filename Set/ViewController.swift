//
//  ViewController.swift
//  Set
//
//  Created by Jose Zamora Orellana on 9/29/18.
//  Copyright © 2018 Jose Zamora Orellana. All rights reserved.
//
/* Rules of set in the game:
    - For every set found +3 to score
    - For every time you peek, -4 to score. This way, if you peek throughout the entire game your score will be negative
    - For every time you add cards to the game, and there is a set already available from the cards in game, -10 to score to compensate for easier difficulty
*/

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Set()
    private var noMoreSets = false
    private var peeked = false
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reset()
    }
    
/** EXTRA CREDIT, shows the user a set available from the cardsInGame. If there is no set available, no penalty will be applied **/
    //Is used to check if there is a set available from all combinations in cardsInGame
    @IBAction func peek() {
        game.cardsSelected.removeAll()
        reset()
        peeked = true
        
        for i in 0..<game.cardsInGame.count {
            for j in i..<game.cardsInGame.count {
                for k in j..<game.cardsInGame.count {
                    if i == j ? false: j != k {
                        game.select(card: game.cardsInGame[i], peek: peeked)
                        game.select(card: game.cardsInGame[j], peek: peeked)
                        if game.select(card: game.cardsInGame[k], peek: peeked) != nil {
                            game.points(val: -4)
                            cardButtons[i].layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                            cardButtons[j].layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                            cardButtons[k].layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                            game.cardsSelected.removeAll()
                            updateViewFromModel()
                            return
                        }
                        game.cardsSelected.removeAll()
                    }
                }
            }
        }
        //Removes penalty if not set is found
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        var isSet = false
        //If the player selects a card following a peek, removes the hint and continues as normal
        if peeked {
            reset()
            peeked = false
        }
        
        //Preventing any invisible buttons (not in cardsInGame) from doing anything
        if let index = cardButtons.index(of: sender) {
            if index < game.cardsInGame.count {
                //If this is the third card selected, Set.select(...) will return a boolean value if it happens to become a set
                if game.select(card: game.cardsInGame[index]) != nil { isSet = true }
                highlight(button: sender)
            }
        }
        
        //Follows if the previous if statement results in a set
        if game.cards.count == 0, isSet {
            peek()
            var check = true
            for button in cardButtons {
                if button.layer.borderColor == #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) {
                    check = false
                    game.points(val: -1)
                }
            }
            if check { noMoreSets = true }
            peeked = false
        }
        
        updateViewFromModel()
    }
    
    @IBAction func appendThree() {
        if game.cardsInGame.count < 24, game.cards.count > 0 {
            peek()
            for button in cardButtons {
/** EXTRA CREDIT, penalizes -1 from the score if there is a set when the "+3 cards" button is pressed **/
                if button.layer.borderColor == #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) {
                    game.points(val: -6)
                    break;
                }
            }
            peeked = false
            game.appendCards(numOfCards: 3)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame() {
        game = Set()
        noMoreSets = false
        reset()
        updateViewFromModel()
    }
    
    private func highlight(button: UIButton) {
        if peeked {
            button.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        } else if game.cardsSelected.count == 3 {
            reset()
        } else {
            button.layer.borderColor = button.layer.borderColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) ? #colorLiteral(red: 0.01328834418, green: 1, blue: 0.1080952454, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    private func updateViewFromModel() {
        var correspondingIndex = 0
        scoreLabel.text = "Score: \(game.points()!)"
        if noMoreSets { scoreLabel.text = "No more sets! Score: \(game.points()!)" }
        
        for card in game.cardsInGame {
            //If the card is already selected, highlight
            if game.cardsSelected.index(of: card) == nil, !peeked {
                cardButtons[correspondingIndex].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cardButtons[correspondingIndex].isHidden = false
            cardButtons[correspondingIndex].setTitle(card.contents(), for: UIControlState.normal)
            cardButtons[correspondingIndex].setAttributedTitle(card.attributedContents(), for: UIControlState.normal)
            correspondingIndex += 1
        }
        
        //Every button after the cardsInGame
        for i in correspondingIndex..<24 { cardButtons[i].isHidden = true }
    }
    
    private func reset() {
        game.cardsSelected.removeAll()
        for button in cardButtons {
            button.layer.cornerRadius = 6
            button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            button.layer.borderWidth = 1
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
        updateViewFromModel()
    }
}



//
//  Set.swift
//  Set
//
//  Created by Jose Zamora Orellana on 9/29/18.
//  Copyright © 2018 Jose Zamora Orellana. All rights reserved.
//

import Foundation

class Set {
    
    var cards = [Card]()
    var cardsSelected = [Card]()
    var cardsInGame = [Card]()
    private var score : Int
    
    private func createCards() {
        for color in Color.all {
            for symbol in Shape.all {
                for shade in Shade.all {
                    for number in 1...3 {
                        let card = Card(c: color, s: symbol, n:
                            number, sh: shade)
                        cards.append(card)
                    }
                }
            }
        }
        shuffle()
    }
    
    private func shuffle() {
        for index in cards.indices {
            let rand = cards.count
            let rIndex = rand.arc4random
            let temp = cards[index]
            cards[index] = cards[rIndex]
            cards[rIndex] = temp
        }
        
        appendCards(numOfCards: 12)
    }
    
    func appendCards(numOfCards: Int) {
        //Checks if there are any more cards form the deck
        if cards.count > 0 {
            for _ in 1...numOfCards { cardsInGame.append(cards.remove(at: cards.count-1)) }
        }
    }
    
    // Does most of the work: add the cards to cardsSelected, and removes cards from the main deck, preventing any repetitions.
    //Discardable as to return an optional Bool value to return true if the third selected card creates a set with the other two selected cards
    //Since ViewController.peek() calls this function, optional parameter peek used to prevent score change from the times ViewController.peek() calls Set.select(...)
    @discardableResult func select(card: Card, peek: Bool = false) -> Bool? {
        //If card is already in selectedCards, remove it from cardsSelected
        if let cardAlreadySelected = cardsSelected.index(of: card) {
            cardsSelected.remove(at: cardAlreadySelected)
        } else {
            if cardsSelected.count <= 3 { cardsSelected.append(card) }
        }
        
        if cardsSelected.count == 3 {
            if isSet() {
                for card in cardsSelected {
                    //If card is in cardsInGame, remove it from cards
                    if let cardInGame = cardsInGame.index(of: card), !peek {
                        cardsInGame.remove(at: cardInGame)
                        if cards.count > 0 {
                            //Removes card from the deck (preventing repetitions), while adding it to the game
                            cardsInGame.append(cards.remove(at: cards.count - 1))
                        }
                        print("We have \(cards.count) cards left")
                        cardsSelected.removeAll()
                    }
                }
                if !peek { points(val: 3) }
                return true;
            } else {
                if !peek { points(val: -2) }
                cardsSelected.removeAll()
            }
        }
        return nil;
    }
    
    //Acts as a getter for score, while also incrementing if val is defined
    @discardableResult func points(val: Int = 0) -> Int? {
        score += val
        return score
    }
    
    func isSet() -> Bool {
        if cardsSelected.count < 3 { return false }
        var set = [Bool]()
        
        //Some boolean algebra
        set.append(cardsSelected[0].color == cardsSelected[1].color)
        if set[0] { set[0] = cardsSelected[1].color == cardsSelected[2].color ? cardsSelected[0].color == cardsSelected[2].color : false }
        else { set[0] = cardsSelected[1].color != cardsSelected[2].color ? cardsSelected[0].color != cardsSelected[2].color : false }
        
        set.append(cardsSelected[0].shade == cardsSelected[1].shade)
        if set[1] { set[1] = cardsSelected[1].shade == cardsSelected[2].shade ? cardsSelected[0].shade == cardsSelected[2].shade : false }
        else { set[1] = cardsSelected[1].shade != cardsSelected[2].shade ? cardsSelected[0].shade != cardsSelected[2].shade : false }
        
        set.append(cardsSelected[0].shape == cardsSelected[1].shape)
        if set[2] { set[2] = cardsSelected[1].shape == cardsSelected[2].shape ? cardsSelected[0].shape == cardsSelected[2].shape : false }
        else { set[2] = cardsSelected[1].shape != cardsSelected[2].shape ? cardsSelected[0].shape != cardsSelected[2].shape : false }
        
        set.append(cardsSelected[0].number == cardsSelected[1].number)
        if set[3] { set[3] = cardsSelected[1].number == cardsSelected[2].number ? cardsSelected[0].number == cardsSelected[2].number : false }
        else { set[3] = cardsSelected[1].number != cardsSelected[2].number ? cardsSelected[0].number != cardsSelected[2].number : false }
        
        return set[0] && set[1] && set[2] && set[3]
        //XCode 10 return statement: 
        //return set.allSatisfy({$0 == true})
    }
    
    init() {
        cards = [Card]()
        cardsSelected = [Card]()
        cardsInGame = [Card]()
        score = 0
        createCards()
    }
    
}

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

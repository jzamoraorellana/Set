//
//  Card.swift
//  Concentration
//
//  Created by Jose on 9/24/18.
//  Copyright © 2018 Jose. All rights reserved.
//

import Foundation
import UIKit

struct Card : Equatable {
    
    //To make things easier and obtain the index(of: Card) method
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.shade == rhs.shade &&
            lhs.number == rhs.number
    }
    
    let color : Color
    let shape : Shape
    let shade : Shade
    let number : Int
    var isChosen : Bool
    
    func contents() -> String {
        var contents = ""
        var shape: String
        
        switch(self.shape) {
        case .square: shape = "■"
        case .triangle: shape = "▲"
        case .circle: shape = "●"
        }
        
        for _ in 1...self.number { contents += shape }
        
        return contents
    }
    
    func attributedContents() -> NSAttributedString {
        var strokeColor : UIColor
        
        switch(self.color) {
        case .red: strokeColor = UIColor.red
        case .green: strokeColor = UIColor.green
        case .purple: strokeColor = UIColor.purple
        }
        
        var fillColor = strokeColor
        switch (self.shade) {
        case .solid: fillColor = strokeColor.withAlphaComponent(0.0)
        case .striped: fillColor = strokeColor.withAlphaComponent(0.3)
        case .outline: fillColor = strokeColor.withAlphaComponent(1.0)
        }
        
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: strokeColor,
            .foregroundColor: fillColor,
            .strokeWidth: -5.0
        ]
        
        let attributedString = NSAttributedString(string: self.contents(), attributes: attributes)
        return attributedString
    }
    
    init(c: Color, s: Shape, n: Int, sh : Shade) {
        color = c
        shape = s
        number = n
        shade = sh
        isChosen = false
    }
}

enum Color {
    case red
    case green
    case purple
    
    static let all = [red, green, purple]
}

enum Shape {
    case square
    case triangle
    case circle
    
    static let all = [square, triangle, circle]
}

enum Shade {
    case solid
    case striped
    case outline
    
    static let all = [solid, striped, outline]
}

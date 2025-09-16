//
//  CardsModel.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let type: CardType
    let color: CardColor
    let shading: CardShading
    var count: Int
    var isMatched = false
    var isSelected = false
    var isFaceUp = true
    var isVisible = true
    var position: CGPoint?
}

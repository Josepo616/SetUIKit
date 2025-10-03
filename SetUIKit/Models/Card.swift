//
//  CardsModel.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import UIKit

struct Card: Identifiable, Equatable {
    let id: UUID
    let type: CardType
    let color: CardColor
    let shading: CardShading
    var count: Int
    var isMatched: Bool = false
    var isSelected: Bool = false
    var isFaceUp: Bool = true
    var isVisible: Bool = true
    var position: CGPoint?
}

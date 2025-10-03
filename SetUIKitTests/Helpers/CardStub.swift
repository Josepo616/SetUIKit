//
//  CardStub.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import Foundation

@testable import SetUIKit

struct CardStub {
    static func makeCard(
        id: UUID = UUID(),
        type: CardType = .circle,
        color: CardColor = .red,
        shading: CardShading = .filled,
        count: Int = 1
    ) -> Card {
        return Card(
            id: id,
            type: type,
            color: color,
            shading: shading,
            count: count,
            isMatched: false,
            isSelected: false,
            isFaceUp: true,
            isVisible: true,
            position: nil
        )
    }

    static func makeValidSetTriplet() -> [Card] {
        return [
            makeCard(type: .circle, color: .red, shading: .filled, count: 1),
            makeCard(type: .circle, color: .red, shading: .filled, count: 2),
            makeCard(type: .circle, color: .red, shading: .filled, count: 3),
        ]
    }
}

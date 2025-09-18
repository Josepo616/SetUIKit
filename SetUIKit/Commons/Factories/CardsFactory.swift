//
//  CardsFactory.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import Foundation

struct CardsFactory {
    static func makeCards() -> [Card] {
        var deck: [Card] = []
        for type in CardType.allCases {
            for color in CardColor.allCases {
                for shading in CardShading.allCases {
                    for count in 1...3 {
                        deck.append(Card(id: UUID(), type: type, color: color, shading: shading, count: count))
                    }
                }
            }
        }
        return deck.shuffled()
    }
}

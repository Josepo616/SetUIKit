//
//  MockSetGameLogic.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import UIKit

@testable import SetUIKit

class MockSetGameLogic: SetGameLogic {
    var addMoreCardsCalled = false
    var addMoreCardsCount = 0
    var shuffleVisibleCardsCalled = false
    var setupCardsGridCalled = false
    var lastTappedCardID: UUID?

    override func addMoreCards(count: Int = 3, _ selectedCards: [Card]? = nil) {
        addMoreCardsCalled = true
        addMoreCardsCount = count
    }

    override func shuffleVisibleCards() {
        shuffleVisibleCardsCalled = true
    }

    override func setupCardsGrid() {
        setupCardsGridCalled = true
    }

    override func handleCardTap(
        _ tappedCardID: UUID,
        in scrollView: UIScrollView
    ) {
        lastTappedCardID = tappedCardID
    }
}

//
//  TestableSetGameLogic.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

@testable import SetUIKit

final class TestableSetGameLogic: SetGameLogic {
    private(set) var addMoreCardsCalledWith: [Card]? = nil
    private(set) var deselectCardsCalledWith: [Card]? = nil
    private(set) var setupCardsGridCalled = false

    override func addMoreCards(count: Int = 3, _ selectedCards: [Card]? = nil) {
        addMoreCardsCalledWith = selectedCards
    }

    override func deselectCards(_ selectedCards: [Card]) {
        deselectCardsCalledWith = selectedCards
    }

    override func setupCardsGrid() {
        setupCardsGridCalled = true
    }
}

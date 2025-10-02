//
//  HandleCardTapComprehensiveTests.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
@testable import SetUIKit

final class HandleCardTapComprehensiveTests: XCTestCase {
    
    var sut: SetGameLogic!
    var scrollView: UIScrollView!
    var deck: [Card]!
    
    override func setUp() {
        super.setUp()
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: 400, height: 800)
    }
    
    override func tearDown() {
        sut = nil
        scrollView = nil
        deck = nil
        super.tearDown()
    }
    
    /// Given: one visible card (unselected) and a scroll view with matching CardView
    /// When: the single card is tapped
    /// Then: the visibleCards model toggles isSelected to true and the CardView updates its border color
    func test_singleTap_selectsCard_and_updatesCardViewBorder() {
        // Given
        let card = CardStub.makeCard()
        deck = [card]
        sut = SetGameLogic(startedAmount: 1, allCards: deck, targetScrollView: scrollView, gameState: .started)
        attachCardViews(to: scrollView, for: sut.visibleCards)
        
        // Precondition
        XCTAssertFalse(sut.visibleCards[0].isSelected, "Given: card starts unselected")
        
        // When
        sut.handleCardTap(card.id, in: scrollView)
        
        // Then: model updated
        XCTAssertTrue(sut.visibleCards[0].isSelected, "Then: visible card must be marked selected after tap")
        
        // Then: UI updated (CardView border color)
        let expectationColor = expectation(description: "wait border color animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let cardView = self.scrollView.subviews.compactMap({ $0 as? CardView }).first { $0.card.id == card.id }
            XCTAssertNotNil(cardView, "CardView should exist in scrollView")
            XCTAssertEqual(cardView?.layer.borderColor, UIColor.cyan.cgColor, "CardView border should be cyan after selecting")
            expectationColor.fulfill()
        }
        wait(for: [expectationColor], timeout: 1.0)
    }
    
    /// Given: a card that is currently selected and selectedCards.count < 3
    /// When: the same card is tapped again
    /// Then: the model deselects the card and CardView updates accordingly
    func test_tap_whenCardAlreadySelected_and_selectedCardsLessThan3_deselects() {
        // Given
        var card = CardStub.makeCard()
        card.isSelected = true
        deck = [card]
        sut = SetGameLogic(startedAmount: 1, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.visibleCards = [card]
        attachCardViews(to: scrollView, for: sut.visibleCards)
        
        // Precondition
        XCTAssertTrue(sut.visibleCards[0].isSelected, "Given: card should start selected")
        
        // When
        sut.handleCardTap(card.id, in: scrollView)
        
        // Then: model updated -> deselected
        XCTAssertFalse(sut.visibleCards[0].isSelected, "Then: card must be deselected after tapping when already selected and <3 selected")
        
        // Then: UI updated (border color to label)
        let exp = expectation(description: "wait deselect animation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            let cardView = self.scrollView.subviews.compactMap({ $0 as? CardView }).first { $0.card.id == card.id }
            XCTAssertNotNil(cardView)
            XCTAssertEqual(cardView?.layer.borderColor, UIColor.label.cgColor)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // Los otros métodos de prueba seguirían la misma estructura. Aquí van los primeros tres, pero puedes hacer lo mismo para los demás.
    
    /// Given: three visible cards forming a valid set and a mock delegate
    /// When: the three cards are tapped sequentially
    /// Then: delegate.didUpdateScore is called with +3, validSet is true and snackbar message indicates success
    func test_select_three_valid_cards_updatesScore_and_showsSnackbar_fixed() {
        // Given
        let triplet = CardStub.makeValidSetTriplet()
        deck = triplet
        sut = SetGameLogic(startedAmount: 3, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.setupCardsGrid()
        
        let mockDelegate = MockGameDelegate()
        mockDelegate.scoreExpectation = expectation(description: "delegate should be called for valid set")
        sut.delegate = mockDelegate
        
        XCTAssertEqual(sut.score, 0)
        
        // When: tap the three cards sequentially
        for card in sut.visibleCards {
            sut.handleCardTap(card.id, in: scrollView)
        }
        
        // Then: wait for delegate to be called
        wait(for: [mockDelegate.scoreExpectation!], timeout: 1.0)
        
        XCTAssertTrue(sut.validSet, "Then: validSet should be true for a valid triplet")
        XCTAssertEqual(mockDelegate.lastScore, 3, "Then: score should increase by 3 for a valid set")
        XCTAssertEqual(mockDelegate.lastSnackbarMessage, "Set valid, keep going!")
    }
    
    /// Given: three visible cards that are invalid and a mock delegate
    /// When: the three cards are tapped sequentially
    /// Then: delegate.didUpdateScore is called with -1 and snackbar indicates invalid set
    func test_select_three_invalid_cards_appliesPenalty_and_showsSnackbar() {
        // Given
        let card1 = CardStub.makeCard(type: .circle, color: .red, shading: .filled, count: 1)
        let card2 = CardStub.makeCard(type: .circle, color: .red, shading: .filled, count: 2)
        let card3 = CardStub.makeCard(type: .square, color: .red, shading: .filled, count: 2) // breaks the "all same or all different" rule
        deck = [card1, card2, card3]
        sut = SetGameLogic(startedAmount: 3, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.setupCardsGrid()
        
        let mockDelegate = MockGameDelegate()
        mockDelegate.scoreExpectation = expectation(description: "delegate should be called for invalid set")
        sut.delegate = mockDelegate
        
        // Precondition
        XCTAssertEqual(sut.score, 0, "Precondition: initial score should be 0")
        
        // When: tap all three cards
        for card in sut.visibleCards {
            sut.handleCardTap(card.id, in: scrollView)
        }
        
        // Then
        wait(for: [mockDelegate.scoreExpectation!], timeout: 1.0)
        
        XCTAssertFalse(sut.validSet, "Then: validSet should be false for an invalid triplet")
        XCTAssertEqual(mockDelegate.lastScore, -1, "Then: score should decrease by 1 for an invalid set")
        
        // Assert that the snackbar message indicates invalidity (case-insensitive)
        XCTAssertTrue(
            mockDelegate.lastSnackbarMessage?.lowercased().contains("invalid set") ?? false,
            "Then: snackbar message should indicate invalidity"
        )
    }
    
    /// Given: 4 visible cards where first 3 are a valid set, validSet is true, and three are pre-selected
    /// When: the 4th card is tapped (which causes the code path where selectedCards.count == 4)
    /// Then: addMoreCards(selectedCards) should be invoked and setupCardsGrid should be scheduled (setupCardsGrid override flag)
    func test_fourthTap_with_previousValidSet_callsAddMoreCards_withSelectedTriplet() {
        // Given
        let firstThree = CardStub.makeValidSetTriplet()
        let fourth = CardStub.makeCard(type: .square, color: .green, shading: .empty, count: 1)
        var deck = firstThree + [fourth]
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        
        let sut = TestableSetGameLogic(startedAmount: 4, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.visibleCards = deck
        sut.visibleCards[0].isSelected = true
        sut.visibleCards[1].isSelected = true
        sut.visibleCards[2].isSelected = true
        sut.validSet = true
        
        attachCardViews(to: scrollView, for: sut.visibleCards)
        
        // When
        sut.handleCardTap(fourth.id, in: scrollView)
        
        // Then
        XCTAssertNotNil(sut.addMoreCardsCalledWith, "Then: addMoreCards should be called when 3 selected + 4th tapped and validSet == true")
        XCTAssertEqual(sut.addMoreCardsCalledWith?.count, 3, "Then: addMoreCards should receive the 3 cards to replace")
        XCTAssertTrue(sut.setupCardsGridCalled, "Then: setupCardsGrid should be invoked after handling the 4-selection")
        XCTAssertFalse(sut.scoreUpdated, "Then: scoreUpdated should be reset to false after processing the 4-selection branch")
    }
    
    /// Given: 4 visible cards where first 3 are NOT a valid set (validSet = false) and three are pre-selected
    /// When: the 4th card is tapped
    /// Then: deselectCards(...) should be called with the selectedCards
    func test_fourthTap_with_invalidSet_callsDeselectCards() {
        // Given
        let c1 = CardStub.makeCard(type: .circle, color: .red, shading: .filled, count: 1)
        let c2 = CardStub.makeCard(type: .circle, color: .red, shading: .filled, count: 1)
        let c3 = CardStub.makeCard(type: .square, color: .green, shading: .empty, count: 2)
        let c4 = CardStub.makeCard(type: .triangle, color: .purple, shading: .striped, count: 3)
        let deck = [c1, c2, c3, c4]
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        
        let sut = TestableSetGameLogic(startedAmount: 4, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.visibleCards = deck
        sut.visibleCards[0].isSelected = true
        sut.visibleCards[1].isSelected = true
        sut.visibleCards[2].isSelected = true
        sut.validSet = false
        
        attachCardViews(to: scrollView, for: sut.visibleCards)
        
        // When
        sut.handleCardTap(c4.id, in: scrollView)
        
        // Then
        XCTAssertNotNil(sut.deselectCardsCalledWith, "Then: deselectCards should be called when 4th card is tapped with an invalid set")
        XCTAssertEqual(sut.deselectCardsCalledWith?.count, 3, "Then: deselectCards should receive the previously selected triplet")
        XCTAssertTrue(sut.setupCardsGridCalled, "Then: setupCardsGrid should be called after processing the invalid set")
        XCTAssertFalse(sut.scoreUpdated, "Then: scoreUpdated should be reset to false after handling the invalid set")
    }
    
    /// Given: a game with some visible cards and a mock delegate
    /// When: handleCardTap is called with an unknown UUID
    /// Then: no state changes occur and delegate is not called
    func test_handleCardTap_withUnknownCardID_doesNothing() {
        // Given
        let deck = SetGameCardsMock.makeDeckMock()
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        
        let sut = SetGameLogic(startedAmount: 3, allCards: deck, targetScrollView: scrollView, gameState: .started)
        sut.setupCardsGrid()
        
        let mockDelegate = MockGameDelegate()
        sut.delegate = mockDelegate
        
        let unknownID = UUID()
        
        // Precondition
        XCTAssertTrue(sut.selectedCards.isEmpty, "Precondition: no cards selected initially")
        
        // When
        sut.handleCardTap(unknownID, in: scrollView)
        
        // Then
        XCTAssertTrue(sut.selectedCards.isEmpty, "Then: selectedCards should remain empty if ID not found")
        XCTAssertFalse(mockDelegate.didUpdateScoreCalled, "Then: delegate should not be called")
    }
    
    /// Given: a set of visible cards with some selected
    /// When: deselectCards is called on those selected cards
    /// Then: all those cards should have isSelected = false
    func test_deselectCards_unselectsAllSelectedCards() {
        // Given
        let card1 = CardStub.makeCard(type: .circle, color: .red, shading: .filled, count: 1)
        let card2 = CardStub.makeCard(type: .triangle, color: .green, shading: .empty, count: 2)
        let card3 = CardStub.makeCard(type: .square, color: .purple, shading: .striped, count: 3)
        
        var deck = [card1, card2, card3]
        deck[0].isSelected = true
        deck[2].isSelected = true
        
        let scrollView = UIScrollView()
        let sut = SetGameLogic(startedAmount: 3, allCards: deck, targetScrollView: scrollView, gameState: .started)
        
        // Precondition
        XCTAssertTrue(sut.visibleCards[0].isSelected, "Precondition: first card should be selected")
        XCTAssertFalse(sut.visibleCards[1].isSelected, "Precondition: second card should not be selected")
        XCTAssertTrue(sut.visibleCards[2].isSelected, "Precondition: third card should be selected")
        
        // When
        sut.deselectCards([deck[0], deck[2]])
        
        // Then
        XCTAssertFalse(sut.visibleCards[0].isSelected, "Then: first card should now be unselected")
        XCTAssertFalse(sut.visibleCards[2].isSelected, "Then: third card should now be unselected")
        XCTAssertFalse(sut.visibleCards[1].isSelected, "Then: second card should remain unselected")
    }
}

private func attachCardViews(to scrollView: UIScrollView, for visibleCards: [Card]) {
    // create CardView instances matching visibleCards and add to scrollView
    for card in visibleCards {
        let cardView = CardView(card: card, size: CGSize(width: 100, height: 150))
        cardView.frame = CGRect(origin: .zero, size: cardView.frame.size)
        scrollView.addSubview(cardView)
    }
}

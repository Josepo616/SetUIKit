//
//  SetGameLogicTests 2.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest

@testable import SetUIKit

final class SetGameLogicTests: XCTestCase {
    
    // MARK: - Properties
    var sut: SetGameLogic!
    var mockDelegate: MockGameDelegate!
    var deck: [Card]!
    var scrollView: UIScrollView!
    
    // MARK: - SetUp and TearDown
    
    override func setUp() {
        super.setUp()
        // Initialize common dependencies before each test
        deck = Array(SetGameCardsMock.makeDeckMock().prefix(25))
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: 400, height: 800)
        scrollView.bounds = scrollView.frame
        
        // Initialize the SetGameLogic instance
        sut = SetGameLogic(
            startedAmount: 24,
            allCards: deck,
            targetScrollView: scrollView,
            gameState: .started
        )
        
        // Set up the delegate
        mockDelegate = MockGameDelegate()
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        // Clean up after each test
        sut = nil
        mockDelegate = nil
        deck = nil
        scrollView = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_setupCardsGrid_triggersDelegateWhenLayoutHidesButton() {
        // Given: already initialized in setUp
        // When
        sut.setupCardsGrid()
        
        // Then
        XCTAssertNotNil(
            mockDelegate.didHideButtonFlag,
            "Then: delegate should be informed about button visibility"
        )
        XCTAssertEqual(
            mockDelegate.didHideButtonFlag,
            sut.shouldHiddeButton,
            "Then: delegate should receive the same flag as sut.shouldHiddeButton"
        )
    }
    
    func test_setupCardsGrid_onCardTapped_executesHandleCardTap() {
        // Given: already initialized in setUp
        sut.setupCardsGrid()
        
        guard let card = sut.visibleCards.first,
              let cardView = sut.cardViewsByID[card.id]
        else {
            XCTFail("Precondition failed: CardView not found")
            return
        }
        
        // Precondition
        XCTAssertFalse(
            card.isSelected,
            "Precondition: card should start unselected"
        )
        
        // When: manually invoke the onCardTapped closure
        cardView.onCardTapped?(card.id)
        
        // Then
        XCTAssertTrue(
            sut.visibleCards.first?.isSelected ?? false,
            "Then: card should become selected after tap"
        )
    }
    
    func test_addMoreCards_addsCards_whenLessThanThreeSelected() {
        // Given: already initialized in setUp
        sut = SetGameLogic(
            startedAmount: 3,
            allCards: deck,
            targetScrollView: scrollView,
            gameState: .started
        )

        let initialVisibleCount = sut.visibleCards.count
        let initialRemainingCount = sut.cardsRemaining.count
        
        // When
        sut.addMoreCards(count: 2)
        
        // Then
        XCTAssertEqual(
            sut.visibleCards.count,
            initialVisibleCount + 2,
            "Then: two cards should be added to visibleCards"
        )
        XCTAssertEqual(
            sut.cardsRemaining.count,
            initialRemainingCount - 2,
            "Then: two cards should be removed from remaining deck"
        )
    }
    
    func test_shuffleVisibleCards_reordersCards() {
        // Given: already initialized in setUp
        let originalOrder = sut.visibleCards.map { $0.id }
        
        // When
        sut.shuffleVisibleCards()
        let shuffledOrder = sut.visibleCards.map { $0.id }
        
        // Then
        XCTAssertEqual(
            Set(originalOrder),
            Set(shuffledOrder),
            "Then: all original cards should still be present"
        )
        XCTAssertNotEqual(
            originalOrder,
            shuffledOrder,
            "Then: the order of cards should be changed after shuffle"
        )
    }
    
    func
    test_addMoreCards_withValidSet_replacesSelectedCards_and_keepsTotalCount()
    {
        // Given: a valid set of 3 selected cards, already set up
        let validTriplet = CardStub.makeValidSetTriplet()  // must be 3 cards forming a valid set
        let remainingDeck = SetGameCardsMock.makeDeckMock().filter {
            !validTriplet.contains($0)
        }
        let allCards = validTriplet + remainingDeck
        sut = SetGameLogic(
            startedAmount: 6,
            allCards: allCards,
            targetScrollView: scrollView,
            gameState: .started
        )
        
        // Select the valid set
        validTriplet.forEach { card in
            if let index = sut.visibleCards.firstIndex(of: card) {
                sut.visibleCards[index].isSelected = true
            }
        }
        
        let oldVisibleIDs = sut.visibleCards.map { $0.id }
        
        // When: addMoreCards is called (should replace the valid set)
        sut.addMoreCards()
        
        // Then: selected cards are replaced
        let newVisibleIDs = sut.visibleCards.map { $0.id }
        XCTAssertFalse(
            validTriplet.allSatisfy { newVisibleIDs.contains($0.id) },
            "Then: selected cards should be replaced"
        )
        
        // And: total count of visible cards remains the same
        XCTAssertEqual(
            newVisibleIDs.count,
            oldVisibleIDs.count,
            "Then: total visible cards count should remain the same"
        )
    }
    
    func test_addCards_and_delegateRemaingCardsCount() {
        // Given: already initialized in setUp
        sut = SetGameLogic(
            startedAmount: 3,
            allCards: deck,
            targetScrollView: scrollView,
            gameState: .started
        )
        let mockDelegate = MockGameDelegate()
        sut.delegate = mockDelegate
        let initialVisibleCount = sut.visibleCards.count
        let initialRemainingCount = sut.cardsRemaining.count
        
        // When: add 3 cards
        sut.addMoreCards(count: 3)
        
        // Then: visibleCards increased by 3
        XCTAssertEqual(sut.visibleCards.count, initialVisibleCount + 3)
        XCTAssertEqual(sut.cardsRemaining.count, initialRemainingCount - 3)
        
        // When: remove all remaining cards to trigger delegate
        sut.cardsRemaining.removeAll()
        sut.addMoreCards(count: 3)
        
        // Then: delegate should be called
        XCTAssertEqual(mockDelegate.didHideButtonFlag, sut.shouldHiddeButton)
    }
}


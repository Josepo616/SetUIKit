//
//  SetGameViewControllerTests.swift
//  SetUIKitTests
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
@testable import SetUIKit

final class SetGameViewControllerTests: XCTestCase {

    // MARK: - Properties
    var mockLogic: MockSetGameLogic!
    var vc: SetGameViewControllerMock!

    // MARK: - SetUp and TearDown

    override func setUp() {
        super.setUp()
        // Initialize the common dependencies before each test
        mockLogic = MockSetGameLogic(startedAmount: 12, allCards: [], targetScrollView: UIScrollView(), gameState: .notStarted)
        vc = SetGameViewControllerMock(gameLogic: mockLogic)
    }

    override func tearDown() {
        // Clean up after each test
        mockLogic = nil
        vc = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_shuffleCards_callsGameLogicMethods() {
        // When
        vc.shuffleCards()

        // Then
        XCTAssertTrue(mockLogic.shuffleVisibleCardsCalled)
        //XCTAssertTrue(mockLogic.setupCardsGridCalled)
    }

    func test_addMoreCards_callsGameLogicMethods() {
        // When
        vc.addMoreCards()

        // Then
        XCTAssertTrue(mockLogic.addMoreCardsCalled)
        XCTAssertEqual(mockLogic.addMoreCardsCount, 3)
        XCTAssertTrue(mockLogic.setupCardsGridCalled)
    }

    func test_handleCardTap_callsGameLogicHandleCardTap() {
        let scrollView = UIScrollView()
        let tappedID = UUID()

        // When
        vc.handleCardTap(tappedID, in: scrollView)

        // Then
        XCTAssertEqual(mockLogic.lastTappedCardID, tappedID)
    }
}

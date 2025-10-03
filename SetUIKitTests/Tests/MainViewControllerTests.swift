//
//  MainViewControllerTests.swift
//  SetUIKitTests
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
@testable import SetUIKit

final class MainViewControllerTests: XCTestCase {

    // MARK: - Properties
    var mainVC: MainViewControllerMock!
    var mockGameLogic: MockSetGameLogic!
    var mockShapesVC: SetGameViewControllerMock!

    // MARK: - SetUp and TearDown

    override func setUp() {
        super.setUp()
        mainVC = MainViewControllerMock()
        mainVC.setupOutletsForTesting()
        
        let deck = Array(SetGameCardsMock.makeDeckMock().prefix(25))
        mockGameLogic = MockSetGameLogic(startedAmount: 24, allCards: deck, targetScrollView: mainVC.scrollView, gameState: .started)
        mockShapesVC = SetGameViewControllerMock(gameLogic: mockGameLogic)
        mainVC.shapesVC = mockShapesVC
    }

    override func tearDown() {
        mainVC = nil
        mockGameLogic = nil
        mockShapesVC = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testStartNewGameCreatesNewSetGameViewControllerAndResetsScore() {
        /// Given
        XCTAssertEqual(mainVC.children.count, 0)
        XCTAssertEqual(mainVC.scoreLabel.text, nil)
        XCTAssertTrue(mainVC.moreCardsButton.isHidden)
        /// When
        mainVC.startNewGame(self)
        /// Then
        XCTAssertEqual(mainVC.children.count, 1)
        XCTAssertNotNil(mainVC.shapesVC)
        XCTAssertEqual(mainVC.scoreLabel.text, "Score: 0")
        XCTAssertFalse(mainVC.moreCardsButton.isHidden)
    }

    func testAddMoreCardsCallsGameLogicAddMoreCards() {
        /// Given
        XCTAssertFalse(mockGameLogic.addMoreCardsCalled)
        /// When
        mainVC.addMoreCards(self)
        /// Then
        XCTAssertTrue(mockGameLogic.addMoreCardsCalled)
    }

    func testShuffleButtonActionCallsGameLogicShuffle() {
        /// Given
        XCTAssertFalse(mockGameLogic.shuffleVisibleCardsCalled)
        /// When
        mainVC.shuffleButtonAction(self)
        /// Then
        XCTAssertTrue(mockGameLogic.shuffleVisibleCardsCalled)
    }

    func testDidUpdateScoreUpdatesScoreLabel() {
        /// Given: The score starts in 0
        /// When
        mainVC.didUpdateScore(to: 5)
        /// Then
        XCTAssertEqual(mainVC.scoreLabel.text, "Score: 5")
    }

    func testDidCardsRemainingOverUpdatesMoreCardsButtonVisibility() {
        /// Given: the initial state for the button visibility is hide
        /// When
        mainVC.didCardsRemainingOver(to: true)
        /// Then
        XCTAssertTrue(mainVC.moreCardsButton.isHidden)
        /// When
        mainVC.didCardsRemainingOver(to: false)
        /// Then
        XCTAssertFalse(mainVC.moreCardsButton.isHidden)
    }
}

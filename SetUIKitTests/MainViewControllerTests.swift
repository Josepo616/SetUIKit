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

    func test_startNewGame_createsNewSetGameViewController_andResetsScore() {
        XCTAssertEqual(mainVC.children.count, 0)
        XCTAssertEqual(mainVC.scoreLabel.text, nil)
        XCTAssertTrue(mainVC.moreCardsButton.isHidden)

        mainVC.startNewGame(self)

        XCTAssertEqual(mainVC.children.count, 1)
        XCTAssertNotNil(mainVC.shapesVC)
        XCTAssertEqual(mainVC.scoreLabel.text, "Score: 0")
        XCTAssertFalse(mainVC.moreCardsButton.isHidden)
    }

    func test_addMoreCards_callsGameLogicAddMoreCards() {
        XCTAssertFalse(mockGameLogic.addMoreCardsCalled)
        mainVC.addMoreCards(self)
        XCTAssertTrue(mockGameLogic.addMoreCardsCalled)
    }

    func test_shuffleButtonAction_callsGameLogicShuffle() {
        XCTAssertFalse(mockGameLogic.shuffleVisibleCardsCalled)
        mainVC.shuffleButtonAction(self)
        XCTAssertTrue(mockGameLogic.shuffleVisibleCardsCalled)
    }

    func test_didUpdateScore_updatesScoreLabel() {
        mainVC.didUpdateScore(to: 5)
        XCTAssertEqual(mainVC.scoreLabel.text, "Score: 5")
    }

    func test_didCardsRemainingOver_updatesMoreCardsButtonVisibility() {
        mainVC.didCardsRemainingOver(to: true)
        XCTAssertTrue(mainVC.moreCardsButton.isHidden)
        mainVC.didCardsRemainingOver(to: false)
        XCTAssertFalse(mainVC.moreCardsButton.isHidden)
    }
}

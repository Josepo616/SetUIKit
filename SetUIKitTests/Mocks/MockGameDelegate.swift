//
//  GameViewControllerDelegateMock.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
import UIKit
@testable import SetUIKit

final class MockGameDelegate: GameViewControllerDelegate {
    var didUpdateScoreCalled = false
    var lastScore: Int?
    var didStartState: GameState?
    var rotateCalled: Bool = false
    var didHideButtonFlag: Bool?
    var lastSnackbarMessage: String?
    var scoreExpectation: XCTestExpectation?

    func didUpdateScore(to score: Int) {
        didUpdateScoreCalled = true
        lastScore = score
        scoreExpectation?.fulfill()
    }

    func gameDidStart(to gameState: GameState) {
        didStartState = gameState
    }

    func didRotationHappened(to hasRotated: Bool) {
        rotateCalled = hasRotated
    }

    func didCardsRemainingOver(to shouldHiddeButton: Bool) {
        didHideButtonFlag = shouldHiddeButton
    }

    func showSnackbarMessage(message: String) {
        print("Snackbar message: \(message)")
        lastSnackbarMessage = message
    }
}

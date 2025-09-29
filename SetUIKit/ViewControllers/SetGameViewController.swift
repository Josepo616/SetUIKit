//
//  SetGameViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

class SetGameViewController: UIViewController {

    private let targetScrollView: UIScrollView
    let startedAmount: Int
    var gameState: GameState
    var gameLogic: SetGameLogic
    var hasRotated = false

    init(
        startedAmount: Int,
        targetScrollView: UIScrollView,
        gameState: GameState = .notStarted
    ) {
        self.startedAmount = startedAmount
        let allCards = CardsFactory.makeCards()
        self.targetScrollView = targetScrollView
        self.gameLogic = SetGameLogic(
            startedAmount: startedAmount,
            allCards: allCards,
            targetScrollView: targetScrollView,
            gameState: gameState
        )
        self.gameState = gameState
        super.init(nibName: nil, bundle: nil)
        self.startGame()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.hasRotated = true
            self.gameLogic.delegate?.didRotationHappened(to: self.hasRotated)
        })
    }

    private func handleCardTap(
        _ tappedCardID: UUID,
        in scrollView: UIScrollView
    ) {
        gameLogic.handleCardTap(tappedCardID, in: scrollView)
    }

    func startGame() {
        gameState = .started
        gameLogic.delegate?.didGameStart(to: gameState)

    }

    func shuffleCards() {
        gameLogic.shuffleVisibleCards()
        gameLogic.setupCardsGrid()
    }

    func addMoreCards() {
        gameLogic.addMoreCards(count: 3)
        gameLogic.setupCardsGrid()
    }
}

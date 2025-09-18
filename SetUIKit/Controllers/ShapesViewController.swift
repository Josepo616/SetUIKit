//
//  ShapesViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

class ShapesViewController: UIViewController {

    private let targetScrollView: UIScrollView
    private var selectedCount = 0
    let startedAmount: Int
    var gameState: GameState
    var gameLogic: GameLogicProtocol
    var hasRotated = false

    init(startedAmount: Int, targetScrollView: UIScrollView, gameState: GameState = .notStarted) {
        self.startedAmount = startedAmount
        let allCards = CardsFactory.makeCards()
        self.targetScrollView = targetScrollView
        self.gameLogic = GameLogic(
            startedAmount: startedAmount,
            allCards: allCards,
            targetScrollView: targetScrollView
        )
        self.gameState = gameState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if gameState == .notStarted {
            startGame()
            gameLogic.delegate?.gameDidStart(to: gameState)
            gameLogic.setupCardsGrid()
        }
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.hasRotated = true
            self.gameLogic.delegate?.didRotationHappened(to: self.hasRotated)
            print(self.hasRotated)
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
    }

    func pauseGame() {
        gameState = .paused
    }

    func endGame() {
        gameState = .lost
    }

    func completeGame() {
        gameState = .completed
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

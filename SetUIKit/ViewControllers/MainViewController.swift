//
//  ViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import UIKit

class MainViewController: UIViewController, GameViewControllerDelegate {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var moreCardsButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    private var shapesVC: SetGameViewController?
    private var currentGameState: GameState = .notStarted

    override func viewDidLoad() {
        super.viewDidLoad()
        moreCardsButton.isHidden = true
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else {
            return
        }

        if traitCollection.hasDifferentColorAppearance(
            comparedTo: previousTraitCollection
        ) {
            shapesVC?.gameLogic.setupCardsGrid()
        }
    }

    @IBAction func startNewGame(_ sender: Any) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        let newShapesVC = SetGameViewController(
            startedAmount: 12,
            targetScrollView: scrollView,
            gameState: currentGameState
        )

        newShapesVC.gameLogic.delegate = self
        self.addChild(newShapesVC)
        newShapesVC.didMove(toParent: self)
        self.moreCardsButton.isHidden = false
        self.shapesVC = newShapesVC
        self.scoreLabel.text = "Score: 0"
        self.shapesVC?.gameLogic.setupCardsGrid()
    }

    @IBAction func addMoreCards(_ sender: Any) {
        shapesVC?.addMoreCards()
    }

    @IBAction func shuffleButtonAction(_ sender: Any) {
        shapesVC?.shuffleCards()
    }

    func didCardsRemainingOver(to shouldHidden: Bool) {
        moreCardsButton.isHidden = shouldHidden
    }

    func didUpdateScore(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    func gameDidStart(to gameState: GameState) {
        currentGameState = gameState
    }

    func didRotationHappened(to hasRotated: Bool) {
        if ((shapesVC?.hasRotated) != nil) && (shapesVC?.gameState == .started)
        {
            shapesVC?.gameLogic.setupCardsGrid()
            shapesVC?.hasRotated = false
        }
    }
}

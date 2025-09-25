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
        let swipeDownGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipeDown(_:))
        )
        swipeDownGesture.direction = .down
        
        let rotationGesture = UIRotationGestureRecognizer(
            target: self,
            action: #selector(handleRotation(_:))
        )
        self.view.addGestureRecognizer(swipeDownGesture)
        self.view.addGestureRecognizer(rotationGesture)
    }

    @objc func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.state {
        case .ended:
            shapesVC?.addMoreCards()
        default:
            break
        }
    }

    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .ended:
            shapesVC?.shuffleCards()
        default:
            break
        }
    }
    
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
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

    func shouldAddCardsButtonHidde(to shouldHidden: Bool) {
        moreCardsButton.isHidden = shouldHidden
    }

    func didUpdateScore(to score: Int) {
        scoreLabel.text = "Score: \(score)"
    }

    func didGameStart(to gameState: GameState) {
        currentGameState = gameState
    }

    func didRotationHappened(to hasRotated: Bool) {
        if ((shapesVC?.hasRotated) != nil) && (shapesVC?.gameState == .started)
        {
            shapesVC?.gameLogic.setupCardsGrid()
            shapesVC?.hasRotated = false
        }
    }
    
    func showSnackbarMessage(message: String) {
        let snackbar = UIView()
        snackbar.backgroundColor = shapesVC?.gameLogic.validSet ?? false ? .init(red: 0, green: 0.4, blue: 0, alpha: 1) : .systemRed
        snackbar.layer.cornerRadius = 10
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(snackbar)

        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        snackbar.addSubview(label)

        NSLayoutConstraint.activate([
            snackbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            snackbar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            snackbar.widthAnchor.constraint(equalToConstant: 300),
            snackbar.heightAnchor.constraint(equalToConstant: 50),

            label.centerXAnchor.constraint(equalTo: snackbar.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor)
        ])

        UIView.animate(withDuration: 2) {
            snackbar.alpha = 0.2
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3, animations: {
                snackbar.alpha = 0
            }) { _ in
                snackbar.removeFromSuperview()
            }
        }
    }
}

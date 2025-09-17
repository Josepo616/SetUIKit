//
//  ViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var moreCardsButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    static var gameState: GameState = .notStarted

    private var shapesVC: ShapesViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame(self)
        moreCardsButton.isHidden = true
    }

    @IBAction func startNewGame(_ sender: Any) {
        ViewController.gameState = .started
        
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        let newShapesVC = ShapesViewController(
            startedAmount: 12,
            targetScrollView: scrollView
        )
        addChild(newShapesVC)
        newShapesVC.didMove(toParent: self)
        self.moreCardsButton.isHidden = false
        self.shapesVC = newShapesVC
    }

    @IBAction func addMoreCards(_ sender: Any) {
        shapesVC?.addMoreCards()
        updateMoreCardsButtonVisitability()
    }

    @IBAction func shuffleButtonAction(_ sender: Any) {
        shapesVC?.shuffleCards()
    }

    func updateMoreCardsButtonVisitability() {
        guard let shapesVC = shapesVC else { return }

        let noCardsRemaining = shapesVC.cardsRemaining.isEmpty
        moreCardsButton.isHidden = noCardsRemaining
    }
}

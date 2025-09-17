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
    
    private var shapesVC: ShapesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame(self)
    }

    @IBAction func startNewGame(_ sender: Any) {
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
        if let shapesVC = shapesVC {
            moreCardsButton.isHidden = shapesVC.cardsRemaining.count == 0
        }
    }
}

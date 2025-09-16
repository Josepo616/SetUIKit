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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startNewGame(self)
    }

    @IBAction func startNewGame(_ sender: Any) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        let shapesVC = ShapesViewController(
            startedAmount: 12,
            targetScrollView: scrollView
        )
        addChild(shapesVC)
        shapesVC.didMove(toParent: self)
    }

    @IBAction func addMoreCards(_ sender: Any) {
        for child in children {
            if let shapesVC = child as? ShapesViewController {
                shapesVC.addMoreCards()
            }
        }
    }
}

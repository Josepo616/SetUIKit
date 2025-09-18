//
//  GameLogicProtocol.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

import Foundation
import UIKit

protocol GameLogicProtocol {
    var score: Int { get }
    var cardsRemaining: [Card] { get }
    var visibleCards: [Card] { get set }
    var validSet: Bool { get }
    var delegate: ShapesViewControllerDelegate? { get set }

    func isValidSet(_ cards: [Card]) -> Bool
    func addMoreCards(count: Int)
    func deselectAll()
    func shuffleVisibleCards()
    func handleCardTap(_ cardID: UUID, in scrollView: UIScrollView)
    func setupCardsGrid()
}
